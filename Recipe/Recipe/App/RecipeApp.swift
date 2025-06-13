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
		// Perform cache cleanup in a background thread
		Task.detached {
			try? await ImageDiskCacheManager.shared.cleanupOldCache(expirationDays: 7)
		}
		
		Task.detached {
			let notificationCenter = NotificationCenter.default
			for await _ in notificationCenter.notifications(
				named: UIApplication.didReceiveMemoryWarningNotification
			) {
				await ImageMemoryCacheManager.shared.clearCache()
			}
		}
	}
	
	var body: some Scene {
		WindowGroup {
			RecipeHomeView(viewModel: .init(recipeRepository: RecipeRepository(apiClient: APIClient())))
		}
	}
}
