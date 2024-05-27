//
//  EventListener.swift
//  theMovieDataBase
//
//  Created by Bálna on 2024. 03. 03..
//

import Foundation

protocol EventListener {
	associatedtype Events
	func listen(events: Events)
}
