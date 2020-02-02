//
//  CreatePassword.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreatePassword: UIView {
    
    var nextButtonDelegate: NextButtonDelegate!
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Create a password")
    lazy var subHeadingLabel = CustomStyle.styleSignupSubheading(view: self, title: """
        Passwords need to contain one capital
        and at least one special character.
        """)
        
    lazy var passwordTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Password")
    
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    func setupView() {
        addSubview(passwordTextField)
        addSubview(headingLabel)
        addSubview(subHeadingLabel)
        
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant:30.0),
            subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0),
            subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -10.0),
            passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            ])
        
         passwordTextField.delegate = self
    }
}

extension CreatePassword: UITextFieldDelegate {
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        return false
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    }

}
