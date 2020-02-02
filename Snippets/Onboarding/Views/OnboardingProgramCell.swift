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
            programImageButton.setImage(data.programImage, for: .normal)
            programLabel.text = data.programName
            userIdLabel.text = data.userId
        }
    }
    
    lazy var selectionLayerView: UIImageView = {
       let view = UIImageView()
        view.frame.size = CGSize(width: 95.0, height: 95.0)
        view.image = UIImage(imageLiteralResourceName: "selected-program")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
        lazy var programImageButton: UIButton = {
            let button = UIButton()
            button.contentMode = .scaleAspectFit
            button.clipsToBounds = true
            button.layer.cornerRadius = 7
            button.isEnabled = true
            return button
        }()
    
    fileprivate var programLabel: UILabel = {
        var programLabel = UILabel()
        programLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        programLabel.textColor = CustomStyle.white
        return programLabel
    }()
    
    // Change to Subscriber count when numbers are high
    
    fileprivate var userIdLabel: UILabel = {
        let userIdLabel = UILabel()
        userIdLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        userIdLabel.textColor = CustomStyle.fithShade
        return userIdLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        programImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true
        
//        selectionLayerView.translatesAutoresizingMaskIntoConstraints = false
//        selectionLayerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0).isActive = true
//        selectionLayerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
//        selectionLayerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
//        selectionLayerView.heightAnchor.constraint(equalToConstant: contentView.frame.width).isActive = true

        contentView.addSubview(programLabel)
        programLabel.translatesAutoresizingMaskIntoConstraints = false
        programLabel.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 7.0).isActive = true
        programLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        programLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        programLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        contentView.addSubview(userIdLabel)
        userIdLabel.translatesAutoresizingMaskIntoConstraints = false
        userIdLabel.topAnchor.constraint(equalTo: programLabel.bottomAnchor, constant: 0.0).isActive = true
        userIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        userIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        userIdLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
        @objc func programButtonPress(sender: UIButton) {
         print("Button \(sender.tag) Clicked")
            sender.addSubview(selectionLayerView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
