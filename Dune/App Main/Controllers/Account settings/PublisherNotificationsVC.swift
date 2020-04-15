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
        label.textColor = CustomStyle.primaryblack
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
    
    let epLikesToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
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
        label.textColor = CustomStyle.primaryblack
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
    
    let epCommentsToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
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
        label.textColor = CustomStyle.primaryblack
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
    
    let newSubsToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = CustomStyle.primaryBlue
        return toggle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        self.title = "Publisher Notifications"
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
        epLikesStackedView.addArrangedSubview(epLikesToggle)
        
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
        epCommentsStackedView.addArrangedSubview(epCommentsToggle)
        
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
        newSubsStackedView.addArrangedSubview(newSubsToggle)
        
        newSubsLabelsStackedView.addArrangedSubview(newSubsLabel)
        newSubsLabelsStackedView.addArrangedSubview(newSubsSubView)
        
        newSubsSubView.addSubview(newSubsSubLabel)
        newSubsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        newSubsSubLabel.leadingAnchor.constraint(equalTo: newSubsSubView.leadingAnchor).isActive = true
        newSubsSubLabel.trailingAnchor.constraint(equalTo: newSubsSubView.trailingAnchor).isActive = true
        newSubsSubLabel.topAnchor.constraint(equalTo: newSubsSubView.topAnchor).isActive = true
        
    }
    
}
