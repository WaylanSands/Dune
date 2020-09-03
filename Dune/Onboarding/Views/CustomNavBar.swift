//
//  CustomNavBar.swift
//  Snippets
//
//  Created by Waylan Sands on 6/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


class CustomNavBar: PassThoughView {
    
    // Styling device to device
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()

    var leftButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 16.0, y: 45.0, width: 30.0, height: 30.0)
        button.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15.0, bottom: 0, right: 0)
        return button
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .white
        return label
    }()

    var rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.textAlignment = .right
        button.tintColor = .white
        return button
    }()

   override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomStyle.onBoardingBlack.withAlphaComponent(0.95)
        setAnchors()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnchors() {
        self.addSubview(leftButton)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: dynamicNavbarButtonHeight).isActive = true
        leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        leftButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor, constant: 2).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(rightButton)
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor, constant: 2).isActive = true
        rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    
    func pinNavBarTo(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight()).isActive = true
    }
}

