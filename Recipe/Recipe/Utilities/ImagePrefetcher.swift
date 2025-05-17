//
//  ImagePrefetcher.swift
//  Recipe
//
//  Created by Jongho Lee on 5/15/25.
//
import UIKit

@MainActor
class ImagePrefetcher {
	private var memoryCache: ImageMemoryCachable
	private var diskCache: ImageDiskCachable
	
	init(memoryCache: ImageMemoryCachable = ImageMemoryCacheManager.shared,
		 diskCache: ImageDiskCachable) {
		self.memoryCache = memoryCache
		self.diskCache = diskCache
	}
	
	func prefetch(urls: [String], keys: [String]) async {
		guard urls.count == keys.count else { return }
		
		await withTaskGroup(of: Void.self) { group in
			for (urlString, key) in zip(urls, keys) {
				group.addTask {
					if await self.memoryCache.imageFromMemoryCache(for: key) != nil { return }
					if let data = try? await self.diskCache.loadImageData(for: key),
					   let image = UIImage(data: data) {
						await self.memoryCache.saveImageToMemoryCache(image, for: key)
						return
					}
					
					guard let url = URL(string: urlString) else { return }
					do {
						let (data, _) = try await URLSession.shared.data(from: url)
						if let image = UIImage(data: data) {
							await self.memoryCache.saveImageToMemoryCache(image, for: key)
							try await self.diskCache.saveData(data, for: key)
						}
					} catch {
						print("❌ prefetch failed for: \(urlString)")
					}
				}
			}
		}
	}
}
