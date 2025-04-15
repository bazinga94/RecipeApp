//
//  APIClientTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/14/25.
//

import XCTest
@testable import Recipe

final class APIClientTests: XCTestCase {
	
	var sut: APIClient!

    override func setUpWithError() throws {
		sut = APIClient()
    }

    override func tearDownWithError() throws {
		sut = nil
    }

	func test_APIClient_invalidUrl_shouldThrowError() async {
		// Given
		let invalidUrlString = ""
		
		// When & Then
		do {
			let _ = try await sut.fetch(for: RecipesResponseDTO.self, from: invalidUrlString)
			XCTFail("Error not occured")
		} catch {
			XCTAssertEqual(error as? APIError, APIError.invalidUrl)
		}
	}
}
