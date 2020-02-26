
//
//  StudioVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class StudioVC: UIViewController {
    
    var customNav: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = .clear
        nav.leftButton.setImage(UIImage(named: "upload-icon-white"), for: .normal)
        nav.rightButton.setImage(UIImage(named: "record-icon"), for: .normal)
        nav.titleLabel.text = "Studio"
        return nav
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.addSubview(customNav)
        customNav.pinNavBarTo(view)

        view.backgroundColor = .black
    }

}
