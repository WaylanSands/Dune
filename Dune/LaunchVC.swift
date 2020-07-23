//
//  LaunchVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {
    
    let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    let completedIntro = UserDefaults.standard.bool(forKey: "completedIntro")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var style:UIStatusBarStyle = .lightContent
    var rootVC : UIViewController?
    
    let logoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash-icon")
        return imageView
    }()
    
    let duneLabel: UILabel = {
        let label = UILabel()
        label.text = "Dune"
        label.font = UIFont.systemFont(ofSize: 29, weight: .bold)
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
        if completedIntro {
            if loggedIn {
                getUserData()
            } else {
                sendToSignUp()
            }
        } else {
            sendToIntro()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        style = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func configureView() {
        view.addSubview(logoStackView)
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        logoStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        logoStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        
        logoStackView.addArrangedSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        logoStackView.addArrangedSubview(duneLabel)
    }
    
    func getUserData() {
        FireStoreManager.getUserData() {
            self.determineFirstScreen()
        }
    }
    
    func determineFirstScreen() {
        if User.completedOnBoarding! {
            rootVC = MainTabController()
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                 sceneDelegate.window?.rootViewController = rootVC
            } else {
                 appDelegate.window?.rootViewController = rootVC
            }
        } else {
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
    }
    
    func sendToSignUp() {
        rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
        
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = rootVC
        } else {
             appDelegate.window?.rootViewController = rootVC
        }
    }
    
    func sendToIntro() {
        rootVC = IntroVC()
        
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = rootVC
        } else {
             appDelegate.window?.rootViewController = rootVC
        }
    }
}
