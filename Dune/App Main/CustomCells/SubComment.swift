//
//  SubComment.swift
//  Dune
//
//  Created by Waylan Sands on 2/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SubCommentCell: CommentCell {
    
    override func configureViews() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 60).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: -2).isActive = true
        usernameButton.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        usernameButton.heightAnchor.constraint(equalToConstant: usernameButton.titleLabel!.font.lineHeight).isActive = true
//        usernameButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        
        self.addSubview(activeCommentLabel)
        activeCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        activeCommentLabel.topAnchor.constraint(equalTo: usernameButton.bottomAnchor).isActive = true
        activeCommentLabel.leadingAnchor.constraint(equalTo: usernameButton.leadingAnchor).isActive = true
        activeCommentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        activeCommentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: activeCommentLabel.font!.lineHeight).isActive = true
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: activeCommentLabel.bottomAnchor, constant: 7).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: activeCommentLabel.leadingAnchor, constant: 5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        self.addSubview(voteCountLabel)
        voteCountLabel.translatesAutoresizingMaskIntoConstraints = false
        voteCountLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20).isActive = true
        voteCountLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
        self.addSubview(replyButton)
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.leadingAnchor.constraint(equalTo: voteCountLabel.trailingAnchor, constant: 20).isActive = true
        replyButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
        
        self.addSubview(voteUpButton)
        voteUpButton.translatesAutoresizingMaskIntoConstraints = false
        voteUpButton.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: 5).isActive = true
        voteUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -17).isActive = true
        
        self.addSubview(voteDownButton)
        voteDownButton.translatesAutoresizingMaskIntoConstraints = false
        voteDownButton.bottomAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 30).isActive = true
        voteDownButton.centerXAnchor.constraint(equalTo: voteUpButton.centerXAnchor).isActive = true
        
        self.addSubview(headerBottomLine)
        headerBottomLine.translatesAutoresizingMaskIntoConstraints = false
        headerBottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        headerBottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headerBottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headerBottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
}
