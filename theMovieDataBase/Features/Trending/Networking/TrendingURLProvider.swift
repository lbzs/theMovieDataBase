//
//  TrendingURLProvider.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

final class TrendingURLProvider: URLProvider {

	func makeURL() -> URL? {
		return URL(string: "https://api.themoviedb.org/3/trending/all/day")
	}
}
