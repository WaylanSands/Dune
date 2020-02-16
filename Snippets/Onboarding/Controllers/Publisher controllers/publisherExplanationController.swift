//
//  publisherExplanationController.swift
//  Snippets
//
//  Created by Waylan Sands on 18/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class publisherExplanationController: UIViewController {
    
    @IBOutlet weak var createChannel: UIButton!
    @IBOutlet weak var createProgram: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelDescription: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var programDescription: UILabel!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    
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
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        customNavBar.skipButton.isHidden = true
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.9254901961, green: 0.9450980392, blue: 0.9725490196, alpha: 1), image: nil, button: createChannel)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: createProgram)
        
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
            headingLabelTopAnchor.constant = 80.0
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            containerViewHeight.constant = 1580.0
        case .iPhone8, .iPhone8Plus:
            containerViewHeight.constant = 1490.0
        case .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            headingLabelTopAnchor.constant = 80.0
            containerViewHeight.constant = 1480.0
        case .unknown:
            break
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createChannelPress(_ sender: Any) {
        if let nameController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "nameController") as? publisherNameController {
            nameController.publisherAccountType = .channel
            navigationController?.pushViewController(nameController, animated: true)
        }
    }
    
    @IBAction func createProgramPress(_ sender: Any) {
        if let nameController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "nameController") as? publisherNameController {
            nameController.publisherAccountType = .program
            navigationController?.pushViewController(nameController, animated: true)
        }
    }
    
}
