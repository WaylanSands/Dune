//
//  ListenerProfileImageController.swift
//  Snippets
//
//  Created by Waylan Sands on 16/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ListenerProfileImageController: UIViewController {
    
    @IBOutlet weak var bitmojiButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var titleLabelStack: UIStackView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleStackTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStack: UIStackView!
    @IBOutlet weak var profileImagesYAnchor: NSLayoutConstraint!
    @IBOutlet var profileImages: [UIImageView]!
    
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
        styleButtons()
        styleForScreens()
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.snapColor, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: addPhotoButton)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
             titleStackTopAnchor.constant = 60.0
             mainTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
              styleProfileImages(size: 60.0)
             profileImagesYAnchor.constant = -20.0
        case .iPhone8:
            styleProfileImages(size: 70.0)
        case .iPhone8Plus:
            styleProfileImages(size: 80.0)
        case .iPhone11:
            styleProfileImages(size: 85.0)
        case .iPhone11Pro:
             styleProfileImages(size: 75.0)
        case .iPhone11ProMax:
            styleProfileImages(size: 85.0)
        case .unknown:
            break
        }
    }
    
    func styleProfileImages(size: CGFloat ) {
        for eachImage in profileImages {
            eachImage.widthAnchor.constraint(equalToConstant: size).isActive = true
            eachImage.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addLaterPress() {
    }
}

