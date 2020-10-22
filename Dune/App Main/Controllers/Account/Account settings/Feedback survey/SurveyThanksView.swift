//
//  SurveyThanksView.swift
//  Dune
//
//  Created by Waylan Sands on 15/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SurveyThanksView: UIView {
    
    var sendSMS: (()-> Void)!
    
    let mainHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Thank you"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = CustomStyle.white
        label.textAlignment = .center
        return label
    }()
    
    let subHeadingLabel: UILabel = {
        let label = UILabel()
        label.text = """
        You have been rewarded
        for your contribution
        """
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = CustomStyle.white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let credLabel: UILabel = {
        let label = UILabel()
        label.text = "+75 Dune Cred"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = CustomStyle.primaryYellow
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let copyShareLink: UIButton = {
        let button = UIButton()
        button.setTitle("Copy Dune share link", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.backgroundColor = .white
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(copyShareLinkPress), for: .touchUpInside)
        //        button.layer.borderWidth = 1
        //        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    let smsShareLink: UIButton = {
        let button = UIButton()
        button.setTitle("Share Dune via SMS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.backgroundColor = CustomStyle.buttonBlue
        button.addTarget(self, action: #selector(sendLinkViaSMS), for: .touchUpInside)

        button.layer.cornerRadius = 17
        //        button.layer.borderWidth = 1
        //        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.95)
        //        styleForScreens()
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureView() {
        self.addSubview(mainHeadingLabel)
        mainHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        mainHeadingLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -120).isActive = true
        mainHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(subHeadingLabel)
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.topAnchor.constraint(equalTo: mainHeadingLabel.bottomAnchor, constant: 20).isActive = true
        subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(credLabel)
        credLabel.translatesAutoresizingMaskIntoConstraints = false
        credLabel.topAnchor.constraint(equalTo: subHeadingLabel.bottomAnchor, constant: 20).isActive = true
        credLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        self.addSubview(smsShareLink)
        smsShareLink.translatesAutoresizingMaskIntoConstraints = false
        smsShareLink.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60).isActive = true
        smsShareLink.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        smsShareLink.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        smsShareLink.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        self.addSubview(copyShareLink)
        copyShareLink.translatesAutoresizingMaskIntoConstraints = false
        copyShareLink.bottomAnchor.constraint(equalTo: smsShareLink.topAnchor, constant: -20).isActive = true
        copyShareLink.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        copyShareLink.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        copyShareLink.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
    }
    
    @objc func copyShareLinkPress() {
        copyShareLink.setTitle("Link copied", for: .normal)
        UIPasteboard.general.string = "www.dailyune.com"
    }
    
    @objc func sendLinkViaSMS() {
        sendSMS()
    }
    
}
