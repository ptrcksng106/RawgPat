//
//  TabBarController.swift
//  RawgPat
//
//  Created by Patrick Samuel Owen Saritua Sinaga on 21/08/23.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = MainViewController()
        let profileViewController = ProfileViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "iconHome"), tag: 0)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "iconProfile"), tag: 1)
        self.tabBar.backgroundColor = UIColor(red: 250/255, green: 240/255, blue: 230/255, alpha: 1.0)
        viewControllers = [
            UINavigationController(rootViewController: mainViewController),
            UINavigationController(rootViewController: profileViewController)
        ]
        self.selectedIndex = 0    }
}
