//
//  DateFormatter+Extensions.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 26..
//

import Foundation

extension DateFormatter {

	static var NetworkRequestDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	static var UIDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.dateStyle = .medium
		return formatter
	}()
}
