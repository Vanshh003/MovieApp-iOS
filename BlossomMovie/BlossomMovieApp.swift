//
//  BlossomMovieApp.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 02/03/26.
//

import SwiftUI
import SwiftData

@main
struct BlossomMovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()       // first screen shown
        }
        .modelContainer(for: Title.self)    // set up a local database that knows how to store 'Title' objects
    }
}

// WindowGroup -> window of iphone screen


// .modelContainer(for: Title.self)
//        - It Creates the Physical Storage (SwiftData uses a database called SQLite under the hood. When this line runs, the app checks if a database              file already exists on the user's phone.)
//
//        -  It Defines the "Schema" (The Blueprint) By passing Title.self, you are telling SwiftData:
//            "I want to save objects of type Title. Look at the Title class and create a table with columns that match its properties

