//
//  RecipeHomeViewModelTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/14/25.
//

import XCTest
@testable import Recipe

final class RecipeHomeViewModelTests: XCTestCase {
	
	var sut: RecipesListViewModel!
	var mockRepository: MockRecipeRepository!

	override func setUpWithError() throws {
		mockRepository = MockRecipeRepository()
		sut = RecipesListViewModel(recipeRepository: mockRepository)
	}
	
	override func tearDownWithError() throws {
		mockRepository = nil
		sut = nil
	}

	func test_initial_state() {
		// Then
		XCTAssertEqual(sut.state, .idle)
	}
	
	func test_loadRecipes_success_loaded() async {
		// Given
		let recipes = [Recipe(uuid: "", name: "Apam Balik", cuisine: "Malaysian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)]
		mockRepository.result = .success(recipes)
		
		// When
		await sut.loadRecipes()
		
		// Then
		if case .loaded(let recipes) = sut.state {
			XCTAssertEqual(recipes.count, 1)
			XCTAssertEqual(recipes.first?.name, "Apam Balik")
		} else {
			XCTFail("Expected .loaded state")
		}
	}
	
	func test_loadRecipes_failure_failed() async {
		// Given
		mockRepository.result = .failure(APIError.decodingFailed)
		
		// When
		await sut.loadRecipes()
		
		// Then
		if case .failed(let message) = sut.state {
			XCTAssertEqual(message, "Something went wrong. \nPlease try again later.")
		} else {
			XCTFail("Expected .failed state")
		}
	}
	
	func test_loadRecipes_if_not_refresh_state_change_to_loading() async {
		// Given
		let recipes = [Recipe(uuid: "", name: "Apam Balik", cuisine: "Malaysian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)]
		mockRepository.result = .success(recipes)
		let expectation = XCTestExpectation(description: "State should change to loading")
		var stateChangedToLoading: Bool = false
		
		// When
		let cancellable = sut.$state
			.sink { state in
				expectation.fulfill()
				if case .loading = state {
					stateChangedToLoading = true
				}
			}
		
		await sut.loadRecipes(isRefresh: false)
		
		// Then
//		wait(for: [expectation], timeout: 2.0)
		await fulfillment(of: [expectation], timeout: 2.0)
		XCTAssertTrue(stateChangedToLoading)
		cancellable.cancel()
	}
	
	func test_loadRecipes_if_refresh_state_not_change_to_loading() async {
		// Given
		let recipes = [Recipe(uuid: "", name: "Apam Balik", cuisine: "Malaysian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)]
		mockRepository.result = .success(recipes)
		let expectation = XCTestExpectation(description: "State should not change to loading")
		var stateChangedToLoading: Bool = false
		
		// When
		let cancellable = sut.$state
			.sink { state in
				expectation.fulfill()
				if case .loading = state {
					stateChangedToLoading = true
				}
			}
		
		await sut.loadRecipes(isRefresh: true)
		
		// Then
//		wait(for: [expectation], timeout: 2.0)
		await fulfillment(of: [expectation], timeout: 2.0)
		XCTAssertFalse(stateChangedToLoading)
		cancellable.cancel()
	}
}
