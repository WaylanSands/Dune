//
//  CreateUsernameViewController.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

protocol NextButtonDelegate: class {
    func makeNextButton(active: Bool)
    func keyboardNextButtonPress()
}

class CreateUserVC: UIViewController {
    
    @IBOutlet weak var progressBar: UIImageView!
    @IBOutlet weak var progressBarTopAnchor: NSLayoutConstraint!
    
    var nextButtonYPosition: CGFloat = 14
    var datePickerDistance: CGFloat  = 40.0
    var nextButtonLowerYPosition: CGFloat = 100
    lazy var screenWidth = view.frame.width
    var statusStyle: UIStatusBarStyle = .default
    lazy var centerXPosition = self.view.frame.origin.x
    let Under18Years = Calendar.current.date(byAdding: .year, value: -18, to: Date())
    
    let emailTakenAlert = CustomAlertView(alertType: .emailInUse)
    
    let db = Firestore.firestore()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = CustomStyle.primaryBlue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(nextButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 6
        return button
    }()
    
    let noThanksButton: UIButton = {
        let button = UIButton()
        button.setTitle("No thanks", for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(noToNotifications), for: .touchUpInside)
        button.layer.cornerRadius = 6
        button.isHidden = true
        return button
    }()
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.leftButton.setImage(#imageLiteral(resourceName: "back-button-blk"), for: .normal)
        navBar.rightButton.isHidden = true
        navBar.leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        navBar.backgroundColor = .clear
        return navBar
    }()
    
    // Subviews
    let containerView = UIView()
    let addEmail = AddEmail(frame: .zero)
    let createPassword = CreatePassword(frame: .zero)
    let addBirthDate = AllowNotifications(frame: .zero)
    let createUsername = CreateUsername(frame: .zero)
    
    // First subview
    lazy var currentView: UIView = createUsername
    var nextButtonActive = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.statusStyle
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
    }

    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            nextButtonYPosition = 4
            progressBar.isHidden = true
            datePickerDistance = 20.0
            nextButtonLowerYPosition = 60
        case .iPhone8:
            nextButtonYPosition = 20
            nextButtonLowerYPosition = 60
            progressBarTopAnchor.constant = 50.0
        case .iPhone8Plus:
            nextButtonLowerYPosition = 60
             progressBarTopAnchor.constant = 70.0
        case .iPhone11:
            progressBarTopAnchor.constant = 100.0
        case .iPhone11Pro, .iPhone12:
            progressBarTopAnchor.constant = 70.0
        case .iPhone11ProMax, .iPhone12ProMax:
            progressBarTopAnchor.constant = 90.0
        default:
            break
        }
    }
    
    func configureViews() {
        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        containerView.addSubview(createUsername)
        createUsername.translatesAutoresizingMaskIntoConstraints = false
        createUsername.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createUsername.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        createUsername.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createUsername.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createUsername.nextButtonDelegate = self
        
        containerView.addSubview(addEmail)
        addEmail.translatesAutoresizingMaskIntoConstraints = false
        addEmail.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addEmail.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addEmail.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addEmail.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addEmail.nextButtonDelegate = self
        
        containerView.addSubview(createPassword)
        createPassword.translatesAutoresizingMaskIntoConstraints = false
        createPassword.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        createPassword.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        createPassword.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        createPassword.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createPassword.nextButtonDelegate = self
        
        containerView.addSubview(addBirthDate)
        addBirthDate.translatesAutoresizingMaskIntoConstraints = false
        addBirthDate.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        addBirthDate.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        addBirthDate.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addBirthDate.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        addBirthDate.nextButtonDelegate = self
        
        view.addSubview(nextButton)
        nextButton.frame = CGRect(x: 16, y: view.center.y + nextButtonYPosition - 20, width: view.frame.width - 32, height: 40)
//        nextButton.translatesAutoresizingMaskIntoConstraints = false
//        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: nextButtonYPosition).isActive = true
        
//        view.addSubview(noThanksButton)
//        noThanksButton.translatesAutoresizingMaskIntoConstraints = false
//        noThanksButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        noThanksButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        noThanksButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        noThanksButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 10).isActive = true

        view.bringSubviewToFront(progressBar)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    

    func toCenter(view: UIView) {
        view.frame.origin.x = self.centerXPosition
    }

    func backOffScreen(view: UIView) {
        view.frame.origin.x -= screenWidth
    }
    
    func forwardOffScreen(view: UIView) {
        view.frame.origin.x += screenWidth
    }
    
    func transitionToCenter(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.toCenter(view: view)}, completion: {(value: Bool) in
            self.currentView = view
        })
    }
    
    func transitionBackwards(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations:  {self.backOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    func transitionForward(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.forwardOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    //MARK: Next Button Press
    @IBAction func nextButtonPress() {
        
        if nextButtonActive == false && currentView == addEmail {
            if addEmail.emailAvailable != false {
                addEmail.emailTextField.shake()
                addEmail.showInvalidMessage()
            } else {
               UIApplication.shared.windows.last?.addSubview(emailTakenAlert)
            }
        }
        
        if nextButtonActive == false && currentView == createPassword {
            createPassword.validationLabel.text = "Too weak"
            createPassword.validationLabel.isHidden = false
        }
        
        
        if nextButtonActive {
            switch currentView {
            case createUsername:
                User.username = createUsername.username
                transitionBackwards(view: createUsername)
                transitionToCenter(view: addEmail)
                updateProgressImage(2)
                nextButtonActive = addEmail.nextButtonActive
                createUsername.userTextField.resignFirstResponder()
                addEmail.emailTextField.becomeFirstResponder()
            case addEmail:
                User.email = addEmail.emailTextField.text!
                transitionBackwards(view: addEmail)
                transitionToCenter(view: createPassword)
                updateProgressImage(3)
                nextButtonActive = createPassword.nextButtonActive
                addEmail.emailTextField.resignFirstResponder()
                createPassword.passwordTextField.becomeFirstResponder()
            case createPassword:
                User.password = createPassword.password
                transitionBackwards(view: createPassword)
                transitionToCenter(view: addBirthDate)
                animateNextButtonDown()
                updateProgressImage(4)
                nextButtonActive = false
                createPassword.passwordTextField.resignFirstResponder()
            case addBirthDate:
                User.interests = addBirthDate.selectedCategories
                navigateToAccountType()
            default: return
            }
        }
    }
    
    func animateNextButtonDown() {
        UIView.animate(withDuration: 0.5) {
            self.nextButton.frame = CGRect(x: 16, y: self.view.frame.height - self.nextButtonLowerYPosition, width: self.view.frame.width - 32, height: 40)
//            self.view.backgroundColor = CustomStyle.onBoardingBlack
//            self.statusStyle = .lightContent
//            self.customNavBar.leftButton.setImage(UIImage(named: "back-button-white"), for: .normal)
//            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func animateNextButtonUp() {
        UIView.animate(withDuration: 0.5) {
            self.nextButton.frame = CGRect(x: 16, y: self.view.center.y + self.nextButtonYPosition - 20, width: self.view.frame.width - 32, height: 40)
//            self.view.backgroundColor = CustomStyle.white
//            self.statusStyle = .default
//            self.customNavBar.leftButton.setImage(UIImage(named: "back-button-blk"), for: .normal)
//            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func navigateToAccountType() {
        if let accountTypeController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "accountTypeController") as? AccountTypeVC {
            navigationController?.pushViewController(accountTypeController, animated: false)
        }
    }
    
    @IBAction func backButtonPress() {
        switch currentView {
        case createUsername:
            createUsername.userTextField.resignFirstResponder();
            navigationController?.popViewController(animated: true)
        case addEmail:
            transitionForward(view: addEmail)
            transitionToCenter(view: createUsername)
            updateProgressImage(1)
            currentView = createUsername
            self.nextButtonActive = createUsername.nextButtonActive
            addEmail.emailTextField.resignFirstResponder()
            createUsername.userTextField.becomeFirstResponder()
        case createPassword:
            transitionForward(view: createPassword)
            transitionToCenter(view: addEmail)
            updateProgressImage(2)
            currentView = addEmail
            self.nextButtonActive = addEmail.nextButtonActive
            createPassword.passwordTextField.resignFirstResponder()
            addEmail.emailTextField.becomeFirstResponder()
        case addBirthDate:
            noThanksButton.isHidden = true
            transitionForward(view: addBirthDate)
            transitionToCenter(view: createPassword)
            updateProgressImage(3)
            animateNextButtonUp()
            currentView = createPassword
        default: return
        }
    }
    
    func updateProgressImage(_ imageNumber: Int) {
        if UIDevice.current.deviceType != .iPhoneSE {
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
    
    @objc func noToNotifications() {
        print("No")
//         navigateToAccountType()
    }
    
}

extension CreateUserVC: NextButtonDelegate {
    
    func makeNextButton(active: Bool) {
        nextButtonActive = active
    }
    
    func keyboardNextButtonPress() {
        print("keyboard")
        nextButtonPress()
    }
    
}
