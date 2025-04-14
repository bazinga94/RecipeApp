//
//  RecipeList.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeList: View {
	@State var recipes: [Recipe]
	
    var body: some View {
		List(recipes, id: \.uuid) { recipe in
			RecipeRow(recipe: recipe)
		}
		.navigationTitle("Recipes")
    }
}

#Preview {
	RecipeList(recipes: [])
}
