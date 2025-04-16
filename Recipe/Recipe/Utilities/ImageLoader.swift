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

@MainActor
class ImageLoader: ObservableObject, ImageLoadable {
	@Published var image: UIImage?
	@Published var fail: Bool = false
	
	private var memoryCache: ImageMemoryCachable
	private var diskCache: ImageDiskCachable
	
	init(memoryCache: ImageMemoryCachable, diskCache: ImageDiskCachable) {
		self.memoryCache = memoryCache
		self.diskCache = diskCache
	}

	/// Load UIImage from cache if available, otherwise fetch from URL and cache it
	func loadImage(from urlString: String?, cacheKey: String) async {
		self.fail = false
		
		guard let urlString else {
			self.fail = true
			return
		}
		
		if let memoryCachedImage = memoryCache.imageFromMemoryCache(for: cacheKey) {
			self.image = memoryCachedImage
			return
		}
		
		if let diskCachedData = await diskCache.imageDataFromDiskCache(for: cacheKey), let cachedImage = UIImage(data: diskCachedData) {
			memoryCache.saveImageToMemoryCache(cachedImage, for: cacheKey)
			self.image = cachedImage
			return
		}
		
		guard let url = URL(string: urlString) else {
			self.fail = true
			return
		}

		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			if let uiImage = UIImage(data: data) {
				memoryCache.saveImageToMemoryCache(uiImage, for: cacheKey)
				await diskCache.saveToDiskCache(data, for: cacheKey)
				self.image = uiImage
			} else {
				self.fail = true
			}
		} catch {
			self.fail = true
			print(error)
		}
	}
}
