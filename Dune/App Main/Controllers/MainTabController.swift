//
//  MainTabController.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

let dunePlayBar = DunePlayer()
let duneTabBar = DuneTabBar()

class MainTabController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationControllers()
        configureDunePlayer()
        configureDuneTabBar()
    }
    
    private func configureDuneTabBar() {
        view.addSubview(duneTabBar)
        duneTabBar.isHidden = false
        duneTabBar.frame = CGRect(x: 0, y: view.frame.height - self.tabBar.frame.height - UIDevice.safeBottomHeight, width: self.view.frame.width, height: self.tabBar.frame.height +  UIDevice.safeBottomHeight)
        duneTabBar.tabButtonSelection = tabSelection
    }
    
    private  func configureDunePlayer() {
        view.addSubview(dunePlayBar)
        dunePlayBar.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 600)
        dunePlayBar.yPosition = view.frame.height - (self.tabBar.frame.height + UIDevice.safeBottomHeight)
    }
    
    private func configureNavigationControllers() {
        var accountController: UINavigationController
        
        if CurrentProgram.isPublisher! {
            accountController = UINavigationController(rootViewController: ProgramAccountVC())
        } else {
            accountController = UINavigationController(rootViewController: ListenerAccountVC())
        }
        accountController.navigationBar.barStyle = .default

        let mainFeedController = UINavigationController(rootViewController: MainFeedVC())
        mainFeedController.navigationBar.barStyle = .black
        let trendingController = UINavigationController(rootViewController: TrendingVC())
        trendingController.navigationBar.barStyle = .black
        let searchController = UINavigationController(rootViewController: SearchVC())
        searchController.navigationBar.barStyle = .black
        let studioController = UINavigationController(rootViewController:StudioVC())
        studioController.navigationBar.barStyle = .black
        
//        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        tabBar.isHidden = true

//        tabBar.isUserInteractionEnabled = false
//        tabBar.backgroundImage = UIImage()
//        tabBar.shadowImage = UIImage()
//        tabBar.clipsToBounds = true

//        mainFeedController.tabBarItem.image = UIImage(imageLiteralResourceName: "feed-icon")
//        mainFeedController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//        mainFeedController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "feed-icon-selected")
//
//        searchController.tabBarItem.image = UIImage(imageLiteralResourceName: "search-icon")
//        searchController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//        searchController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "search-icon-selected")
//        searchController.navigationBar.barStyle = .black
//
//        studioController.tabBarItem.image = UIImage(imageLiteralResourceName: "studio-icon")
//        studioController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//        studioController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "studio-icon")
//
//        trendingController.tabBarItem.image = UIImage(imageLiteralResourceName: "trending-icon")
//        trendingController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//        trendingController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "trending-icon-selected")
//        trendingController.navigationBar.barStyle = .black
//
//        accountController.tabBarItem.image = UIImage(imageLiteralResourceName: "account-icon")
//        accountController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
//        accountController.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "account-icon-selected")
        
        viewControllers = [mainFeedController, trendingController, studioController, searchController, accountController]
    }
    
    func tabSelection(index: Int) {
        selectedIndex = index
        
        switch selectedIndex {
        case 0:
            let dailyFeedVC = viewControllers![0] as! UINavigationController
            dailyFeedVC.popToRootViewController(animated: true)
        case 1:
            let trendingVC = viewControllers![1] as! UINavigationController
            trendingVC.popToRootViewController(animated: true)
        case 2:
            let studioVC = viewControllers![2] as! UINavigationController
            studioVC.popToRootViewController(animated: true)
        case 3:
            let searchVC = viewControllers![3] as! UINavigationController
            searchVC.popToRootViewController(animated: true)
        case 4:
            let accountVC = viewControllers![4] as! UINavigationController
            accountVC.popToRootViewController(animated: true)
        default:
            break
        }
    }
}
