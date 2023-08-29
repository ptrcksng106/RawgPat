//
//  MainViewController.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 22/08/23.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var indicatorLoading: UIActivityIndicatorView!
    @IBOutlet var gameTableView: UITableView!
    @IBOutlet var gameSearchBar: UISearchBar!
    private var games: [GameModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorLoading.startAnimating()
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        gameTableView.register(nib, forCellReuseIdentifier: "GameTableViewCell")
        gameTableView.delegate = self
        gameTableView.dataSource = self
        gameTableView.rowHeight = 100
        gameSearchBar.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SignInWithAppleManager.checkUserAuth { (authState) in
            switch authState {
            case .undefined:
                let controller = SignInViewController()
                controller.modalPresentationStyle = .fullScreen
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            case .signedOut:
                let controller = SignInViewController()
                controller.modalPresentationStyle = .fullScreen
                controller.delegate = self
                self.present(controller, animated: true, completion: nil)
            case .signedIn:
                print("Sign in")
            }
        }
        Task {
            await getListGames()
        }
    }
    func getListGames() async {
        let network = NetworkService()
        do {
            games = try await network.getListGames()
            gameTableView.reloadData()
            indicatorLoading.stopAnimating()
            indicatorLoading.isHidden = true
        } catch {
            fatalError("Error: connection failed.")
        }
    }
    func searchGame(titleSearch: String) async {
        let network = NetworkService()
        do {
            games = try await network.getSearchGame(querySearch: titleSearch)
            gameTableView.reloadData()
            indicatorLoading.stopAnimating()
            indicatorLoading.isHidden = true
        } catch {
            fatalError("Error: connection failed.")
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell", for: indexPath) as? GameTableViewCell {
            let game = games[indexPath.row]
            cell.titleGame.text = game.name
            cell.imageGame.image = game.image
            cell.dateGame.text = game.released.lowercased()
            cell.ratingGame.text = String(format: "%.1f", game.rating)
            if game.state == .new {
                cell.indicatorLoading.isHidden = false
                cell.indicatorLoading.startAnimating()
                startDownload(game: game, indexPath: indexPath)
            } else {
                cell.indicatorLoading.stopAnimating()
                cell.indicatorLoading.isHidden = true
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    fileprivate func startDownload(game: GameModel, indexPath: IndexPath) {
        let imageDownloader = ImageDownloader()
        if game.state == .new {
            Task {
                do {
                    let image = try await imageDownloader.downloadImage(url: game.backgroundImage ?? URL(string: "https://api.rawg.io/api/games?key=02b6331c94884114a2f0e09524f577c7&page=2")!)
                    game.state = .downloaded
                    game.image = image
                    self.gameTableView.reloadRows(at: [indexPath], with: .automatic)
                } catch {
                    game.state = .failed
                    game.image = nil
                }
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailView = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailView.gameId = self.games[indexPath.row].id
        self.present(detailView, animated: true, completion: nil)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension MainViewController: SignInViewControllerDelegate {
    func didFinishAuth() {
    }
}
