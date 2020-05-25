//
//  CustomAlertVC.swift
//  Dune
//
//  Created by Waylan Sands on 29/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

enum alertType {
    case networkIssue
    case wrongPassword
    case wrongPasswordForChange
    case noUserFound
    case invalidEmail
    case skipAddingImage
    case skipAddingProgramSummary
    case changingUsername
    case publisherChangingDisplayName
    case changingPassword
    case changingEmail
    case signOutAttempt
    case deleteAccount
    case deleteProgram
    case shortAudioLength
    case audioTooLong
    case shortIntroLength
    case removeIntro
    case notAPublisher
    case cantFindLargeImage
    case invalidURL
}

protocol CustomAlertDelegate {
    func primaryButtonPress()
    func cancelButtonPress()
}

class CustomAlertView: UIView {
    
    var typeOfAlert: alertType
    var alertDelegate: CustomAlertDelegate?
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        label.textAlignment = .center
        return label
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let primaryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryYellow
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 17.5
        button.clipsToBounds = true
        return button
    }()
    
    let secondaryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    required init(alertType: alertType) {
        self.typeOfAlert = alertType
        super.init(frame: UIScreen.main.bounds)
        prepareAlert()
        configureViews()
        self.alpha = 0
    }
    
    override func draw(_ rect: CGRect) {
        fitContainerHeight()
        fadeIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.fadeInContainerView()
        }
    }
    
    func fadeInContainerView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerView.alpha = 1
        }, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareAlert() {
        switch typeOfAlert {
        case .networkIssue:
            headingLabel.text = "Network Issue"
            bodyTextLabel.text = "It appears you have no internet connection"
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .noUserFound:
            headingLabel.text = "Invalid login"
            bodyTextLabel.text = "No user found with that email, please check again."
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .wrongPassword:
            headingLabel.text = "Invalid login"
            bodyTextLabel.text = "Whoops, looks like this email and password combination do not match"
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .invalidEmail:
            headingLabel.text = "Invalid login"
            bodyTextLabel.text = "We're having trouble finding a user with this email"
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .skipAddingImage:
            headingLabel.text = "Skipping Forward"
            bodyTextLabel.text = "You may skip this step though all publishers are required to have a unique profile image before pubishing episodes on Dune."
            primaryButton.setTitle("Skip", for: .normal)
            primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .skipAddingProgramSummary:
            headingLabel.text = "Skipping Forward"
            bodyTextLabel.text = "You may skip this step though all publishers are required to provide a summary before pubishing episodes on Dune."
            primaryButton.setTitle("Skip", for: .normal)
            primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .changingEmail:
            headingLabel.text = "Change Email"
            bodyTextLabel.text = "Are you sure you would like to change your email address?"
            primaryButton.setTitle("Continue", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .publisherChangingDisplayName:
            headingLabel.text = "Change Display Name"
            bodyTextLabel.text = "Changing your display name will also change the name of your primary program"
            primaryButton.setTitle("Continue", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .changingPassword:
            headingLabel.text = "Change Password"
            bodyTextLabel.text = "Are you sure you would like to change your password?"
            primaryButton.setTitle("Yes please", for: .normal)
            //                      primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .changingUsername:
            headingLabel.text = "Change Username"
            bodyTextLabel.text = "Are you sure you would like to change your username? You may not be able to change it back."
            primaryButton.setTitle("Continue", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .signOutAttempt:
            headingLabel.text = "Sign Out"
            bodyTextLabel.text = "Are you sure you would like to sign out?"
            primaryButton.setTitle("Yes please", for: .normal)
            //                      primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .deleteAccount:
            headingLabel.text = "Delete Account"
            bodyTextLabel.text = "Are you sure you would like to delete your account? It will be permanent."
            primaryButton.setTitle("Continue", for: .normal)
            //                      primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .wrongPasswordForChange:
            headingLabel.text = "Wrong password"
            bodyTextLabel.text = "The password you have entered is incorrect"
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            secondaryButton.setTitle("Reset password", for: .normal)
        //          secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .shortAudioLength:
            headingLabel.text = "Insufficient length"
            bodyTextLabel.text = "Episodes must at least be 10 seconds"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .shortIntroLength:
            headingLabel.text = "Insufficient length"
            bodyTextLabel.text = "Intro recordings must at least be 10 seconds"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .removeIntro:
            headingLabel.text = "Remove intro"
            bodyTextLabel.text = "Are you sure you would like to remove your intro recording?"
            primaryButton.setTitle("Please remove", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .deleteProgram:
            headingLabel.text = "Delete program"
            bodyTextLabel.text = "Are you sure you would like delete this program? You will not be able to get it back."
            primaryButton.setTitle("Delete", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .audioTooLong:
            headingLabel.text = "Audio too long"
            bodyTextLabel.text = "Audio exceeds maximum duration of sixty seconds. Please trim or record another episode."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .notAPublisher:
            headingLabel.text = "Welcome to Dune Studio"
            bodyTextLabel.text = """
            The studio is only made available to publishers.
            
            If you wish to publish content, you can switch to a publisher account in a few simple steps.
            """
            primaryButton.setTitle("Switch account", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .cantFindLargeImage:
            headingLabel.text = "Unsuccessful link"
            bodyTextLabel.text = "Sorry but we were unable to dig up a large image for this link, this will be fixed shortly."
            primaryButton.setTitle("Remove link", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .invalidURL:
            headingLabel.text = "Invalid link"
            bodyTextLabel.text = "Looks like the link you have added is not a valid URL."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        }
    }
    
    func configureViews() {
        let blurredView = UIView()
        blurredView.backgroundColor = .black
        blurredView.alpha = 0.7
       
        self.addSubview(blurredView)
        blurredView.pinEdges(to: self)
        
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant:  -30).isActive = true
        containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30).isActive = true
        
        containerView.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(bodyTextLabel)
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyTextLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20).isActive = true
        bodyTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35).isActive = true
        bodyTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35).isActive = true
        
        containerView.addSubview(primaryButton)
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: 30).isActive = true
        primaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        primaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        primaryButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        containerView.addSubview(secondaryButton)
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 20).isActive = true
        secondaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        secondaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func fitContainerHeight() {

        if secondaryButton.titleLabel?.text == nil {
            containerView.heightAnchor.constraint(equalToConstant: headingLabel.frame.height + bodyTextLabel.frame.height + primaryButton.frame.height + secondaryButton.frame.height + 70).isActive = true
        } else {
            containerView.heightAnchor.constraint(equalToConstant: headingLabel.frame.height + bodyTextLabel.frame.height + primaryButton.frame.height + secondaryButton.frame.height + 120).isActive = true
        }
    }
    
    @objc func primaryButtonPress() {
        alertDelegate?.primaryButtonPress()
        self.removeFromSuperview()
    }
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    @objc func cancelPress() {
        alertDelegate?.cancelButtonPress()
        self.removeFromSuperview()
    }
    
    @objc func skipForward() {
        alertDelegate?.primaryButtonPress()
        self.removeFromSuperview()
    }
    
}
