//
//  ImageDiskCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 5/16/25.
//

import Foundation
import CryptoKit

protocol ImageDiskCachable: Sendable {
	func loadImageData(for key: String) async throws -> Data?
	func saveData(_ imageData: Data, for key: String) async throws
}

protocol DiskCacheCleanable {
	func cleanupOldCache(expirationDays: Double) async throws
}

struct CacheMetadata: Codable {
	let key: String       // file name ("uuid_small.jpg")
	var date: Date        // file creation date & last access date
}

actor ImageDiskCacheManager: ImageDiskCachable, DiskCacheCleanable {
	
	static let shared = ImageDiskCacheManager()
	
	private let cacheDirectory: URL
	private let metadata: DiskMetadataStore
	
	// Keep initializer public for testing, should not use in production code
	private init(subdirectory: String = "DownloadedImages") {
		let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
		self.cacheDirectory = base.appendingPathComponent(subdirectory)
		let metadataFileURL = cacheDirectory.appendingPathComponent("cache_metadata.json")
		self.metadata = DiskMetadataStore(metadataFileURL: metadataFileURL)
		
		// Create cache directory
		if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error)
			}
		}
	}
	
	// MARK: - ImageDiskCachable

	func loadImageData(for key: String) async throws -> Data? {
		let fileURL = self.cacheDirectory.appendingPathComponent(key)
		guard DiskManager.fileExists(at: fileURL) else { return nil }
		
		let data = try await DiskManager.read(from: fileURL)
		await metadata.updateAccessData(key: key)
		return data
	}
	
	func saveData(_ imageData: Data, for key: String) async throws {
		let fileURL = self.cacheDirectory.appendingPathComponent(key)
		try imageData.write(to: fileURL)
		await metadata.add(item: CacheMetadata(key: key, date: Date()))
	}
	
	// MARK: - DiskCacheCleanable
	
	/// Delete cache files that are older than the specified number of days
	func cleanupOldCache(expirationDays: Double) async throws {
		let deleteKeys = await metadata.expiredKeys(expirationDays: expirationDays)
		
		for key in deleteKeys {
			try await self.deleteImage(for: key)
		}
	}
	
	private func deleteImage(for key: String) async throws {
		// Remove cache by key
		let fileURL = cacheDirectory.appendingPathComponent(key)
		guard DiskManager.fileExists(at: fileURL) else { return }
		try await DiskManager.delete(at: fileURL)
		
		// Remove from metadata
		await metadata.delete(key: key)
	}
	
	private func hashKey(_ key: String) -> String {
		let hash = SHA256.hash(data: Data(key.utf8))
		return hash.map { String(format: "%02x", $0) }.joined()
	}
}
