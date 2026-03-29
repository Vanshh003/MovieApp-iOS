//
//  HomeView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 02/03/26.
//


// main screen ui
// it renders a full screen hero image - 85% of screen height with a gradient fading to black at the bottom
// play button -> navigate to the detail view ... download button -> saves the hero tile to local db immediately
// 4 horizontal scrolling rows: trending movies, tv, top rated movies, tv -> HorizontalListView

import SwiftUI
import SwiftData

struct HomeView: View {
    let viewModel = ViewModel()
    
    @State
    private var titleDetailPath = NavigationPath()
    
    // '@Environment(\.modelContext) gives the ciew access to the SwiftData dv si the download button can save titles
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        // when u tap a movie, titleDetailPath.append(title) pushes the detaul view onto the stack.
        NavigationStack(path: $titleDetailPath) {
            GeometryReader { geo in
                ScrollView {
                    switch viewModel.homeStatus {   // ui state machine, it renders different things based on whether state
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                                .frame(width: geo.size.width, height: geo.size.height)
                        case .success:
                            LazyVStack {
                                AsyncImage(url: URL(string: viewModel.heroTitle.posterPath ?? "")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .overlay {
                                            LinearGradient (
                                                stops: [Gradient.Stop(color: .clear, location: 0.8),
                                                        Gradient.Stop(color: .gradient, location: 1)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        }
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width, height: geo.size.height * 0.85)
                                
                                HStack {
                                    Button {
                                        titleDetailPath.append(viewModel.heroTitle)
                                    } label: {
                                        Text(Constants.playString)
                                            .ghostButton()
                                    }
                                    
                                    Button {
                                        modelContext.insert(viewModel.heroTitle)
                                        try? modelContext.save()
                                    } label: {
                                        Text(Constants.downloadString)
                                            .ghostButton()
                                    }
                                }
                                
                                HorizontalListView(header: Constants.trendingMoviesString, titles: viewModel.trendingMovies) { title in
                                    titleDetailPath.append(title)
                                }
                                HorizontalListView(header: Constants.trendingTVString, titles: viewModel.trendingTV) { title in
                                    titleDetailPath.append(title)
                                }
                                HorizontalListView(header: Constants.topRatedMovieString, titles: viewModel.topRatedMovies) { title in
                                    titleDetailPath.append(title)
                                }
                                HorizontalListView(header: Constants.topRatedTVString, titles: viewModel.topRatedTV) { title in
                                    titleDetailPath.append(title)
                                }
                            }
                            
                        case .failed(let error):
                            Text("error: \(error.localizedDescription)")
                                .errorMessage()
                                .frame(width: geo.size.width, height: geo.size.height)
                        }
                }
                .task {         // runs the data fetch when the view appears, on a background thread, without freezing the UI
                    await viewModel.getTitles()
                }
                .navigationDestination(for: Title.self) { title in      // the navigationDestination defines what screen to show when a                                                             title is appended to the path
                    TitleDetailView(title: title)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}


// '@State' means ui can change this variable
// 'NavigationPath()' helps us manage where the user goes in the app
// '.task' modifier runs an async task when the view appears allowing it to fetch data without blocking the ui
// 'NavigationStack' starts with the main screen and lets you navigate to new ones (kinda like stacking pages on top of each other)
// 'titleDetailPath.append(viewModel.heroTitle)' -> this adds a new screen to the stack using hero title as a data for that screen

// '@Environment(\.modelContext) gives the ciew access to the SwiftData dv si the download button can save titles

// WebKit is a UI kit tool which helps accomplish displaying a web page or youtube videos (trailers say) in the app
