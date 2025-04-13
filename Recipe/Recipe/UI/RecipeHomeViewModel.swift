//
//  RecipeHomeViewModel.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import Foundation

class RecipesListViewModel: ObservableObject {
	
	@Published var recipes: [Recipe] = []
	@Published var isLoading: Bool = false
	@Published var errorMessage: String?
	
	private var apiClient: APIClientProtocol
	
	init(apiClient: APIClientProtocol) {
		self.apiClient = apiClient
	}
	
	@MainActor
	func fetchRecipes() async {
		guard !isLoading else { return }
		
		isLoading = true
		errorMessage = nil
		
		defer {
			isLoading = false
		}
		
		// All Recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
		// Malformed Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
		// Empty Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
		
		do {
			let recipesResponse = try await self.apiClient.fetch(for: RecipesResponseDTO.self, from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
			self.recipes = RecipeMapper.mapList(recipesResponse.recipes)
		} catch {
			print(error)
			self.errorMessage = "Something went wrong. Please try again later."
		}
	}
}
