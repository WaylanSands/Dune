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
    @IBOutlet weak var profileImagesStack: UIStackView!
    @IBOutlet var profileImages: [UIImageView]!
    
    let deviceType = UIDevice.current.deviceType

    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
      styleTitleLabel()
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.snapColor, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: addPhotoButton)
    }
    
func styleTitleLabel() {
    switch deviceType {
    case .iPhone4S:
        break
    case .iPhoneSE:
        break
    case .iPhone8:
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
        titleLabelStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: -5.0).isActive = true
        styleProfileImages()
    case .iPhone8Plus:
        break
    case .iPhone11:
        break
    case .iPhone11ProMax:
        break
    case .unknown:
        break
    default:
        return
    }
}
    func styleProfileImages() {
        profileImagesStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10.0).isActive = true
        for eachImage in profileImages {
            eachImage.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
             eachImage.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        }
    }
    
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addLaterPress() {
    }
}

