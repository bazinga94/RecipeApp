//
//  RecipeRepositoryTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/14/25.
//

import XCTest
@testable import Recipe

final class RecipeRepositoryTests: XCTestCase {

    override func setUpWithError() throws {
		
    }

    override func tearDownWithError() throws {

    }
	
	/*
	 {
	 "cuisine": "Malaysian",
	 "name": "Apam Balik",
	 "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
	 "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
	 "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
	 "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
	 "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
	 }
	 */
	func test_recipe_repository_success_all() async throws {
		// Given
		let dto = RecipesResponseDTO(recipes: [
			RecipeDTO(uuid: "", name: "Apam Balik", cuisine: "Malaysian", photo_url_large: nil, photo_url_small: nil, source_url: nil, youtube_url: nil),
			RecipeDTO(uuid: "", name: "Apple & Blackberry Crumble", cuisine: "British", photo_url_large: nil, photo_url_small: nil, source_url: nil, youtube_url: nil),
			RecipeDTO(uuid: "", name: "Banana Pancakes", cuisine: "American", photo_url_large: nil, photo_url_small: nil, source_url: nil, youtube_url: nil)
		])
		let mockClient = MockAPIClient()
		mockClient.result = .success(dto)
		let repository = RecipeRepository(apiClient: mockClient)
		
		// When
		let recipes = try await repository.fetchRecipes()
		
		// Then
		XCTAssertEqual(recipes.count, 3)
		XCTAssertEqual(recipes.first?.name, "Apam Balik")
		XCTAssertEqual(recipes.first?.cuisine, "Malaysian")
		XCTAssertEqual(recipes.last?.name, "Banana Pancakes")
		XCTAssertEqual(recipes.last?.cuisine, "American")
	}
	
	func test_recipe_repository_success_empty() async {
		// Given
		let dto = RecipesResponseDTO(recipes: [])
		let mockClient = MockAPIClient()
		mockClient.result = .success(dto)
		let repository = RecipeRepository(apiClient: mockClient)
		
		// When & Then
		do {
			let recipes = try await repository.fetchRecipes()
			XCTAssertEqual(recipes.count, 0)
		} catch {
			XCTFail("Unexpected error")
		}
	}
	
	func test_recipe_repository_failure() async {
		// Given
		let mockClient = MockAPIClient()
		mockClient.result = .failure(APIError.invalidUrl)
		let repository = RecipeRepository(apiClient: mockClient)
		
		// When & Then
		do {
			let _ = try await repository.fetchRecipes()
			XCTFail("Error not occured")
		} catch {
			guard let apiError = error as? APIError else {
				XCTFail("Unexpected error type")
				return
			}
			XCTAssertEqual(apiError, .invalidUrl)
		}
	}
}
