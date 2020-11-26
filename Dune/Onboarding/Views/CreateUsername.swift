 //
//  AddEmailView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class CreateUsername: UIView {
    
    var nameTaken = false
    var nextButtonActive = false
    var headingYConstant: CGFloat = 260.0
    var textFieldYPosition: CGFloat = -37
    var hasDash: Bool?
    var hasDecimal: Bool?
    var hasUnderScore: Bool?
    let validString = CharacterSet(charactersIn: " !@#€$%^&*()+{}[]|\"<>,~`/:;?=\\¥'£•¢")
    let defaultSubHeading = " Create a unique usersname. You can always change it later."
    let maxCharacterMessage = "Maximum characters is 15"
    let spaceOrSpecialCharacterEntered = "Oops, Usernames can only contain Latin letters, numbers and 1 - _ or . but no special characters"
    
    unowned var nextButtonDelegate: NextButtonDelegate!
    
    var timer = Timer()
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    var username: String?
    let db = Firestore.firestore()
    
    lazy var userTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Username")
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Create username")
    
    let subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.subTextColor
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
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "textfield-validation-tick")
        return imageView
    }()
    
    let unavailableLabel: UILabel = {
        let label = UILabel()
        label.text = "Unavailable"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        styleForScreens()
        configureView()
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
        case .iPhone11Pro, .iPhone12:
            headingYConstant = 220.0
        case .iPhone11ProMax, .iPhone12ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureView() {
        self.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: headingYConstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0).isActive = true
        subHeadingLabel.text = defaultSubHeading
        
        self.addSubview(userTextField)
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: textFieldYPosition).isActive = true
        userTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        userTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userTextField.setLeftPadding(40)
        
        userTextField.delegate = self
        userTextField.keyboardType = .asciiCapable
        userTextField.returnKeyType = .next
        userTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        userTextField.clearButtonMode = .never
        userTextField.becomeFirstResponder()
        
        userTextField.addSubview(validationIcon)
        validationIcon.translatesAutoresizingMaskIntoConstraints = false
        validationIcon.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
        validationIcon.trailingAnchor.constraint(equalTo: userTextField.trailingAnchor, constant: -20).isActive = true
        validationIcon.heightAnchor.constraint(equalToConstant: 10).isActive = true
        validationIcon.widthAnchor.constraint(equalToConstant: 14).isActive = true
        validationIcon.isHidden = true

        userTextField.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
        spinner.trailingAnchor.constraint(equalTo: userTextField.trailingAnchor, constant: -20).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.startAnimating()
        spinner.isHidden = true
        
        userTextField.addSubview(handleIcon)
        handleIcon.translatesAutoresizingMaskIntoConstraints = false
        handleIcon.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor,constant: -2).isActive = true
        handleIcon.leadingAnchor.constraint(equalTo: userTextField.leadingAnchor, constant: 20).isActive = true
        
        userTextField.addSubview(unavailableLabel)
        unavailableLabel.translatesAutoresizingMaskIntoConstraints = false
        unavailableLabel.centerYAnchor.constraint(equalTo: userTextField.centerYAnchor).isActive = true
        unavailableLabel.trailingAnchor.constraint(equalTo: userTextField.trailingAnchor, constant: -20).isActive = true
        unavailableLabel.backgroundColor = CustomStyle.secondShade
        unavailableLabel.isHidden = true
    }
}

extension CreateUsername: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        nextButtonActive = false
        nextButtonDelegate.makeNextButton(active: false)
        checkUsernameIsFree()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Touch")
        nextButtonDelegate.keyboardNextButtonPress()
        return true
    }
    
    @objc func checkUsernameIsFree(){
        
        validationIcon.isHidden = true
        unavailableLabel.isHidden = true
        
        if userTextField.text!.count < 2 {
            spinner.isHidden = true
            validationIcon.isHidden = true
            unavailableLabel.isHidden = true
            nextButtonActive = false
            nextButtonDelegate.makeNextButton(active: false)
        } else {
            spinner.isHidden = false
            if FirebaseStatus.isChecking == false {
                checkUsername()
            }
        }
        
        
    }
    
    @objc func checkUsername() {
        guard let name = userTextField.text else { return }
        
        if name.count >= 2 {
          FireStoreManager.checkIfUsernameExists(name: name) { success in
                self.spinner.isHidden = true
                if name != self.userTextField.text {
                    self.checkUsername()
                }

                if success && FirebaseStatus.isChecking == false {
                    // Username is not taken
                    self.validationIcon.isHidden = false
                    self.unavailableLabel.isHidden = true
                    self.nextButtonActive = true
                    self.nextButtonDelegate.makeNextButton(active: true)
                    self.username = self.userTextField.text
                } else if success == false && FirebaseStatus.isChecking == false {
                    // Username is taken
                    self.nameTaken = true
                    self.unavailableLabel.isHidden = false
                    self.nextButtonActive = false
                    self.nextButtonDelegate.makeNextButton(active: false)
                }
            }
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
            userTextField.shake()
            showInvalidMessage()
            return false
        }
        
        // Reset if string passes
        resetSubHeading()
        return true
    }
    
    func showInvalidMessage() {
        userTextField.shake()
        subHeadingLabel.text = spaceOrSpecialCharacterEntered
    }
    
    func showMaxCharacterMessage() {
        subHeadingLabel.text = maxCharacterMessage
    }
    
    func resetSubHeading() {
        subHeadingLabel.text = defaultSubHeading
    }
    
}
