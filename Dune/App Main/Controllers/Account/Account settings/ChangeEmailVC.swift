//
//  CreatePasswordView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import FirebaseFirestore
import UIKit

class ChangeEmailVC: UIViewController {
    
    var keyboardExtened = false
    var headingYconstant: CGFloat = 220.0
    var textFieldYposition: CGFloat = -37
    let defaultSubHeadingText = "You may need to confirm this later"
    let invalidMessage = "Please enter a valid email address"

    let db = Firestore.firestore()
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: view, title: "Change your email")
    lazy var emailTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: view, placeholder: "New email")
    lazy var passwordTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: view, placeholder: "Current password")
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let textFieldToggle: UIButton =  {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action:#selector(toggleButtonPress), for: .touchUpInside)
        return button
    }()
    
    lazy var containerView: PassThoughView = {
        let view = PassThoughView()
        return view
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        label.textAlignment = .center
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
        navigationItem.title = "Email"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .white
        emailTextField.keyboardType = .emailAddress
        configureDelegates()
        styleForScreens()
        configureViews()
        setupKeyBoard()
    }
    
    func configureDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    func setupKeyBoard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingYconstant = 95.0
            textFieldYposition = -45
            scrollViewContainer.isHidden = true
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
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(gmailButton)
        scrollViewContainer.addArrangedSubview(yahooButton)
        scrollViewContainer.addArrangedSubview(icloudButton)
        scrollViewContainer.addArrangedSubview(outlookButton)
        scrollViewContainer.addArrangedSubview(hotmailButton)
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.bottomAnchor,constant: 60).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant:  16).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant:  -16).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollViewContainer.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        
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
        subHeadingLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        subHeadingLabel.text = defaultSubHeadingText
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(textFieldToggle)
        textFieldToggle.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggle.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        textFieldToggle.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.clearButtonMode = .whileEditing
        emailTextField.autocapitalizationType = .none
        
        
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.returnKeyType = .next
        passwordTextField.clearButtonMode = .never
        passwordTextField.isSecureTextEntry = false
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .none
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func emailButtonPress(sender: UIButton) {
        if  emailTextField.text != "" {
            emailTextField.text = "\(emailTextField.text!)\(sender.titleLabel!.text!).com"
            resetSubHeading()
            textFieldDidChange(emailTextField)
        }
    }
    
    @objc func selectButtonPress() {
        guard let newEmail = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        saveButton.setTitle("Updating...", for: .normal)
        FireAuthManager.updateUser(with: newEmail, using: password) { result in
            
            if result == .success {
                self.moveBack()
            } else {
                self.saveButton.setTitle("Save", for: .normal)
                self.passwordTextField.text = ""
                self.saveButton(isEnabled: false)
            }
        }
    }
    
    func moveBack() {
        navigationController?.popViewController(animated: true)
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

extension ChangeEmailVC: UITextFieldDelegate {
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return true
        }
        
        scrollView.frame.origin.y = view.frame.height - keyboardRect.height - 45
        
        if keyboardRect.height >= 260 && UIDevice.current.deviceType == .iPhone8 {
            scrollView.isHidden = true
        } else if keyboardRect.height < 260 && UIDevice.current.deviceType == .iPhone8 {
            scrollView.isHidden = false
        }
    }
    
    func saveButton(isEnabled: Bool) {
        if isEnabled {
            saveButton.setTitleColor(UIColor.white.withAlphaComponent(1), for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
            saveButton.isEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        subHeadingLabel.text = "You may need to confirm this later"
        subHeadingLabel.textColor = CustomStyle.fourthShade
        
        guard let passwordText = passwordTextField.text else { return }
        
        if emailTextField.text != "" && passwordText.count >= 8 {
            if emailTextField.text!.isValidEmail {
                // Is valid email
                checkEmailAvailability()
                resetSubHeading()
            } else {
                saveButton(isEnabled: false)
            }
        } else {
            saveButton(isEnabled: false)
        }
    }
    
    
    func checkEmailAvailability() {
        
        emailTextField.checkEmail(db: db, field: emailTextField.text!) { success, email in
            if success {
                // Email is taken
                self.saveButton(isEnabled: false)
                self.subHeadingLabel.text = "This email is already in use"
                self.subHeadingLabel.textColor = CustomStyle.sixthShade
//                self.nextButtonDelegate.makeNextButton(active: false)
            } else {
                // Email is not taken
                self.saveButton(isEnabled: true)
            }
        }
    }
    
    func showInvalidMessage() {
        emailTextField.shake()
        subHeadingLabel.text = invalidMessage
        subHeadingLabel.textColor = CustomStyle.fifthShade
        subHeadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func resetSubHeading() {
        subHeadingLabel.textColor = CustomStyle.fourthShade
        subHeadingLabel.text = defaultSubHeadingText
    }
    
}

