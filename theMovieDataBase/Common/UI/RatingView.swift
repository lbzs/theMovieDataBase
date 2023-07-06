//
//  RatingView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 07. 04..
//

import SwiftUI

struct RatingView: View {

	@Environment(\.sizeCategory) var sizeCategory

	// valid between 0.0 and 1.0
	var rating: Double

	private var formattedVoteAverage2: Double {
		return rating * 100
	}

	private var ratingColor: Color {
		switch rating {
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
				.foregroundColor(.black)
			RatingOverlay(percentage: rating)
				.foregroundColor(ratingColor)
			HStack(spacing: 0) {
				Text(String(format: "%1.0f", formattedVoteAverage2))
					.foregroundColor(.white)
					.fontWeight(.bold)
					.font(.subheadline)
					.dynamicTypeSize(.large ... .accessibility2)
				Text("%")
					.foregroundColor(.white)
					.font(.caption2)
					.dynamicTypeSize(.large ... .accessibility2)
			}
		}
		.frame(width: size, height: size, alignment: .center)
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
		RatingView(rating: 1)
	}
}

extension RatingView {

	// Accessibility compatible sizes
	private var size: CGFloat {
		switch sizeCategory {
		case .extraSmall,
			 .small,
			 .medium,
			 .large:
			return 50
		case .extraLarge:
			return 55
		case .extraExtraLarge:
			return 60
		case .extraExtraExtraLarge:
			return 65
		case .accessibilityMedium:
			return 75
		case .accessibilityLarge,
			 .accessibilityExtraLarge,
			 .accessibilityExtraExtraLarge,
			 .accessibilityExtraExtraExtraLarge:
			return 90
		}
	}

}
