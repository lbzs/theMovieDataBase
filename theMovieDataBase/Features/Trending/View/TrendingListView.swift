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
			HStack(spacing: 0) {
				ForEach(trending) { trend in
					TrendingCell(image: Image(uiImage: trend.image), title: trend.title, date: trend.releaseDate, voteAverage: trend.voteAverage)
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

	private var formattedVoteAverage: Double {
		var formattedVoteAverage = voteAverage
		while formattedVoteAverage >= 1.0 {
			formattedVoteAverage /= 10
		}
		return formattedVoteAverage
	}

	private var formattedVoteAverage2: Double {

		var formattedVoteAverage = voteAverage
		while formattedVoteAverage <= 10 {
			formattedVoteAverage *= 10
		}
		return formattedVoteAverage
	}

	var body: some View {
		VStack {
			ZStack(alignment: .bottomLeading) {
				image?
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(10)
					.frame(width: 150, height: 200)
				ZStack {
					Circle()
					RatingView(percentage: formattedVoteAverage)
						.foregroundColor(.yellow)
					HStack(spacing: 0) {
						Text(String(format: "%1.0f", formattedVoteAverage2))
							.foregroundColor(.white)
							.fontWeight(.bold)
							.font(.subheadline)
						Text("%")
							.foregroundColor(.white)
							.font(.caption2)
					}
				}
				.frame(width: 45, height: 45, alignment: .center)
				.offset(x: 20, y: 22.5)
			}
			Spacer().frame(height: 30)
			Text(title)
				.frame(width: 120, alignment: .leading)
				.fixedSize(horizontal: true, vertical: false)
				.lineLimit(nil)
				.fontWeight(.bold)
				.font(.subheadline)
			Text(formattedDate)
				.frame(width: 120, alignment: .leading)
				.fontWeight(.thin)
				.font(.subheadline)
			Spacer()
		}
	}
}

struct RatingView: Shape {

	// value between 0 and 100
	var percentage: Double

	func path(in rect: CGRect) -> Path {
		var path = Path()
		path.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
					radius: rect.width / 2 - 2,
					startAngle: .degrees(-90),
					endAngle: .degrees(-90 + percentage * 360),
					clockwise: false)
		return path.strokedPath(.init(lineWidth: 3, lineCap: .round))
	}
}

struct TrendingListView_Preview: PreviewProvider {
	static var previews: some View {
		TrendingListView(trending: [Trending(id: 1,
											 title: "Title",
											 posterPath: "",
											 voteAverage: 9.2,
											 mediaType: .movie,
											 releaseDate: "2023-11-02",
											 image: .add)])
	}
}
