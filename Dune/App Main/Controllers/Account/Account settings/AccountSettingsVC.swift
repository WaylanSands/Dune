//
//  AccountSettingsVC.swift
//  Dune
//
//  Created by Waylan Sands on 24/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MessageUI
import CryptoKit
import FirebaseAuth
import AuthenticationServices

class AccountSettingsVC: UIViewController {
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 980.0)
    lazy var versionNumber = VersionControl.lastetVersion
    
    let logOutAlert = CustomAlertView(alertType: .loggingOut)
    let deleteAccountAlert = CustomAlertView(alertType: .deleteAccount)
    var networkingIndicator = NetworkingProgress()
    
    var logoutPress = false
    var deleteAccountPress = false
    var provider = OAuthProvider(providerID: "twitter.com")
    
    fileprivate var currentNonce: String?
    
    lazy var scrollView: UIView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = self.view.bounds
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame.size = contentViewSize
        return containerView
    }()
    
    let topStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    lazy var inviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Promote Dune", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(presentInvitePeopleVC), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    lazy var helpCentreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Help Centre", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(presentHelpCentreVC), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    lazy var feedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send App Feedback", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    lazy var editAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Account", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(presentEditListenerVC), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    // LineBreak
    
    let lineBreakView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    // Make Private
    
    let privateLabel: UILabel = {
        let label = UILabel()
        label.text = "Private Channel"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let privateSubLabel: UILabel = {
        let label = UILabel()
        label.text = "When active only approved accounts may listen or view your episodes."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var privateChannelToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = CustomStyle.primaryBlue
        toggle.addTarget(self, action: #selector(privateToggled), for: .valueChanged)
        if !CurrentProgram.isPublisher! {
            toggle.isEnabled = false
        }
        return toggle
    }()
    
    // Push Notifications
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Push Notifications"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let notificationsStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        return view
    }()
    
    // New Episodes
    
    let newEpsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let newEpsLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let newEpisodesLabel: UILabel = {
        let label = UILabel()
        label.text = "New Episodes"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let newEpisodesSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let newEpisodesSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Be notified when your subscriptions post new content."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let newEpisodesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // Comment tags or replies
    
    let commentRepliesStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let commentReplyLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let commentReplyLabel: UILabel = {
        let label = UILabel()
        label.text = "Comments tags or replies"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let commentReplySubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let commentReplySubLabel: UILabel = {
        let label = UILabel()
        label.text = "Be notified when you’re mentioned in a comment by tagging or a response."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let commentReplyToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // Episode Mentions
    
    let epMentionStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let epMentionLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let epMentionLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode Mentions"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let epMentionSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let epMentionSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Be notified when you’re tagged in  an episode."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let epMentionToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // Marketing & App updates
    
    let marketingStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let marketingLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let marketingLabel: UILabel = {
        let label = UILabel()
        label.text = "Marketing & App updates"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let marketingSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let marketingSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay in the loop when there are changes in the app."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let marketingToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    //Publisher Notifications
    
    let publisherNotificationsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var publisherNotificationButon: UIButton = {
        let button = UIButton()
        button.setTitle("Publisher Notifications", for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(presentPublisherNotificationsVC), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: view.frame.width - 40, bottom: 0, right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0)
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    // LineBreak
    
    let emailLineBreakView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    // Email Notifications
    
    let emailNotificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Email Notifications"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let emailMarketingStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let emailMarketingLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let emailMarketingLabel: UILabel = {
        let label = UILabel()
        label.text = "Marketing & App updates"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let emailMarketingSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emailMarketingSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Stay in the loop when there are changes in the app."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let emailMarketingToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // Line Break
    
    let bottomLineBreakView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    // Bottom Section
    
    lazy var bottomStackedView: UIStackView = {
        let view = UIStackView()
        view.setCustomSpacing(10.0, after: privateLabel)
        view.setCustomSpacing(20.0, after: privateSubLabel)
        view.axis = .vertical
        view.alignment = .leading
        return view
    }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(logoutButtonPress), for: .touchUpInside)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.addTarget(self, action: #selector(deleteProgram), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version \(versionNumber)"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    // Custom NavBar
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Settings"
        nav.leftButton.isHidden = true
        return nav
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    
    // View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        configureViews()
        deleteAccountAlert.alertDelegate = self
        logOutAlert.alertDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurePrivacyState()
    }
    
    func  configurePrivacyState() {
        switch CurrentProgram.privacyStatus {
        case .madePrivate:
            privateChannelToggle.setOn(true, animated: false)
        case .madePublic:
            privateChannelToggle.setOn(false, animated: false)
        default:
            privateChannelToggle.setOn(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deleteAccountPress = false
        logoutPress = false
    }
    
    func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            contentViewSize = CGSize(width: view.frame.width, height: 1000.0)
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(containerView)
        containerView.backgroundColor = .white
        
        containerView.addSubview(topStackedView)
        topStackedView.translatesAutoresizingMaskIntoConstraints = false
        topStackedView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 35).isActive = true
        topStackedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        topStackedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        
        topStackedView.addArrangedSubview(inviteButton)
        topStackedView.addArrangedSubview(helpCentreButton)
        topStackedView.addArrangedSubview(feedbackButton)
        topStackedView.addArrangedSubview(editAccountButton)
        
        containerView.addSubview(lineBreakView)
        lineBreakView.translatesAutoresizingMaskIntoConstraints = false
        lineBreakView.topAnchor.constraint(equalTo: topStackedView.bottomAnchor, constant: 30.0).isActive = true
        lineBreakView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16.0).isActive = true
        lineBreakView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        lineBreakView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        // Push Notifications
        
        containerView.addSubview(notificationsLabel)
        notificationsLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationsLabel.topAnchor.constraint(equalTo: lineBreakView.bottomAnchor, constant: 30.0).isActive = true
        notificationsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        notificationsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        
        containerView.addSubview(notificationsStackedView)
        notificationsStackedView.translatesAutoresizingMaskIntoConstraints = false
        notificationsStackedView.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 15).isActive = true
        notificationsStackedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        notificationsStackedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        
        // New Episodes
        
        notificationsStackedView.addArrangedSubview(newEpsStackedView)
        newEpsStackedView.addArrangedSubview(newEpsLabelsStackedView)
        newEpsStackedView.addArrangedSubview(newEpisodesToggle)
        
        newEpsLabelsStackedView.addArrangedSubview(newEpisodesLabel)
        newEpsLabelsStackedView.addArrangedSubview(newEpisodesSubView)
        
        newEpisodesSubView.addSubview(newEpisodesSubLabel)
        newEpisodesSubLabel.translatesAutoresizingMaskIntoConstraints = false
        newEpisodesSubLabel.leadingAnchor.constraint(equalTo: newEpisodesSubView.leadingAnchor).isActive = true
        newEpisodesSubLabel.trailingAnchor.constraint(equalTo: newEpisodesSubView.trailingAnchor).isActive = true
        newEpisodesSubLabel.topAnchor.constraint(equalTo: newEpisodesSubView.topAnchor).isActive = true
        
        // Comment tags or replies
        
        notificationsStackedView.addArrangedSubview(commentRepliesStackedView)
        commentRepliesStackedView.addArrangedSubview(commentReplyLabelsStackedView)
        commentRepliesStackedView.addArrangedSubview(commentReplyToggle)
        
        commentReplyLabelsStackedView.addArrangedSubview(commentReplyLabel)
        commentReplyLabelsStackedView.addArrangedSubview(commentReplySubView)
        
        commentReplySubView.addSubview(commentReplySubLabel)
        commentReplySubLabel.translatesAutoresizingMaskIntoConstraints = false
        commentReplySubLabel.leadingAnchor.constraint(equalTo: commentReplySubView.leadingAnchor).isActive = true
        commentReplySubLabel.trailingAnchor.constraint(equalTo: commentReplySubView.trailingAnchor).isActive = true
        commentReplySubLabel.topAnchor.constraint(equalTo: commentReplySubView.topAnchor).isActive = true
        
        // Episode Mentions
        
        notificationsStackedView.addArrangedSubview(epMentionStackedView)
        epMentionStackedView.addArrangedSubview(epMentionLabelsStackedView)
        epMentionStackedView.addArrangedSubview(epMentionToggle)
        
        epMentionLabelsStackedView.addArrangedSubview(epMentionLabel)
        epMentionLabelsStackedView.addArrangedSubview(epMentionSubView)
        
        epMentionSubView.addSubview(epMentionSubLabel)
        epMentionSubLabel.translatesAutoresizingMaskIntoConstraints = false
        epMentionSubLabel.leadingAnchor.constraint(equalTo: epMentionSubView.leadingAnchor).isActive = true
        epMentionSubLabel.trailingAnchor.constraint(equalTo: epMentionSubView.trailingAnchor).isActive = true
        epMentionSubLabel.topAnchor.constraint(equalTo: epMentionSubView.topAnchor).isActive = true
        
        // Marketing & App updates
        
        notificationsStackedView.addArrangedSubview(marketingStackedView)
        marketingStackedView.addArrangedSubview(marketingLabelsStackedView)
        marketingStackedView.addArrangedSubview(marketingToggle)
        
        marketingLabelsStackedView.addArrangedSubview(marketingLabel)
        marketingLabelsStackedView.addArrangedSubview(marketingSubView)
        
        marketingSubView.addSubview(marketingSubLabel)
        marketingSubLabel.translatesAutoresizingMaskIntoConstraints = false
        marketingSubLabel.leadingAnchor.constraint(equalTo: marketingSubView.leadingAnchor).isActive = true
        marketingSubLabel.trailingAnchor.constraint(equalTo: marketingSubView.trailingAnchor).isActive = true
        marketingSubLabel.topAnchor.constraint(equalTo: marketingSubView.topAnchor).isActive = true
        
        // Publisher Notifications
        
        notificationsStackedView.addArrangedSubview(publisherNotificationsStackedView)
        publisherNotificationsStackedView.addArrangedSubview(publisherNotificationButon)
        
        // Line break
        
        containerView.addSubview(emailLineBreakView)
        emailLineBreakView.translatesAutoresizingMaskIntoConstraints = false
        emailLineBreakView.topAnchor.constraint(equalTo: notificationsStackedView.bottomAnchor, constant: 20.0).isActive = true
        emailLineBreakView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 16.0).isActive = true
        emailLineBreakView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        emailLineBreakView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Email Notifications
        
        containerView.addSubview(emailNotificationsLabel)
        emailNotificationsLabel.addTopAndSideAnchors(to: emailLineBreakView, top: 30, leading: 0, trailing: 0)
        
        containerView.addSubview(emailMarketingStackedView)
        emailMarketingStackedView.addTopAndSideAnchors(to: emailNotificationsLabel, top: 15, leading: 0, trailing: 0)
        
        emailMarketingStackedView.addArrangedSubview(emailMarketingLabelsStackedView)
        emailMarketingStackedView.addArrangedSubview(emailMarketingToggle)
        
        emailMarketingLabelsStackedView.addArrangedSubview(emailMarketingLabel)
        emailMarketingLabelsStackedView.addArrangedSubview(emailMarketingSubView)
        
        emailMarketingSubView.addSubview(emailMarketingSubLabel)
        emailMarketingSubLabel.translatesAutoresizingMaskIntoConstraints = false
        emailMarketingSubLabel.leadingAnchor.constraint(equalTo: emailMarketingSubView.leadingAnchor).isActive = true
        emailMarketingSubLabel.trailingAnchor.constraint(equalTo: emailMarketingSubView.trailingAnchor).isActive = true
        emailMarketingSubLabel.topAnchor.constraint(equalTo: emailMarketingSubView.topAnchor).isActive = true
        
        //  Private channel, Log out, Delete Account and Version Number
        
        containerView.addSubview(bottomLineBreakView)
        bottomLineBreakView.addTopAndSideAnchors(to: emailMarketingStackedView, top: 40, leading: 0, trailing: 0)
        bottomLineBreakView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            
        containerView.addSubview(privateLabel)
        privateLabel.translatesAutoresizingMaskIntoConstraints = false
        privateLabel.topAnchor.constraint(equalTo: bottomLineBreakView.bottomAnchor, constant: 20).isActive = true
        privateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        privateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        containerView.addSubview(privateChannelToggle)
        privateChannelToggle.translatesAutoresizingMaskIntoConstraints = false
        privateChannelToggle.centerYAnchor.constraint(equalTo: privateLabel.centerYAnchor, constant: 15).isActive = true
        privateChannelToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        containerView.addSubview(privateSubLabel)
        privateSubLabel.translatesAutoresizingMaskIntoConstraints = false
        privateSubLabel.topAnchor.constraint(equalTo: privateLabel.bottomAnchor, constant: 10).isActive = true
        privateSubLabel.trailingAnchor.constraint(equalTo: privateChannelToggle.leadingAnchor, constant: -30).isActive = true
        privateSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        containerView.addSubview(deleteAccountButton)
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAccountButton.topAnchor.constraint(equalTo: privateSubLabel.bottomAnchor, constant: 20).isActive = true
        deleteAccountButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        deleteAccountButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        containerView.addSubview(logOutButton)
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.topAnchor.constraint(equalTo: deleteAccountButton.bottomAnchor, constant: 20).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        containerView.addSubview(versionLabel)
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 20).isActive = true
        versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func presentInvitePeopleVC() {
        let inviteVC = InvitePeopleVC()
        navigationController?.pushViewController(inviteVC, animated: true)
    }
    
    @objc func presentHelpCentreVC() {
        let helpVC = HelpCentreVC()
        navigationController?.pushViewController(helpVC, animated: true)
    }
    
    @objc func presentEditProgramVC() {
        let editProgramVC = EditProgramVC()
        navigationController?.pushViewController(editProgramVC, animated: true)
    }
    
    @objc func presentPublisherNotificationsVC() {
        let notificationsVC = PublisherNotificationsVC()
        navigationController?.pushViewController(notificationsVC, animated: true)
    }
    
    @objc func presentEditListenerVC() {
        let profileEditVC = EditAccountVC()
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
    
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func privateToggled() {
        switch privateChannelToggle.isOn {
        case true:
            print("was true")
            FireStoreManager.changeChannel(state: .madePrivate)
            CurrentProgram.privacyStatus = .madePrivate
        case false:
            subscribeCurrentInvites()
            FireStoreManager.changeChannel(state: .madePublic)
            FireStoreManager.revertChannelToPublicWith(ID: CurrentProgram.ID!) {
                CurrentProgram.privacyStatus = .madePublic
                CurrentProgram.pendingChannels = []
                CurrentProgram.deniedChannels = []
                print("Success reverting")
            }
        }
    }
    
    func subscribeCurrentInvites() {
        let inviteIDs = CurrentProgram.pendingChannels! + CurrentProgram.deniedChannels!
        for each in inviteIDs {
            CurrentProgram.subscriberIDs!.append(each)
            CurrentProgram.subscriberCount! += 1
        }
    }
    
    @objc func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["waylan@dailyune.com"])
            mail.setMessageBody("<p>Dune Feedback</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Email not configured")
        }
    }
    
    // MARK: Logging out
    @objc func logoutButtonPress() {
        logoutPress = true
        view.addSubview(logOutAlert)
    }
    
    @objc func deleteProgram() {
        deleteAccountPress = true
        view.addSubview(deleteAccountAlert)
    }
}

extension AccountSettingsVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

extension AccountSettingsVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        
        if logoutPress {
            logoutPress = false
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "loggedIn")
                if let signupScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVC") as? SignUpVC {
                    User.signOutUser()
                    CurrentProgram.signOutProgram()
                    navigationController?.pushViewController(signupScreen, animated: false)
                }
            } catch let err {
                print(err)
            }
        } else if deleteAccountPress {
            deleteAccountPress = false
            if let providerData = Auth.auth().currentUser?.providerData {
                for userInfo  in providerData {
                    print(userInfo.providerID)
                    
                    switch userInfo.providerID {
                    case "twitter.com":
                        reAuthenticateTwitterUser()
                    case "apple.com":
                        if #available(iOS 13.0, *) {
                            let nonce = self.randomNonceString()
                            currentNonce = nonce
                            let appleIDProvider = ASAuthorizationAppleIDProvider()
                            let request = appleIDProvider.createRequest()
                            request.requestedOperation = .operationRefresh
                            request.nonce = sha256(nonce)
                            
                            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                            authorizationController.delegate = self
                            authorizationController.presentationContextProvider = self
                            authorizationController.performRequests()
                        }
                    case "password":
                        let deleteAccountVC = DeleteAccount()
                        navigationController?.pushViewController(deleteAccountVC, animated: true)
                    default:
                        break
                    }
                    
                }
            }
        }
    }
    
    func reAuthenticateTwitterUser() {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                print("Error getting Twitter credential \(error!.localizedDescription)")
            } else {
                FireAuthManager.reAuthenticate(credential: credential!) { result in
                    if result == .success {
                        print("Success re-authenticating")
                        self.deleteSocialSignUp()
                    }
                }
            }
        }
    }
    
    func deleteSocialSignUp() {
        self.networkingIndicator.taskLabel.text = "Deleting account data"
        view.addSubview(networkingIndicator)
        FireStoreManager.deleteProgram(with:  CurrentProgram.ID!, introID: CurrentProgram.introID, imageID:  CurrentProgram.imageID, isSubProgram: false) {
            
            Auth.auth().currentUser?.delete(completion: { (error) in
                if error != nil {
                    print("Error deleting user \(error!.localizedDescription)")
                } else {
                    print("Success, user has been deleted")
                    self.networkingIndicator.removeFromSuperview()
                    if let signupScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "signUpVC") as? SignUpVC {
                        User.signOutUser()
                        CurrentProgram.signOutProgram()
                        UserDefaults.standard.set(false, forKey: "loggedIn")
                        self.navigationController?.pushViewController(signupScreen, animated: false)
                    }
                }
            })
        }
    }
    
    func cancelButtonPress() {
        logoutPress = false
        deleteAccountPress = false
    }
  
}

@available(iOS 13.0, *)
extension AccountSettingsVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
   
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            FireAuthManager.reAuthenticate(credential: credential) { result in
                if result == .success {
                    print("Success re-authenticating")
                    self.deleteSocialSignUp()
                }
            }
        }
    }
    
    @available(iOS 13, *)
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
