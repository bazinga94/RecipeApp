//
//  RecipeRepository.swift
//  Recipe
//
//  Created by Jongho Lee on 4/14/25.
//

import Foundation

protocol RecipeRepositoryProtocol {
	func fetchRecipes() async throws -> [Recipe]
}

class RecipeRepository: RecipeRepositoryProtocol {
	
	private enum URL {
		static let all = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
		static let malformed = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
		static let empty = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
	}
	
	private let apiClient: APIClientProtocol
	
	init(apiClient: APIClientProtocol) {
		self.apiClient = apiClient
	}
	
	// All Recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
	// Malformed Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
	// Empty Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
	
	func fetchRecipes() async throws -> [Recipe] {
		let dto = try await apiClient.fetch(
			for: RecipesResponseDTO.self,
			from: URL.all
		)
		return RecipeMapper.mapList(dto.recipes)
	}
}
