//
//  MockRecipeRepository.swift
//  Recipe
//
//  Created by Jongho Lee on 4/14/25.
//

@testable import Recipe

class MockRecipeRepository: RecipeRepositoryProtocol {
	var result: Result<[Recipe], Error>!

	func fetchRecipes() async throws -> [Recipe] {
		switch result {
		case .success(let recipes):
			return recipes
		case .failure(let error):
			throw error
		default:
			fatalError("Invalid mock setup")
		}
	}
}
