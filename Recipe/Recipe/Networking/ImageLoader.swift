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

	func loadImage(from urlString: String?, cacheKey: String) async {
		self.fail = false
		
		guard let urlString else {
			self.fail = true
			return
		}
		
		if let memoryCachedImage = ImageCacheManager.shared.imageFromMemoryCache(for: cacheKey) {
			self.image = memoryCachedImage
			return
		}
		
		if let diskCachedImage = ImageCacheManager.shared.imageFromDiskCache(for: cacheKey) {
			ImageCacheManager.shared.saveImageToMemoryCache(diskCachedImage, for: cacheKey)
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
				ImageCacheManager.shared.saveImageToMemoryCache(uiImage, for: cacheKey)
				ImageCacheManager.shared.saveImageToDiskCache(uiImage, for: cacheKey)
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
