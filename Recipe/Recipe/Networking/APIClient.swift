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
	
	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T {
		
		guard let url = URL(string: urlString) else {
			throw APIError.invalidUrl
		}
		
		let (data, urlResponse) = try await URLSession.shared.data(from: url)
		
		guard let httpUrlResponse = urlResponse as? HTTPURLResponse, httpUrlResponse.statusCode == 200 else {
//			print(urlResponse)
			throw APIError.invalidResponse
		}
		
		do {
//			let rawString = String(data: data, encoding: .utf8) ?? "No data"
//			print("OUTPUT: \n\(rawString)")
			let result = try JSONDecoder().decode(T.self, from: data)
			return result
		} catch {
			print("Decoding Error: \(error)")
			throw APIError.invalidData
		}
	}
}

enum APIError: Error {
	case invalidUrl
	case invalidResponse
	case invalidData
}
