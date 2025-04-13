//
//  RecipeMapper.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

struct RecipeMapper {
	static func map(dto: RecipeDTO) -> Recipe {
		return Recipe(
			uuid: dto.uuid,
			name: dto.name,
			cuisine: dto.cuisine,
			photoUrlLarge: dto.photo_url_large,
			photoUrlSmall: dto.photo_url_small,
			sourceUrl: dto.source_url,
			youtubeUrl: dto.youtube_url
		)
	}

	static func mapList(_ dtos: [RecipeDTO]) -> [Recipe] {
		return dtos.map { map(dto: $0) }
	}
}
