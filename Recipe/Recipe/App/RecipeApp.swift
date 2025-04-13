//
//  RecipeApp.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

@main
struct RecipeApp: App {
    var body: some Scene {
        WindowGroup {
			RecipeHomeView(viewModel: .init(apiClient: APIClient()))
        }
    }
}
