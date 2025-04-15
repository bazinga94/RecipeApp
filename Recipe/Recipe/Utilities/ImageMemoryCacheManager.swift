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
	
	private init() {
		// Set cache capacity
		memoryCache.countLimit = 200
		memoryCache.totalCostLimit = 100_000_000		// 100MB
	}

	func imageFromMemoryCache(for key: String) -> UIImage? {
		memoryCache.object(forKey: key as NSString)
	}
	
	func saveImageToMemoryCache(_ image: UIImage, for key: String) {
		memoryCache.setObject(image, forKey: key as NSString)
	}
}
