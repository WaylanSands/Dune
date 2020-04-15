//
//  AddEmailView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ChangeUsernameVC: UIViewController {
    
    var headingYconstant: CGFloat = 220.0
    var textFieldYposition: CGFloat = -37
    var hasDash: Bool?
    var hasDecimal: Bool?
    var hasUnderScore: Bool?
    let validString = CharacterSet(charactersIn: " !@#€$%^&*()+{}[]|\"<>,~`/:;?=\\¥'£•¢")
    let defaultSubHeading = "Changing your username may result is someone obtaining the original."
    let maxCharacterMessage = "Maximum characters is 15"
    let spaceOrSpecialCharacterEntered = "Oops, Usernames can only contain Latin letters, numbers and 1 - _ or . but no special characters"
    
    var username: String?
    let db = Firestore.firestore()
    
    lazy var usernameTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: view, placeholder: User.username!)
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: view, title: "Change username")
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let handleIcon: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        label.text = "@"
        return label
    }()
    
    let validationIcon: UIImageView = {
        let imageview = UIImageView()
        imageview.image = #imageLiteral(resourceName: "textfield-validation-tick")
        return imageview
    }()
    
    let unavilableLabel: UILabel = {
        let label = UILabel()
        label.text = "Unavilable"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    let saveButton: UIButton = {
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
        view.backgroundColor = .white
        styleForScreens()
        configureView()
        navigationItem.title = "Username"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTextField.becomeFirstResponder()
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
    
    func configureView() {
        view.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: headingYconstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        view.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        subHeadingLabel.text = defaultSubHeading
        
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameTextField.setLeftPadding(40)
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 12).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        usernameTextField.delegate = self
        usernameTextField.keyboardType = .asciiCapable
        usernameTextField.returnKeyType = .next
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        usernameTextField.clearButtonMode = .never
        
        usernameTextField.addSubview(validationIcon)
        validationIcon.translatesAutoresizingMaskIntoConstraints = false
        validationIcon.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
        validationIcon.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: -20).isActive = true
        validationIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        validationIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        validationIcon.isHidden = true
        
        usernameTextField.addSubview(handleIcon)
        handleIcon.translatesAutoresizingMaskIntoConstraints = false
        handleIcon.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor,constant: -2).isActive = true
        handleIcon.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor, constant: 20).isActive = true
        
        usernameTextField.addSubview(unavilableLabel)
        unavilableLabel.translatesAutoresizingMaskIntoConstraints = false
        unavilableLabel.centerYAnchor.constraint(equalTo: usernameTextField.centerYAnchor).isActive = true
        unavilableLabel.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor, constant: -20).isActive = true
        unavilableLabel.isHidden = true
        unavilableLabel.backgroundColor = CustomStyle.secondShade
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func selectButtonPress() {
        User.username = usernameTextField.text
        FireStoreManager.updateUsername()
        navigationController?.popViewController(animated: true)
    }
}

extension ChangeUsernameVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        saveButton.isEnabled = false
        checkUsernameIsFree()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @objc func checkUsernameIsFree() {
        
        self.validationIcon.isHidden = true
        self.unavilableLabel.isHidden = true
        
        if usernameTextField.text!.count < 3 {
            self.validationIcon.isHidden = true
            self.unavilableLabel.isHidden = true
            self.saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            self.saveButton.isEnabled = false
        } else if FirebaseStatus.isChecking == false {
            checkUsername()
        }
    }
    
    
    @objc func checkUsername() {
        guard let name = usernameTextField.text else { return }
        
        if name.count >= 3 {
            print("Name being passed in \(name)")
            FireStoreManager.checkIfUsernameExists(name: name) { success in
                
                if name != self.usernameTextField.text {
                    self.checkUsername()
                }
                
                print(success)
                if success && FirebaseStatus.isChecking == false {
                    // Username is not taken
                    self.saveButton(isEnabled: true)
                } else if success == false && FirebaseStatus.isChecking == false {
                    // Username is taken
                    self.saveButton(isEnabled: false)
                }
            }
        }
    }
    
    func saveButton(isEnabled: Bool) {
        if isEnabled {
            validationIcon.isHidden = false
            unavilableLabel.isHidden = true
            saveButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
            saveButton.isEnabled = true
        } else {
            validationIcon.isHidden = true
            unavilableLabel.isHidden = false
            saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            saveButton.isEnabled = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Check for backspace
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        // Check allowed special characters have only been used once
        if textField.text?.count == 15 {
            showMaxCharacterMessage()
            return false
        }
        
        if string == "-" && hasDash == true {
            showInvalidMessage()
            return false
        }
        
        if string == "." && hasDecimal == true {
            showInvalidMessage()
            return false
        }
        
        if string == "_" && hasUnderScore == true {
            showInvalidMessage()
            return false
        }
        
        if string == "-" {
            hasDash = true
        } else if string == "." {
            hasDecimal = true
        }else if string == "_" {
            hasUnderScore = true
        }
        
        // Check special characters are not used
        if string.rangeOfCharacter(from: validString) != nil {
            usernameTextField.shake()
            showInvalidMessage()
            return false
        }
        
        // Reset if string passes
        resetSubHeading()
        return true
    }
    
    func showInvalidMessage() {
        usernameTextField.shake()
        subHeadingLabel.text = spaceOrSpecialCharacterEntered
        subHeadingLabel.textColor = CustomStyle.fithShade
        subHeadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func showMaxCharacterMessage() {
        subHeadingLabel.text = maxCharacterMessage
        subHeadingLabel.textColor = CustomStyle.fithShade
        subHeadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func resetSubHeading() {
        subHeadingLabel.textColor = CustomStyle.fourthShade
        subHeadingLabel.text = defaultSubHeading
    }
    
}

