//
//  ContentView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import Combine
import SwiftUI

struct ContentView: View {
	let viewWillAppear = PassthroughSubject<Void, Never>()

	init(viewModel: TrendingViewModel) {
		self.viewModel = viewModel
		viewModel.listen(
			events: TrendingViewModel.Events(
				viewWillAppear: viewWillAppear
			)
		)
	}

	@ObservedObject
	var viewModel: TrendingViewModel
	
    var body: some View {
		TrendingListView(trending: viewModel.trending)
		.onAppear(perform: viewWillAppear.send)
		.refreshable {
            viewWillAppear.send(())
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(viewModel: TrendingViewModel(session: URLSession.shared, urlProvider: TrendingURLProvider()))
    }
}
