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
    
    static func moveTrimXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x - button.frame.width) - 20
    }
    
    static func moveFilterXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x - (button.frame.width * 2)) - 40
    }
    
    static func moveRedoXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x + button.frame.width) + 30
    }
    
    static func moveMusicXPosition(button: UIButton, to recordButton: UIButton) {
        button.frame.origin.x = (recordButton.frame.origin.x + (button.frame.width * 2)) + 50
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
