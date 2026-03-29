//
//  Title.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 05/03/26.
//



// Movie/TV Show data model



import SwiftData

struct TMDBAPIObject: Decodable {
    var results: [Title] = []
}

@Model //tells SwiftData that this class can be saced to the local db, without it titles only exist in memoty and disappear when app closes
class Title: Decodable, Identifiable, Hashable {
    @Attribute(.unique) var id: Int?            // no duplicate titles saved to db
    var title: String?                          // tmdb uses title for movies
    var name: String?                           // tmdb uses name for tv shows
    var overview: String?
    var posterPath: String?
    
    init(id: Int? = nil, title: String? = nil, name: String? = nil, overview: String? = nil, posterPath: String? = nil) {
        self.id = id
        self.title = title
        self.name = name
        self.overview = overview
        self.posterPath = posterPath
    }
    
    // it tells swift which json field maps to which property
    enum CodingKeys: CodingKey {
            case id
            case title
            case name
            case overview
            case posterPath
        }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        overview = try container.decodeIfPresent(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    }
    
    
    // hardcoded values for temp check
    static var previewTitles = [
            Title(id: 1, title: "BeetleJuice", name: "BeetleJuice", overview: "A movie about BeetleJuice", posterPath: Constants.testTitleURL),
            Title(id: 2, title: "Pulp Fiction", name: "Pulp Fiction", overview: "A movie about Pulp Fiction", posterPath: Constants.testTitleURL2),
            Title(id: 3, title: "The Dark Knight", name: "The Dark Knight", overview: "A movie about the Dark Knight", posterPath: Constants.testTitleURL3)
    ]
}

// 'Hashable' let swift tell if two items are same. required when using navigation path
// 'Decodable' means swift can automatically convert json from api into a Title object.
