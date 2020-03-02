//
//  PlayBar.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class PlayBar: UIView {
    
    var episodeImage: UIImage
    var programName: String
    var handel: String
    var likesOverTen: Bool
    var likes: Int
    var listens: Int
    var commentCount: Int
    var saveCount: Int
    var shareLink: String
    
    lazy var smallProfileImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = episodeImage
        return imageView
    }()
    
    lazy var programNameLabel: UILabel = {
        let label = UILabel()
        label.text = programName
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    lazy var handelLabel: UILabel = {
        let label = UILabel()
        label.text = handel
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.2
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = CustomStyle.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
//        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        return button
    }()
    
    
    init(episode: Episode) {
        self.episodeImage = episode.smallProgramImage
        self.programName = episode.programName
        self.handel = episode.accountHandel
        self.likesOverTen = episode.likesOverTen
        self.likes = episode.likes
        self.listens = episode.listens + 1
        self.commentCount = episode.commentCount
        self.saveCount = episode.saveCount
        self.shareLink = episode.shareLink
        super.init(frame: CGRect.zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        self.addSubview(smallProfileImage)
        smallProfileImage.translatesAutoresizingMaskIntoConstraints = false
        smallProfileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        smallProfileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        smallProfileImage.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        smallProfileImage.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.addSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0).isActive = true
        programNameLabel.leadingAnchor.constraint(equalTo: smallProfileImage.trailingAnchor, constant: 10.0).isActive = true
        programNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.addSubview(handelLabel)
        handelLabel.translatesAutoresizingMaskIntoConstraints = false
        handelLabel.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor).isActive = true
        handelLabel.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor).isActive = true
        handelLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        self.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
    }
    
    
}
