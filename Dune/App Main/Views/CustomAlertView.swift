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
    case skipAddingListenerImage
    case skipAddingProgramSummary
    case changingUsername
    case programChangingName
    case changingPassword
    case changingEmail
    case signOutAttempt
    case deleteAccount
    case deleteProgram
    case shortAudioLength
    case audioTooLong
    case shortIntroLength
    case removeIntro
    case publisherNotSetUp
    case listenerNotSetUp
    case notAPublisher
    case switchToPublisher
    case cantFindLargeImage
    case invalidURL
    case socialAccountNotFound
    case appleNameFail
    case iOS13Needed
    case userNotFound
    case loggingOut
    case emailInUse
    case nextVersion
    case hashTagUsed
    case linkNotSecure
    case imageNotSupported
    case reportProgram
    case reportEpisode
    case noIntroRecorded
    case removingSubscriber
    case finishSetup
    case boothBackOut
    case uploadIntroOption
}

// For implementation
// UIApplication.shared.windows.last?.addSubview()


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
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        view.alpha = 0
        return view
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        label.textAlignment = .center
        return label
    }()
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.sixthShade
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
        return button
    }()
    
    let secondaryButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 17.5
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
            bodyTextLabel.text = "You may skip this step though all channel's are required to have a unique image before publishing episodes on Dune."
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
        case .programChangingName:
            headingLabel.text = "Change Name"
            bodyTextLabel.text = "Changing this will change the name of your primary channel"
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
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .wrongPasswordForChange:
            headingLabel.text = "Wrong Password"
            bodyTextLabel.text = "The password you have entered is incorrect"
            primaryButton.setTitle("Try again", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            secondaryButton.setTitle("Reset password", for: .normal)
        //          secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .shortAudioLength:
            headingLabel.text = "Insufficient Length"
            bodyTextLabel.text = "Episodes must at least be 10 seconds"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .shortIntroLength:
            headingLabel.text = "Insufficient Length"
            bodyTextLabel.text = "Intro recordings must at least be 10 seconds"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .removeIntro:
            headingLabel.text = "Remove Intro"
            bodyTextLabel.text = "Are you sure you would like to remove your intro recording?"
            primaryButton.setTitle("Please remove", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .deleteProgram:
            headingLabel.text = "Delete Channel"
            bodyTextLabel.text = "Are you sure you would like delete this channel? You will not be able to get it back."
            primaryButton.setTitle("Delete", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .audioTooLong:
            headingLabel.text = "Audio Too Long"
            bodyTextLabel.text = "Audio exceeds maximum duration of 2 minutes. Please trim or record another episode."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .publisherNotSetUp:
            headingLabel.text = "Finish Setup"
            bodyTextLabel.text = "To unlock all Dune features you must complete your account setup."
            primaryButton.setTitle("Complete", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .cantFindLargeImage:
            headingLabel.text = "Unsuccessful Link"
            bodyTextLabel.text = "Sorry but we were unable to dig up a large image for this link, this will be fixed shortly."
            primaryButton.setTitle("Remove link", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .invalidURL:
            headingLabel.text = "Invalid Link"
            bodyTextLabel.text = "Looks like the link you have added is not a valid URL."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .socialAccountNotFound:
            headingLabel.text = "Account Not Found"
            bodyTextLabel.text = "A Dune account with those details does not exist. Would you like to create an account or try again?"
            primaryButton.setTitle("Create account", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Try again", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .appleNameFail:
            headingLabel.text = "Apple ID Issue"
            bodyTextLabel.text = "We are unable to attain your username from Apple. Please signup with your email."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .iOS13Needed:
            headingLabel.text = "Feature Unavailable"
            bodyTextLabel.text = "We apologise, this feature is only available for devices on iOS 13 "
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .userNotFound:
            headingLabel.text = "User Not Found"
            bodyTextLabel.text = "There is no user with this username. They may have changed it or it doesn't exist."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .loggingOut:
            headingLabel.text = "Logging Out"
            bodyTextLabel.text = "Are you sure you would like to log out?"
            primaryButton.setTitle("Log out", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .emailInUse:
            headingLabel.text = "Invalid Email"
            bodyTextLabel.text = "The email address you have entered is already in use"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .nextVersion:
            headingLabel.text = "Withheld Feature"
            bodyTextLabel.text = "This feature is being withheld pending the official Appstore release."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .hashTagUsed:
            headingLabel.text = "Hashtags Not Needed"
            bodyTextLabel.text = "This isn't Instagram, no need for hashtags."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .linkNotSecure:
            headingLabel.text = "Unsecured Link"
            bodyTextLabel.text = "The link you have supplied seems to be unsecure. We recommend using a link which starts in https"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .imageNotSupported:
            headingLabel.text = "Unsupported Image"
            bodyTextLabel.text = "We apologise the image file supplied from the link is not currently supported. This will be corrected in the near future."
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .reportProgram:
            headingLabel.text = "Report Channel"
            bodyTextLabel.text = "If you believe this channel has been acting inappropriately please report."
            primaryButton.setTitle("Report", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .reportEpisode:
            headingLabel.text = "Report Episode"
            bodyTextLabel.text = "If you believe this episode's material is inappropriate please report."
            primaryButton.setTitle("Report", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .noIntroRecorded:
            headingLabel.text = "No Intro Recorded"
            bodyTextLabel.text = "Channel's without a play button below them have not recorded an intro"
            primaryButton.setTitle("Dismiss", for: .normal)
            primaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .removingSubscriber:
            headingLabel.text = "Remove Subscriber"
            bodyTextLabel.text = "This channel will no longer be able to access your content while your channel is set to private."
            primaryButton.setTitle("Remove", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Cancel", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        case .finishSetup:
            headingLabel.text = "Account Options"
            bodyTextLabel.text = """
            You may continue setting up your account as either a listener or a publisher.
            
            You can switch later within the app.
            """
            primaryButton.setTitle("Publisher", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Listener", for: .normal)
            configureSecondaryButtonForPrimaryOption()
        case .listenerNotSetUp:
            headingLabel.text = "Finish Setup"
            bodyTextLabel.text = "To unlock all Dune features you must complete your account setup."
            primaryButton.setTitle("Complete", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .notAPublisher:
            headingLabel.text = "Become A Publisher"
            bodyTextLabel.text = "The studio is only made available to Dune publishers. If you wish to publish content, you can switch to a publisher account & complete your publisher setup."
            primaryButton.setTitle("Switch", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .skipAddingListenerImage:
            headingLabel.text = "Skipping Forward"
            bodyTextLabel.text = "You may skip this step though all accounts's are required to have a unique image before joining in on discussions."
            primaryButton.setTitle("Skip", for: .normal)
            primaryButton.addTarget(self, action: #selector(skipForward), for: .touchUpInside)
            secondaryButton.setTitle("Dismiss", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            case .switchToPublisher:
                headingLabel.text = "Become A Publisher"
                bodyTextLabel.text = """
                Like to publish content on Dune?
                
                Switch to a publisher account & complete your publisher setup.
                """
                primaryButton.setTitle("Switch", for: .normal)
                primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
                secondaryButton.setTitle("Dismiss", for: .normal)
                secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .boothBackOut:
            headingLabel.text = "Leaving Session"
            bodyTextLabel.text = "Your current recording will be lost if you back out of the booth."
            primaryButton.setTitle("Leave", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Stay", for: .normal)
            secondaryButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        case .uploadIntroOption:
            headingLabel.text = "Audio Intro"
            bodyTextLabel.text = "Would you like to record your intro or upload an audio file?"
            primaryButton.setTitle("Upload", for: .normal)
            primaryButton.addTarget(self, action: #selector(primaryButtonPress), for: .touchUpInside)
            secondaryButton.setTitle("Record", for: .normal)
            secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
            configureSecondaryButtonForPrimaryOption()
        }
        bodyTextLabel.addLineSpacing(spacingValue: 3)
    }
    
    func configureSecondaryButtonForPrimaryOption() {
        secondaryButton.backgroundColor = CustomStyle.sixthShade
        secondaryButton.setTitleColor(.white, for: .normal)
        secondaryButton.addTarget(self, action: #selector(cancelPress), for: .touchUpInside)
        secondaryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
        secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 15).isActive = true
        secondaryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        secondaryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        secondaryButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
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
