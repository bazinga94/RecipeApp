//
//  MockImageDiskCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

@testable import Recipe
import Foundation

class MockImageDiskCacheManager: ImageDiskCachable {
	var mockData: Data?
	
	func imageDataFromDiskCache(for key: String) -> Data? {
		return mockData
	}
	
	func saveToDiskCache(_ imageData: Data, for key: String) {
		mockData = imageData
	}
}
