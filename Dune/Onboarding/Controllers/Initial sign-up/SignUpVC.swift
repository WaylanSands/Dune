//
//  InitialSignupController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailSignUpOutlet: UIButton!
    @IBOutlet weak var facebookSignUpOutlet: UIButton!
    @IBOutlet weak var appleSignUpOutlet: UIButton!
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var stackedTitleAndIcon: UIStackView!
    @IBOutlet weak var titleBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var stackedButtons: UIStackView!
    @IBOutlet weak var stackedButtonsYAnchor: NSLayoutConstraint!
    
    let deviceType = UIDevice.current.deviceType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButtons()
        styleForScreens()
        configureNavigation()
    }
    
    func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: #imageLiteral(resourceName: "closed-mail-envelope"), button: emailSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9529411765, alpha: 1), image: UIImage(named: "twitter-logo"), button: facebookSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.white, image: #imageLiteral(resourceName: "apple-logo"), button: appleSignUpOutlet)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            titleBottomAnchor.constant = 30.0
            stackedTitleAndIcon.spacing = 40.0
            stackedButtonsYAnchor.constant = 30
            titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
            logoLabel.font = UIFont.systemFont(ofSize: 23.0, weight: .heavy)
        case .iPhone8:
            titleBottomAnchor.constant = 30.0
            stackedButtonsYAnchor.constant = 10
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
    @IBAction func signInButtonPress(_ sender: UIButton) {
        if let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as? SignInVC {
            navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    
//    @IBAction func emailSignUpButtonPress(_ sender: UIButton) {
//        if let createUserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "createUserVC") as? CreateUserVC {
//            navigationController?.pushViewController(createUserVC, animated: true)
//        }
//    }
    
    
}

