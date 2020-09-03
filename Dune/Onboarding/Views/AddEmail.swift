//
//  CreatePasswordView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class AddEmail: UIView {
    
    var keyboardExtened = false
    var nextButtonActive = false
    var headingYConstant: CGFloat = 260.0
    var textFieldYPosition: CGFloat = -37
    var nextButtonDelegate: NextButtonDelegate!
    let defaultSubHeadingText = "You’ll need to confirm this later"
    let invalidMessage = "Please enter a valid email address"
    let takenEmailMessage = "This email is already in use"
    
    var emailAvailable: Bool?
    let db = Firestore.firestore()
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Add your email address")
    lazy var emailTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "Email")
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitle("@gmail", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let hotmailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitle("@hotmail", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.layer.cornerRadius = 17.5
        button.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        return button
    }()
    
    let outlookButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitle("@outlook", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let icloudButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitle("@icloud", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let yahooButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.setTitle("@yahoo", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(emailButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 17.5
        return button
    }()
    
    let subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.subTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupKeyBoard()
        styleForScreens()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingYConstant = 95.0
            textFieldYPosition = -45
            scrollViewContainer.isHidden = true
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
        self.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(gmailButton)
        scrollViewContainer.addArrangedSubview(yahooButton)
        scrollViewContainer.addArrangedSubview(icloudButton)
        scrollViewContainer.addArrangedSubview(outlookButton)
        scrollViewContainer.addArrangedSubview(hotmailButton)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.bottomAnchor,constant: 60).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  16).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant:  -16).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
        self.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: headingYConstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40.0).isActive = true
        subHeadingLabel.text = defaultSubHeadingText
        
        self.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: textFieldYPosition).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.autocapitalizationType = .none
    }
    
    @objc func emailButtonPress(sender: UIButton) {
        if  emailTextField.text != "" {
            emailTextField.text = "\(emailTextField.text!)\(sender.titleLabel!.text!).com"
            nextButtonDelegate.makeNextButton(active: true)
            nextButtonActive = true
            resetSubHeading()
            textFieldDidChange(emailTextField)
        }
    }
}

extension AddEmail: UITextFieldDelegate {
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            nextButtonDelegate.keyboardNextButtonPress()
            return true
        }
        
        scrollView.frame.origin.y = self.frame.height - keyboardRect.height - 45
        
        if keyboardRect.height >= 260 && UIDevice.current.deviceType == .iPhone8 {
            scrollView.isHidden = true
        } else if keyboardRect.height < 260 && UIDevice.current.deviceType == .iPhone8 {
            scrollView.isHidden = false
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        nextButtonActive = false
        nextButtonDelegate.makeNextButton(active: false)
        
        if textField.text != ""  {
            if textField.text!.isValidEmail {
                checkEmailAvailability()
                resetSubHeading()
            }
        }
    }
    
    
    func checkEmailAvailability() {
        emailTextField.checkEmail(db: db, field: emailTextField.text!) { isTaken, email in
            if email != self.emailTextField.text {
                self.checkEmailAvailability()
            }
            if isTaken {
                self.nextButtonDelegate.makeNextButton(active: false)
                self.nextButtonActive = false
                self.emailAvailable = false
            } else {
                self.nextButtonDelegate.makeNextButton(active: true)
                self.nextButtonActive = true
                self.emailAvailable = true
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            return true
        }
        
        return true
    }
    
    func showInvalidMessage() {
        emailTextField.shake()
        subHeadingLabel.text = invalidMessage
    }
    
    func resetSubHeading() {
        subHeadingLabel.text = defaultSubHeadingText
    }
    
}
