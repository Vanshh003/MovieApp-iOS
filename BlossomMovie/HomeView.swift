//
//  HomeView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 02/03/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    let viewModel = ViewModel()
    
    @State
    private var titleDetailPath = NavigationPath()
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack(path: $titleDetailPath) {
            GeometryReader { geo in
                ScrollView {
                    switch viewModel.homeStatus {
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
                .task {
                    await viewModel.getTitles()
                }
                .navigationDestination(for: Title.self) { title in
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

// WebKit is a UI kit tool which helps accomplish displaying a web page or youtube videos (trailers say) in the app
