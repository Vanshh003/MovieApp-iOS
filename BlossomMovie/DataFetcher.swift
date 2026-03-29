//
//  DataFetcher.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 06/03/26.
//



// this is the engine that makes all internet calls.
// 3 public functions and one private helper



import Foundation

struct DataFetcher {
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    
    
    // sample urls
    // https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY
    // https://api.themoviedb.org/3/search/movie?api_key=YourKey&query=PulpFiction
    
    
    // fetches a list of movies or tvshows
    // for -> media type: "movie" or "tv"
    // by -> endpoint type: "trending", "top_rated", "upcoming" or "search"
    // with -> optional search quety (only used with by = search)
    func fetchTitles(for media: String, by type: String, with title:String? = nil) async throws -> [Title] {
        let fetchTitlesURL = try buildURL(media: media, type: type, searchPhrase: title)        // to construct right api url
        
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
        print(fetchTitlesURL)
        
        var titles = try await fetchAndDecode(url: fetchTitlesURL, type: TMDBAPIObject.self).results       // to actually fetch and parse it
        
        Constants.addPosterPath(to: &titles)    // to turn partual paths into full image urls
        return titles
    }
    
    
    // takes a movie title like "inception", searched yt for "inception trailer" and returns yt vid id (like "dQw4w9WgXcQ")
    func fetchVideoId(for title: String) async throws -> String {
        guard let baseSearchURL = youtubeSearchURL else {
            throw NetworkError.missingConfig
        }
        
        guard let searchAPIKey = youtubeAPIKey else {
            throw NetworkError.missingConfig
        }
        
        let trailerSearch = title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue
        
        guard let fetchVideoURL = URL(string: baseSearchURL)?
            .appending(queryItems: [
                URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: trailerSearch),
                URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: searchAPIKey)
            ]) else {
            throw NetworkError.urlBuildFailed
        }
        
        print(fetchVideoURL)
        
        return try await fetchAndDecode(url: fetchVideoURL, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
    }
    
    
    // does actual http request
    func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, urlResponse) = try await URLSession.shared.data(from: url)   // downloads data from internet
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(type, from: data)
    }
    
    
    // constructs tmdb api url form parts
    private func buildURL(media: String, type: String, searchPhrase:String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL else {
            throw NetworkError.missingConfig
        }
        
        guard let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if(type == "trending") {
            path = "3/\(type)/\(media)/day"
        } else if (type == "top_rated" || type == "upcoming") {
            path = "3/\(media)/\(type)"
        } else if type == "search" {
            path = "3/\(type)/\(media)"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        var urlQueryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
                
        if let searchPhrase {
            urlQueryItems.append(URLQueryItem(name: "query", value: searchPhrase))
        }
        
        // build url
        guard let url = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: urlQueryItems) else {
                throw NetworkError.urlBuildFailed
        }

        return url
    }
}
