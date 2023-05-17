//
//  Trending.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

struct Trending: Decodable {

	let title: String
	let posterPath: String
	let voteAverage: Double
}
