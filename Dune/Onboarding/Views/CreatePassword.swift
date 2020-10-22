//
//  CreatePassword.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreatePassword: UIView {
    
    var password: String?
    
    var nextButtonActive = false
    var headingYConstant: CGFloat = 260.0
    var textFieldYPosition: CGFloat = -37
    var nextButtonDelegate: NextButtonDelegate!
    let defaultSubHeadingText = "Passwords must contain at least one upper & lowercase character, one number & be at least 8 characters long"
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Create a password")
    lazy var passwordTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Password")
    
    let subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.subTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let validationLabel: UILabel = {
        let label = UILabel()
        label.text = "Strong"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    let textFieldToggle: UIButton =  {
        let button = UIButton()
        button.setTitle("Hide", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action:#selector(toggleButtonPress), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        styleForScreens()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingYConstant = 95.0
            textFieldYPosition = -45
        case .iPhone8:
            headingYConstant = 145.0
            textFieldYPosition = -30
        case .iPhone8Plus:
            headingYConstant = 180.0
        case .iPhone11:
            break
        case .iPhone11Pro:
            headingYConstant = 220.0
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func setupView() {
        
        self.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: headingYConstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0).isActive = true
        subHeadingLabel.text = defaultSubHeadingText
        
        self.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: textFieldYPosition).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.rightView = UIView()
    
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .next
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.clearButtonMode = .never
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .password
        
        self.addSubview(textFieldToggle)
        textFieldToggle.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggle.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        textFieldToggle.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20).isActive = true
        
        self.addSubview(validationLabel)
        validationLabel.translatesAutoresizingMaskIntoConstraints = false
        validationLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5).isActive = true
        validationLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor, constant: 10).isActive = true
        validationLabel.isHidden = true
    }
    
    @objc func toggleButtonPress() {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            textFieldToggle.setTitle("Hide", for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            textFieldToggle.setTitle("Show", for: .normal)
        }
    }
}

extension CreatePassword: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextButtonDelegate.keyboardNextButtonPress()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
                
        if textField.text!.count >= 8 {
            if textField.text!.isValidPassword() == true {
                nextButtonActive = true
                validationLabel.text = "Strong"
                validationLabel.isHidden = false
                nextButtonDelegate.makeNextButton(active: true)
                self.password = passwordTextField.text
            } else {
                nextButtonActive = false
                validationLabel.isHidden = true
                nextButtonDelegate.makeNextButton(active: false)
            }
        } else {
            nextButtonActive = false
            validationLabel.isHidden = true
            nextButtonDelegate.makeNextButton(active: false)
        }
        
    }
    
}

