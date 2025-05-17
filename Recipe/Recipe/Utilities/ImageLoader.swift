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

class ImageLoader: ObservableObject, ImageLoadable {
	@Published var image: UIImage?
	@Published var fail: Bool = false
	
	private var memoryCache: ImageMemoryCachable
	private var diskCache: ImageDiskCachable
	
	static private var inFlightTasks: [String: Task<UIImage?, Never>] = [:]
	private var currentTask: Task<Void, Never>?
	
	init(memoryCache: ImageMemoryCachable, diskCache: ImageDiskCachable) {
		self.memoryCache = memoryCache
		self.diskCache = diskCache
	}
	
	/// Cancel loading image
	func cancel() {
		currentTask?.cancel()
	}

	/// Load UIImage from cache if available, otherwise fetch from URL and cache it
	func loadImage(from urlString: String?, cacheKey: String) async {
		guard let urlString, let url = URL(string: urlString) else {
			await MainActor.run {
				self.fail = true
			}
			return
		}
		
		currentTask = Task(priority: .userInitiated) {
			if Task.isCancelled { return }
			// 1. Memory cache
			if let memoryCachedImage = memoryCache.imageFromMemoryCache(for: cacheKey) {
				await MainActor.run {
					self.image = memoryCachedImage
				}
				return
			}
			
			// 2. Disk cache
			if let diskCachedData = try? await diskCache.loadImageData(for: cacheKey), let cachedImage = UIImage(data: diskCachedData) {
				memoryCache.saveImageToMemoryCache(cachedImage, for: cacheKey)
				await MainActor.run {
					self.image = cachedImage
				}
				return
			}
			
			// 3. In-flight deduplication
			if let ongoing = Self.inFlightTasks[cacheKey] {
				let image = await ongoing.value
				await MainActor.run {
					self.image = image
				}
				return
			}
		
			// 4. Start new download task
			let downloadTask = Task<UIImage?, Never> {
				do {
	//				let (data, _) = try await withTimeout(seconds: 3) {
	//					try await retry(times: 2) {
	//						try await URLSession.shared.data(from: url)
	//					}
	//				}
					let (data, _) = try await retry(times: 2) {
						try await URLSession.shared.data(from: url)
					}
					
					guard let uiImage = UIImage(data: data) else { return nil }
					
					memoryCache.saveImageToMemoryCache(uiImage, for: cacheKey)
					try await diskCache.saveData(data, for: cacheKey)
					return uiImage
				} catch {
					print(error)
					return nil
				}
			}
			
			Self.inFlightTasks[cacheKey] = downloadTask
			let image = await downloadTask.value
			Self.inFlightTasks[cacheKey] = nil
			
			if Task.isCancelled { return }
			
			await MainActor.run {
				if let image = image {
					self.image = image
				} else {
					self.fail = true
				}
			}
		}
	}
}
