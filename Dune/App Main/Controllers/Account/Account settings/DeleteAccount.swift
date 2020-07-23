//
//  DeleteAccount.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DeleteAccount: UIViewController {
    
    let defaultSubHeadingText = "We hope you'll be back again soon."
    var networkingIndicator = NetworkingProgress()
    
    var headingTopConstant: CGFloat = 220
    
    let db = Firestore.firestore()
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: view, title: "Delete account")
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
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(selectButtonPress), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    
    override func viewDidLoad() {
        navigationItem.title = "Delete account"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = .white
        styleForScreens()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordTextField.becomeFirstResponder()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
              headingTopConstant = 100
        case .iPhone8:
            headingTopConstant = 170
        case .iPhone8Plus:
             headingTopConstant = 170
        case .iPhone11:
            break
        case .iPhone11Pro:
            headingTopConstant = 200
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        view.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: headingTopConstant).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        view.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0).isActive = true
        subHeadingLabel.text = defaultSubHeadingText
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 40).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(textFieldToggle)
        textFieldToggle.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggle.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        textFieldToggle.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.returnKeyType = .next
        passwordTextField.clearButtonMode = .never
        passwordTextField.isSecureTextEntry = false
        passwordTextField.autocorrectionType = .no
        passwordTextField.textContentType = .none
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func selectButtonPress() {
        guard let password = passwordTextField.text else { return }
        saveButton.setTitle("Checking...", for: .normal)
        FireAuthManager.reAuthenticate(with: User.email!, using: password) { result in
            
            if result == .success {
                self.networkingIndicator.taskLabel.text = "Deleting account data"
                UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)
                FireStoreManager.deleteProgram(with:  CurrentProgram.ID!, introID: CurrentProgram.introID, imageID:  CurrentProgram.imageID, isSubProgram: false) {
                    
                    Auth.auth().currentUser?.delete(completion: { (error) in
                        if error != nil {
                            print("Error deleting user \(error!.localizedDescription)")
                        } else {
                            print("Success user has been deleted")
                            self.networkingIndicator.removeFromSuperview()
                            if let signupScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVC") as? SignUpVC {
                                User.signOutUser()
                                CurrentProgram.signOutProgram()
                                UserDefaults.standard.set(false, forKey: "loggedIn")
                                self.navigationController?.pushViewController(signupScreen, animated: false)
                            }
                        }
                    })
                }
            } else {
                self.saveButton.setTitle("Save", for: .normal)
                self.passwordTextField.text = ""
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



