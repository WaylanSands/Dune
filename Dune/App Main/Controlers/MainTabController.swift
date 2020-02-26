//
//  MainTabController.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    func setupTabBar() {
        let mainFeedController = UINavigationController(rootViewController: MainFeedVC())
        let searchController = UINavigationController(rootViewController: SearchVC())
        let studioController = UINavigationController(rootViewController: StudioVC())
        let playlistController = UINavigationController(rootViewController: TrendingVC())
        let accountController = UINavigationController(rootViewController: AccountVC())
        
        mainFeedController.tabBarItem.image = UIImage(imageLiteralResourceName: "feed-icon")
        mainFeedController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "feed-icon-selected")
        
        searchController.tabBarItem.image = UIImage(imageLiteralResourceName: "search-icon")
        searchController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "search-icon-selected")
        
        studioController.tabBarItem.image = UIImage(imageLiteralResourceName: "studio-icon")
        studioController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "studio-icon-selected")
        
        playlistController.tabBarItem.image = UIImage(imageLiteralResourceName: "trending-icon")
        playlistController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "trending-icon-selected")
        
        accountController.tabBarItem.image = UIImage(imageLiteralResourceName: "account-icon")
        accountController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "account-icon-selected")
        
        viewControllers = [mainFeedController, searchController, studioController, playlistController, accountController]
    }

}
