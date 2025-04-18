//
//  ImageDiskCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

import Foundation

protocol ImageDiskCachable {
	func imageDataFromDiskCache(for key: String) async -> Data?
	func saveToDiskCache(_ imageData: Data, for key: String) async
}

protocol DiskCacheMetadataManagable {
	func loadMetadata() -> [CacheMetadata]?
	func saveMetadata(_ metadata: [CacheMetadata])
}

protocol DiskCacheCleanable {
	func deleteFile(for key: String)
	func cleanupOldCache(expirationDays: Double)
}

struct CacheMetadata: Codable {
	let key: String       // file name ("uuid_small.jpg")
	var date: Date        // file creation date & last access date
}

final class ImageDiskCacheManager: ImageDiskCachable, DiskCacheMetadataManagable, DiskCacheCleanable {
	static let shared = ImageDiskCacheManager()
	
	private let cacheDirectory: URL
	private let metadataFileURL: URL
	
	private let metadataQueue = DispatchQueue(label: "com.jongko.Recipe.metadataqueue")
	
	// Keep initializer public for testing, should not use in production code
	init(subdirectory: String = "DownloadedImages") {
		let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
		cacheDirectory = base.appendingPathComponent(subdirectory)
		metadataFileURL = cacheDirectory.appendingPathComponent("cache_metadata.json")
		
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

	func imageDataFromDiskCache(for key: String) async -> Data? {
		return await withCheckedContinuation { continuation in
			DispatchQueue.global(qos: .userInitiated).async {
				let fileURL = self.cacheDirectory.appendingPathComponent(key)
				guard let data = try? Data(contentsOf: fileURL) else {
					continuation.resume(returning: nil)
					return
				}
				
				self.metadataQueue.sync {
					// Update saved image's metadata
					var metadataList = self.loadMetadata() ?? []
					
					if let index = metadataList.firstIndex(where: { $0.key == key }) {
						var metadata = metadataList[index]
						metadata.date = Date() // Update to current date
						metadataList[index] = metadata
						self.saveMetadata(metadataList)
					}
				}
				
				continuation.resume(returning: data)
			}
		}
	}
	
	func saveToDiskCache(_ imageData: Data, for key: String) async {
		await withCheckedContinuation { continuation in
			DispatchQueue.global(qos: .background).async {
				let fileURL = self.cacheDirectory.appendingPathComponent(key)
				do {
					try imageData.write(to: fileURL)
					
					self.metadataQueue.sync {
						// Add saved image's metadata
						let metadata = CacheMetadata(key: key, date: Date())
						var metadataList = self.loadMetadata() ?? []
						metadataList.removeAll { $0.key == key }
						metadataList.append(metadata)
						self.saveMetadata(metadataList)
					}
					
					continuation.resume()
				} catch {
					print(error)
					continuation.resume()
				}
			}
		}
	}
	
	// MARK: - DiskCacheMetadataManagable
	
	func loadMetadata() -> [CacheMetadata]? {
		guard let data = try? Data(contentsOf: metadataFileURL) else { return nil }
		let decoder = JSONDecoder()
		return try? decoder.decode([CacheMetadata].self, from: data)
	}
	
	func saveMetadata(_ metadata: [CacheMetadata]) {
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(metadata) else { return }
		try? data.write(to: metadataFileURL)
	}
	
	// MARK: - DiskCacheCleanable
	
	func deleteFile(for key: String) {
		// Remove cache by key
		let fileURL = cacheDirectory.appendingPathComponent(key)
		try? FileManager.default.removeItem(at: fileURL)
		
		// Remove from metadata
		var metadataList = loadMetadata() ?? []
		metadataList.removeAll { $0.key == key }
		saveMetadata(metadataList)
	}
	
	/// Delete cache files that are older than the specified number of days
	func cleanupOldCache(expirationDays: Double) {
		let now = Date()
		guard let metadataList = self.loadMetadata() else { return }
		
		for item in metadataList {
			let cacheAge = now.timeIntervalSince(item.date)
			if cacheAge > expirationDays * 86400 { // 1 day = 86400 seconds
				self.deleteFile(for: item.key)
			}
		}
	}
}
