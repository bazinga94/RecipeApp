//
//  ImageCacheManager.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import UIKit

protocol ImageMemoryCachable {
	func imageFromMemoryCache(for key: String) -> UIImage?
	func saveImageToMemoryCache(_ image: UIImage, for key: String)
}

protocol ImageDiskCachable {
	func imageFromDiskCache(for key: String) -> UIImage?
	func saveImageToDiskCache(_ image: UIImage, for key: String)
}

final class ImageCacheManager: ImageMemoryCachable, ImageDiskCachable {
	static let shared = ImageCacheManager()
	private let memoryCache = NSCache<NSString, UIImage>()
	private let cacheDirectory: URL
	
	private init() {
		// Set cache directory (in the Caches folder)
		cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("DownloadedImages")
		
		// Create the cache directory
		if !FileManager.default.fileExists(atPath: cacheDirectory.path) {
			try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
		}
	}
	
	// Find the image in memory cache
	func imageFromMemoryCache(for key: String) -> UIImage? {
		return memoryCache.object(forKey: key as NSString)
	}
	
	// Find the image in disk cache
	func imageFromDiskCache(for key: String) -> UIImage? {
		let fileURL = cacheDirectory.appendingPathComponent(key)
		return UIImage(contentsOfFile: fileURL.path)
	}
	
	// Save the image to memory cache
	func saveImageToMemoryCache(_ image: UIImage, for key: String) {
		memoryCache.setObject(image, forKey: key as NSString)
	}
	
	// Save the image to disk cache
	func saveImageToDiskCache(_ image: UIImage, for key: String) {
		let fileURL = cacheDirectory.appendingPathComponent(key)
//		if let data = image.pngData() {
		if let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() {
			try? data.write(to: fileURL)
		}
	}
}
