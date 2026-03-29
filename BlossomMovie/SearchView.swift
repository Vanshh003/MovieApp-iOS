//
//  SearchView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 26/03/26.
//

import SwiftUI

struct SearchView: View {
    @State private var searchByMovies = true // tracks whether user is searching movies or tvshows. the toolbar toggles between the two modes changing icon, title and placeholder text
    @State private var searchText = ""
    
    private let searchViewModel = SearchViewModel()
    
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                if let error = searchViewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 10))
                }
                
                LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]) {    // 3 column grid of poster thumbnails
                    ForEach(searchViewModel.searchTitles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")){ image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            navigationPath.append(title)
                        }
                    }
                }
            }
            .navigationTitle(searchByMovies ? Constants.movieSearchString : Constants.tvSearchString)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchByMovies.toggle()
                        
                        Task {
                            await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
                        }
                        
                    } label: {
                        Image(systemName: searchByMovies ? Constants.movieIconString : Constants.tvIconString)
                    }
                }
            }
            .searchable(text: $searchText, prompt: searchByMovies ? Constants.moviePlaceHolderString : Constants.tvPlaceHolderString)
            .task(id: searchText) {     // reactive task that reruns whenever searchText changes.
                try? await Task.sleep(for: .milliseconds(500))  // debounce.. it waits hald a seconf after the user stops typing before firing the search request. this prevents a new api call on every single keystroke
                
                if Task.isCancelled {
                    return
                }
                
                await searchViewModel.getSearchTitles(by: searchByMovies ? "movie" : "tv", for: searchText)
            }
            .navigationDestination(for: Title.self) { title in
                TitleDetailView(title: title)
            }
        }
    }
}

#Preview {
    SearchView()
}


// '.searchable()' adds ios native searchbar to the navigation bar. as user types searchText updates
