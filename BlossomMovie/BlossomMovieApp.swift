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
            ContentView()
        }
        .modelContainer(for: Title.self)
    }
}
