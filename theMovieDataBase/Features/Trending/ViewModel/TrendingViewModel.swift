//
//  TrendingViewModel.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import Foundation

enum ViewState {
	case initial
	case loading
	case loaded
	case failedToLoad
}

@MainActor
final class TrendingViewModel: ObservableObject {

	@Published
	private(set) var trending: [Trending] = []

	@Published
	private(set) var viewState: ViewState = .initial

	private let networkController: NetworkController<PagedResource<Trending>>

	init(session: URLSession, urlProvider: URLProvider) {
		self.networkController = NetworkController(session: session, urlProvider: urlProvider)
	}

	func load() {
		viewState = .loading
		Task {
			do {
				let trending = try await networkController.load().results
				viewState = .loaded
				await MainActor.run {
					self.trending = trending
				}
			} catch {
				viewState = .failedToLoad
				print(error)
			}
		}
	}
}
