//
//  HorizontalListView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 03/03/26.
//



// scrollable movie row
// it renders a horizontal ScrollView with LazyHStack
            // lazy means posters are only loaded into memory as they scroll into view, which is critical for performance when you have more poster images in one row


import SwiftUI

struct HorizontalListView: View {
    let header : String
    var titles : [Title]
    
    // a closure, gets called when a poster is tapped
    let onSelect : (Title) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.title)
            
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(titles) { title in
                        AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 120, height: 200)
                        .onTapGesture {
                            onSelect(title)
                        }
                    }
                }
            }
        }
        .frame(height: 250)
        .padding(10)
    }
}

#Preview {
    HorizontalListView(header: Constants.trendingMoviesString, titles: Title.previewTitles) {title in
            
    }
}

// 'onSelect' is a closure property that takes a title and returns nothing. the title we pass will be accessible to home view allowing it to handle navigation. it is how this reusable component communicates back to the HomeView, it doesnt navigate itself, it just tells the parent: "the user tapped this tile, you handle it"

// AsyncImage loads images from urls asynchronously, it shows a spinner while loading,then the image when ready
