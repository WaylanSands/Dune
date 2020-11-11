//
//  SelectInterestView.swift
//  Dune
//
//  Created by Waylan Sands on 15/8/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SelectInterestView: UIView {
        
    var headingYConstant: CGFloat = 260.0
    var nextButtonDelegate: NextButtonDelegate!
    let defaultSubHeadingText = "Discover relevant content."
    
    lazy var dateTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "")
    
    let headingLabel: UILabel =  {
        let label = UILabel()
        label.text = "Select categories that interest you"
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var subHeadingLabel: UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.subTextColor
        label.text = defaultSubHeadingText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        styleForScreens()
        setupView()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingYConstant = 95.0
        case .iPhone8:
            headingYConstant = 145.0
        case .iPhone8Plus:
            headingYConstant = 180.0
        case .iPhone11:
            break
        case .iPhone11Pro, .iPhone12:
              headingYConstant = 220.0
        case .iPhone11ProMax, .iPhone12ProMax:
            break
        case .unknown:
            break
        }
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(headingLabel)
        headingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        headingLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: headingYConstant).isActive = true
        
        addSubview(subHeadingLabel)
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0).isActive = true
        subHeadingLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        subHeadingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        
    }
}

