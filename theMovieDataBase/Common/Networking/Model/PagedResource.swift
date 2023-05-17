//
//  PagedResource.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

struct PagedResource<T>: Decodable where T: Decodable {
	
	let page: Int
	let totalPages: Int
	let totalResults: Int
	let results: [T]
}
