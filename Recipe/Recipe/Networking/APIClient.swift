//
//  APIClient.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import Foundation

protocol APIClientProtocol {
	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T
}

class APIClient: APIClientProtocol {
	
	init() { }
	
	/// Fetch Decodable object from URL
	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T {
		
		guard let url = URL(string: urlString) else {
			throw APIError.invalidURL
		}
		
		let (data, urlResponse) = try await URLSession.shared.data(from: url)
		
		guard let httpUrlResponse = urlResponse as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
			throw APIError.badResponse
		}
		
		do {
			let result = try JSONDecoder().decode(T.self, from: data)
			return result
		} catch {
			print("Decoding Error: \(error)")
			throw APIError.decodingFailed
		}
	}
}

enum APIError: Error {
	case invalidURL
	case badResponse
	case decodingFailed
}
