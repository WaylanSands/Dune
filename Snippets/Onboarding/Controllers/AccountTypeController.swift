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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1), image: #imageLiteral(resourceName: "signIn-button-icon"), button: listenerButton)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1), image: #imageLiteral(resourceName: "signIn-button-icon"), button: publisherButton)
    }

}
