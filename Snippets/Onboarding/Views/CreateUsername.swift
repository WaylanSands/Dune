//
//  AddEmailView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreateUsername: UIView {
    
    var authSuccess = false
    
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
            let headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Create username")
            let subHeadingLabel = CustomStyle.styleSignupSubheading(view: self, title: """
            Create a username for your new account.
            You can always change it later
            """)
            let userTextField = CustomStyle.styleSignUpTextField(view: self, placeholder: "Username")
            userTextField.delegate = self
            
            addSubview(userTextField)
            addSubview(headingLabel)
            addSubview(subHeadingLabel)
            
            
            headingLabel.translatesAutoresizingMaskIntoConstraints = false
            subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
            userTextField.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0),
                subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                userTextField.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -12.0),
                userTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
                userTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
                userTextField.heightAnchor.constraint(equalToConstant: 40),
                ])
        }
}

extension CreateUsername: UITextFieldDelegate {
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
