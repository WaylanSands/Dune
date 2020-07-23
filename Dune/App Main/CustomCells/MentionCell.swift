//
//  MentionCell.swift
//  Dune
//
//  Created by Waylan Sands on 7/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import ActiveLabel

protocol MentionCellDelegate {
    func visitProfile(program: Program)
    func showCommentsFor(episode: Episode)
}

class MentionCell: UITableViewCell {
    
    var mention: Mention!
    var mentionType: MentionType!
    var cellDelegate: MentionCellDelegate!
    var isFetching = false
    
    var profileImageButton: UIButton = {
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
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.seventhShade
        label.numberOfLines = 0
        label.enabledTypes = [.mention, .url]
        label.lineBreakMode = .byWordWrapping
        label.urlMaximumLength = 30
        label.sizeToFit()
        label.handleMentionTap { userHandle in print("\(userHandle) tapped") }
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
    
    let nameStackView: UIStackView = {
       let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 7
        view.alignment = .leading
        return view
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.preservesSuperviewLayoutMargins = false
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.layoutMargins = .zero
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetup(mention: Mention) {
        self.mention = mention
        conFigureMentionType(type: mention.type)
//        usernameLabel.text = mention.publisherUsername
        usernameButton.setTitle(mention.publisherUsername, for: .normal)
        captionLabel.text = mention.caption
        dateLabel.text = mention.timeSince
        
        FileManager.getImageWith(imageID: mention.imageID) { image in
            DispatchQueue.main.async {
                self.profileImageButton.setImage(image, for: .normal)
            }
        }
    }
    
    func conFigureMentionType(type: String) {
        switch type {
        case "commentReply":
            actionButton.setTitle("Reply", for: .normal)
            typeLabel.text = "Replied"
            mentionType = .commentReply
        case "commentTag":
            actionButton.setTitle("Reply", for: .normal)
            typeLabel.text = "Mentioned you"
            mentionType = .commentTag
        case "episodeTag":
            actionButton.setTitle("View", for: .normal)
            typeLabel.text = "Tagged you"
            mentionType = .episodeTag
        default:
            break
        }
    }
    
    func configureViews() {
        self.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14).isActive = true
        profileImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.addSubview(nameStackView)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: -2).isActive = true
        nameStackView.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        nameStackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor).isActive = true
        
        nameStackView.addArrangedSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.heightAnchor.constraint(equalToConstant: usernameButton.titleLabel!.font.lineHeight).isActive = true
        
        nameStackView.addArrangedSubview(typeLabel)
//        typeLabel.translatesAutoresizingMaskIntoConstraints = false
//        typeLabel.topAnchor.constraint(equalTo: nameStackView.topAnchor).isActive = true
        
        self.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: usernameButton.bottomAnchor).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: usernameButton.leadingAnchor).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        self.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 7).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor, constant: 5).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        self.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 20).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor).isActive = true
    }
    
    @objc func actionButtonPress() {
        switch mentionType {
        case .commentReply, .commentTag:
            if !isFetching {
                isFetching = true
                FireStoreManager.getEpisodeWith(episodeID: mention.primaryEpisodeID) { episode in
                    self.cellDelegate.showCommentsFor(episode: episode)
                    self.isFetching = false
                }
            }
        case .episodeTag:
            if !isFetching {
                isFetching = true
                FireStoreManager.fetchAndCreateProgramWith(programID: mention.publisherID) { program in
                    self.cellDelegate.visitProfile(program: program)
                    self.isFetching = false
                }
            }
        default:
            break
        }
    }
    
    @objc func visitProfile() {
        if !isFetching {
            isFetching = true
            FireStoreManager.fetchAndCreateProgramWith(programID: mention.publisherID) { program in
                self.cellDelegate.visitProfile(program: program)
                self.isFetching = false
            }
        }
    }

}
