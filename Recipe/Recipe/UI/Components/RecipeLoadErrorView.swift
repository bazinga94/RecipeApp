//
//  RecipeLoadErrorView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeLoadErrorView: View {
	let errorMessage: String
	let retryAction: () -> Void
	
    var body: some View {
		VStack(spacing: 12) {
			Image(systemName: "exclamationmark.triangle")
				.font(.largeTitle)
				.foregroundColor(.gray)
			Text(errorMessage)
				.font(.title3)
				.foregroundColor(.red)
			Button("Retry", action: retryAction)
		}
    }
}

#Preview {
	RecipeLoadErrorView(errorMessage: "Something went wrong. \nPlease try again later.", retryAction: {})
}
