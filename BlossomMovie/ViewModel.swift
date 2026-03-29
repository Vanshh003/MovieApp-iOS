//
//  ViewModel.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 07/03/26.
//



// home and upcoming data manager
// mvvm architecture
// viewmodel sits between ui and the data -> it fetches data, tracks loading state, and tells ui what to show



import Foundation

// View Model -> handle data while UI focuses on managing the interface


@Observable     // its important that VM updates UI whenever the data changes
                // allows this VM to automatically notify UI if any data changes
                // cant use with structs as structs are value types
class ViewModel {
    // state machine
    enum FetchStatus {
        case notStarted
        case fetching
        case success
        case failed(underlyingError: Error)
    }
    
    // private set ensures that only the VM can update homeStatus. other parts of app can only read it
    private(set) var homeStatus: FetchStatus = .notStarted
    private(set) var videoIdStatus: FetchStatus = .notStarted
    private(set) var upcomingStatus: FetchStatus = .notStarted
    
    private let dataFetcher = DataFetcher()
    
    var trendingMovies: [Title] = []
    var trendingTV: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTV: [Title] = []
    var upcomingMovies: [Title] = []
    var heroTitle = Title.previewTitles[0]
    var videoId = ""
    
    
    // fetches all four home screen lists in parallel using async let.
    // without async let, each fetch would wait for the previous one to finish taking 4x longer
    // with async let, all 4 start simultaneously and the function waits until all 4 complete
    // then pick a random trending movie as heroTitle
    func getTitles() async {
        homeStatus = .fetching
        
        if trendingMovies.isEmpty {
            do {
                // when making multiple async calls, using try await for each one can slow things down because each call must finish before the next one starts.. to improve speed, async let is used, allowing each call to run in  parallel instead
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTV = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let tRMovies = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let tRTV = dataFetcher.fetchTitles(for: "tv", by: "top_rated")
                
                trendingMovies = try await tMovies
                trendingTV = try await tTV
                topRatedMovies = try await tRMovies
                topRatedTV = try await tRTV
                
                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }
    
    
    // fetches a yt trailer video id for given title name
    func getVideoId(for title: String) async {
        videoIdStatus = .fetching
        
        do {
            videoId = try await dataFetcher.fetchVideoId(for: title)
            videoIdStatus = .success
        } catch {
            print(error)
            videoIdStatus = .failed(underlyingError: error)
        }
    }
    
    
    // fetches list of upcoming movies for upcoming tab
    func getUpcomingMovies() async {
            upcomingStatus = .fetching
            
            do {
                upcomingMovies = try await dataFetcher.fetchTitles(for: "movie", by: "upcoming")
                upcomingStatus = .success
            } catch {
                print(error)
                upcomingStatus = .failed(underlyingError: error)
            }
        }
}


// 'Observable' makes swift automatucallyd etect when any property changes and re-render any view that depends on it
