//
//  PublisherNotificationsVC.swift
//  Dune
//
//  Created by Waylan Sands on 12/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PublisherNotificationsVC: UIViewController {
    
    var mainStackedViewYPosition: CGFloat = 100
    
    let mainstackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 40
        return view
    }()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.titleLabel.text = "Publisher Notifications"
        return nav
    }()
    
    // Episode Likes
    
    let epLikesStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let epLikesLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let epLikesLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode Likes"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let epLikesSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let epLikesSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Get notified when a user likes one of your episodes."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let episodeLikesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(episodeLikesToggled), for: .valueChanged)
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // Episode Comments
    
    let epCommentsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let epCommentsLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let epCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode Comments"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let epCommentsSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let epCommentsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Get notified when a user comments on one of your episdoes."
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let episodeCommentsToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(episodeCommentsToggled), for: .valueChanged)
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    // New Subscribers
    
    let newSubsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 20
        return view
    }()
    
    let newSubsLabelsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let newSubsLabel: UILabel = {
        let label = UILabel()
        label.text = "New Subscribers"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let newSubsSubView: UIView = {
        let view = UIView()
        return view
    }()
    
    let newSubsSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Get notified when you receive new subscribers. "
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let newSubscribersToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.addTarget(self, action: #selector(newSubscribersToggled), for: .valueChanged)
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNotificationToggles()
    }
    
    func configureNotificationToggles() {
        if User.didAllowNotifications == nil {
            episodeLikesToggle.isOn = false
            episodeCommentsToggle.isOn = false
            newSubscribersToggle.isOn = false
        } else {
            episodeLikesToggle.isOn = User.didAllowEpisodeLikeNotifications!
            episodeCommentsToggle.isOn = User.didAllowEpisodeCommentNotifications!
            newSubscribersToggle.isOn = User.didAllowNewSubscriptionNotifications!
        }
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhoneSE:
            mainStackedViewYPosition = 100
        case .iPhone8, .iPhone8Plus:
            mainStackedViewYPosition = 100
        case .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            mainStackedViewYPosition = 140
        default:
            mainStackedViewYPosition = 100
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        
        view.addSubview(mainstackedView)
        mainstackedView.translatesAutoresizingMaskIntoConstraints = false
        mainstackedView.topAnchor.constraint(equalTo: view.topAnchor, constant: mainStackedViewYPosition).isActive = true
        mainstackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mainstackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        mainstackedView.addArrangedSubview(epLikesStackedView)
        epLikesStackedView.addArrangedSubview(epLikesLabelsStackedView)
        epLikesStackedView.addArrangedSubview(episodeLikesToggle)
        
        epLikesLabelsStackedView.addArrangedSubview(epLikesLabel)
        epLikesLabelsStackedView.addArrangedSubview(epLikesSubView)
        
        epLikesSubView.addSubview(epLikesSubLabel)
        epLikesSubLabel.translatesAutoresizingMaskIntoConstraints = false
        epLikesSubLabel.leadingAnchor.constraint(equalTo: epLikesSubView.leadingAnchor).isActive = true
        epLikesSubLabel.trailingAnchor.constraint(equalTo: epLikesSubView.trailingAnchor).isActive = true
        epLikesSubLabel.topAnchor.constraint(equalTo: epLikesSubView.topAnchor).isActive = true
        
        // Episode Comments
        
        mainstackedView.addArrangedSubview(epCommentsStackedView)
        epCommentsStackedView.addArrangedSubview(epCommentsLabelsStackedView)
        epCommentsStackedView.addArrangedSubview(episodeCommentsToggle)
        
        epCommentsLabelsStackedView.addArrangedSubview(epCommentsLabel)
        epCommentsLabelsStackedView.addArrangedSubview(epCommentsSubView)
        
        epCommentsSubView.addSubview(epCommentsSubLabel)
        epCommentsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        epCommentsSubLabel.leadingAnchor.constraint(equalTo: epCommentsSubView.leadingAnchor).isActive = true
        epCommentsSubLabel.trailingAnchor.constraint(equalTo: epCommentsSubView.trailingAnchor).isActive = true
        epCommentsSubLabel.topAnchor.constraint(equalTo: epCommentsSubView.topAnchor).isActive = true
        
        // New Subscribers
        
        mainstackedView.addArrangedSubview(newSubsStackedView)
        newSubsStackedView.addArrangedSubview(newSubsLabelsStackedView)
        newSubsStackedView.addArrangedSubview(newSubscribersToggle)
        
        newSubsLabelsStackedView.addArrangedSubview(newSubsLabel)
        newSubsLabelsStackedView.addArrangedSubview(newSubsSubView)
        
        newSubsSubView.addSubview(newSubsSubLabel)
        newSubsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        newSubsSubLabel.leadingAnchor.constraint(equalTo: newSubsSubView.leadingAnchor).isActive = true
        newSubsSubLabel.trailingAnchor.constraint(equalTo: newSubsSubView.trailingAnchor).isActive = true
        newSubsSubLabel.topAnchor.constraint(equalTo: newSubsSubView.topAnchor).isActive = true
    }
    
    @objc func episodeLikesToggled() {
        if FirebaseNotifications.askedPermission {
            FirebaseNotifications.toggle(notification: .episodeLikeNotifications, on: episodeLikesToggle.isOn)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.promptForPushNotifications { granted in
                if granted {
                    self.configureNotificationToggles()
                }
            }
        }
    }
    
    @objc func episodeCommentsToggled() {
        if FirebaseNotifications.askedPermission {
            FirebaseNotifications.toggle(notification: .episodeCommentNotifications, on:  episodeCommentsToggle.isOn)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.promptForPushNotifications { granted in
                if granted {
                    self.configureNotificationToggles()
                }
            }
        }
    }
    
    @objc func newSubscribersToggled() {
        if FirebaseNotifications.askedPermission {
            FirebaseNotifications.toggle(notification: .newSubscriberNotifications, on:  newSubscribersToggle.isOn)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.promptForPushNotifications { granted in
                if granted {
                    self.configureNotificationToggles()
                }
            }
        }
    }
    
}
