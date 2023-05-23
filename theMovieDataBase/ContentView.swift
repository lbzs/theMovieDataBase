//
//  ContentView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import SwiftUI

struct ContentView: View {

	@ObservedObject
	var viewModel: TrendingViewModel
	
    var body: some View {
		switch viewModel.viewState {
		case .initial:
			Text("Initial")
		case .failedToLoad:
			Text("Failed")
		case .loaded:
			Text("Loaded")
		case .loading:
			Text("Loading")
		}
		List(viewModel.trending, rowContent: {
			Text($0.title)
		})
		.onAppear(perform: viewModel.load)
		.refreshable {
			viewModel.load()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(viewModel: TrendingViewModel(session: URLSession.shared, urlProvider: TrendingURLProvider()))
    }
}
