//
//  APIConfig.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 05/03/26.
//

import Foundation

struct APIConfig: Decodable {
    let tmdbBaseURL: String
    let tmdbAPIKey: String
    let youtubeBaseURL: String
    let youtubeAPIKey: String
    let youtubeSearchURL: String
    
    // singleton pattern -> design pattern which ensures only one instance ('shared') of APIConfig is created
    //                   -> good for centralized resource management and usage
    
    //       () at the end immediately execute the closure at runtime, in turn, the credentials are available
    //          right away.
    static let shared: APIConfig? = {
        do {
            return try loadConfig()
        } catch {
            print("failed to load APIConfig: \(error.localizedDescription)")
            return nil
        }
    }()
    
    private static func loadConfig() throws -> APIConfig {
        guard let url = Bundle.main.url(forResource: "APIConfig", withExtension: "json") else {
            throw APIConfigError.fileNotFound
        }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(APIConfig.self, from: data)
        } catch let error as DecodingError {
            throw APIConfigError.decodingFailed(underlyingError: error)
        } catch {
            throw APIConfigError.decodingFailed(underlyingError: error)
        }
    }
}
