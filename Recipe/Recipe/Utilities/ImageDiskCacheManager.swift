//
//  ImageDiskCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

import Foundation

protocol ImageDiskCachable {
	func imageDataFromDiskCache(for key: String) -> Data?
	func saveToDiskCache(_ imageData: Data, for key: String)
}

class ImageDiskCacheManager: ImageDiskCachable {
	private let cacheDirectory: URL
	
	init(subdirectory: String = "DownloadedImages") {
		let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
		cacheDirectory = base.appendingPathComponent(subdirectory)
		
		if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
			do {
				try FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error)
			}
		}
	}

	func imageDataFromDiskCache(for key: String) -> Data? {
		let fileURL = cacheDirectory.appendingPathComponent(key)
		guard let data = try? Data(contentsOf: fileURL) else {
			return nil
		}
		return data
	}
	
	func saveToDiskCache(_ imageData: Data, for key: String) {
		let fileURL = cacheDirectory.appendingPathComponent(key)
		do {
			try imageData.write(to: fileURL)
		} catch {
			print(error)
		}
	}
}
