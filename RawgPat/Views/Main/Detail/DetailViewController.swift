//
//  DetailViewController.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 24/08/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var activityIndicatorLoading: UIActivityIndicatorView!
    @IBOutlet var descriptionGame: UILabel!
    @IBOutlet var ratingGame: UILabel!
    @IBOutlet var titleGame: UILabel!
    @IBOutlet var imageGame: UIImageView!
    private var gameDetailFetch: GameDetailModel?
    private var imgDownloader = ImageDownloader()
    var game: GameDetailModel?
    var gameId: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        makeUIBackButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await getDetailGame(self.gameId)
        }
    }
    func getDetailGame(_ id: Int) async {
        let network = NetworkService()
        let idstring = String(id)
        do {
            activityIndicatorLoading.startAnimating()
            self.game = try await network.getDetailGame(id: idstring)
            self.imageGame.image = try await imgDownloader.downloadImage(url: (game?.backgroundImage)!)
            self.imageGame?.layer.cornerRadius = 5
            self.titleGame.text = game?.name
            self.descriptionGame.text = game?.description
            self.ratingGame.text = String(format: "%.1f", game!.rating ?? 0)
            activityIndicatorLoading.stopAnimating()
            activityIndicatorLoading.isHidden = true
        } catch {
          fatalError("Error: connection failed. \(error)")
        }
    }
    func makeUIBackButton() {
        let backButton = UIBarButtonItem(
            title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backAction)
        )
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc func backAction() -> Void {
        dismiss(animated: true, completion: nil)
    }
}
