//
//  ImageLoader.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

protocol ImageLoadable {
	func loadImage(from urlString: String?, cacheKey: String) async
}

actor InFlightTaskActor {
	private var tasks: [String: Task<UIImage?, Never>] = [:]
	
	func get(for key: String) -> Task<UIImage?, Never>? {
		tasks[key]
	}
	func set(_ task: Task<UIImage?, Never>?, for key: String) {
		tasks[key] = task
	}
	func remove(for key: String) {
		tasks[key] = nil
	}
}

final class ImageLoader: ObservableObject, ImageLoadable, @unchecked Sendable {
	@Published var image: UIImage?
	@Published var fail: Bool = false
	
	private var memoryCache: ImageMemoryCachable
	private var diskCache: ImageDiskCachable
	
	static private let inFlightTaskActor = InFlightTaskActor()
	private var currentTask: Task<Void, Never>?
	
	init(memoryCache: ImageMemoryCachable, diskCache: ImageDiskCachable) {
		self.memoryCache = memoryCache
		self.diskCache = diskCache
	}
	
	func cancel() {
		currentTask?.cancel()
	}
	
	func loadImage(from urlString: String?, cacheKey: String) async {
		guard let urlString, let url = URL(string: urlString) else {
			await updateFailOnMain()
			return
		}
		// Cancel any existing task first
		cancel()
		// New load task
		currentTask = Task {
			await self.loadImageImpl(url: url, cacheKey: cacheKey)
		}
	}
	
	private func loadImageImpl(url: URL, cacheKey: String) async {
		// 1. Memory cache
		if let memoryCachedImage = await memoryCache.imageFromMemoryCache(for: cacheKey) {
			await updateImageOnMain(memoryCachedImage)
			return
		}
		
		// 2. Disk cache
		if let diskCachedData = try? await diskCache.loadImageData(for: cacheKey),
		   let cachedImage = UIImage(data: diskCachedData) {
			await memoryCache.saveImageToMemoryCache(cachedImage, for: cacheKey)
			await updateImageOnMain(cachedImage)
			return
		}
		
		// 3. In-flight deduplication
		if let ongoing = await Self.inFlightTaskActor.get(for: cacheKey) {
			let image = await ongoing.value
			if let image = image {
				await updateImageOnMain(image)
			} else {
				await updateFailOnMain()
			}
			return
		}
		
		// 4. Download and cache
		let downloadTask = createDownloadTask(url: url, cacheKey: cacheKey)
		await Self.inFlightTaskActor.set(downloadTask, for: cacheKey)
		let image = await downloadTask.value
		await Self.inFlightTaskActor.remove(for: cacheKey)
		
		if Task.isCancelled { return }
		
		if let image = image {
			await updateImageOnMain(image)
		} else {
			await updateFailOnMain()
		}
	}
	
	private func createDownloadTask(url: URL, cacheKey: String) -> Task<UIImage?, Never> {
		let memoryCache = self.memoryCache
		let diskCache = self.diskCache
		return Task {
			do {
				let (data, _) = try await retry(times: 2) {
					try await URLSession.shared.data(from: url)
				}
				guard let uiImage = UIImage(data: data) else { return nil }
				await memoryCache.saveImageToMemoryCache(uiImage, for: cacheKey)
				try await diskCache.saveData(data, for: cacheKey)
				return uiImage
			} catch {
				print(error)
				return nil
			}
		}
	}
	
	// MARK: - MainActor-safe UI update helpers
	@MainActor
	private func updateImageOnMain(_ image: UIImage) {
		self.image = image
		self.fail = false
	}
	
	@MainActor
	private func updateFailOnMain() {
		self.fail = true
	}
}
