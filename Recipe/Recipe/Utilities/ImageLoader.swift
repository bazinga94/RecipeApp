//
//  ImageLoader.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

protocol ImageCacheable {
	func loadImage(from urlString: String?, cacheKey: String) async
}

@MainActor
class ImageLoader: ObservableObject, ImageCacheable {
	@Published var image: UIImage?
	@Published var fail: Bool = false
	
	private var cacheManager: ImageMemoryCachable & ImageDiskCachable
	
	init(cacheManager: ImageMemoryCachable & ImageDiskCachable = ImageCacheManager.shared) {
		self.cacheManager = cacheManager
	}

	// Load UIImage from cache if available, otherwise fetch from URL and cache it
	func loadImage(from urlString: String?, cacheKey: String) async {
		self.fail = false
		
		guard let urlString else {
			self.fail = true
			return
		}
		
		if let memoryCachedImage = cacheManager.imageFromMemoryCache(for: cacheKey) {
			self.image = memoryCachedImage
			return
		}
		
		if let diskCachedImage = cacheManager.imageFromDiskCache(for: cacheKey) {
			cacheManager.saveImageToMemoryCache(diskCachedImage, for: cacheKey)
			self.image = diskCachedImage
			return
		}
		
		guard let url = URL(string: urlString) else {
			self.fail = true
			return
		}

		do {
			let (data, _) = try await URLSession.shared.data(from: url)
			if let uiImage = UIImage(data: data) {
				cacheManager.saveImageToMemoryCache(uiImage, for: cacheKey)
				cacheManager.saveImageToDiskCache(uiImage, for: cacheKey)
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
