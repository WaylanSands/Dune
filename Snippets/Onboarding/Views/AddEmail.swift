//
//  CreatePasswordView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AddEmail: UIView {
    
    var nextButtonDelegate: NextButtonDelegate!
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Add your email address")
    lazy var subHeadingLabel = CustomStyle.styleSignupSubheading(view: self, title: "You’ll need to confirm this later")
    lazy var emailTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Email")
    
    var invalidEmail = "Please enter a valid email address"

    
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
        addSubview(emailTextField)
        addSubview(headingLabel)
        addSubview(subHeadingLabel)
                
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        headingLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant:30.0),
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0),
        subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        emailTextField.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -10.0),
        emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
        emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
        emailTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        emailTextField.delegate = self
    }
}

extension AddEmail: UITextFieldDelegate {
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//       return false
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true
//    }
}
