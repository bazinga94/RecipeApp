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
	
	enum State: Equatable {
		case idle
		case loading
		case failed(String)
		case loaded([Recipe])
		
		static func ==(lhs: State, rhs: State) -> Bool {
			switch (lhs, rhs) {
			case (.idle, .idle), (.loading, .loading):
				return true
			case (.failed(let message1), .failed(let message2)):
				return message1 == message2
			case (.loaded(let recipes1), .loaded(let recipes2)):
				return recipes1 == recipes2
			default:
				return false
			}
		}
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
