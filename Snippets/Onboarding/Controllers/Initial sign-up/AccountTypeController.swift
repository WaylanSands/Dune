//
//  AccountTypeController.swift
//  Snippets
//
//  Created by Waylan Sands on 13/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AccountTypeController: UIViewController {

    @IBOutlet weak var listenerButton: UIButton!
    @IBOutlet weak var publisherButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadlingBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var logoIconTopAnchor: NSLayoutConstraint!
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: listenerButton)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.9254901961, green: 0.9450980392, blue: 0.9725490196, alpha: 1), image: nil, button: publisherButton)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            subheadlingBottomAnchor.constant = 50.0
            logoIconTopAnchor.constant = 60.0
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
}
