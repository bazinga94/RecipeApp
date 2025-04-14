//
//  MockAPIClient.swift
//  Recipe
//
//  Created by Jongho Lee on 4/14/25.
//

import Foundation
@testable import Recipe

class MockAPIClient: APIClientProtocol {
	var result: Result<Decodable, Error>!

	func fetch<T: Decodable>(for: T.Type, from urlString: String) async throws -> T {
		switch result {
		case .success(let data as T):
			return data
		case .failure(let error):
			throw error
		default:
			fatalError("Invalid mock setup")
		}
	}
}
