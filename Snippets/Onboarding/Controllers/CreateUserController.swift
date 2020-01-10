//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class CreateUserController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    lazy var emailView = CreateUsername(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 200))
    lazy var passwordView = AddEmail(frame: CGRect(x: self.view.frame.size.width, y: 100, width: self.view.frame.size.width, height: 200))

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(emailView)
        self.view.addSubview(passwordView)
        
        
        emailView.translatesAutoresizingMaskIntoConstraints = false
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150.0),
            emailView.widthAnchor.constraint(equalToConstant: CGFloat(self.view.frame.size.width)),

            ])
        
        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    @IBAction func nextSelected(_ sender: Any) {
        emailView.transitionOut()
        passwordView.transitionIn()
                
    }
    
}
