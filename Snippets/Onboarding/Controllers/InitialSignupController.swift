//
//  InitialSignupController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class InitialSignupController: UIViewController {
    
    
    @IBOutlet weak var emailSignUpOutlet: UIButton!
    @IBOutlet weak var facebookSignUpOutlet: UIButton!
    @IBOutlet weak var appleSignUpOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: #imageLiteral(resourceName: "closed-mail-envelope"), button: emailSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: #imageLiteral(resourceName: "facebook-logo"), button: facebookSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: .white, image: #imageLiteral(resourceName: "apple-logo"), button: appleSignUpOutlet)
    }
    
    @IBAction func emailSignUp(_ sender: UIButton) {
    }
    
}
