//
//  DiskMetadataStore.swift
//  Recipe
//
//  Created by Jongho Lee on 5/17/25.
//

import Foundation

actor DiskMetadataStore {
	private var metadataFileURL: URL
	
	init(metadataFileURL: URL) {
		self.metadataFileURL = metadataFileURL
	}
	
	func load() -> [CacheMetadata] {
		guard let data = try? Data(contentsOf: metadataFileURL) else { return [] }
		let decoder = JSONDecoder()
		return (try? decoder.decode([CacheMetadata].self, from: data)) ?? []
	}
	
	func save(_ metadata: [CacheMetadata]) {
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(metadata) else { return }
		try? data.write(to: metadataFileURL)
	}
	
	func updateAccessData(key: String) {
		var updated = load()
		if let index = updated.firstIndex(where: { $0.key == key }) {
			updated[index].date = Date()	// Update to current date
			save(updated)
		}
	}
	
	func add(item: CacheMetadata) {
		var metadataList = load()
		metadataList.removeAll { $0.key == item.key }
		metadataList.append(item)
		save(metadataList)
	}
	
	func delete(key: String) {
		var metadataList = load()
		metadataList.removeAll { $0.key == key }
		save(metadataList)
	}
	
	func expiredKeys(expirationDays: Double) -> [String] {
		let now = Date()
		let threshold = expirationDays * 86400
		return load()
			.filter {
				now.timeIntervalSince($0.date) > threshold
			}
			.map { $0.key }
	}
}
