//
//  AccountTypeController.swift
//  Snippets
//
//  Created by Waylan Sands on 13/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class AccountTypeVC: UIViewController {
    
    @IBOutlet weak var listenerButton: UIButton!
    @IBOutlet weak var publisherButton: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subheadlingBottomAnchor: NSLayoutConstraint!
    
    let db = Firestore.firestore()
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    
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
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            subheadlingBottomAnchor.constant = 50.0
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
    
    @IBAction func accountTypebuttonPress(_ sender: UIButton) {
        
        // If is already logged in they are returning to finish onboarding
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        if loggedIn {
            updateReturningUser()
        } else {
            createNewUser()
        }
        
        if sender.titleLabel?.text == "Publisher" {
            print("hit publisher")
            User.isPublisher = true
           
            if let programNameVC = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "programNameVC") as? ProgramNameVC {
                navigationController?.pushViewController(programNameVC, animated: true)
                print("publisher push")
            }
        } else if sender.titleLabel?.text == "Listener" {
            User.isPublisher = false

            if let listenerImageVC = UIStoryboard(name: "OnboardingListener", bundle: nil).instantiateViewController(withIdentifier: "listenerImageVC") as? ListenerImageVC {
                navigationController?.pushViewController(listenerImageVC, animated: true)
            }
        }
    }
    
    // Ceate new user and add details
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
                    User.subscriptionIDs = [String]()
                    
                    self.db.collection("users").document(uid).setData([
                        "ID" : User.ID!,
                        "username": User.username!,
                        "email": User.email!,
                        "birthDate": User.birthDate!,
                        "isPublisher": User.isPublisher!,
                        "completedOnBoarding" : false,
                        "subscriptionIDs" : User.subscriptionIDs!
                    ]) { err in
                        if let err = err {
                            print("Error creating new user document: \(err)")
                        } else {
                            print("Success creating new user document")
                        }
                    }
                }
            }
        }
    }
    
    // The user is returning after not finishing onboarding previously
    func updateReturningUser() {
        print("attempting to update returning user")
        DispatchQueue.global(qos: .userInitiated).async {
            print("updating user")
            
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
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
}
