//
//  CommentTextView.swift
//  Dune
//
//  Created by Waylan Sands on 30/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol commentTextViewDelegate {
    func append(comment: Comment, primaryID: String?)
    func reloadTableView()
    func dismissKeyBoard()
}

class CommentTextView: UIStackView {
    
    var isReply = false
    var episodeID: String!
    var commentID: String?
    var placeholderIsActive = true
    var commentDelegate: commentTextViewDelegate!
    var viewHeightConstraint: NSLayoutConstraint!

    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4
        view.layer.rasterizationScale = UIScreen.main.scale
        view.layer.shouldRasterize = true
        return view
    }()
    
    let dropKeyboardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dropKeyboard-arrow"), for: .normal)
        button.addTarget(self, action: #selector(dropKeyboardPress), for: .touchUpInside)
        return button
    }()
    
    let postButton: UIButton = {
       let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.addTarget(self, action: #selector(postButtonPress), for: .touchUpInside)
        return button
    }()
    
    let commentView: UITextView = {
       let view = UITextView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 7
        view.textContainer.maximumNumberOfLines = 7
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 5, right: 55)
        view.textColor = CustomStyle.primaryBlack
        view.isScrollEnabled = false
        view.keyboardType = .twitter
        view.keyboardAppearance = .light
        view.tintColor = CustomStyle.primaryBlue
        view.autocorrectionType = .no
        return view
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Leave a comment..."
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        self.addSubview(backgroundView)
        backgroundView.pinEdges(to: self)
        
        self.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        commentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        commentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -7).isActive = true
        commentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        commentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 34).isActive = true
        
        self.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 18).isActive = true
        placeholderLabel.centerYAnchor.constraint(equalTo: commentView.centerYAnchor).isActive = true
        
        self.addSubview(dropKeyboardButton)
        dropKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        dropKeyboardButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        dropKeyboardButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
        dropKeyboardButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dropKeyboardButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(postButton)
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -15).isActive = true
        postButton.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: -3).isActive = true
    }
    
    @objc func postButtonPress() {
        if !commentView.text.isEmpty && !isReply {
            postButton.setTitle("Posting...", for: .normal)
            FireBaseComments.postCommentForEpisode(ID: episodeID, comment: commentView.text.trimmingTrailingSpaces) { comment in
                self.commentDelegate.append(comment: comment, primaryID: nil)
                self.postButton.setTitle("Post", for: .normal)
                self.commentView.text = ""
            }
        } else if !commentView.text.isEmpty && isReply {
            postButton.setTitle("Posting...", for: .normal)
            FireBaseComments.postCommentReplyForEpisode(ID: episodeID, primaryID: commentID!, comment: commentView.text.trimmingTrailingSpaces) { comment in
                self.commentDelegate.append(comment: comment, primaryID: comment.primaryID)
                self.postButton.setTitle("Post", for: .normal)
                self.commentView.text = ""
            }
        }
        commentView.textColor = CustomStyle.primaryBlack
        isReply = false
    }
    
    @objc func dropKeyboardPress() {
        commentDelegate.dismissKeyBoard()
        commentView.resignFirstResponder()
    }

}
