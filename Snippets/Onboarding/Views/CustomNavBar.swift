//
//  CustomNavBar.swift
//  Snippets
//
//  Created by Waylan Sands on 6/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CustomNavBar: UIView {
    
    // Styling device to device
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()

    var backButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 16.0, y: 45.0, width: 30.0, height: 30.0)
        button.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15.0, bottom: 0, right: 0)
        return button
    }()

    var navBarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .white
        return label
    }()

    var skipButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.textAlignment = .right
        button.tintColor = .white
        return button
    }()

   override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomStyle.onboardingBlack
        self.alpha = 0.95
        setAnchors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnchors() {
        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: dynamicNavbarButtonHeight).isActive = true
        backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(navBarTitleLabel)
        navBarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        navBarTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        navBarTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
        skipButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
