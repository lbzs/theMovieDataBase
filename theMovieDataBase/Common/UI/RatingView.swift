//
//  RatingView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 07. 04..
//

import SwiftUI

struct RatingView: View {

	var rating: Double

	private var formattedVoteAverage: Double {
		var formattedVoteAverage = rating
		while formattedVoteAverage >= 1.0 {
			formattedVoteAverage /= 10
		}
		return formattedVoteAverage
	}

	private var formattedVoteAverage2: Double {

		var formattedVoteAverage = rating
		while formattedVoteAverage <= 10 {
			formattedVoteAverage *= 10
		}
		return formattedVoteAverage
	}

	private var ratingColor: Color {
		switch formattedVoteAverage {
		case 0..<0.4:
			return .red
		case 0.4..<0.7:
			return .yellow
		default:
			return .green
		}
	}

	var body: some View {
		ZStack {
			Circle()
			RatingOverlay(percentage: formattedVoteAverage)
				.foregroundColor(ratingColor)
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
	}
}

private struct RatingOverlay: Shape {

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

struct RatingView_Preview: PreviewProvider {
	static var previews: some View {
		RatingView(rating: 79)
	}
}
