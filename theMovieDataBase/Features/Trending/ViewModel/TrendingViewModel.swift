//
//  TrendingViewModel.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import Combine
import UIKit
import Foundation

enum ViewState {
	case initial
	case loading
	case loaded
	case failedToLoad
}

@MainActor
final class TrendingViewModel: ObservableObject {
	var cancellables: [AnyCancellable] = []

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
				await MainActor.run { [weak self] in
					self?.trending = trending
				}


				let imageURLs = trending.map(\.posterPath)
				let imageDataDictionary = try await networkController.loadImageData(from: imageURLs)

				for (index, element) in trending.enumerated() {
					guard let data = imageDataDictionary[element.posterPath],
						  let image = UIImage(data: data) else {
						return
					}
					let newTrending = Trending(id: element.id,
											   title: element.title,
											   posterPath: element.posterPath,
											   voteAverage: element.voteAverage,
											   mediaType: element.mediaType,
											   releaseDate: element.releaseDate,
											   image: image)
					await MainActor.run { [weak self] in
						self?.trending[index] = newTrending
					}
				}
			} catch {
				viewState = .failedToLoad
				print(error)
			}
		}
	}
}

extension TrendingViewModel: EventListener {
	struct Events {
		let viewWillAppear: PassthroughSubject<Void, Never>
	}
	func listen(events: Events) {
		let viewWillAppearSubscriber = events.viewWillAppear.sink { [weak self] _ in
			self?.load()
		}
		cancellables.append(viewWillAppearSubscriber)
	}
}
