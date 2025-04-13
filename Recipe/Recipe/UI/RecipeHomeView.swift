//
//  RecipeHomeView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeHomeView: View {
	
	@State var recipes: [Recipe] = []
	
	var body: some View {
		NavigationView {
			Group {
				List(recipes, id: \.uuid) { recipe in
					RecipeRowView(recipe: recipe)
				}
				.navigationTitle("Recipes")
				.refreshable {
					await fetchRecipes()
				}
				.task {
					await fetchRecipes()
				}
			}
		}
	}
	
	// All Recipes: https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json
	// Malformed Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json
	// Empty Data: https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json
	func fetchRecipes() async {
		do {
			let apiClient = APIClient()
			let recipesResponse = try await apiClient.fetch(for: RecipesResponseDTO.self, from: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
			self.recipes = RecipeMapper.mapList(recipesResponse.recipes)
		} catch {
			print(error)
		}
	}
}

struct RecipeRowView: View {
	let recipe: Recipe
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 4) {
				Text(recipe.name)
					.font(.headline)
				Text(recipe.cuisine)
					.font(.subheadline)
					.foregroundColor(.gray)
			}
		}
		.padding(.vertical, 4)
	}
}

#Preview {
    RecipeHomeView()
}
