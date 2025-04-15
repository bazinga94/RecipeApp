//
//  RecipeListView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeListView: View {
	@StateObject private var viewModel: RecipeListViewModel
	
	init(recipes: [Recipe]) {
		_viewModel = StateObject(wrappedValue: RecipeListViewModel(recipes: recipes))
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
					Section {
						ForEach(viewModel.sortedAndFilteredRecipes) { recipe in
							NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
								RecipeRow(recipe: recipe)
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
	RecipeListView(recipes: [.init(uuid: "", name: "TEST", cuisine: "Korean", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)])
}
