//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
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

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

class CreateUserController: UIViewController {

    @IBOutlet weak var createUsernameField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    lazy var emailView = CreateUsername(frame: CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: 200))
    lazy var passwordView = AddEmail(frame: CGRect(x: self.view.frame.size.width, y: 100, width: self.view.frame.size.width, height: 200))

    
    override func viewDidAppear(_ animated: Bool) {
        createUsernameField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.view.addSubview(emailView)
        self.view.addSubview(passwordView)
        
        createUsernameField.layer.cornerRadius = 6.0
        createUsernameField.layer.masksToBounds = true
        createUsernameField.setLeftPaddingPoints(20)

        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    @IBAction func nextSelected(_ sender: Any) {
        emailView.transitionOut()
        passwordView.transitionIn()
        
        createUsernameField.resignFirstResponder()
        
    }
    
}
