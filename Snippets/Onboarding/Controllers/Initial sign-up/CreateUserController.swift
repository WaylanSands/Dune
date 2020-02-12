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
    @IBOutlet weak var progressBarSE: UIImageView!
    @IBOutlet weak var progressBarTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var progressBarWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var progressBarHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var nextButtonYAnchor: NSLayoutConstraint!
    
    
    lazy var screenWidth = view.frame.width
    var subviewHeight: CGFloat = 200
    lazy var nextButtonY = self.view.frame.size.height / 2 - 200
    
    lazy var helperView = UIView()
    lazy var addEmail = AddEmail(frame: .zero)
    lazy var createPassword = CreatePassword(frame: .zero)
    lazy var addBirthDate = AddBirthDate(frame: .zero)
    lazy var createUsername = CreateUsername(frame: .zero)
    
    lazy var currentView: UIView = createUsername
    
    let deviceType = UIDevice.current.deviceType
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        
        self.view.addSubview(helperView)
        helperView.translatesAutoresizingMaskIntoConstraints = false
        helperView.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
        helperView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        helperView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        helperView.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        helperView.addSubview(createUsername)
        createUsername.nextButtonDelegate = self
        createUsername.translatesAutoresizingMaskIntoConstraints = false
        createUsername.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
        createUsername.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createUsername.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        createUsername.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        helperView.addSubview(addEmail)
        addEmail.nextButtonDelegate = self
        addEmail.translatesAutoresizingMaskIntoConstraints = false
        addEmail.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
        addEmail.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addEmail.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addEmail.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        helperView.addSubview(createPassword)
        createPassword.nextButtonDelegate = self
        createPassword.translatesAutoresizingMaskIntoConstraints = false
        createPassword.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
        createPassword.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createPassword.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        createPassword.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        helperView.addSubview(addBirthDate)
        addBirthDate.nextButtonDelegate = self
        addBirthDate.translatesAutoresizingMaskIntoConstraints = false
        addBirthDate.heightAnchor.constraint(equalToConstant: subviewHeight).isActive = true
        addBirthDate.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addBirthDate.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addBirthDate.bottomAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        
        nextButton.backgroundColor = CustomStyle.primaryBlue.withAlphaComponent(1)
        nextButton.layer.cornerRadius = 6.0
        nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            progressBarSE.isHidden = false
            progressBar.isHidden = true
            backButtonTopAnchor.constant = 10.0
            progressBarTopAnchor.constant = 25.0
            progressBarWidthAnchor.constant = 30
            progressBarHeightAnchor.constant = 30
            nextButtonYAnchor.constant = -5.0
            subviewHeight = 190.0
        case .iPhone8:
            progressBarTopAnchor.constant = 70.0
            progressBarWidthAnchor.constant = 32.0
            progressBarHeightAnchor.constant = 32.0
        case .iPhone8Plus:
            progressBarWidthAnchor.constant = 32.0
            progressBarHeightAnchor.constant = 32.0
        case .iPhone11:
            progressBarWidthAnchor.constant = 32.0
            progressBarHeightAnchor.constant = 32.0
        case .iPhone11Pro:
            progressBarWidthAnchor.constant = 32.0
            progressBarHeightAnchor.constant = 32.0
        case .iPhone11ProMax:
            progressBarWidthAnchor.constant = 32.0
            progressBarHeightAnchor.constant = 32.0
        case .unknown:
            break
        }
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
            self.currentView = view
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
            transitionBackwards(view: createUsername); transitionToCenter(view: addEmail)
            updateProgressImage(2)
            createUsername.userTextField.resignFirstResponder()
            addEmail.emailTextField.becomeFirstResponder()
        case addEmail:
            transitionBackwards(view: addEmail); transitionToCenter(view: createPassword)
            updateProgressImage(3)
            addEmail.emailTextField.resignFirstResponder()
            createPassword.passwordTextField.becomeFirstResponder()
        case createPassword: transitionBackwards(view: createPassword); transitionToCenter(view: addBirthDate); updateProgressImage(4)
        createPassword.passwordTextField.resignFirstResponder(); addBirthDate.dateTextField.becomeFirstResponder();
        case addBirthDate: addBirthDate.dateTextField.resignFirstResponder()
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
            createUsername.userTextField.resignFirstResponder();
            navigationController?.popViewController(animated: true)
        case addEmail:
            transitionForward(view: addEmail); transitionToCenter(view: createUsername); updateProgressImage(1); currentView = createUsername
        case createPassword:
            transitionForward(view: createPassword); transitionToCenter(view: addEmail); updateProgressImage(2); currentView = addEmail
        case addBirthDate:
            transitionForward(view: addBirthDate); transitionToCenter(view: createPassword); updateProgressImage(3) ;currentView = createPassword
        default: return
        }
    }
    
    func updateProgressImage(_ imageNumber: Int) {
        if deviceType == .iPhoneSE {
            switch imageNumber {
            case 1:
                progressBarSE.image = #imageLiteral(resourceName: "signup-step-one")
            case 2:
                progressBarSE.image = #imageLiteral(resourceName: "signup-step-two")
            case 3:
                progressBarSE.image = #imageLiteral(resourceName: "signup-step-three")
            case 4:
                 progressBarSE.image = #imageLiteral(resourceName: "signup-step-four")
            default:
                progressBarSE.isHidden = true
            }
        } else {
            switch imageNumber {
            case 1:
                progressBar.image = #imageLiteral(resourceName: "signup-step-one")
            case 2:
                progressBar.image = #imageLiteral(resourceName: "signup-step-two")
            case 3:
                progressBar.image = #imageLiteral(resourceName: "signup-step-three")
            case 4:
                progressBar.image = #imageLiteral(resourceName: "signup-step-four")
            default:
                progressBar.isHidden = true
            }
        }
    }
}

extension CreateUserController: NextButtonDelegate {
    func activeNextButton(_: Bool) {
        nextButton.backgroundColor = CustomStyle.primaryYellow.withAlphaComponent(1)
    }
}
