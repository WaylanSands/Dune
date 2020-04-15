//
//  SignInController.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var clickHereLabel: UIButton!
    @IBOutlet weak var textFieldsTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordTopAnchor: NSLayoutConstraint!
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
    
    let networkIssueAlert = CustomAlertView(alertType: .networkIssue)
    let wrongPasswordAlert = CustomAlertView(alertType: .wrongPassword)
    let noUserAlert = CustomAlertView(alertType: .noUserFound)
    let invalidEmailAlert = CustomAlertView(alertType: .invalidEmail)

    var signinButtonPadding: CGFloat = 10.0
    
    lazy var containerView: PassThoughView = {
        let view = PassThoughView()
        return view
    }()
    
    let signinButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.addTarget(self, action: #selector(signInButtonPress), for: .touchUpInside)
        return button
    }()
    
    let textFieldToggle: UIButton =  {
        let button = UIButton()
        button.setTitle("Show", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action:#selector(toggleButtonPress), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyBoardObserver()
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.keyboardType = .emailAddress
        emailTextField.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addKeyBoardObserver() {
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        signinButton.frame.origin.y = view.frame.height - keyboardRect.height - 50
    }
    
    func configureDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func configureViews() {
         customNavBar.backgroundColor = .clear
         customNavBar.titleLabel.text = "Sign in"
         customNavBar.rightButton.isHidden = true
         customNavBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
                        
         view.addSubview(containerView)
         containerView.translatesAutoresizingMaskIntoConstraints = false
         containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
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
        
        view.addSubview(textFieldToggle)
        textFieldToggle.translatesAutoresizingMaskIntoConstraints = false
        textFieldToggle.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
        textFieldToggle.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20).isActive = true
         
         styleTextFields(textField: emailTextField, placeholder: "Enter email")
         styleTextFields(textField: passwordTextField, placeholder: "Enter password")
        
        passwordTextField.clearButtonMode = .never
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .password
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
    
    @objc func signInButtonPress() {
        print("hit")
        guard let email =  emailTextField.text else { return }
        guard let password =  passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            guard let vc = self else { return }
          
            if let error = error {
               if let errCode = AuthErrorCode(rawValue: error._code) {

                    switch errCode {
                    case .networkError:
                        UIApplication.shared.windows.last?.addSubview(vc.networkIssueAlert)
                        print("There was a networkError")
                    case .wrongPassword:
                         UIApplication.shared.windows.last?.addSubview(vc.wrongPasswordAlert)
                        print("Wrong password")
                    case .userNotFound:
                         UIApplication.shared.windows.last?.addSubview(vc.noUserAlert)
                         print("No user found")
                    case .invalidEmail:
                        UIApplication.shared.windows.last?.addSubview(vc.invalidEmailAlert)
                        print("Invalid Email")
                    default:
                        print("Other error!")
                    }
                }
            } else {
                vc.signInUser()
            }
           
        }
    }
    
    func signInUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (snapshot, error) in
            if error != nil {
                print("There was an error getting users document: \(error!)")
            } else {
                UserDefaults.standard.set(true, forKey: "loggedIn")
                guard let data = snapshot?.data() else { return }
                User.modelUser(data: data)
                LaunchControllerSwitch.updateRootVC()
            }
        }
    }
    
    func resignTextBoard() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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

