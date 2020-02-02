//
//  publisherImageController.swift
//  Snippets
//
//  Created by Waylan Sands on 20/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class publisherImageController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var addLaterBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonBottomAnchor: NSLayoutConstraint!
    
    let deviceType = UIDevice.current.deviceType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         styleForScreens()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: uploadImageButton)
        
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            backButtonTopAnchor.constant = 10.0
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingLabelTopAnchor.constant = 40.0
            addLaterBottomAnchor.constant = 20.0
        case .iPhone8:
            headingLabelTopAnchor.constant = 70.0
            addLaterBottomAnchor.constant = 20.0
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
    
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadImageButtonPress() {
        if let categoriesController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "categoriesController") as? publisherCategoriesController {
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    
}
