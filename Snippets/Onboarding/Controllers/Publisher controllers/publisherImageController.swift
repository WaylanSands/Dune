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
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var addLaterBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonBottomAnchor: NSLayoutConstraint!
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
        customNavBar.navBarTitleLabel.isHidden = true
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
         styleForScreens()
        addRoundedCorners()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: uploadImageButton)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
    }
    
    func addRoundedCorners() {
        for eachImage in profileImages {
            eachImage.layer.cornerRadius = 7
            eachImage.clipsToBounds = true
        }
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
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
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadImageButtonPress() {
        if let categoriesController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "categoriesController") as? publisherCategoriesController {
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    
}
