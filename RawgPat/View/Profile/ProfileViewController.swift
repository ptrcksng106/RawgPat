//
//  ProfileViewController.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 21/08/23.
//

import UIKit

class ProfileViewController: UIViewController {
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension ProfileViewController: SignInViewControllerDelegate {
    func didFinishAuth() {
    }
}
