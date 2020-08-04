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
    
    let thisView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    
    func setupTabBar() {

        var accountController: UINavigationController
        
        if CurrentProgram.isPublisher! {
            accountController = UINavigationController(rootViewController: ProgramAccountVC())
        } else {
            accountController = UINavigationController(rootViewController: ListenerAccountVC())
        }
        
        let mainFeedController = UINavigationController(rootViewController: MainFeedVC())
        let trendingController = UINavigationController(rootViewController: TrendingVC())
        let searchController = UINavigationController(rootViewController: SearchVC())
        let studioController = UINavigationController(rootViewController: StudioVC())
        
        mainFeedController.tabBarItem.image = UIImage(imageLiteralResourceName: "feed-icon")
        mainFeedController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        mainFeedController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "feed-icon-selected")
        
        searchController.tabBarItem.image = UIImage(imageLiteralResourceName: "search-icon")
        searchController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        searchController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "search-icon-selected")
        searchController.navigationBar.barStyle = .black
        
        studioController.tabBarItem.image = UIImage(imageLiteralResourceName: "studio-icon")
        studioController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        studioController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "studio-icon")
        
        trendingController.tabBarItem.image = UIImage(imageLiteralResourceName: "trending-icon")
        trendingController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        trendingController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "trending-icon-selected")
        trendingController.navigationBar.barStyle = .black
        
        accountController.tabBarItem.image = UIImage(imageLiteralResourceName: "account-icon")
        accountController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        accountController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "account-icon-selected")
        
        viewControllers = [mainFeedController, trendingController, studioController, searchController, accountController]
    }
}
