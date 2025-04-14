//
//  APIClientTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/14/25.
//

import XCTest
@testable import Recipe

final class APIClientTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
		
    }

	func test_APIClient_invalidUrl_shouldThrowError() async {
		// Given
		let client = APIClient()
		let invalidUrlString = ""
		
		// When & Then
		do {
			let _ = try await client.fetch(for: RecipesResponseDTO.self, from: invalidUrlString)
			XCTFail("Error not occured")
		} catch {
			XCTAssertEqual(error as? APIError, APIError.invalidUrl)
		}
	}
}
