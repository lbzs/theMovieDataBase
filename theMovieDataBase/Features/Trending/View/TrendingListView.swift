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
		NavigationView {
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 0) {
					ForEach(trending) { trend in
						NavigationLink(destination: DetailView()) {
							TrendingCell(image: Image(uiImage: trend.image), title: trend.title, date: trend.releaseDate, voteAverage: trend.voteAverage)
								.navigationTitle("Trending")
						}
					}
				}
			}
		}
	}
}

struct TrendingCell: View {

	var image: Image?
	var title: String
	var date: String
	var voteAverage: Double

	private var formattedDate: String {
		guard let date = DateFormatter.NetworkRequestDateFormatter.date(from: date) else {
			return date
		}
		return DateFormatter.UIDateFormatter.string(from: date)
	}

	var body: some View {
		VStack {
			ZStack(alignment: .bottomLeading) {
				image?
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(10)
					.frame(width: 150, height: 200)
				RatingView(rating: voteAverage)
					.offset(x: 20, y: 22.5)
			}
			Spacer().frame(height: 30)
			Text(title)
				.frame(width: 120, alignment: .leading)
				.fixedSize(horizontal: true, vertical: false)
				.lineLimit(nil)
				.fontWeight(.bold)
				.font(.subheadline)
				.foregroundColor(.primary)
			Text(formattedDate)
				.frame(width: 120, alignment: .leading)
				.fontWeight(.thin)
				.font(.subheadline)
				.foregroundColor(.primary)
			Spacer()
		}
	}
}

struct TrendingListView_Preview: PreviewProvider {
	static var previews: some View {
		TrendingListView(trending: [Trending(id: 1,
											 title: "Title",
											 posterPath: "",
											 voteAverage: 0.92,
											 mediaType: .movie,
											 releaseDate: "2023-11-02",
											 image: UIImage(named: "sample")!)])
	}
}
