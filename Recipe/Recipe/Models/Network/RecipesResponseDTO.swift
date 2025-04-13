//
//  RecipesResponseDTO.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

struct RecipesResponseDTO: Decodable {
	let recipes: [RecipeDTO]
}

struct RecipeDTO: Decodable {
	let uuid: String
	let name: String
	let cuisine: String
	let photo_url_large: String?
	let photo_url_small: String?
	let source_url: String?
	let youtube_url: String?
}
