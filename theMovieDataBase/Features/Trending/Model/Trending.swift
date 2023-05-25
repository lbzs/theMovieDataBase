//
//  Trending.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation
import UIKit

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
	let releaseDate: String
	let image: UIImage

	enum CodingKeys: CodingKey {
		case id
		case title // media type `movie` uses `title` for title
		case name // media type `tv` & `prople` uses `name` for title
		case posterPath
		case voteAverage
		case mediaType
		case releaseDate // media type `movie` uses `releaseDate` for release date
		case firstAirDate // media type `tv` uses `firstAirDate` for release date
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
		if let date = try container.decodeIfPresent(String.self, forKey: .releaseDate) {
			releaseDate = date
		} else if let date = try container.decodeIfPresent(String.self, forKey: .firstAirDate) {
			releaseDate = date
		} else {
			releaseDate = ""
		}
		image = UIImage()
	}

	init(id: Int,
		 title: String,
		 posterPath: String,
		 voteAverage: Double,
		 mediaType: MediaType,
		 releaseDate: String,
		 image: UIImage) {
		self.id = id
		self.title = title
		self.posterPath = posterPath
		self.voteAverage = voteAverage
		self.mediaType = mediaType
		self.releaseDate = releaseDate
		self.image = image
	}
}
