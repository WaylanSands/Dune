
//
//  StudioVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class StudioVC: UIViewController {
    
    lazy var tabBar = navigationController?.tabBarController?.tabBar
    
    var customNav: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = .clear
        nav.leftButton.setImage(UIImage(named: "upload-icon-white"), for: .normal)
        nav.rightButton.setImage(UIImage(named: "record-icon"), for: .normal)
        nav.rightButton.addTarget(self, action: #selector(recordButtonPress), for: .touchUpInside)
        nav.titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nav.titleLabel.text = "Studio"
        return nav
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "You currently have no unpublished episodes"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fithShade
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        configireViews()
        view.addSubview(customNav)
        customNav.pinNavBarTo(view)
        
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Track.trackOption = nil
    }

    func setupNavigationBar() {
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configireViews() {
        view.backgroundColor = CustomStyle.onboardingBlack

        view.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        contentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        tabBar?.isHidden = false
        tabBar!.backgroundImage =  UIImage()
        tabBar!.items?[0].image = UIImage(named: "feed-icon-selected")
        tabBar!.items?[1].image =  UIImage(named: "search-icon-selected")
        tabBar!.items?[3].image =  UIImage(named: "trending-icon-selected")
        tabBar!.items?[4].image =  UIImage(named: "account-icon-selected")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBar?.barStyle = .default
        tabBar!.backgroundImage = .none
        tabBar!.items?[0].image = UIImage(named: "feed-icon")
        tabBar!.items?[1].image =  UIImage(named: "search-icon")
        tabBar!.items?[2].image =  UIImage(named: "studio-icon")
        tabBar!.items?[3].image =  UIImage(named: "trending-icon")
        tabBar!.items?[4].image =  UIImage(named: "account-icon")
    }
    
    @objc func recordButtonPress() {
        let recordVC = RecordBoothVC()
        navigationController?.pushViewController(recordVC, animated: false)
    }
    
    
}
