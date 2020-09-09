//
//  AccountTypeController.swift
//  Snippets
//
//  Created by Waylan Sands on 13/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import OneSignal
import FirebaseFirestore

class AccountTypeVC: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadlingLabel: UILabel!
    @IBOutlet weak var listenerButton: UIButton!
    @IBOutlet weak var publisherButton: UIButton!
    @IBOutlet weak var subHeadingBottomAnchor: NSLayoutConstraint!
    
    let networkingIndicator = NetworkingProgress()
    let completionAlert = CustomAlertView(alertType: .finishSetup)
    let customNavBar = CustomNavBar()
    let db = Firestore.firestore()
    let device = UIDevice()
    var fastTrack = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.alpha = 0
        subHeadlingLabel.alpha = 0
        listenerButton.alpha = 0
        publisherButton.alpha = 0
        removeBackButtonIfRootView()
        completionAlert.alertDelegate = self
        configureNavigation()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.headingLabel.alpha = 1
            self.subHeadlingLabel.alpha = 1
            self.listenerButton.alpha = 1
            self.publisherButton.alpha = 1
        }, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        fastTrack = false
    }
    
    func removeBackButtonIfRootView() {
        if navigationController != nil {
            customNavBar.leftButton.isHidden = true
        }
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureViews() {
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: nil, button: listenerButton)
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.secondShade, image: nil, button: publisherButton)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        customNavBar.rightButton.isHidden = true
        customNavBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            subHeadingBottomAnchor.constant = 50.0
        case .iPhone8:
            break
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
    
    @IBAction func accountTypeButtonPress(_ sender: UIButton) {
        if sender.titleLabel?.text == "Finish Setup" {
            view.addSubview(completionAlert)
        } else if sender.titleLabel?.text == "Start Listening" {
            networkingIndicator.taskLabel.text = "Fast tracking account"
            UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)
            CurrentProgram.isPublisher = false
            User.isSetUp = false
            fastTrack = true
            updateOrCreateUser()
        }
        
    }
    
    func updateOrCreateUser() {
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        
        if loggedIn {
            updateReturningUser()
        } else if User.socialSignUp == true {
            signUpSocialUser()
        } else {
            createNewUser()
        }
    }
    
    func createNewUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("creating new user")
            
            Auth.auth().createUser(withEmail: User.email!, password: User.password!) { result, error in
                
                if error != nil {
                    print("Theres been an Auth error\(error!.localizedDescription)")
                } else {
                    
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    guard let uid = result?.user.uid else { return }
                    User.ID = uid
                    
                    self.db.collection("users").document(uid).setData([
                        "ID" : User.ID!,
                        "email": User.email!,
                        "isSetUp" : User.isSetUp!,
                        "username": User.username!,
                        "displayName": User.username!,
                        "completedOnBoarding" : false,
                        "interests" :  User.interests!,
                    ]) { err in
                        if let err = err {
                            print("Error creating new user document: \(err)")
                        } else {
                            print("Success creating new user")
                            if self.fastTrack {
                                self.fastTrackAccount()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fastTrackAccount() {
        DispatchQueue.global(qos: .userInitiated).async {
            let programID = NSUUID().uuidString
            print("Fast tracking")
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            User.ID = uid
            CurrentProgram.rep = 0
            CurrentProgram.image = (CurrentProgram.image ?? #imageLiteral(resourceName: "missing-image-large"))
            CurrentProgram.summary = ""
            CurrentProgram.tags = [String]()
            User.completedOnBoarding = true
            CurrentProgram.hasIntro = false
            CurrentProgram.hasMentions = false
            CurrentProgram.isPublisher = false
            CurrentProgram.programIDs = [String]()
            CurrentProgram.name = User.username!
            CurrentProgram.isPrimaryProgram = true
            CurrentProgram.subscriberCount = 0
            CurrentProgram.repMethods = [String]()
            CurrentProgram.username = User.username
            CurrentProgram.subPrograms = [Program]()
            CurrentProgram.subscriberIDs = [String]()
            CurrentProgram.episodeIDs = [[String:Any]]()
            User.programID = CurrentProgram.ID ?? programID
            CurrentProgram.ID = CurrentProgram.ID ?? programID
            if User.recommendedProgram == nil {
                CurrentProgram.subscriptionIDs = [CurrentProgram.ID ?? programID]
            } else {
                CurrentProgram.subscriptionIDs?.append(CurrentProgram.ID ?? programID)
            }
            
            // Private channel
            CurrentProgram.privacyStatus = .madePublic
            CurrentProgram.pendingChannels = [String]()
            CurrentProgram.deniedChannels = [String]()
                        
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(User.programID!)

            
            userRef.updateData([
                "programID": User.programID!,
                "completedOnBoarding" : true,
                ])
            { (error) in
                if let error = error {
                    print("There has been an error adding program ID: \(error.localizedDescription)")
                } else {
                    print("Successfully added channel ID")
                    
                    if CurrentProgram.imageID != nil {
                        programRef.setData(["imageID" : CurrentProgram.imageID!])
                    }
                    
                    programRef.setData([
                        "subscriptionIDs" : CurrentProgram.subscriptionIDs!,
                        "isPublisher" : CurrentProgram.isPublisher!,
                        "episodeIDs" : CurrentProgram.episodeIDs!,
                        "summary": CurrentProgram.summary ?? "",
                        "privacyStatus" : "madePublic",
                        "username" : User.username!,
                        "isPrimaryProgram" : true,
                        "ID" : CurrentProgram.ID!,
                        "name" : User.username!,
                        "pendingChannels": [],
                        "deniedChannels" : [],
                        "subscriberCount" : 0,
                        "hasMentions" : false,
                        "ownerID" : User.ID!,
                        "subscriberIDs": [],
                        "programIDs" : [],
                        "hasIntro" : false,
                        "repMethods" : [],
                        "tags" : [],
                        "rep" : 0
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the program: \(error.localizedDescription)")
                        } else {
                            print("Successfully fast tracked")
                            self.presentSearchVC()
                        }
                    }
                }
            }
        }
    }
    
    func presentProgramNameVC() {
        if let programNameVC = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "programNameVC") as? ProgramNameVC {
            navigationController?.pushViewController(programNameVC, animated: true)
        }
    }
    
    func presentDisplayNameVC() {
        if let displayNameVC = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "displayNameVC") as? DisplayNameVC {
            navigationController?.pushViewController(displayNameVC, animated: true)
        }
    }
    
    func presentSearchVC() {
        DispatchQueue.main.async {
//            duneTabBar.tabButtonSelection(0)
            self.networkingIndicator.removeFromSuperview()
            let tabBar = MainTabController()
            tabBar.selectedIndex = 0
//            DuneDelegate.newRootView(tabBar)

            
//            if User.recommendedProgram != nil {
//                let searchNav = tabBar.selectedViewController as! UINavigationController
//                let searchVC = searchNav.viewControllers[0] as! SearchVC
//                searchVC.programToPush = User.recommendedProgram!
//            }
            
            DuneDelegate.newRootView(tabBar)
        }
    }
    
    func updateReturningUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            User.ID = uid
            
            let userRef = self.db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "isSetUp" : User.isSetUp!
            ]) { err in
                if let err = err {
                    print("Error setting up returned user: \(err)")
                } else {
                    print("Success setting up returned user")
                    if self.fastTrack {
                        self.fastTrackAccount()
                    }
                }
            }
            
            userRef.getDocument(source: .default) { (snapshot, error) in
                
                if error != nil {
                    print("Error getting returning user's snapshot \(error!)")
                }
                
                guard let data = snapshot?.data() else { return }
                User.modelUser(data: data)
                
                // Get their previous programID find and delete the document
                if data["programID"] != nil {
                    let programID = data["programID"] as? String
                    
                    self.db.collection("programs").document(programID!).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                }
            }
        }
    }
    
    func signUpSocialUser() {
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.setData([
                "ID" : User.ID!,
                "isSetUp" : User.isSetUp!,
                "username" : User.username!,
                "completedOnBoarding" : false,
            ]) { error in
                if error != nil {
                    print("Error attempting to signup Twitter user: \(error!.localizedDescription)")
                } else {
                    print("Success signing up Twitter user")
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    if self.fastTrack {
                        self.fastTrackSocialAccount()
                    }
                }
            }
        }
    }
    
    func fastTrackSocialAccount() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            CurrentProgram.rep = 0
            User.completedOnBoarding = true
            CurrentProgram.hasIntro = false
            CurrentProgram.isPublisher = false
            CurrentProgram.hasMentions = false
            CurrentProgram.tags = [String]()
            CurrentProgram.repMethods = [String]()
            CurrentProgram.programIDs = [String]()
            CurrentProgram.isPrimaryProgram = true
            CurrentProgram.subscriberCount = 0
            CurrentProgram.subPrograms = [Program]()
            CurrentProgram.subscriberIDs = [String]()
            CurrentProgram.episodeIDs = [[String:Any]]()
            User.programID = CurrentProgram.ID
            CurrentProgram.image = CurrentProgram.image ?? #imageLiteral(resourceName: "missing-image-large")
            CurrentProgram.summary = (CurrentProgram.summary ?? "")
            
            // Private channel
            CurrentProgram.privacyStatus = .madePublic
            CurrentProgram.pendingChannels = [String]()
            CurrentProgram.deniedChannels = [String]()
            
            if User.recommendedProgram == nil {
                CurrentProgram.subscriptionIDs = [CurrentProgram.ID!]
            } else {
                CurrentProgram.subscriptionIDs?.append(CurrentProgram.ID!)
            }
                        
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(User.programID!)
            
            userRef.updateData([
                "programID": User.programID!,
                "completedOnBoarding" : true,
                ])
            { (error) in
                if let error = error {
                    print("There has been an error adding program ID: \(error.localizedDescription)")
                } else {
                    print("Successfully added channel ID")
                    
                    if CurrentProgram.imageID != nil {
                        programRef.setData(["imageID" : CurrentProgram.imageID!])
                    }
                    
                    programRef.setData([
                        "subscriptionIDs" :  CurrentProgram.subscriptionIDs!,
                        "isPublisher" : CurrentProgram.isPublisher!,
                        "episodeIDs" : CurrentProgram.episodeIDs!,
                        "summary": CurrentProgram.summary!,
                        "privacyStatus" : "madePublic",
                        "name" : CurrentProgram.name!,
                        "username" : User.username!,
                        "isPrimaryProgram" : true,
                        "pendingChannels": [],
                        "deniedChannels" : [],
                        "hasMentions" : false,
                        "subscriberCount" : 0,
                        "ownerID" : User.ID!,
                        "subscriberIDs": [],
                        "programIDs" : [],
                        "hasIntro" : false,
                        "repMethods" : [],
                        "ID" : User.ID!,
                        "tags": [],
                        "rep": 0
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the program: \(error.localizedDescription)")
                        } else {
                            print("Successfully fast tracked")
                            self.presentSearchVC()
                        }
                    }
                }
            }
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AccountTypeVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        presentProgramNameVC()
        CurrentProgram.isPublisher = true
        User.isSetUp = false
        updateOrCreateUser()
    }
    
    func cancelButtonPress() {
        presentDisplayNameVC()
        CurrentProgram.isPublisher =  false
        User.isSetUp = false
        updateOrCreateUser()
    }
    
    
}
