//
//  SignInController.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var clickHereLabel: UIButton!
    @IBOutlet weak var emailLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var socialSignInYConstraint: NSLayoutConstraint!
    
    var provider = OAuthProvider(providerID: "twitter.com")
    let networkingIndicator = NetworkingProgress()
    var twitterAuthResult: AuthDataResult?
    
    var socialSignup: Bool = false {
        didSet {
            if socialSignup == false {
                networkingIndicator.removeFromSuperview()
            }
        }
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavBarHeight = device.navBarHeight()
    lazy var dynamicNavBarButtonHeight = device.navBarButtonTopAnchor()
    
    let networkIssueAlert = CustomAlertView(alertType: .networkIssue)
    let wrongPasswordAlert = CustomAlertView(alertType: .wrongPassword)
    let noUserAlert = CustomAlertView(alertType: .noUserFound)
    let invalidEmailAlert = CustomAlertView(alertType: .invalidEmail)
    let socialAccountNotFoundAlert = CustomAlertView(alertType: .socialAccountNotFound)
    let featureUnavailableAlert = CustomAlertView(alertType: .iOS13Needed)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var rootVC : UIViewController?
    
    var signInButtonPadding: CGFloat = 10.0
    
    lazy var containerView: PassThoughView = {
        let view = PassThoughView()
        return view
    }()
    
    let signInButton: UIButton = {
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
      
        if socialSignup {
            print("Adding indicator")
            self.networkingIndicator.taskLabel.text = "Signing in using Twitter"
            UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)
            self.signInButton.isHidden = true
        } else {
            emailTextField.becomeFirstResponder()
            emailTextField.keyboardType = .emailAddress
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        networkingIndicator.removeFromSuperview()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
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
        signInButton.frame.origin.y = view.frame.height - keyboardRect.height - 45
    }
    
    func configureDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        socialAccountNotFoundAlert.alertDelegate = self
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
        
        containerView.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavBarHeight).isActive = true
        
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
            emailLabelTopAnchor.constant = 50
            emailLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            passwordLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        case .iPhone8:
            emailLabelTopAnchor.constant = 80
        case .iPhone8Plus:
            break
        case .iPhone11:
            emailLabelTopAnchor.constant = 140
        case .iPhone11Pro:
            emailLabelTopAnchor.constant = 90
        case .iPhone11ProMax:
            emailLabelTopAnchor.constant = 140
        case .unknown:
            break
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    func styleTextFields(textField: UITextField, placeholder: String) {
        textField.backgroundColor = CustomStyle.sixthShade
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: CustomStyle.fifthShade])
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
        signInButton.setTitle("Signing in...", for: .normal)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (snapshot, error) in
            if error != nil {
                print("There was an error getting users document: \(error!)")
            } else {
                
                if snapshot!.exists {
                
                UserDefaults.standard.set(true, forKey: "loggedIn")
                guard let data = snapshot?.data() else { return }
                User.modelUser(data: data)
                
                let completedOnBoarding = data["completedOnBoarding"] as! Bool
                
                if User.isPublisher! {
                    FireStoreManager.getProgramData { success in
                        print("Received program data: \(success)")
                        
                        if completedOnBoarding {
                            self.sendToMainFeed()
                        } else {
                            self.sendToAccountType()
                        }
                    }
                } else {
                    if completedOnBoarding {
                        self.sendToMainFeed()
                    } else {
                        self.sendToAccountType()
                    }
                }
                } else {
                    UIApplication.shared.keyWindow!.addSubview(self.socialAccountNotFoundAlert)
                    self.signInButton.isHidden = false
                }
            }
        }
    }
    
    func sendToAccountType() {
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as! AccountTypeVC
        let navController = UINavigationController()
        navController.viewControllers = [rootVC!]
        
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = navController
        } else {
             appDelegate.window?.rootViewController = navController
        }
    }
    
    func sendToMainFeed() {
        rootVC = MainTabController()
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = rootVC
        } else {
             appDelegate.window?.rootViewController = rootVC
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
    
    @IBAction func useTwitterPress() {
         self.socialSignup = true
        
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print("Error attempting to sign in using Twitter: \(error!.localizedDescription)")
                self.socialSignup = false
            } else {
                Auth.auth().signIn (with: credential!) { authResult, error in
                    if error != nil {
                        print("Error attempting Twitter sign in \(error!.localizedDescription)")
                        self.socialSignup = false
                    } else {
                        print("Successful sign in using Twitter")
                        self.signInButton.isHidden = true
                        self.twitterAuthResult = authResult
                        self.signInUser()
                    }
                }
            }
        }
    }
    
    @IBAction func UseApplePress() {
        if #available(iOS 13, *) {
            startSignInWithAppleFlow()
        } else {
            UIApplication.shared.keyWindow!.addSubview(self.featureUnavailableAlert)
        }
    }

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    func moveToAccountTypeVC() {
        let info = twitterAuthResult!.additionalUserInfo?.profile
        let profileImage = info!["profile_image_url_https"] as? String
        let imagePath = profileImage?.replacingOccurrences(of: "_normal", with: "")
        let username = info!["screen_name"] as? String
        let summary = info!["description"] as? String
        let name = info!["name"] as? String
        
        User.displayName = name
        User.username = username
        User.imagePath = imagePath
        User.socialSignUp = true
        User.ID = twitterAuthResult!.user.uid
        
        CurrentProgram.name = name
        CurrentProgram.summary = summary
        CurrentProgram.username = username
        CurrentProgram.imagePath = imagePath
        CurrentProgram.ID = twitterAuthResult!.user.uid
        
        if let accountTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeVC {
            self.navigationController?.pushViewController(accountTypeVC, animated: true)
        }
    }
}

extension SignInVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        moveToAccountTypeVC()
        print("alert")
    }
    
    func cancelButtonPress() {
        emailTextField.becomeFirstResponder()
        signInButton.setTitle("Sign in", for: .normal)
    }
}


@available(iOS 13.0, *)
extension SignInVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
   
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        guard let nonce = currentNonce else {
          fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            socialSignup = false
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            socialSignup = false
            return
        }
        
        print("Adding indicator")
        self.networkingIndicator.taskLabel.text = "Signing in with Apple"
        UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)

        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                self.socialSignup = false
                print(error!.localizedDescription)
                return
          }
          // User is signed in to Firebase with Apple.
          print("User signed in with Apple ID")
          User.ID = authResult!.user.uid
          CurrentProgram.ID = authResult!.user.uid
          self.signInButton.isHidden = true
          self.signInUser()
        }
      }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
      print("Sign in with Apple errored: \(error)")
    }
    
}
