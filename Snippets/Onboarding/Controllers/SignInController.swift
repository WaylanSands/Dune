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
        styleTextFields(textField: passwordTextField, placeholder: "Enter password")
        backButton.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        emailTextField.becomeFirstResponder()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: #imageLiteral(resourceName: "signIn-button-icon"), button: signInButton)
    }
    
    @IBAction func backButtonPress() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
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
