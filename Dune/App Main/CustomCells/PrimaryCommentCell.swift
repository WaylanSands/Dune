//
//  PrimaryComment.swift
//  Dune
//
//  Created by Waylan Sands on 2/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PrimaryCommentCell: CommentCell {
    
    let replyDashView: UIView = {
       let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
   override func normalSetUp(comment: Comment) {
        self.comment = comment
        self.dateLabel.text = comment.timeSince
        self.usernameLabel.text = comment.username
        self.activeCommentLabel.text = comment.comment
        self.voteCountLabel.text = dynamicVotesTextWith(votes: 0)
        
        FileManager.getImageWith(imageID: comment.profileImageID) { image in
            DispatchQueue.main.async {
                self.profileImageButton.setImage(image, for: .normal)
            }
        }
        checkVoteParticipation()
        configureIfCommentHeading()
        configureViewRepliesText()
    }
    
    func  configureViewRepliesText() {
        var replyPlural: String
        
        if comment.subCommentCount == 1 {
            replyPlural = "Reply"
        } else {
            replyPlural = "Replies"
        }
        replyCountButton.setTitle("View \(comment.subCommentCount) \(replyPlural)", for: .normal)
    }
    
    override func configureViews() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: -2).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        
        self.addSubview(activeCommentLabel)
        activeCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        activeCommentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        activeCommentLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        activeCommentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        activeCommentLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: activeCommentLabel.font!.lineHeight).isActive = true
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: activeCommentLabel.bottomAnchor, constant: 7).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: activeCommentLabel.leadingAnchor, constant: 5).isActive = true
        
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
        voteDownButton.bottomAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 20).isActive = true
        voteDownButton.centerXAnchor.constraint(equalTo: voteUpButton.centerXAnchor).isActive = true
        
        self.addSubview(replyDashView)
        replyDashView.translatesAutoresizingMaskIntoConstraints = false
        replyDashView.leadingAnchor.constraint(equalTo: activeCommentLabel.leadingAnchor).isActive = true
        replyDashView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 25).isActive = true
        replyDashView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        replyDashView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        replyDashView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.addSubview(replyCountButton)
        replyCountButton.translatesAutoresizingMaskIntoConstraints = false
        replyCountButton.centerYAnchor.constraint(equalTo: replyDashView.centerYAnchor).isActive = true
        replyCountButton.leadingAnchor.constraint(equalTo: replyDashView.trailingAnchor, constant: 15).isActive = true
    }
    
    @objc func viewRepliesPress() {
        cellDelegate.fetchSubCommentsFor(comment: comment)
    }
    
    
    
}
