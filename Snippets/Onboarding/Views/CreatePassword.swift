//
//  CreatePassword.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreatePassword: UIView {
    
    var authSuccess = false
    var nextButtonDelegate: NextButtonDelegate!
    
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
        let headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Create a password")
        let subHeadingLabel = CustomStyle.styleSignupSubheading(view: self, title: """
            Passwords need to contain one capital
            and at least one special character.
            """)
        let userTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Password")
        userTextField.delegate = self
        
        addSubview(userTextField)
        addSubview(headingLabel)
        addSubview(subHeadingLabel)
        
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant:30.0),
            subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0),
            subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userTextField.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -12.0),
            userTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            userTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            userTextField.heightAnchor.constraint(equalToConstant: 40),
            ])
    }
}

extension CreatePassword: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text! == "Code" {
            authSuccess = true
        }
        
        print("\(textField.text!)")
        return true
    }
}
