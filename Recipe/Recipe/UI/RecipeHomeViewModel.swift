//
//  RecipeHomeViewModel.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import Foundation

class RecipesListViewModel: ObservableObject {

	@Published private(set) var state = State.idle
	
	private var apiClient: APIClientProtocol
	
	enum State {
		case idle
		case loading
		case failed(String)
		case loaded([Recipe])
	}
	
	init(apiClient: APIClientProtocol) {
		self.apiClient = apiClient
	}
	
	@MainActor
	func fetchRecipes(isRefresh: Bool = false) async {
		if case .loading = state { return }
		
		if !isRefresh {
			state = .loading
		}
		
		// All Recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
		// Malformed Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
		// Empty Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
		
		do {
			let recipesResponse = try await self.apiClient.fetch(for: RecipesResponseDTO.self, from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
			self.state = .loaded(RecipeMapper.mapList(recipesResponse.recipes))
		} catch {
			print(error)
			self.state = .failed("Something went wrong. \nPlease try again later.")
		}
	}
}
