//
//  SignUpNavigationController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SignUpNavigationController: UINavigationController {
    
    let yourBackImage = UIImage(#imageLiteral(resourceName: "left-arrow-angle"))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.backIndicatorImage = yourBackImage.withRenderingMode(.alwaysOriginal)
        self.navigationBar.backIndicatorTransitionMaskImage = yourBackImage

    }

}
