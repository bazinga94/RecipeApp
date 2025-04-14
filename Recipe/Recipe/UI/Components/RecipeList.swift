//
//  RecipeList.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeList: View {
	enum SortOption: String, CaseIterable {
		case name = "Name"
		case cuisine = "Cuisine"
	}
	
	@State private var sortOption: SortOption = .name
	@State var recipes: [Recipe]
	@State var searchText: String = ""
	
	private var sortedAndFilteredRecipes: [Recipe] {
		
		let filteredRecipes = recipes.filter { recipe in
			return searchText.isEmpty || recipe.name.localizedCaseInsensitiveContains(searchText) || recipe.cuisine.localizedCaseInsensitiveContains(searchText)
		}
		
		switch sortOption {
		case .name:
			return filteredRecipes.sorted { $0.name < $1.name }
		case .cuisine:
			return filteredRecipes.sorted { $0.cuisine < $1.cuisine }
		}
	}
	
    var body: some View {
		NavigationView {
			List {
				Section {
					Picker("Sort by", selection: $sortOption) {
						ForEach(SortOption.allCases, id: \.self) { option in
							Text(option.rawValue)
						}
					}
					.pickerStyle(.segmented)
					.padding(.vertical, 5)
					.padding(.horizontal, 40)
				}
				
				Section {
					ForEach(sortedAndFilteredRecipes) { recipe in
//						RecipeRow(recipe: recipe)
						NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
							RecipeRow(recipe: recipe)
						}
					}
				}
			}
			.navigationTitle("Recipes")
			.navigationBarTitleDisplayMode(.inline)
			.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
		}
			
//		.toolbar {
//			ToolbarItem {
//				TextField("Search recipe", text: $searchText)
//					.textFieldStyle(.roundedBorder)
//			}
//		}
		
//		VStack {
//			Picker("Sort by", selection: $sortOption) {
//				ForEach(SortOption.allCases, id: \.self) { option in
//					Text(option.rawValue)
//				}
//			}
//			.pickerStyle(.segmented)
//			.padding(.all)
//			
//			List(sortedRecipes, id: \.uuid) { recipe in
//				RecipeRow(recipe: recipe)
//			}
//		}
//		.navigationTitle("Recipes")
    }
}

struct RecipeDetailView: View {
	var recipe: Recipe
	
	var body: some View {
		VStack {
			Text(recipe.name)
				.font(.largeTitle)
				.padding()
			
			Text(recipe.cuisine)
				.font(.title2)
				.padding()
			
			Text(recipe.photoUrlLarge ?? "")
				.padding()
			
			Spacer()
		}
		.navigationTitle("Recipe Details")
	}
}

#Preview {
	RecipeList(recipes: [.init(uuid: "", name: "TEST", cuisine: "Korean", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil)])
}
