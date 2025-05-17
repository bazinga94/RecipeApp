//
//  RecipeListView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeListView: View {
	@ObservedObject private var viewModel: RecipeListViewModel
	let onScrollToBottom: () -> Void
	
	init(viewModel: RecipeListViewModel, onScrollToBottom: @escaping () -> Void) {
		self.viewModel = viewModel
		self.onScrollToBottom = onScrollToBottom
	}
	
	var body: some View {
		NavigationView {
			VStack {
				Picker("Sort by", selection: $viewModel.sortOption) {
					ForEach(RecipeListViewModel.SortOption.allCases, id: \.self) { option in
						Text(option.rawValue)
					}
				}
				.pickerStyle(.segmented)
				.padding(.vertical, 5)
				.padding(.horizontal, 40)
				
				List {
					switch viewModel.sortOption {
					case .name:
						ForEach(viewModel.sortedRecipes) { recipe in
							NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
								RecipeRow(recipe: recipe)
									.onAppear {
										if recipe == viewModel.recipes.last {
											onScrollToBottom()
										}
									}
							}
						}
//						ForEach(Array(viewModel.sortedRecipes.enumerated()), id: \.element.id) { index, recipe in
//							NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
//								RecipeRow(recipe: recipe)
//									.onAppear {
//										Task {
//											await viewModel.prefetchIfNeeded(index: index)
//										}
//									}
//							}
//						}
					case .cuisine:
						ForEach(viewModel.groupedRecipes.keys.sorted(), id: \.self) { cuisine in
							Section(header: Text(cuisine).font(.title2).fontWeight(.bold)) {
								ForEach(viewModel.groupedRecipes[cuisine] ?? []) { recipe in
									NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
										RecipeRow(recipe: recipe)
									}
								}
							}
						}
					}
				}
			}
			.navigationTitle("Recipes")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
		}
    }
}

#Preview {
	RecipeListView(viewModel: RecipeListViewModel(recipes: [.init(uuid: "", name: "TEST", cuisine: "Korean", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)]), onScrollToBottom: {})
}
