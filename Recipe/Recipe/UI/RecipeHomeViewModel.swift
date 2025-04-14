//
//  RecipeHomeViewModel.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import Foundation

class RecipesListViewModel: ObservableObject {

	@Published private(set) var state = State.idle
	
	private let recipeRepository: RecipeRepositoryProtocol
	
	enum State {
		case idle
		case loading
		case failed(String)
		case loaded([Recipe])
	}
	
	init(recipeRepository: RecipeRepositoryProtocol) {
		self.recipeRepository = recipeRepository
	}
	
	@MainActor
	func loadRecipes(isRefresh: Bool = false) async {
		if case .loading = state { return }
		
		if !isRefresh {
			state = .loading
		}
		
		do {
			let recipes = try await recipeRepository.fetchRecipes()
			state = .loaded(recipes)
		} catch {
			print(error)
			state = .failed("Something went wrong. \nPlease try again later.")
		}
	}
}
