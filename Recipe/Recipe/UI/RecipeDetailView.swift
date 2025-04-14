//
//  RecipeDetailView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/14/25.
//

import SwiftUI

struct RecipeDetailView: View {
	var recipe: Recipe
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 15) {
				Text(recipe.name)
					.font(.title)
					.fontWeight(.bold)
				
				AsyncCachedImage(urlString: recipe.photoUrlLarge, id: recipe.id + "_large")
					.cornerRadius(5)

				Text("Cuisine: \(recipe.cuisine)")
					.font(.caption)
				
				if let urlString = recipe.sourceUrl, let sourceURL = URL(string: urlString) {
					Link("Detail Recipe", destination: sourceURL)
						.font(.subheadline)
						.foregroundColor(.blue)
				}
				
				if let urlString = recipe.youtubeUrl, let youtubeURL = URL(string: urlString) {
					Link("Watch on YouTube", destination: youtubeURL)
						.font(.subheadline)
						.foregroundColor(.blue)
				}
			}
			.padding()
		}
	}
}

#Preview {
	RecipeDetailView(recipe: .init(uuid: "", name: "Apam Balik", cuisine: "Malaysian", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"))
}
