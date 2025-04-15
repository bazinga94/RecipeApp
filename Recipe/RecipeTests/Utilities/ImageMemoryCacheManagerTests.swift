//
//  ImageMemoryCacheManagerTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/15/25.
//

import XCTest
@testable import Recipe

class ImageMemoryCacheManagerTests: XCTestCase {
	
	var sut: ImageMemoryCacheManager!
	let testKey = "test"
	let testImage = UIImage(systemName: "photo")!

	override func setUpWithError() throws {
		sut = ImageMemoryCacheManager.shared
	}

	override func tearDownWithError() throws {
		sut.saveImageToMemoryCache(UIImage(), for: testKey)  // memory cache clear
	}

	func test_image_from_memory_cache() {
		// Given
		sut.saveImageToMemoryCache(testImage, for: testKey)

		// When
		let cachedImage = sut.imageFromMemoryCache(for: testKey)

		// Then
		XCTAssertNotNil(cachedImage)
		XCTAssertEqual(cachedImage, testImage)
	}

//	func test_image_from_disk_cache() {
//		// Given
//		sut.saveImageToDiskCache(testImage, for: testKey)
//
//		// When
//		let cachedImage = sut.imageFromDiskCache(for: testKey)
//
//		// Then
//		XCTAssertNotNil(cachedImage)
//		XCTAssertEqual(cachedImage, testImage)
//	}

	func test_save_image_to_memory_cache() {
		// When
		sut.saveImageToMemoryCache(testImage, for: testKey)

		// Then
		let cachedImage = sut.imageFromMemoryCache(for: testKey)
		XCTAssertNotNil(cachedImage)
		XCTAssertEqual(cachedImage, testImage)
	}

//	func test_save_image_to_disk_cache() {
//		// When
//		sut.saveImageToDiskCache(testImage, for: testKey)
//
//		// Then
//		let cachedImage = sut.imageFromDiskCache(for: testKey)
//		XCTAssertNotNil(cachedImage)
//		XCTAssertEqual(cachedImage, testImage)
//	}
}
