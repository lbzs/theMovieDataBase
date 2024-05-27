//
//  TrendingListView.swift
//  theMovieDataBase
//
//  Created by Bálna on 2023. 05. 23..
//

import Foundation
import SwiftUI


struct TrendingListViewDataProvider {
    private var trending: [Trending]
    
    init(trending: [Trending]) {
        self.trending = trending
    }
    
    func data() -> [TrendingCell.Data] {
        trending.map { (trending: Trending) in
            TrendingCell.Data(
                id: trending.id,
                image: Image(uiImage: trending.image),
                title: trending.title,
                releaseDate: formatDate(trending.releaseDate),
                voteAverage: trending.voteAverage
            )
        }
    }
    
    private func formatDate(_ date: String) -> String {
        guard let date = DateFormatter.NetworkRequestDateFormatter.date(from: date) else {
            return date
        }
        return DateFormatter.UIDateFormatter.string(from: date)
    }
}

struct TrendingListView: View {
    var dataProvider: TrendingListViewDataProvider

	var body: some View {
		NavigationView {
			ScrollView(.horizontal, showsIndicators: false) {
				HStack(spacing: 0) {
                    ForEach(dataProvider.data()) { data in
						NavigationLink(destination: DetailView(title: data.title, releaseYear: data.releaseDate, rating: data.voteAverage)) {
                            TrendingCell(data: data)
								.navigationTitle("Trending")
						}
					}
				}
			}
		}
	}
}

struct TrendingCell: View {
    
    struct Data: Identifiable {
        let id: Int
        let image: Image?
        let title: String
        let releaseDate: String
        let voteAverage: Double
    }
    
    var data: Data

	var body: some View {
		VStack {
			ZStack(alignment: .bottomLeading) {
                data.image?
					.resizable()
					.aspectRatio(contentMode: .fit)
					.cornerRadius(10)
					.frame(width: 150, height: 200)
                RatingView(rating: data.voteAverage)
					.offset(x: 20, y: 22.5)
			}
			Spacer().frame(height: 30)
            Text(data.title)
				.frame(width: 120, alignment: .leading)
				.fixedSize(horizontal: true, vertical: false)
				.lineLimit(nil)
				.fontWeight(.bold)
				.font(.subheadline)
				.foregroundColor(.primary)
            Text(data.releaseDate)
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
        TrendingListView(
            dataProvider: TrendingListViewDataProvider(
                trending: [Trending(id: 1,
                                    title: "Title",
                                    posterPath: "",
                                    voteAverage: 0.92,
                                    mediaType: .movie,
                                    releaseDate: "2023-11-02",
                                    image: UIImage(named: "sample")!)]))
    }
}
