//
//  LaunchVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    private let completedIntro = UserDefaults.standard.bool(forKey: "completedIntro")
    private let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    private var style: UIStatusBarStyle = .lightContent
    private var rootVC : UIViewController!
    private var finishedAnimation = false
    private var hasUserData = false
    private var isLoggedIn = false
    
    private let labelMask: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash-icon")
        return imageView
    }()
    
    private let duneLabel: UILabel = {
        let label = UILabel()
        label.text = "Dune"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onBoardingBlack
        configureView()
    }
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedIn()
        animateWithLogo()
    }
    
    func checkIfLoggedIn() {
        if completedIntro && loggedIn {
            print("logged in")
            isLoggedIn = true
            getUserData()
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        style = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func configureView() {
        
        view.addSubview(duneLabel)
        duneLabel.frame = CGRect(x: view.frame.width / 2 - duneLabel.intrinsicContentSize.width, y: view.frame.height / 2 - (20 + 20), width: duneLabel.intrinsicContentSize.width, height: 40)
        
        view.addSubview(labelMask)
        labelMask.frame = CGRect(x: view.frame.width / 2 - duneLabel.intrinsicContentSize.width, y: view.frame.height / 2 - (20 + 20), width: duneLabel.intrinsicContentSize.width, height: 40)
        
        view.addSubview(logoImageView)
        logoImageView.frame = CGRect(x: view.frame.width / 2 - 20, y: view.frame.height / 2 - (20 + 20), width: 40, height: 40)

    }
    
    func animateWithLogo() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
            self.duneLabel.frame.origin.x = self.view.frame.width / 2 - 15
            self.labelMask.frame.origin.x = self.labelMask.frame.width - 20
            self.logoImageView.frame.origin.x = self.view.frame.width / 2 - 65
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.finishedAnimation = true
                if self.isLoggedIn && self.hasUserData {
                    self.grantUserAccess()
                } else if self.completedIntro && !self.loggedIn {
                    self.sendToSignUp()
                } else if !self.completedIntro {
                    self.sendToIntro()
                }
            }
        }
    }
    
    private func getUserData() {
        FireStoreManager.getUserData() {
            self.hasUserData = true
            print("Returned")
            if self.finishedAnimation {
                self.grantUserAccess()
            }
        }
    }
    
    // Determine if user is returning to complete onboarding or returning as full fledged user.
    private func grantUserAccess() {
        if User.completedOnBoarding! {
            rootVC = MainTabController()
            DuneDelegate.newRootView(rootVC)
        } else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as! AccountTypeVC
            let navController = UINavigationController()
            navController.viewControllers = [rootVC!]
            DuneDelegate.newRootView(navController)
        }
    }
    
    private func sendToSignUp() {
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
        DuneDelegate.newRootView(rootVC)
    }
    
    private func sendToIntro() {
        rootVC = IntroVC()
        DuneDelegate.newRootView(rootVC)
    }
}
