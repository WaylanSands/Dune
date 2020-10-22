//
//  InitialSignupController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import CryptoKit
import FirebaseAuth
import FirebaseAnalytics
import FirebaseFirestore
import AuthenticationServices

class SignUpVC: UIViewController {
    
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailSignUpOutlet: UIButton!
    @IBOutlet weak var facebookSignUpOutlet: UIButton!
    @IBOutlet weak var appleSignUpOutlet: UIButton!
    @IBOutlet weak var appIconView: UIImageView!
    @IBOutlet weak var stackedTitleAndIcon: UIStackView!
    @IBOutlet weak var titleBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var stackedButtons: UIStackView!
    @IBOutlet weak var stackedButtonsYAnchor: NSLayoutConstraint!
    
    let deviceType = UIDevice.current.deviceType
    var rootVC : UIViewController!
    
    let provider = OAuthProvider(providerID: "twitter.com")
   
    let networkingIndicator = NetworkingProgress()
   
    let featureUnavailableAlert = CustomAlertView(alertType: .iOS13Needed)
    let appleNameFailAlert = CustomAlertView(alertType: .appleNameFail)
    
    var socialSignup: Bool = false {
        didSet {
            if socialSignup == false {
                networkingIndicator.removeFromSuperview()
            }
        }
    }

    fileprivate var currentNonce: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onBoardingBlack
        styleButtons()
        styleForScreens()
        configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if socialSignup {
            print("Adding indicator")
            self.networkingIndicator.taskLabel.text = "Fetching details"
            UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)
            view.addSubview(self.networkingIndicator)

        } 
    }
    
    func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        networkingIndicator.removeFromSuperview()
    }
    
    func styleButtons() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: #imageLiteral(resourceName: "mail-icon"), button: emailSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9529411765, alpha: 1), image: UIImage(named: "twitter-logo"), button: facebookSignUpOutlet)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.white, image: #imageLiteral(resourceName: "apple-logo"), button: appleSignUpOutlet)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S, .iPhoneSE:
            titleBottomAnchor.constant = 30.0
            stackedTitleAndIcon.spacing = 40.0
            stackedButtonsYAnchor.constant = 30
            titleLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
            logoLabel.font = UIFont.systemFont(ofSize: 23.0, weight: .heavy)
        case .iPhone8:
            titleBottomAnchor.constant = 30.0
            stackedButtonsYAnchor.constant = 10
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
    
    @IBAction func signInButtonPress(_ sender: UIButton) {
        if let signInVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signInVC") as? SignInVC {
            navigationController?.pushViewController(signInVC, animated: true)
        }
    }
    
    @IBAction func twitterSignupPress() {
        socialSignup = true
        
        provider.getCredentialWith(nil) { credential, error in
            
            if error != nil {
                print("Error attempting to sign up using Twitter: \(error!.localizedDescription)")
                self.socialSignup = false
            } else {
                
                Auth.auth().signIn(with: credential!) { [unowned self] authResult, error in
                    
                    if error != nil {
                        print("Error attempting Twitter sign up")
                        self.socialSignup = false
                        self.networkingIndicator.removeFromSuperview()
                    } else {
                        print("Successful signup using Twitter")
                        Analytics.logEvent(AnalyticsEventSignUp, parameters: ["signup-method" : "Twitter"])
                        
                        let info = authResult!.additionalUserInfo?.profile
                        let profileImage = info!["profile_image_url_https"] as? String
                        let imagePath = profileImage?.replacingOccurrences(of: "_normal", with: "")
                        let username = info!["screen_name"] as? String
                        let summary = info!["description"] as? String
                        let name = info!["name"] as? String

                        User.socialSignUp = true
                        User.username = username
                        User.ID = authResult!.user.uid
                        CurrentProgram.imagePath = imagePath

                        CurrentProgram.name = name
                        CurrentProgram.summary = summary
                        CurrentProgram.username = username
                        CurrentProgram.imagePath = imagePath
                        CurrentProgram.ID = authResult!.user.uid

                        self.attemptToStoreProgramImage()
                        
                        if let accountTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeVC {
                            self.navigationController?.pushViewController(accountTypeVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func attemptToStoreProgramImage() {
        if CurrentProgram.imagePath != nil && CurrentProgram.imagePath != ""  {
            FileManager.fetchImageFrom(url: CurrentProgram.imagePath!) { image in
                if image != nil {
                    FileManager.storeTwitterProgramImage(image: image!)
                }
            }
        }
    }
    
    
    @IBAction func appleSignUpPress() {
        if #available(iOS 13, *) {
            startSignInWithAppleFlow()
            socialSignup = true
        } else {
            view.addSubview(self.featureUnavailableAlert)
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
                
                let completedOnBoarding = data["completedOnBoarding"] as! Bool
                
                FireStoreManager.getProgramData { success in
                    print("Received program data: \(success)")
                    
                    if completedOnBoarding {
                        self.sendToMainFeed()
                    } else {
                        self.sendToAccountType()
                    }
                }
            }
        }
    }
    
    func sendToAccountType() {
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as! AccountTypeVC
        let navController = UINavigationController()
        navController.viewControllers = [rootVC!]
        DuneDelegate.newRootView(navController)
    }
    
    func sendToMainFeed() {
        rootVC = MainTabController()
        DuneDelegate.newRootView(rootVC)
    }
    
}

@available(iOS 13.0, *)
extension SignUpVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
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
                 self.socialSignup = false
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.socialSignup = false
                return
            }
            
            self.networkingIndicator.taskLabel.text = "Fetching details"
            self.view.addSubview(self.networkingIndicator)

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    self.socialSignup = false
                    return
                }
                // User is signed in to Firebase with Apple.
                print("User signed in with Apple ID")
                User.ID = authResult!.user.uid
                CurrentProgram.ID = authResult!.user.uid
                Analytics.logEvent(AnalyticsEventSignUp, parameters: ["signup-method" : "Apple"])
                
                FireStoreManager.checkIfUserExists(ID: User.ID!) { userExists in
                    
                    if userExists {
                        self.socialSignup = false
                        self.signInUser()
                    } else {
                        
                        if let fullName = appleIDCredential.fullName,
                            let firstName = fullName.givenName,
                            let familyName = fullName.familyName {
                            let username = firstName + familyName
                            
                            CurrentProgram.name = "\(firstName) \(familyName)"
                           
                            print("Users Apple name is \(username)")
                            
                            FireStoreManager.checkIfUsernameExists(name: username) { success in
                                if success {
                                    self.moveToAccountTypeVC(with: username)
                                } else {
                                    let uniqueName = self.nameWithRandomDigits(name: username)
                                    self.moveToAccountTypeVC(with: uniqueName)
                                }
                            }
                        } else {
                            self.networkingIndicator.removeFromSuperview()
                            self.view.addSubview(self.appleNameFailAlert)
                            self.socialSignup = false
                        }
                    }
                }
            }
        }
    }
    
    
    func nameWithRandomDigits(name: String) -> String {
        let randomInt = Int.random(in: 1...1000)
        let randomNumberString = String(randomInt)
        return name + randomNumberString
    }
    
    func moveToAccountTypeVC(with name: String) {
       
        User.username = name
        User.socialSignUp = true
        CurrentProgram.username = name
        
        if let accountTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeVC {
            self.navigationController?.pushViewController(accountTypeVC, animated: true)
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
        self.socialSignup = false
    }
    
}
