//
//  SignInController.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var clickHereLabel: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var textFieldsTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordTopAnchor: NSLayoutConstraint!
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
    
    var signinButtonPadding: CGFloat = 10.0
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let signinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitle("Sign in", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.backgroundColor = .clear
        customNavBar.navBarTitleLabel.text = "Sign in"
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        
        styleForScreens()
        
        view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        containerView.addSubview(signinButton)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
        
        styleTextFields(textField: emailTextField, placeholder: "Enter email")
        styleTextFields(textField: passwordTextField, placeholder: "Enter password")
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.emailTextField.becomeFirstResponder()
        })
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            textFieldsTopAnchor.constant = 50
            emailLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            passwordLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        case .iPhone8:
            textFieldsTopAnchor.constant = 80
        case .iPhone8Plus:
            break
        case .iPhone11:
            textFieldsTopAnchor.constant = 140
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            textFieldsTopAnchor.constant = 140
        case .unknown:
            break
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        signinButton.frame.origin.y = view.frame.height - keyboardRect.height - 50
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func backButtonPress() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    func styleTextFields(textField: UITextField, placeholder: String) {
        textField.backgroundColor = CustomStyle.sixthShade
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: CustomStyle.fithShade])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.setLeftPadding(20)
    }
}

