//
//  SignInController.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SignInController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        styleTextFields(textField: emailTextField, placeholder: "Enter email")
        emailTextField.becomeFirstResponder()
        styleTextFields(textField: passwordTextField, placeholder: "Enter password")
        backButton.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: #imageLiteral(resourceName: "signIn-button-icon"), button: signInButton)
    
        emailTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
        
       @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        signInButton.frame.origin.y = self.view.frame.height - keyboardRect.height - 60
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

extension SignInController: UITextFieldDelegate {
    
}
