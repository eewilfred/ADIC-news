//
//  NYNews.swift
//  ADIC-News
//
//  Created by Edwin Wilson on 01/09/2021.
//

import Foundation

enum Format: String, Codable {

    case medium = "mediumThreeByTwo210"
    case large = "mediumThreeByTwo440"
    case thumbnail = "Standard Thumbnail"
}

// MARK: - NYNews

struct NYNews: BaseResult {

    static let apiKey = "/viewed/1.json"
    
    let news: [News]?

    enum CodingKeys: String, CodingKey {
        case news = "results"
    }
}

// MARK: - Result

struct News: Decodable {
    let id: Int?
    let publishedDate: String?
    let adxKeywords: String?
    let byline: String?
    let type: String?
    let title: String?
    let desFacet: [String]?
    let geoFacet: [String]?
    let media: [Media]?

    enum CodingKeys: String, CodingKey {
        case id
        case publishedDate = "published_date"
        case adxKeywords = "adx_keywords"
        case byline
        case type
        case title
        case desFacet = "des_facet"
        case geoFacet = "geo_facet"
        case media
    }
}

struct Media: Codable {

    let mediaMetadata: [MediaMetadata]?

    enum CodingKeys: String, CodingKey {

        case mediaMetadata = "media-metadata"
    }
}

// MARK: - MediaMetadatum

struct MediaMetadata: Codable {
    let url: String?
    let format: Format?
}
