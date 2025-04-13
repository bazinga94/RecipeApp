//
//  Recipe.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

struct Recipe: Identifiable {
	var id: String { uuid }
	
	let uuid: String
	let name: String
	let cuisine: String
	let photoUrlLarge: String?
	let photoUrlSmall: String?
	let sourceUrl: String?
	let youtubeUrl: String?
}
