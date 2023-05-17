//
//  theMovieDataBaseApp.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import SwiftUI

@main
struct theMovieDataBaseApp: App {
    var body: some Scene {
        WindowGroup {
			ContentView(viewModel: TrendingViewModel(session: URLSession.shared, urlProvider: TrendingURLProvider()))
        }
    }
}
