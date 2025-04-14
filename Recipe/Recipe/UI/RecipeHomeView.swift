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
							await viewModel.fetchRecipes()
						}
					}
				} else {
					RecipeListView(recipes: recipes)
						.refreshable {
							await viewModel.fetchRecipes(isRefresh: true)
						}
				}
			case .failed(let errorMessage):
				RecipeLoadErrorView(errorMessage: errorMessage) {
					Task {
						await viewModel.fetchRecipes()
					}
				}
			}
		}
		.task {
			if case .idle = viewModel.state {
				await viewModel.fetchRecipes()
			}
		}
	}
}

#Preview {
	RecipeHomeView(viewModel: .init(apiClient: APIClient()))
}
