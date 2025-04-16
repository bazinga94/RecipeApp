//
//  RecipeApp.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

@main
struct RecipeApp: App {
	// When the app starts
	init () {
		let imageCacheManager = ImageDiskCacheManager()
		// Perform cache cleanup in a background thread
		Task.detached {
			imageCacheManager.cleanupOldCache(expirationDays: 7)
		}
		
	}
	
	var body: some Scene {
		WindowGroup {
			RecipeHomeView(viewModel: .init(recipeRepository: RecipeRepository(apiClient: APIClient())))
		}
	}
}
