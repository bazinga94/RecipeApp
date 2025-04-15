//
//  ImageDiskCacheManagerTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/15/25.
//

import XCTest
@testable import Recipe

class ImageDiskCacheManagerTests: XCTestCase {
	
	var sut: ImageDiskCacheManager!
	let testKey = "test"
	let testImage = UIImage(systemName: "photo")!
	var imageData: Data!

	override func setUpWithError() throws {
		sut = ImageDiskCacheManager(subdirectory: "TEST")
		imageData = testImage.pngData()
	}

	override func tearDownWithError() throws {
		sut = nil
		imageData = nil
		// Clean up disk
		let fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
			.appendingPathComponent("TEST")
			.appendingPathComponent(testKey)
		try? FileManager.default.removeItem(at: fileURL)
	}
	
	func test_image_from_disk_cache() {
		// Given
		sut.saveToDiskCache(imageData, for: testKey)

		// When
		let cachedData = sut.imageDataFromDiskCache(for: testKey)

		// Then
		XCTAssertNotNil(cachedData)
		XCTAssertEqual(cachedData, imageData)
	}
}
