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
    @IBOutlet weak var listenerButton: UIButton!
    @IBOutlet weak var publisherButton: UIButton!
    @IBOutlet weak var subHeadingBottomAnchor: NSLayoutConstraint!
    
    let networkingIndicator = NetworkingProgress()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let customNavBar = CustomNavBar()
    let db = Firestore.firestore()
    let device = UIDevice()
    var fastTrack = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeBackButtonIfRootView()
        configureNavigation()
        styleForScreens()
        configureViews()
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
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        
        if sender.titleLabel?.text == "Finish Setup" {
            User.isPublisher = true
            presentProgramNameVC()
        } else if sender.titleLabel?.text == "Start Listening" {
            networkingIndicator.taskLabel.text = "Fast tracking account"
            UIApplication.shared.keyWindow!.addSubview(self.networkingIndicator)

            User.isPublisher = false
            fastTrack = true
        }
        
        if loggedIn {
            updateReturningUser()
        } else if User.socialSignUp == true {
            signUpSocialUser()
        } else {
           createNewUser()
        }
        print("Hit")
    }
    
    func createNewUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("creating new User")
            
            Auth.auth().createUser(withEmail: User.email!, password: User.password!) { (result, error) in
                
                if error != nil {
                    print("Theres been an Auth error\(error.debugDescription)")
                } else {
                    
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    guard let uid = result?.user.uid else { return }
                    User.ID = uid
                    
                    self.db.collection("users").document(uid).setData([
                        "ID" : User.ID!,
                        "email": User.email!,
                        "username": User.username!,
                        "displayName": User.username!,
                        "completedOnBoarding" : false,
                        "isPublisher": User.isPublisher!,
                    ]) { err in
                        if let err = err {
                            print("Error creating new user document: \(err)")
                        } else {
                            print("Success creating new user document")
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
                OneSignal.sendTags(["onboarded" : true])
                let programID = NSUUID().uuidString
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                User.ID = uid
                CurrentProgram.rep = 0
                CurrentProgram.image = (CurrentProgram.image ?? #imageLiteral(resourceName: "missing-image-large"))
                CurrentProgram.summary = ""
                CurrentProgram.tags = [String]()
                User.completedOnBoarding = true
                CurrentProgram.hasIntro = false
                CurrentProgram.hasMentions = false
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

                // Ready to move
                self.presentSearchVC()

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
    
    func presentSearchVC() {
        DispatchQueue.main.async {
            self.networkingIndicator.removeFromSuperview()
            let tabBar = MainTabController()
            tabBar.selectedIndex = 1
            
            if User.recommendedProgram != nil {
                let searchNav = tabBar.selectedViewController as! UINavigationController
                let searchVC = searchNav.viewControllers[0] as! SearchVC
                searchVC.programToPush = User.recommendedProgram!
            }
            
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                sceneDelegate.window?.rootViewController = tabBar
            } else {
                self.appDelegate.window?.rootViewController = tabBar
            }
        }
    }
    
    func updateReturningUser() {
        print("attempting to update returning user")
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            User.ID = uid
            
            let userRef = self.db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "isPublisher": User.isPublisher!
            ]) { err in
                if let err = err {
                    print("Error adding publisher type for returning user: \(err)")
                } else {
                    print("Success adding publisher type for returning user")
                    if self.fastTrack {
                        self.fastTrackAccount()
                    }
                }
            }
            
            userRef.getDocument(source: .default) { (snapshot, error) in
                
                if error != nil {
                    print("Error getting returing user's snapshot \(error!)")
                }
                
                // Create a user singleton with the user's previous data
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
                "username" : User.username!,
                "completedOnBoarding" : false,
                "isPublisher" : User.isPublisher!,
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
                OneSignal.sendTags(["onboarded" : true])
                
                CurrentProgram.rep = 0
                User.completedOnBoarding = true
                CurrentProgram.hasIntro = false
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
                                
                // Ready to move
                self.presentSearchVC()

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
//                                self.attemptToStoreProgramImage()
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
