//
//  GameDetailModel.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 24/08/23.
//

import UIKit

class GameDetailModel {
    let name: String?
    let backgroundImage: URL?
    let description: String?
    let rating: Double?
    var image: UIImage?
    var state: DownloadState = .new
    enum CodingKeys: String, CodingKey {
        case name
        case image = "background_image"
        case description = "description_raw"
        case rating
    }
    init(name: String?, description: String?, rating: Double?, backgroundImage: URL) {
        self.name = name
        self.description = description
        self.rating = rating
        self.backgroundImage = backgroundImage
    }
}

struct GameDetailResponse: Codable {
    let name: String?
    let backgroundImage: URL?
    let description: String?
    let rating: Double?
    enum CodingKeys: String, CodingKey {
        case name
        case backgroundImage = "background_image"
        case description = "description_raw"
        case rating
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.backgroundImage = try container.decodeIfPresent(URL.self, forKey: .backgroundImage)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating)
    }
}
