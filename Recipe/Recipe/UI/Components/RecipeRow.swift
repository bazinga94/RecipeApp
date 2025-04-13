//
//  RecipeRow.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeRow: View {
	let recipe: Recipe
	
	var body: some View {
		HStack(alignment: .top) {
			VStack(alignment: .leading, spacing: 4) {
				Text(recipe.name)
					.font(.headline)
				Text(recipe.cuisine)
					.font(.subheadline)
					.foregroundColor(.gray)
			}
		}
		.padding(.vertical, 4)
	}
}

#Preview {
	RecipeRow(recipe: .init(uuid: "", name: "TEST NAME", cuisine: "TEST CUISINE", photoUrlLarge: nil, photoUrlSmall: nil, sourceUrl: nil, youtubeUrl: nil))
}
