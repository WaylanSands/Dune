//
//  LaunchControllerSwitch.swift
//  Dune
//
//  Created by Waylan Sands on 31/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class LaunchControllerSwitch {
    
    static func updateRootVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var rootVC : UIViewController?

//        UserDefaults.standard.set(false, forKey: "loggedIn")
//        UserDefaults.standard.set(false, forKey: "hasCustomImage")
//        UserDefaults.standard.set(false, forKey: "completedOnboarding")
        
        let loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
        let completedOnboarding = UserDefaults.standard.bool(forKey: "completedOnboarding")
                
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
        }
    }
    
}


