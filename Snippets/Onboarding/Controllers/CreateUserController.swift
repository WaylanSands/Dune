//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreateUserController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    lazy var username = CreateUsername(frame: CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: 180))
    lazy var email = AddEmail(frame: CGRect(x: self.view.frame.size.width, y: 150, width: self.view.frame.size.width, height: 180))

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(username)
        self.view.addSubview(email)
              
        
        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    @IBAction func nextSelected(_ sender: Any) {

        username.transitionOut()
        email.transitionIn(nextButton)
    }
    
}
