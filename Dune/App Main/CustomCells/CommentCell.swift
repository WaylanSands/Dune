//
//  CommentCell.swift
//  Dune
//
//  Created by Waylan Sands on 30/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import ActiveLabel

protocol CommentCellDelegate {
    func updateTableView()
//    func visitProgramWith(programID: String)
    func updateCommentTextFieldWithReply(comment: Comment)
    func fetchSubCommentsFor(comment: Comment)
    func visitProfile(program: Program)
}

class CommentCell: UITableViewCell {
    
    var comment: Comment!
    var userUpVoted = false
    var userDownVoted = false
    var voteDisplayCount: Int = 0
    var cellDelegate: CommentCellDelegate!
    var isFetching = false
    
    let userNotFoundAlert = CustomAlertView(alertType: .userNotFound)
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        return button
    }()
    
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        label.textColor = CustomStyle.primaryBlack
//        return label
//    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        return button
    }()
    
    lazy var activeCommentLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.seventhShade
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .url]
        label.lineBreakMode = .byWordWrapping
        label.urlMaximumLength = 30
        label.sizeToFit()
        label.handleMentionTap { username in
            if !self.isFetching {
                self.isFetching = true
                FireStoreManager.getProgramWith(username: username) { program in
                    self.isFetching = false
                    if program != nil {
                        self.cellDelegate?.visitProfile(program: program!)
                    } else {
                        print("User does not exist")
                        UIApplication.shared.windows.last?.addSubview(self.userNotFoundAlert)
                    }
                }
            }
        }
        label.mentionColor = CustomStyle.linkBlue
        label.enabledTypes = [.mention, .url]
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let replyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reply", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    let replyCountButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    let voteUpButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "voteUp-arrow"), for: .normal)
        button.padding = 10
        return button
    }()
    
    let voteDownButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "voteDown-arrow"), for: .normal)
        button.padding = 10
        return button
    }()
    
    let voteCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let headerBottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.fourthShade
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.preservesSuperviewLayoutMargins = false
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.layoutMargins = .zero
        styleForScreens()
        configureViews()
    }
    
    override func prepareForReuse() {
        
    }
    
    func normalSetUp(comment: Comment) {
        self.comment = comment
        self.dateLabel.text = comment.timeSince
//        self.usernameLabel.text = comment.username
        self.usernameButton.setTitle(comment.username, for: .normal)
        self.activeCommentLabel.text = comment.comment
        self.voteCountLabel.text = dynamicVotesTextWith(votes: 0)
        
        FileManager.getImageWith(imageID: comment.profileImageID) { image in
            DispatchQueue.main.async {
                self.profileImageButton.setImage(image, for: .normal)
            }
        }
        
        checkVoteParticipation()
        configureIfCommentHeading()
    }
    
    func styleForScreens() {
        
    }
    
    func dynamicVotesTextWith(votes: Int) -> String {
        var votePlural: String
        let voteCount = comment.voteCount + votes
        
        if voteCount == 1 || voteCount == -1 {
            votePlural = "Vote"
        } else {
            votePlural = "Votes"
        }
        
        return "\(voteCount.roundedWithAbbreviations) \(votePlural)"
    }
    
    func checkVoteParticipation() {
        voteDownButton.setImage(UIImage(named: "voteDown-arrow"), for: .normal)
        voteUpButton.setImage(UIImage(named: "voteUp-arrow"), for: .normal)
        userDownVoted = false
        userUpVoted = false
        
        if User.upVotedComments != nil {
            if User.upVotedComments!.contains(comment.ID) {
                voteUpButton.setImage(UIImage(named: "votedUp-arrow"), for: .normal)
                userUpVoted = true
            }
        }

        if User.downVotedComments != nil {
            if User.downVotedComments!.contains(comment.ID) {
                voteDownButton.setImage(UIImage(named: "votedDown-arrow"), for: .normal)
                userDownVoted = true
            }
        }
        
        if !userUpVoted && !userDownVoted {
            voteCountLabel.textColor = CustomStyle.fourthShade
            voteDownButton.setImage(UIImage(named: "voteDown-arrow"), for: .normal)
            voteUpButton.setImage(UIImage(named: "voteUp-arrow"), for: .normal)
        }
    }
    
    func configureIfCommentHeading() {
        if comment.isTableViewHeader {
            headerBottomLine.isHidden = false
            voteDownButton.isHidden = true
            voteCountLabel.isHidden = true
            voteUpButton.isHidden = true
            replyButton.isHidden = true
        } else {
            headerBottomLine.isHidden = true
            voteDownButton.isHidden = false
            voteCountLabel.isHidden = false
            voteUpButton.isHidden = false
            replyButton.isHidden = false
        }
    }
    
    func configureViews() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: -2).isActive = true
        usernameButton.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        usernameButton.heightAnchor.constraint(equalToConstant: usernameButton.titleLabel!.font.lineHeight).isActive = true
        
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
        voteDownButton.bottomAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 20).isActive = true
        voteDownButton.centerXAnchor.constraint(equalTo: voteUpButton.centerXAnchor).isActive = true
        
        self.addSubview(headerBottomLine)
        headerBottomLine.translatesAutoresizingMaskIntoConstraints = false
        headerBottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        headerBottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headerBottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        headerBottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    @objc func voteUpPress() {
        if voteUpButton.imageView?.image == UIImage(named: "votedUp-arrow") {
            FireBaseComments.removeUpVoted(comment: comment)
            voteUpButton.setImage(UIImage(named: "voteUp-arrow"), for: .normal)
            if userUpVoted {
               voteCountLabel.text = dynamicVotesTextWith(votes: -1)
                userUpVoted = false
            } else {
                voteCountLabel.text = dynamicVotesTextWith(votes: 0)
            }
        } else {
            if voteDownButton.imageView?.image == UIImage(named: "votedDown-arrow") {
                FireBaseComments.upVote(comment: comment, by: 2)
            } else {
                FireBaseComments.upVote(comment: comment, by: 1)
                if !CurrentProgram.repMethods!.contains(comment.ID) {
                    FireStoreManager.updateProgramRep(programID: comment.programID, repMethod: comment.ID, rep: 6)
                    FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: comment.ID)
                    CurrentProgram.repMethods?.append(comment.ID)
                }
            }
            if userDownVoted {
               voteCountLabel.text = dynamicVotesTextWith(votes: 2)
            } else {
                voteCountLabel.text = dynamicVotesTextWith(votes: 1)
            }
            voteUpButton.setImage(UIImage(named: "votedUp-arrow"), for: .normal)
            voteDownButton.setImage(UIImage(named: "voteDown-arrow"), for: .normal)
        }
    }
    
    @objc func voteDownPress() {
        if voteDownButton.imageView?.image == UIImage(named: "votedDown-arrow") {
            FireBaseComments.removeDownVoted(comment: comment)
            voteDownButton.setImage(UIImage(named: "voteDown-arrow"), for: .normal)
            if userDownVoted{
               voteCountLabel.text = dynamicVotesTextWith(votes: 1)
               userDownVoted = false
            } else {
                voteCountLabel.text = dynamicVotesTextWith(votes: 0)
            }
        } else {
            if voteUpButton.imageView?.image == UIImage(named: "votedUp-arrow") {
                FireBaseComments.downVote(comment: comment, by: -2)
            } else {
                FireBaseComments.downVote(comment: comment, by: -1)
                if !CurrentProgram.repMethods!.contains(comment.ID) {
                    FireStoreManager.updateProgramRep(programID: comment.programID, repMethod: comment.ID, rep: -4)
                    FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: comment.ID)
                    CurrentProgram.repMethods?.append(comment.ID)
                }
            }
            if userUpVoted {
               voteCountLabel.text = dynamicVotesTextWith(votes: -2)
            } else {
                voteCountLabel.text = dynamicVotesTextWith(votes: -1)
            }
            voteUpButton.setImage(UIImage(named: "voteUp-arrow"), for: .normal)
            voteDownButton.setImage(UIImage(named: "votedDown-arrow"), for: .normal)
        }
    }
    
    @objc func replyPress() {
        cellDelegate.updateCommentTextFieldWithReply(comment: comment)
    }
    
    @objc func visitCommenter() {
        if !isFetching {
            isFetching = true
            FireStoreManager.fetchAndCreateProgramWith(programID: comment.programID) { program in
                self.cellDelegate.visitProfile(program: program)
                self.isFetching = false
            }
        }
    }
   
}
