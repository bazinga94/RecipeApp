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
	
	private var prefetchedKeys: Set<String> = []
	
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
	
	@MainActor
	func prefetchIfNeeded(index: Int, count: Int = 5) async {
		let upcoming = Array(recipes.dropFirst(index + 1).prefix(count))

		let targets: [(String, String)] = upcoming.compactMap { recipe -> (String, String)? in
			guard let url = recipe.photoUrlSmall else { return nil }
			let key = recipe.smallImageId
			return prefetchedKeys.contains(key) ? nil : (url, key)
		}

		guard !targets.isEmpty else { return }

		for (_, key) in targets {
			prefetchedKeys.insert(key)
		}

		let urls = targets.map { $0.0 }
		let keys = targets.map { $0.1 }

		let imagePrefetcher = ImagePrefetcher(diskCache: ImageDiskCacheManager.shared)
		await imagePrefetcher.prefetch(urls: urls, keys: keys)
	}
}
