//
//  MockImageMemoryCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

@testable import Recipe
import UIKit

class MockImageMemoryCacheManager: ImageMemoryCachable {
	var mockImage: UIImage?
	
	func imageFromMemoryCache(for key: String) -> UIImage? {
		return mockImage
	}
	
	func saveImageToMemoryCache(_ image: UIImage, for key: String) {
		mockImage = image
	}
}
