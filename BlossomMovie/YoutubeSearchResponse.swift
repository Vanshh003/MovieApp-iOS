//
//  YoutubeSearchResponse.swift
//  BlossomMovie
//
//  Created by Vansh Aggarwal on 11/03/26.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [ItemProperties]?
}

struct ItemProperties: Codable {
    let id: IdProperties?
}

struct IdProperties: Codable {
    let videoId: String?
}
