//
//  RecipeHomeView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeHomeView: View {
	
	@ObservedObject var viewModel: RecipesListViewModel
	
	var body: some View {
		Group {
			switch viewModel.state {
			case .idle, .loading:
				ProgressView()
			case .loaded(let recipes):
				if recipes.isEmpty {
					RecipeEmptyView {
						Task {
							await viewModel.loadRecipes()
						}
					}
				} else {
					RecipeListView(recipes: recipes)
						.refreshable {
							await viewModel.loadRecipes(isRefresh: true)
						}
				}
			case .failed(let errorMessage):
				RecipeLoadErrorView(errorMessage: errorMessage) {
					Task {
						await viewModel.loadRecipes()
					}
				}
			}
		}
		.task {
			if case .idle = viewModel.state {
				await viewModel.loadRecipes()
			}
		}
	}
}

#Preview {
	RecipeHomeView(viewModel: .init(recipeRepository: RecipeRepository(apiClient: APIClient())))
}
