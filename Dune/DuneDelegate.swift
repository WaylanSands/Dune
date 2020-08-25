//
//  SceneSwitch.swift
//  Dune
//
//  Created by Waylan Sands on 4/8/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

struct DuneDelegate {
    
    static func newRootView(_ viewController: UIViewController) {
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
             sceneDelegate.window?.rootViewController = viewController
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = viewController
        }
    }
}
