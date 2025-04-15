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
	
	var sortedAndFilteredRecipes: [Recipe] {
		let filtered = recipes.filter { recipe in
			searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText) || recipe.cuisine.localizedCaseInsensitiveContains(searchText)
		}
		
		switch sortOption {
		case .name:
			return filtered.sorted { $0.name < $1.name }
		case .cuisine:
			return filtered.sorted { $0.cuisine < $1.cuisine }
		}
	}
	
	init(recipes: [Recipe]) {
		self.recipes = recipes
	}
}
