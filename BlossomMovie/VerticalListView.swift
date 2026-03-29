//
//  VerticalListView.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 13/03/26.
//



// used by both upcomingView and downloadView. each row shows a poster thumbnail on the left and the title name on the right


import SwiftUI
import SwiftData

struct VerticalListView: View {
    var titles: [Title]
    let canDelete: Bool     // controls whether swipe to depete is enabled. 
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List(titles) { title in
            NavigationLink {            // NavigationLink wraps each row so tapping tit navigates to TitleDetailView
                TitleDetailView(title: title)
            } label: {
                AsyncImage(url: URL(string: title.posterPath ?? "")) { image in
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(5)
                        
                        Text((title.name ?? title.title) ?? "")
                            .font(.system(size: 14))
                            .bold()
                    }
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150)
            }
            .swipeActions(edge: .trailing) {
                if canDelete {
                    Button {
                        modelContext.delete(title)
                        try? modelContext.save()
                    } label: {
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    VerticalListView(titles: Title.previewTitles, canDelete: true)
}
