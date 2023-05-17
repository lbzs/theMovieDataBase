//
//  TrendingViewModel.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import Foundation

final class TrendingViewModel {

	@Published
	private(set) var trending: [Trending] = []

	private let networkController: NetworkController<PagedResource<Trending>>

	init(session: URLSession, urlProvider: URLProvider) {
		self.networkController = NetworkController(session: session, urlProvider: urlProvider)
	}

	func load() {
		Task {
			if let trending = try? await networkController.load().results { // TODO: error handling
				await MainActor.run {
					self.trending = trending
				}
			}
		}
	}
}
