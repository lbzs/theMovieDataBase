//
//  ContentView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 16..
//

import SwiftUI

struct ContentView: View {

	let viewModel: TrendingViewModel
	
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
		.onAppear(perform: viewModel.load)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView(viewModel: TrendingViewModel(session: URLSession.shared, urlProvider: TrendingURLProvider()))
    }
}
