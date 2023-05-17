//
//  HTTPURLResponse+Extensions.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 17..
//

import Foundation

extension HTTPURLResponse {

	func isSuccessful() -> Bool {
		switch statusCode {
		case 200, 201:
			return true
		default:
			return false
		}
	}
}
