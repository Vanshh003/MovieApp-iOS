//
//  Constants.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 02/03/26.
//

import Foundation
import SwiftUI

struct Constants {
    static let homeString = "Home"
    static let downloadString = "Download"
    static let searchString = "Search"
    static let upcomingString = "Upcoming"
    static let playString = "Play"
    static let trendingMoviesString = "Trending Movies"
    static let trendingTVString = "Trending TV"
    static let topRatedMovieString = "Top Rated Movies"
    static let topRatedTVString = "Top Rated TV"
    static let movieSearchString = "Movie Search"
    static let tvSearchString = "TV Search"
    static let moviePlaceHolderString = "Search for a Movie"
    static let tvPlaceHolderString = "Search for a TV Show"
    
    static let homeIconString = "house"
    static let upcomingIconSrting = "play.circle"
    static let searchIconString = "magnifyingglass"
    static let downloadIconString = "arrow.down.to.line"
    static let tvIconString = "tv"
    static let movieIconString = "movieclapper"
    
    static let testTitleURL = "https://image.tmdb.org/t/p/w1280/lv3OlrXyTNg4Dz0JrtopOmMziNs.jpg"
    static let testTitleURL2 = "https://media.themoviedb.org/t/p/w440_and_h660_face/22bb8mg0wo8BlL84xXjIuMPwWyP.jpg"
    static let testTitleURL3 = "https://media.themoviedb.org/t/p/w440_and_h660_face/lV8YHwGkYZsm6EfIqnhaSz2avKt.jpg"
    
    static let posterURLStart = "https://image.tmdb.org/t/p/w500"
    
    // tmdb api doesnt return full image urls.. it returns a path like /lv301rXyTng4.jpg
    static func addPosterPath(to titles: inout[Title]) {
        for index in titles.indices {
            if let path = titles[index].posterPath {
                titles[index].posterPath = Constants.posterURLStart + path
            }
        }
    }
}

enum YoutubeURLStrings: String {
    case trailer = "trailer"
    case queryShorten = "q"
    case space = " "
    case key = "key"
}

extension Text {
    func ghostButton() -> some View {
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.buttonText)
            .bold()
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.buttonBorder, lineWidth: 5)
            }
    }
}

extension Text {
    func errorMessage() -> some View {
        self
            .foregroundStyle(.red)
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 10))
    }
}
