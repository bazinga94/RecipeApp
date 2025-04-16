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
		
		// Clean up metadata
		let metadataURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
			.appendingPathComponent("TEST")
			.appendingPathComponent("cache_metadata.json")
		try? FileManager.default.removeItem(at: metadataURL)
	}
	
	func test_image_from_disk_cache() async {
		// Given
		await sut.saveToDiskCache(imageData, for: testKey)

		// When
		let cachedData = await sut.imageDataFromDiskCache(for: testKey)

		// Then
		XCTAssertNotNil(cachedData)
		XCTAssertEqual(cachedData, imageData)
	}
	
	func test_save_metadata() async {
		// Given
		await sut.saveToDiskCache(imageData, for: testKey)
		
		// When
		let metadata = sut.loadMetadata()
		
		// Then
		XCTAssertNotNil(metadata)
		XCTAssertEqual(metadata?.count, 1)
		XCTAssertEqual(metadata?.first?.key, testKey)
	}
	
	func test_update_metadata() async {
		// Given
		await sut.saveToDiskCache(imageData, for: testKey)
		let oldMetadata = sut.loadMetadata()
		let oldDate = oldMetadata?.first?.date
		
		// When
		_ = await sut.imageDataFromDiskCache(for: testKey)	// Update "date" metadata by accessing the cache
		let currentMetadata = sut.loadMetadata()
		
		// Then
		XCTAssertNotNil(currentMetadata)
		XCTAssertEqual(currentMetadata?.count, 1)
		XCTAssertEqual(currentMetadata?.first?.key, testKey)
		XCTAssertNotEqual(currentMetadata?.first?.date, oldDate)
	}
	
	func test_delete_file() async {
		// Given
		await sut.saveToDiskCache(imageData, for: testKey)
		
		// When
		sut.deleteFile(for: testKey)
		
		// Then
		let cachedData = await sut.imageDataFromDiskCache(for: testKey)
		XCTAssertNil(cachedData)
		let metadata = sut.loadMetadata()
		XCTAssertTrue(metadata?.isEmpty ?? true)
	}
	
	func test_cleanup_old_cache() async {
		// Given
		await sut.saveToDiskCache(imageData, for: testKey)
		
		// Simulate that the cache is older than 1 day
		let oldDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
		let metadata = CacheMetadata(key: testKey, date: oldDate)
		sut.saveMetadata([metadata])
		let expectation = XCTestExpectation(description: "Cache should be deleted")
		
		// When
		Task.detached {
			self.sut.cleanupOldCache(expirationDays: 1)
			expectation.fulfill()
		}
		
		// Then
		await fulfillment(of: [expectation], timeout: 2.0)
		let cachedData = await sut.imageDataFromDiskCache(for: testKey)
		XCTAssertNil(cachedData)
	}
}
