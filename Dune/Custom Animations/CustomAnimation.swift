//
//  CustomAnimation.swift
//  Dune
//
//  Created by Waylan Sands on 25/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit


struct CustomAnimation {
    
   static func distanceTwenty() -> CGFloat {
        if UIDevice.current.deviceType == .iPhoneSE {
              return 20
        } else {
            return 20
        }
    }
    
    static func distanceForty() -> CGFloat {
         if UIDevice.current.deviceType == .iPhoneSE {
               return 25
         } else {
             return 40
         }
     }
    
    static func distanceFifty() -> CGFloat {
         if UIDevice.current.deviceType == .iPhoneSE {
               return 35
         } else {
             return 50
         }
     }
    
    static func moveTrimXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x - button.frame.width) - distanceTwenty()
    }
    
    static func moveFilterXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x - (button.frame.width * 2)) - distanceForty()
    }
    
    static func moveRedoXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x + button.frame.width) + 30
    }
    
    static func moveMusicXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x + (button.frame.width * 2)) + distanceFifty()
    }
    
    static func transitionFilter(button: UIButton, to recordButton: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .curveEaseInOut, animations: {self.moveTrimXPosition(button: button, to: recordButton)}, completion: nil)
    }
    
    static func transitionTrim(button: UIButton, to recordButton: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .curveEaseInOut, animations: {self.moveFilterXPosition(button: button, to: recordButton)}, completion: nil)
    }
    
    static func transitionRedo(button: UIButton, to recordButton: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .curveEaseInOut, animations: {self.moveRedoXPosition(button: button, to: recordButton)}, completion: nil)
    }
    
    static func transitionMusic(button: UIButton, to recordButton: UIButton) {
        UIView.transition(with: button, duration: 0.4, options: .curveEaseInOut, animations: {self.moveMusicXPosition(button: button, to: recordButton)}, completion: nil)
    }
    
}
