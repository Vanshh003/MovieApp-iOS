//
//  Errors.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 05/03/26.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case dataLoadingFailed(underlyingError: Error)
    case decodingFailed(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "File not found."
        case let .dataLoadingFailed(underlyingError):
            return "Failed to load data. Underlying error: \(underlyingError.localizedDescription)"
        case let .decodingFailed(underlyingError):
            return "Failed to decode data. Underlying error: \(underlyingError.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case badURLResponse(underlyingError: Error)
    case missingConfig
    case urlBuildFailed
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(underlyingError: let error):
            return "failed to parse URL response: \(error.localizedDescription)"
        case .missingConfig:
            return "Missing API configuration."
        case .urlBuildFailed:
            return "Failed to build URL."
        }
    }
}
