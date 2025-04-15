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
	var mockImageCacheManager: MockImageCacheManager!

	override func setUpWithError() throws {
		mockImageCacheManager = MockImageCacheManager()
		sut = ImageLoader(cacheManager: mockImageCacheManager)
	}
	
	override func tearDownWithError() throws {
		mockImageCacheManager = nil
		sut = nil
	}

	func test_load_image_from_memory_cache() async {
		// Given
		let image = UIImage(systemName: "photo")!
		mockImageCacheManager.saveImageToMemoryCache(image, for: "test_image_key")
		
		// When
		await sut.loadImage(from: "test_image_url", cacheKey: "test_image_key")
		
		// Then
		XCTAssertEqual(sut.image, image)
		XCTAssertFalse(sut.fail)
	}
	
	func test_load_image_from_disk_cache() async {
		// Given
		let image = UIImage(systemName: "photo")!
		mockImageCacheManager.saveImageToDiskCache(image, for: "test_image_key")
		
		// When
		await sut.loadImage(from: "test_image_url", cacheKey: "test_image_key")
		
		// Then
		XCTAssertEqual(sut.image, image)
		XCTAssertFalse(sut.fail)
	}
	
	func test_load_image_from_invalid_url() async {
		// Given
		
		// When
		await sut.loadImage(from: "", cacheKey: "test_image_key")
		
		// Then
		XCTAssertNil(sut.image)
		XCTAssertTrue(sut.fail)
	}
}

class MockImageCacheManager: ImageDiskCachable, ImageMemoryCachable {
	var mockImage: UIImage?
	
	func imageFromDiskCache(for key: String) -> UIImage? {
		return mockImage
	}
	
	func saveImageToDiskCache(_ image: UIImage, for key: String) {
		mockImage = image
	}
	
	func imageFromMemoryCache(for key: String) -> UIImage? {
		return mockImage
	}
	
	func saveImageToMemoryCache(_ image: UIImage, for key: String) {
		mockImage = image
	}
}
