//
//  APIClient.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import Foundation

protocol URLSessionProtocol: Sendable {
	func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

protocol APIClientProtocol: Sendable {
	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T
}

final class APIClient: APIClientProtocol {
	
	let session: URLSessionProtocol
	
	init(session: URLSessionProtocol = URLSession.shared) {
		self.session = session
	}
	
	/// Fetch Decodable object from URL
	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T {
		
		guard let url = URL(string: urlString) else {
			throw APIError.invalidURL
		}
		
		let (data, urlResponse) = try await session.data(from: url)
		
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
