//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreateUserController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    lazy var screenWidth = self.view.frame.size.width
    
    lazy var createUsername = CreateUsername(frame: CGRect(x: 0, y: 150, width: self.screenWidth, height: 180))
    lazy var addEmail = AddEmail(frame: CGRect(x: self.screenWidth, y: 150, width: self.screenWidth, height: 180))
    lazy var createPassword = CreatePassword(frame: CGRect(x: self.screenWidth, y: 150, width: self.screenWidth, height: 180))
    lazy var addBirthDate = AddBirthDate(frame: CGRect(x: self.screenWidth, y: 150, width: self.view.frame.size.width, height: 180))
    
    lazy var currentView: UIView = createUsername

    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.backgroundColor = CustomStyle.primaryBlue.withAlphaComponent(0.7)
        self.view.addSubview(createUsername)
        self.view.addSubview(addEmail)
        self.view.addSubview(createPassword)
        self.view.addSubview(addBirthDate)
        
        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        
        backButton.setImage(#imageLiteral(resourceName: "left-arrow-angle"), for: .normal)
    }
    
    // Transition functions
    
    lazy var centerXposition = self.view.frame.origin.x

    func toCenter(view: UIView) {
         view.frame.origin.x = self.centerXposition
    }
    
    func backOffScreen(view: UIView) {
        view.frame.origin.x -= screenWidth
    }
    
    func forwardOffScreen(view: UIView) {
        view.frame.origin.x += screenWidth
    }
    
    
    func transitionToCenter(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: [], animations: {self.toCenter(view: view)}, completion: {(value: Bool) in
        })
    }
    
    func transitionBackwards(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: [], animations:  {self.backOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    func transitionForward(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: [], animations: {self.forwardOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
     // SubViews Controls

    @IBAction func nextButtonPress() {
        
        switch currentView {
        case createUsername:
            transitionBackwards(view: currentView); transitionToCenter(view: addEmail); currentView = addEmail
        case addEmail:
            transitionBackwards(view: currentView); transitionToCenter(view: createPassword); currentView = createPassword
        case createPassword:
            transitionBackwards(view: currentView); transitionToCenter(view: addBirthDate); currentView = addBirthDate
        default: return
        }
    }
    
    @IBAction func backButtonPress() {
        switch currentView {
        case createUsername:
            dismiss(animated: true, completion: nil)
        case addEmail:
            transitionForward(view: currentView); transitionToCenter(view: createUsername); currentView = createUsername
        case createPassword:
            transitionForward(view: currentView); transitionToCenter(view: addEmail); currentView = addEmail
        case addBirthDate:
            transitionForward(view: currentView); transitionToCenter(view: createPassword); currentView = createPassword
        default: return
        }
    }
}
