//
//  InvitePeopleVC.swift
//  Dune
//
//  Created by Waylan Sands on 27/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class InvitePeopleVC: UIViewController {
    
    var mainStackedViewYPosition: CGFloat = 100
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let mainstackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    
    lazy var smsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends via SMS", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.setImage(UIImage(named: "message-friend-icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var emailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends via email", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.setImage(UIImage(named: "email-friend-icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var nativeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends via..", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.setImage(UIImage(named: "native-share-icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends via Facebook", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.setImage(UIImage(named: "facebook-friend-icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    lazy var twitterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Invite friends via Twitter", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.setImage(UIImage(named: "twitter-friend-icon"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        self.title = "Invite Friends"
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
        
        mainstackedView.addArrangedSubview(smsButton)
        smsButton.translatesAutoresizingMaskIntoConstraints = false
        smsButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        mainstackedView.addArrangedSubview(emailButton)
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        emailButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        mainstackedView.addArrangedSubview(nativeButton)
        nativeButton.translatesAutoresizingMaskIntoConstraints = false
        nativeButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        mainstackedView.addArrangedSubview(facebookButton)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        mainstackedView.addArrangedSubview(twitterButton)
        twitterButton.translatesAutoresizingMaskIntoConstraints = false
        twitterButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    }
    
}

