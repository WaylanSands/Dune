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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.snapColor, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)

        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: addPhotoButton)
    }
    
    @IBAction func backButtonPress() {
    navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addLaterPress() {
    }
}

