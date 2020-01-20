//
//  OnboardingProgramCell.swift
//  Snippets
//
//  Created by Waylan Sands on 16/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class OnboardingProgramCell: UICollectionViewCell {
    
    var data: CustomCellData? {
        didSet {
            guard let data = data else { return }
            programImage.setImage(data.programImage, for: .normal)
            programLabel.text = data.programName
            userIdLabel.text = data.userId
        }
    }
    
//    fileprivate var programImage: UIImageView = {
//        let programImage = UIImageView()
//        programImage.translatesAutoresizingMaskIntoConstraints = false
//        programImage.contentMode = .scaleAspectFit
//        programImage.contentMode = .top
//        programImage.clipsToBounds = true
//        programImage.layer.cornerRadius = 7
//        return programImage
//    }()
    
        fileprivate var programImage: UIButton = {
            let programImage = UIButton()
            programImage.translatesAutoresizingMaskIntoConstraints = false
            programImage.contentMode = .scaleAspectFit
            programImage.contentMode = .top
            programImage.clipsToBounds = true
            programImage.layer.cornerRadius = 7
            return programImage
        }()
    
    fileprivate var programLabel: UILabel = {
        var programLabel = UILabel()
        programLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        programLabel.textColor = CustomStyle.white
        programLabel.translatesAutoresizingMaskIntoConstraints = false
        return programLabel
    }()
    
    // Change to Subscriber count when numbers are high
    
    fileprivate var userIdLabel: UILabel = {
        let userIdLabel = UILabel()
        userIdLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        userIdLabel.textColor = CustomStyle.fithShade
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        return userIdLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(programImage)
        programImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        programImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        programImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        programImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        programImage.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        contentView.addSubview(programLabel)
        programLabel.topAnchor.constraint(equalTo: programImage.bottomAnchor, constant: 7.0).isActive = true
        programLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        programLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        contentView.addSubview(userIdLabel)
        userIdLabel.topAnchor.constraint(equalTo: programLabel.bottomAnchor, constant: 0.0).isActive = true
        userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
