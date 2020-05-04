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
    let completedOnboarding = UserDefaults.standard.bool(forKey: "completedOnboarding")
    
    let logoStackView: UIStackView = {
       let view = UIStackView()
        view.spacing = 10
        return view
    }()
   
    let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "signup-logo-icon")
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
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onBoardingBlack
        configureView()
        
        if loggedIn {
            getUserData()
        } else {
            determineFirstScreen()
        }
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
        print("getting user data")
        FireStoreManager.getUserData() {
            self.determineFirstScreen()
        }
    }
    
    func determineFirstScreen() {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                var rootVC : UIViewController?
print("Checking")
        //        UserDefaults.standard.set(false, forKey: "loggedIn")
        //        UserDefaults.standard.set(false, forKey: "hasCustomImage")
        //        UserDefaults.standard.set(false, forKey: "completedOnboarding")
                
                        
                print("Loggedin \(loggedIn)")
                print("CompletedOnboarding \(completedOnboarding)")
                
                if loggedIn && completedOnboarding {
                    rootVC = MainTabController()
                    appDelegate.window?.rootViewController = rootVC
                } else if loggedIn && completedOnboarding == false  {
                    rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as! AccountTypeVC
                    let navController = UINavigationController()
                    navController.viewControllers = [rootVC!]
                    appDelegate.window?.rootViewController = navController
                } else if loggedIn == false {
                    rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNavController") as! UINavigationController
                    appDelegate.window?.rootViewController = rootVC
                    print("This was triggered")
                }
    }
    
    
    
}
