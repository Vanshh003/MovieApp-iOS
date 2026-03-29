//
//  SearchViewModel.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 26/03/26.
//


// search data manager

import Foundation

@Observable
class SearchViewModel {
    private(set) var errorMessage: String?
    private(set) var searchTitles: [Title] = []
    private let dataFetcher = DataFetcher()
    
    // if the search text is empty, it loads trending titles as a default.
    // if there is text, it runs a real search
    // this gives the search screen content to show even before the user types anything
    func getSearchTitles(by media: String, for title: String) async {
        do {
            errorMessage = nil
            if title.isEmpty {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                searchTitles = try await dataFetcher.fetchTitles(for: media, by: "search", with: title)
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
}


// 'private(set)' -> only this class can write these values, but anyone can read them. this prevents other files from accidentally changind the search results
