//
//  CreatePasswordView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import FirebaseFirestore
import UIKit

class ChangePasswordVC: UIViewController {
    
    var keyboardExtened = false
    var headingYconstant: CGFloat = 220.0
    var textFieldYposition: CGFloat = -37
    let defaultSubHeadingText = "Passwords must contain at least one upper & lowercase character, one number & be at least 8 characters long"
    
    var emailAvailable: Bool?
    let db = Firestore.firestore()
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: view, title: "Change password")
    lazy var currentPasswordTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: view, placeholder: "Enter current password")
    lazy var newPasswordTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: view, placeholder: "Enter new password")
    
//    let newPasswordTextField: UITextField = {
//        let field = UITextField()
//        field.placeholder = "Enter new password"
//        field.backgroundColor = CustomStyle.secondShade
//        field.font = UIFont.systemFont(ofSize: 16)
//        field.clearButtonMode = UITextField.ViewMode.whileEditing
//        field.layer.cornerRadius = 6.0
//        field.layer.masksToBounds = true
//        return field
//    }()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let textFieldToggleOne: UIButton =  {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action:#selector(toggleButtonPressOne), for: .touchUpInside)
        return button
    }()
    
    let textFieldToggleTwo: UIButton =  {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action:#selector(toggleButtonPressTwo), for: .touchUpInside)
        return button
    }()
    
    let validationLabel: UILabel = {
        let label = UILabel()
        label.text = "Strong"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    let subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let selectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryBlue
        button.layer.cornerRadius = 6
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(selectButtonPress), for: .touchUpInside)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        navigationItem.title = "Password"
        view.backgroundColor = .white
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    func configureDelegates() {
        newPasswordTextField.delegate = self
        currentPasswordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentPasswordTextField.becomeFirstResponder()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingYconstant = 95.0
            textFieldYposition = -45
        case .iPhone8:
            headingYconstant = 145.0
            textFieldYposition = -30
        case .iPhone8Plus:
            break
            
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        view.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: headingYconstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        view.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        subHeadingLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        subHeadingLabel.text = defaultSubHeadingText
        
        view.addSubview(currentPasswordTextField)
        currentPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        currentPasswordTextField.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40).isActive = true
        currentPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        currentPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        currentPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(newPasswordTextField)
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 12).isActive = true
        newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        newPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(validationLabel)
        validationLabel.translatesAutoresizingMaskIntoConstraints = false
        validationLabel.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 5).isActive = true
        validationLabel.leadingAnchor.constraint(equalTo: currentPasswordTextField.leadingAnchor, constant: 10).isActive = true
        validationLabel.isHidden = true
        
        view.addSubview(textFieldToggleOne)
        textFieldToggleOne.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggleOne.centerYAnchor.constraint(equalTo: currentPasswordTextField.centerYAnchor).isActive = true
        textFieldToggleOne.trailingAnchor.constraint(equalTo: currentPasswordTextField.trailingAnchor, constant: -20).isActive = true

        view.addSubview(textFieldToggleTwo)
        textFieldToggleTwo.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggleTwo.centerYAnchor.constraint(equalTo: newPasswordTextField.centerYAnchor).isActive = true
        textFieldToggleTwo.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(selectButton)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.topAnchor.constraint(equalTo: validationLabel.bottomAnchor, constant: 20).isActive = true
        selectButton.leadingAnchor.constraint(equalTo: newPasswordTextField.leadingAnchor).isActive = true
        selectButton.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        newPasswordTextField.returnKeyType = .next
        newPasswordTextField.clearButtonMode = .never
        newPasswordTextField.isSecureTextEntry = false
        newPasswordTextField.autocorrectionType = .no
        newPasswordTextField.textContentType = .none
        
        currentPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        currentPasswordTextField.returnKeyType = .next
        currentPasswordTextField.clearButtonMode = .never
        currentPasswordTextField.isSecureTextEntry = false
        currentPasswordTextField.autocorrectionType = .no
        currentPasswordTextField.textContentType = .none
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func selectButtonPress() {
        guard let newPassword = newPasswordTextField.text else { return }
        guard let currentpassword = currentPasswordTextField.text else { return }
        selectButton.setTitle("Updating...", for: .normal)
        
        FireAuthManager.updateUser(password: currentpassword, with: newPassword) { (result) in
            if result == .success {
                self.moveBack()
            } else {
                self.selectButton.setTitle("Save", for: .normal)
                self.currentPasswordTextField.text = ""
                self.saveButton(isEnabled: false)
            }
        }
    }
    
    func moveBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func toggleButtonPressOne() {
        if currentPasswordTextField.isSecureTextEntry {
            currentPasswordTextField.isSecureTextEntry = false
            textFieldToggleOne.setTitle("Hide", for: .normal)
        } else {
            currentPasswordTextField.isSecureTextEntry = true
            textFieldToggleOne.setTitle("Show", for: .normal)
        }
    }
    
    @objc func toggleButtonPressTwo() {
        if newPasswordTextField.isSecureTextEntry {
            newPasswordTextField.isSecureTextEntry = false
            textFieldToggleTwo.setTitle("Hide", for: .normal)
        } else {
            newPasswordTextField.isSecureTextEntry = true
            textFieldToggleTwo.setTitle("Show", for: .normal)
        }
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    
    func saveButton(isEnabled: Bool) {
        if isEnabled {
            selectButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
            selectButton.isEnabled = true
        } else {
            selectButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            selectButton.isEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let newPasswordText = newPasswordTextField.text else { return }
        guard let currentPasswordText = currentPasswordTextField.text else { return }
        
        if newPasswordText.count >= 8 && currentPasswordText.count >= 8 {
            
            if newPasswordText.isValidPassword() == true {
                print("valid")
                validationLabel.isHidden = false
                saveButton(isEnabled: true)
            } else {
                print("Invalid")
                validationLabel.isHidden = true
                saveButton(isEnabled: false)
            }
        } else {
            saveButton(isEnabled: false)
        }
    }
}


