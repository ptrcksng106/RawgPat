//
//  GameResponses.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

struct GameResponses: Codable {
    let games: [GameResponse]
    enum CodingKeys: String, CodingKey {
        case games = "results"
    }
}

struct GameResponse: Codable {
    let id: Int
    let name: String
    let backgroundImage: URL
    let released: String
    let rating: Double
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case backgroundImage = "background_image"
        case released
        case rating
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let image = try container.decode(String.self, forKey: .backgroundImage)
        backgroundImage = URL(string: "\(image)") ?? URL(string: "https://api.rawg.io/api/games?key=02b6331c94884114a2f0e09524f577c7&page=2")!
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        released = try container.decode(String.self, forKey: .released)
        rating = try container.decode(Double.self, forKey: .rating)
    }
}
