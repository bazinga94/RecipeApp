//
//  ImageLoaderTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/15/25.
//

import XCTest
@testable import Recipe

@MainActor
final class ImageLoaderTests: XCTestCase {

	var sut: ImageLoader!
	let testKey = "test"
	let testImage = UIImage(systemName: "photo")!
	var mockImageDiskCacheManager: MockImageDiskCacheManager!
	var mockImageMemoryCacheManager: MockImageMemoryCacheManager!

	override func setUpWithError() throws {
		mockImageMemoryCacheManager = MockImageMemoryCacheManager()
		mockImageDiskCacheManager = MockImageDiskCacheManager()
		sut = ImageLoader(memoryCache: mockImageMemoryCacheManager, diskCache: mockImageDiskCacheManager)
	}
	
	override func tearDownWithError() throws {
		mockImageMemoryCacheManager = nil
		mockImageDiskCacheManager = nil
		sut = nil
	}

	func test_load_image_from_memory_cache() async {
		// Given
		mockImageMemoryCacheManager.saveImageToMemoryCache(testImage, for: testKey)
		
		// When
		await sut.loadImage(from: "test_image_url", cacheKey: testKey)
		
		// Then
		XCTAssertEqual(sut.image, testImage)
		XCTAssertFalse(sut.fail)
	}
	
	func test_load_image_from_disk_cache() async {
		// Given
		let imageData = testImage.pngData()!
		mockImageDiskCacheManager.saveToDiskCache(imageData, for: testKey)
		
		// When
		await sut.loadImage(from: "test_image_url", cacheKey: testKey)
		
		// Then
		XCTAssertNotNil(sut.image)
		XCTAssertFalse(sut.fail)
	}
	
	func test_load_image_from_invalid_url() async {
		// Given
		
		// When
		await sut.loadImage(from: "", cacheKey: testKey)
		
		// Then
		XCTAssertNil(sut.image)
		XCTAssertTrue(sut.fail)
	}
}
