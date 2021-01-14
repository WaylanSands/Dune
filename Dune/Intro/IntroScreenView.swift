//
//  IntroScreenView.swift
//  Dune
//
//  Created by Waylan Sands on 2/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class IntroScreenView: UIView {
    private var image: UIImage
    private var heading: String
    private var subHeading: String
    
    // For various device sizes
    private var contentHeight: CGFloat = -170
    private var imageHeight: CGFloat = -50
    private var paddingLeft: CGFloat  = 0
    private var paddingRight: CGFloat  = 0
    private var headingSize: CGFloat = 26
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var headingLabel: UILabel = {
      let label = UILabel()
        label.text = heading
        label.font = UIFont.systemFont(ofSize: headingSize, weight: .bold)
        label.textColor = .white
        label.addCharacterSpacing(kernValue: -0.2)
        return label
    }()
    
    private lazy var subHeadingLabel: UILabel = {
      let label = UILabel()
        label.text = subHeading
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    required init(image: UIImage, heading: String, subHeading: String) {
        self.image = image
        self.heading = heading
        self.subHeading = subHeading
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
        styleForScreens()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
           contentHeight = -120
           imageHeight = -40
            paddingLeft = 20
            paddingRight = -20
            headingSize = 24
        case .iPhone8:
            contentHeight = -135
            imageHeight = -50
            paddingLeft = 20
            paddingRight = -20
        case .iPhone8Plus:
            contentHeight = -135
            imageHeight = -50
            paddingLeft = 20
            paddingRight = -20
        case .iPhone11:
            break
        case .iPhone11Pro, .iPhone12:
            paddingLeft = 10
            paddingRight = -10
        case .iPhone11ProMax, .iPhone12ProMax:
            break
        case .unknown:
            break
        }
    }
    
    private func configureViews() {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: imageHeight).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingLeft).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: paddingRight).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 440).isActive = true
        
        self.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        headingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: contentHeight).isActive = true
        
        self.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 7).isActive = true
    }
}

