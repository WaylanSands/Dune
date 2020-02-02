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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var titleStackTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var profileImagesStack: UIStackView!
    @IBOutlet weak var profileImagesYAnchor: NSLayoutConstraint!
    @IBOutlet var profileImages: [UIImageView]!
    
    let deviceType = UIDevice.current.deviceType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
      styleForScreens()
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.snapColor, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: addPhotoButton)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
             backButtonTopAnchor.constant = 10.0
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
    
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addLaterPress() {
    }
}

