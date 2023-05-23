//
//  Trending.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

struct Trending: Decodable, Identifiable {

	enum MediaType: String, Decodable {
		case movie
		case tv
		case people
	}

	let id: Int
	let title: String
	let posterPath: String
	let voteAverage: Double
	let mediaType: MediaType

	enum CodingKeys: CodingKey {
		case id
		case title // media type `movie` uses `title` for title
		case name // media type `tv` & `prople` uses `name` for title
		case posterPath
		case voteAverage
		case mediaType
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Trending.CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		mediaType = try container.decode(MediaType.self, forKey: .mediaType)
		if let name = try container.decodeIfPresent(String.self, forKey: .name) {
			title = name
		} else if let title = try container.decodeIfPresent(String.self, forKey: .title) {
			self.title = title
		} else {
			title = ""
		}
		posterPath = try container.decode(String.self, forKey: .posterPath)
		voteAverage = try container.decode(Double.self, forKey: .voteAverage)
	}
}
