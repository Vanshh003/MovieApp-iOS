//
//  ContentView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 02/03/26.
//


// outer shell of the entire app
// tab bar with 4 tabs, when you tap each icon, it swaps between the four main views


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(Constants.homeString, systemImage: Constants.homeIconString) {
                HomeView()
            }
            Tab(Constants.upcomingString, systemImage: Constants.upcomingIconSrting) {
                UpcomingView()
            }
            Tab(Constants.searchString, systemImage: Constants.searchIconString) {
                SearchView()
            }
            Tab(Constants.downloadString, systemImage: Constants.downloadIconString) {
                DownloadView()
            }
        }
        .onAppear {                                 // to check if api keys loaded correctly
            if let config = APIConfig.shared {
                print(config.tmdbAPIKey)
                print(config.tmdbBaseURL)
            }
        }
    }
}

#Preview {
    ContentView()
}
