//
//  RecipeEmptyView.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct RecipeEmptyView: View {
	let retryAction: () -> Void
	
    var body: some View {
		VStack(spacing: 12) {
			Image(systemName: "carrot")
				.font(.largeTitle)
				.foregroundColor(.gray)
			Text("No recipes available.")
				.font(.title)
				.foregroundColor(.gray)
			Button("Retry", action: retryAction)
		}
		.padding()
    }
}

#Preview {
	RecipeEmptyView(retryAction: {})
}
