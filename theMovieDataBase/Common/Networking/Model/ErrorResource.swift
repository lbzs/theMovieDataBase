//
//  ErrorResource.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

struct ErrorResource: Codable {
	let statusCode: Int
	let statusMessage: String
}
