//
//  DownloadView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 26/03/26.
//

import SwiftUI
import SwiftData

struct DownloadView: View {
    @Query(sort: \Title.title) var savedTitles: [Title]     // it automatically fetches all saved title objects from the local database sorted alphabetically by title. it also autpmatically updates whenever the db changes. 
    
    var body: some View {
        NavigationStack {
            if savedTitles.isEmpty {
                Text("No Downloads")
                    .padding()
                    .font(.title3)
                    .bold()
            } else {
                VerticalListView(titles: savedTitles, canDelete: true)
            }
        }
    }
}

#Preview {
    DownloadView()
}
