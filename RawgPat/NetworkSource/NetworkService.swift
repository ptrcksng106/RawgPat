//
//  NetworkService.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

class NetworkService {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "RAWG-Info", ofType: "plist") else {
                fatalError("Couldn't find file 'RAWG-Info.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'RAWG-Info.plist'.")
            }
            if value.starts(with: "_") {
                fatalError("Register for a RAWG developer account and get an API key at https://api.rawg.io/docs/")
            }
            return value
        }
    }
    
    func getListGames() async throws -> [GameModel] {
        var components = URLComponents(string: "https://api.rawg.io/api/games")!
        components.queryItems = [
          URLQueryItem(name: "key", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
          fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponses.self, from: data)

        return gameMapper(input: result.games)
      }
    func getSearchGame(querySearch: String) async throws -> [GameModel] {
        var components = URLComponents(string: "https://api.rawg.io/api/games/"+querySearch)!
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
          fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameResponses.self, from: data)

        return gameMapper(input: result.games)
      }
    func getDetailGame(id: String) async throws -> GameDetailModel {
        var components = URLComponents(string: "https://api.rawg.io/api/games/"+id)!
        components.queryItems = [
          URLQueryItem(name: "key", value: apiKey)
        ]
        let request = URLRequest(url: components.url!)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
          fatalError("Error: Can't fetching data.")
        }

        let decoder = JSONDecoder()
        let result = try decoder.decode(GameDetailResponse.self, from: data)

        return gameDetailMapper(input: result)
    }
}

extension NetworkService {
    fileprivate func gameMapper(
        input gamesResponses: [GameResponse]
    ) -> [GameModel] {
        return gamesResponses.map { result in
            return GameModel(id: result.id, name: result.name, backgroundImage: result.backgroundImage, released: result.released, rating: result.rating)
        }
    }
    fileprivate func gameDetailMapper(
        input gameDetailResponse: GameDetailResponse
    ) -> GameDetailModel {
        let game = gameDetailResponse
        return GameDetailModel(name: game.name, description: game.description, rating: game.rating, backgroundImage: game.backgroundImage!)
    }
}
