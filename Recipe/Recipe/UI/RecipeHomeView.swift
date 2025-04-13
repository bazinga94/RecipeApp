//
//  RecipeHomeView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeHomeView: View {
	
	@StateObject var viewModel: RecipesListViewModel
	
	var body: some View {
		NavigationView {
			Group {
				if let errorMessage = viewModel.errorMessage {
					VStack(spacing: 15) {
						Text(errorMessage)
							.foregroundColor(.red)
						Button("Retry") {
							Task {
								await viewModel.fetchRecipes()
							}
						}
					}
				} else {
					VStack {
						List(viewModel.recipes, id: \.uuid) { recipe in
							RecipeRow(recipe: recipe)
						}
						.navigationTitle("Recipes")
						.refreshable {
							await viewModel.fetchRecipes()
						}
					}
					.task {
						await viewModel.fetchRecipes()
					}
				}
			}
		}
	}
}

#Preview {
	RecipeHomeView(viewModel: .init(apiClient: APIClient()))
}
