//
//  RecipeListViewModelTests.swift
//  RecipeTests
//
//  Created by Jongho Lee on 4/15/25.
//

import XCTest
@testable import Recipe

final class RecipeListViewModelTests: XCTestCase {

	var sut: RecipeListViewModel!
	
    override func setUpWithError() throws {
		let recipes = [
			Recipe(uuid: "1", name: "Chocolate Gateau", cuisine: "French", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
			Recipe(uuid: "2", name: "Walnut Roll Gužvara", cuisine: "Croatian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil),
			Recipe(uuid: "3", name: "Seri Muka Kuih", cuisine: "Malaysian", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)
		]
		sut = RecipeListViewModel(recipes: recipes)
    }

    override func tearDownWithError() throws {
		sut = nil
    }

	func test_sort_option_name() {
		// Given & When
		sut.sortOption = .name
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.name }, ["Chocolate Gateau", "Seri Muka Kuih", "Walnut Roll Gužvara"])
	}

	func test_sort_option_cuisine() {
		// Given & When
		sut.sortOption = .cuisine
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.cuisine }, ["Croatian", "French", "Malaysian"])
	}
	
	func test_search_text_name() {
		// Given & When
		sut.searchText = "Roll"
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.name }, ["Walnut Roll Gužvara"])
	}
	
	func test_search_text_cuisine() {
		// Given & When
		sut.searchText = "Mal"
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.cuisine }, ["Malaysian"])
	}
	
	func test_search_text_capital() {
		// Given & When
		sut.searchText = "gaTeau"
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.name }, ["Chocolate Gateau"])
	}
	
	func test_search_text_multiple_words() {
		// Given & When
		sut.searchText = "seri muka"
		
		// Then
		XCTAssertEqual(sut.sortedAndFilteredRecipes.map { $0.name }, ["Seri Muka Kuih"])
	}
}
