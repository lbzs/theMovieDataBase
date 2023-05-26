//
//  TrendingListView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 23..
//

import Foundation
import SwiftUI

struct TrendingListView: View {

	var trending: [Trending]

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack {
				ForEach(trending) { trend in
					TrendingCell(image: Image(uiImage: trend.image), title: trend.title, date: trend.releaseDate)
				}
			}
		}
	}
}

struct TrendingCell: View {

	var image: Image?
	var title: String
	var date: String

	private var formattedDate: String {
		guard let date = DateFormatter.NetworkRequestDateFormatter.date(from: date) else {
			return date
		}
		return DateFormatter.UIDateFormatter.string(from: date)
	}

	var body: some View {
		VStack {
			image?
				.resizable()
				.aspectRatio(contentMode: .fit)
				.cornerRadius(10)
				.frame(width: 150, height: 200)
			Text(title).frame(width: 100).fixedSize(horizontal: true, vertical: false).lineLimit(nil)
			Text(formattedDate)
			Spacer()
		}
	}
}

struct TrendingListView_Preview: PreviewProvider {
	static var previews: some View {
		TrendingListView(trending: [])
	}
}
