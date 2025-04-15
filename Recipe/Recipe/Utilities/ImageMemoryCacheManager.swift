//
//  ImageMemoryCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

import UIKit

protocol ImageMemoryCachable {
	func imageFromMemoryCache(for key: String) -> UIImage?
	func saveImageToMemoryCache(_ image: UIImage, for key: String)
}

final class ImageMemoryCacheManager: ImageMemoryCachable {
	static let shared = ImageMemoryCacheManager()
	
	private let memoryCache = NSCache<NSString, UIImage>()
	
	private init() {}

	func imageFromMemoryCache(for key: String) -> UIImage? {
		memoryCache.object(forKey: key as NSString)
	}
	
	func saveImageToMemoryCache(_ image: UIImage, for key: String) {
		memoryCache.setObject(image, forKey: key as NSString)
	}
}
