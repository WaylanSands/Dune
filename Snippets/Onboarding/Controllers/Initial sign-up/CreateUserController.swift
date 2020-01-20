//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol NextButtonDelegate {
    func activeNextButton(_: Bool)
}

class CreateUserController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressBar: UIImageView!
    
    lazy var screenWidth = self.view.frame.size.width
    let subviewHeight = 200
    lazy var nextButtonY = self.view.frame.size.height / 2 - 200
    
    lazy var createUsername = CreateUsername(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var addEmail = AddEmail(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var createPassword = CreatePassword(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    lazy var addBirthDate = AddBirthDate(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    lazy var currentView: UIView = createUsername
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(createUsername)
        createUsername.nextButtonDelegate = self
        createUsername.translatesAutoresizingMaskIntoConstraints = false
        createUsername.heightAnchor.constraint(equalToConstant: 200).isActive = true
        createUsername.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createUsername.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        self.view.addSubview(addEmail)
        addEmail.nextButtonDelegate = self
        addEmail.translatesAutoresizingMaskIntoConstraints = false
        addEmail.heightAnchor.constraint(equalToConstant: 200).isActive = true
        addEmail.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addEmail.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addEmail.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        self.view.addSubview(createPassword)
        createPassword.nextButtonDelegate = self
        createPassword.translatesAutoresizingMaskIntoConstraints = false
        createPassword.heightAnchor.constraint(equalToConstant: 200).isActive = true
        createPassword.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createPassword.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        createPassword.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        self.view.addSubview(addBirthDate)
        createUsername.nextButtonDelegate = self
        addBirthDate.translatesAutoresizingMaskIntoConstraints = false
        addBirthDate.heightAnchor.constraint(equalToConstant: 200).isActive = true
        addBirthDate.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addBirthDate.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addBirthDate.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        nextButton.backgroundColor = CustomStyle.primaryBlue.withAlphaComponent(0.7)
        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
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
            transitionBackwards(view: currentView); transitionToCenter(view: addEmail); progressBar.image = #imageLiteral(resourceName: "progressBar-two"); currentView = addEmail
        case addEmail:
            transitionBackwards(view: currentView); transitionToCenter(view: createPassword); progressBar.image = #imageLiteral(resourceName: "progressBar-three"); currentView = createPassword
        case createPassword:
            transitionBackwards(view: currentView); transitionToCenter(view: addBirthDate); progressBar.image = #imageLiteral(resourceName: "progressBar-four"); currentView = addBirthDate;
            case addBirthDate:
            navigateToAccountType()
        default: return
        }
    }
    
    func navigateToAccountType() {
           if let accountTypeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeController {
            navigationController?.pushViewController(accountTypeController, animated: true)
        }
    }
    
    @IBAction func backButtonPress() {
        switch currentView {
        case createUsername:
            createUsername.userTextField.resignFirstResponder() ; navigationController?.popViewController(animated: true)
        case addEmail:
            transitionForward(view: currentView); transitionToCenter(view: createUsername); progressBar.image = #imageLiteral(resourceName: "progressBar-one"); currentView = createUsername
        case createPassword:
            transitionForward(view: currentView); transitionToCenter(view: addEmail); progressBar.image = #imageLiteral(resourceName: "progressBar-two"); currentView = addEmail
        case addBirthDate:
            transitionForward(view: currentView); transitionToCenter(view: createPassword); progressBar.image = #imageLiteral(resourceName: "progressBar-three");currentView = createPassword
        default: return
        }
    }
}

extension CreateUserController: NextButtonDelegate {
    func activeNextButton(_: Bool) {
       nextButton.backgroundColor = CustomStyle.primaryBlue.withAlphaComponent(1)
    }
}
