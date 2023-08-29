//
//  GameModel.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

enum DownloadState {
    case new, downloaded, failed
}

class GameModel {
    let id: Int
    let name: String
    let backgroundImage: URL?
    let released: String
    let rating: Double
    var image: UIImage?
    var state: DownloadState = .new
    init(id: Int, name: String, backgroundImage: URL, released: String, rating: Double, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.backgroundImage = backgroundImage
        self.released = released
        self.rating = rating
        self.image = image
    }
}
