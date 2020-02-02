//
//  SignInController.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SignInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var clickHereLabel: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var textFieldsTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordTopAnchor: NSLayoutConstraint!
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let signinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryRed
        button.layer.cornerRadius = 20.0
        button.setTitle("Sign in", for: .normal)
        button.setImage(#imageLiteral(resourceName: "signIn-button-icon"), for: .normal)
        button.imageView!.image!.withRenderingMode(.alwaysOriginal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        return button
    }()
    
    var signinButtonPadding: CGFloat = 10.0
    let deviceType = UIDevice.current.deviceType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        
        view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        containerView.addSubview(signinButton)
        signinButton.translatesAutoresizingMaskIntoConstraints = false
        signinButton.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 20.0).isActive = true
        signinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        signinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        signinButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
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
            backButtonTopAnchor.constant = 10.0
            textFieldsTopAnchor.constant = 50
            emailLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            passwordLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        case .iPhone8:
            backButtonTopAnchor.constant = 10.0
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
    
    @IBAction func backButtonPress() {
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

