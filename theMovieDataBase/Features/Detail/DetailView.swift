//
//  DetailView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 07. 04..
//

import SwiftUI

struct DetailView: View {

	@Environment(\.dismiss) private var dismiss

	var title: String = "Nimona"
	var releaseYear: String = "2023"
	var genres: String = "Animation, Science Fiction, Action, Adventure, Fantasy"
	var runtime: String = "1h 43m"
	var rating: Double = 0.69
	var tagline: String = "A new hero takes shape."
	var overview: String = "A knight framed for a tragic crime teams with a scrappy, shape-shifting teen to prove his innocence."

	var body: some View {

		ZStack(alignment: .topLeading) {
			Image("sample")
				.resizable()
				.offset(CGSize(width: 0, height: -200))

			ScrollView(showsIndicators: false) {
				VStack(alignment: .leading) {
					Text(title)
						.font(.title)
						.fontWeight(.bold)
					Text("(\(releaseYear))")
						.font(.title3)
						.fontWeight(.light)
						.foregroundColor(.gray)
					Text("\(genres) * \(runtime)")
						.font(.caption2)
					HStack(alignment: .top) {
						VStack(alignment: .leading) {
							HStack {
								RatingView(rating: rating)
								Text("User\nScore")
									.font(.footnote)
									.fontWeight(.bold)
							}
							Text(tagline)
								.font(.footnote)
								.fontWeight(.light)
								.italic()
							Text("Overview")
								.fontWeight(.bold)
							Text(overview)
								.fontWeight(.light)
						}
					}

					Spacer(minLength: 500)
				}
				.padding()
				.border(.clear)
				.padding()
				.background()
				.cornerRadius(20)
				.offset(CGSize(width: 0, height: 300))
			}
			HStack(alignment: .top) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "x.circle.fill")
						.foregroundColor(.white)
						.imageScale(.large)
						.frame(width: 50, height: 50)
						.shadow(radius: 5)
				}

			}
		}
		.navigationBarBackButtonHidden(true)
	}
}

struct DetailView_Preview: PreviewProvider {
	static var previews: some View {
		DetailView()
	}
}

