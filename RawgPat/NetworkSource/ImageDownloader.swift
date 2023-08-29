//
//  ImageDownloader.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

class ImageDownloader {

  func downloadImage(url: URL) async throws -> UIImage {
    async let imageData: Data = try Data(contentsOf: url)
    return UIImage(data: try await imageData)!
  }
}
