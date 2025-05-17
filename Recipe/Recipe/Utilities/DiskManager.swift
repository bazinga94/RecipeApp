//
//  DiskManager.swift
//  Recipe
//
//  Created by Jongho Lee on 5/17/25.
//

import Foundation

struct DiskManager {
	static func write(_ data: Data, to url: URL) async throws {
		try await Task.detached(priority: .background) {
			try data.write(to: url)
		}.value
	}

	static func read(from url: URL) async throws -> Data {
		try await Task.detached(priority: .background) {
			try Data(contentsOf: url)
		}.value
	}

	static func delete(at url: URL) async throws {
		try await Task.detached(priority: .background) {
			try FileManager.default.removeItem(at: url)
		}.value
	}

	static func fileExists(at url: URL) -> Bool {
		FileManager.default.fileExists(atPath: url.path)
	}
}
