//
//  RecipeListViewModel.swift
//  Recipe
//
//  Created by Jongho Lee on 4/15/25.
//

import SwiftUI

class RecipeListViewModel: ObservableObject {
	enum SortOption: String, CaseIterable {
		case name = "Name"
		case cuisine = "Cuisine"
	}

	@Published var recipes: [Recipe]
	@Published var searchText: String = ""
	@Published var sortOption: SortOption = .name
	
	var filteredRecipes: [Recipe] {
		return recipes.filter { recipe in
			searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText) || recipe.cuisine.localizedCaseInsensitiveContains(searchText)
		}
	}
	
	var sortedRecipes: [Recipe] {
		return filteredRecipes.sorted { $0.name < $1.name }
	}
	
	var groupedRecipes: [String: [Recipe]] {
		let sorted = filteredRecipes.sorted { $0.cuisine < $1.cuisine }
		return Dictionary(grouping: sorted) { $0.cuisine }
	}
	
	init(recipes: [Recipe]) {
		self.recipes = recipes
	}
}
