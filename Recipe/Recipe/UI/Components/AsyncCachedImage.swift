//
//  AsyncCachedImage.swift
//  Recipe
//
//  Created by Jongho Lee on 4/13/25.
//

import SwiftUI

struct AsyncCachedImage: View {
	let urlString: String?
	let id: String
	
	@StateObject private var imageLoader: ImageLoader
	
	init(urlString: String?, id: String) {
		self.urlString = urlString
		self.id = id
		_imageLoader = StateObject(wrappedValue: ImageLoader(memoryCache: ImageMemoryCacheManager.shared, diskCache: ImageDiskCacheManager()))
	}
	
	var body: some View {
		Group {
			if let image = imageLoader.image {
				Image(uiImage: image)
					.resizable()
					.scaledToFill()
			} else if imageLoader.fail {
				Image(systemName: "photo")
					.resizable()
					.scaledToFit()
					.foregroundColor(.gray)
			} else {
				ProgressView()
			}
		}
		.onAppear {
			Task {
				await imageLoader.loadImage(from: urlString, cacheKey: id)
			}
		}
	}
}

#Preview {
	AsyncCachedImage(urlString: nil, id: "")
}
