//
//  AccountSettingsVC.swift
//  Dune
//
//  Created by Waylan Sands on 24/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AccountSettingsVC: UIViewController {
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 1010.0)
    lazy var versionNumber = VersionControl.lastetVersion
    
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
        view.spacing = 15
        return view
    }()
    
    let inviteStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    let helpStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    let feedbackStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    let accountDetailsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        return view
    }()
    
    let inviteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite People", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    let inviteButonArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    let helpCentreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Help Centre", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    let helpCentreButtonArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    let feedbackButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send App Feedback", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    let feedbackButonArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    let AccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Account Details", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    let AccountButonArrow: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "selection-arrow"), for: .normal)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // LineBreak
    
    let lineBreakView: UIView = {
       let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    // Push Notifications
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Push Notifications"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryblack
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryblack
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryblack
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryblack
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryblack
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
    
    let publisherNotificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Publisher Notifications"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = CustomStyle.primaryblack
        return label
    }()
    
    let publisherNotificationButon: UIButton = {
        let button = UIButton()
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
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryblack
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryblack
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
    
    let bottomStackedView: UIStackView = {
          let view = UIStackView()
          view.spacing = 15
          view.axis = .vertical
        view.alignment = .leading
          return view
      }()
    
    let logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        return button
    }()
    
    lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Version \(versionNumber)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    
    // Custom NavBar
    
    let navBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        nav.titleLabel.text = "Settings"
        nav.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return nav
    }()
    
     // View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureViews()
    }
    
    func configureViews() {
        view.addSubview(navBar)
        navBar.pinNavBarTo(view)
        
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(containerView)
        scrollView.pinEdges(to: scrollView)
        containerView.backgroundColor = .white
        
        containerView.addSubview(topStackedView)
        topStackedView.translatesAutoresizingMaskIntoConstraints = false
        topStackedView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 90).isActive = true
        topStackedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        topStackedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        
        topStackedView.addArrangedSubview(inviteStackedView)
        inviteStackedView.addArrangedSubview(inviteButton)
        inviteStackedView.addArrangedSubview(inviteButonArrow)
        
        topStackedView.addArrangedSubview(helpStackedView)
        helpStackedView.addArrangedSubview(helpCentreButton)
        helpStackedView.addArrangedSubview(helpCentreButtonArrow)
        
        topStackedView.addArrangedSubview(feedbackStackedView)
        feedbackStackedView.addArrangedSubview(feedbackButton)
        feedbackStackedView.addArrangedSubview(feedbackButonArrow)
        
        topStackedView.addArrangedSubview(accountDetailsStackedView)
        accountDetailsStackedView.addArrangedSubview(AccountButton)
        accountDetailsStackedView.addArrangedSubview(AccountButonArrow)
        
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
        notificationsStackedView.topAnchor.constraint(equalTo: notificationsLabel.topAnchor, constant: 50).isActive = true
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
        publisherNotificationsStackedView.addArrangedSubview(publisherNotificationLabel)
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
        emailNotificationsLabel.addTopAndSideAnchors(to: emailLineBreakView, top: 20, leading: 0, trailing: 0)

        containerView.addSubview(emailMarketingStackedView)
        emailMarketingStackedView.addTopAndSideAnchors(to: emailNotificationsLabel, top: 20, leading: 0, trailing: 0)

        emailMarketingStackedView.addArrangedSubview(emailMarketingLabelsStackedView)
        emailMarketingStackedView.addArrangedSubview(emailMarketingToggle)
        
        emailMarketingLabelsStackedView.addArrangedSubview(emailMarketingLabel)
        emailMarketingLabelsStackedView.addArrangedSubview(emailMarketingSubView)
        
        emailMarketingSubView.addSubview(emailMarketingSubLabel)
        emailMarketingSubLabel.translatesAutoresizingMaskIntoConstraints = false
        emailMarketingSubLabel.leadingAnchor.constraint(equalTo: emailMarketingSubView.leadingAnchor).isActive = true
        emailMarketingSubLabel.trailingAnchor.constraint(equalTo: emailMarketingSubView.trailingAnchor).isActive = true
        emailMarketingSubLabel.topAnchor.constraint(equalTo: emailMarketingSubView.topAnchor).isActive = true
        
        // Log out, Delete Account & Version Number
        
        containerView.addSubview(bottomLineBreakView)
        bottomLineBreakView.addTopAndSideAnchors(to: emailMarketingStackedView, top: 40, leading: 0, trailing: 0)
        bottomLineBreakView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        
        containerView.addSubview(bottomStackedView)
        bottomStackedView.addTopAndSideAnchors(to: bottomLineBreakView, top: 20, leading: 0, trailing: 0)

        bottomStackedView.addArrangedSubview(logOutButton)
        bottomStackedView.addArrangedSubview(deleteAccountButton)
        bottomStackedView.addArrangedSubview(versionLabel)
        

        view.bringSubviewToFront(navBar)
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
}


