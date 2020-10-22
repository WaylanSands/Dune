//
//  RequestedInviteCell.swift
//  Dune
//
//  Created by Waylan Sands on 22/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol InviteCellDelegate {
    func approveRequestFor(_ ID: String)
    func returnAllowedFor(_ ID: String)
    func returnRemovedFor(_ ID: String)
    func denyRequestFor(_ ID: String)
}

class PendingInviteCell: UITableViewCell {
    
    var channel: Program!
    var inviteCellDelegate: InviteCellDelegate!
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        return button
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        return button
    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let allowButton: UIButton = {
        let button = UIButton()
        button.setTitle("Allow", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.backgroundColor = CustomStyle.primaryYellow
        button.layer.cornerRadius = 13
        return button
    }()
    
    let removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 13
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layer.rasterizationScale = UIScreen.main.scale
        self.preservesSuperviewLayoutMargins = false
        self.layer.shouldRasterize = true
        self.selectionStyle = .none
        self.separatorInset = .zero
        self.layoutMargins = .zero
        styleForScreens()
        configureViews()
    }
    
    func styleForScreens() {
        
    }
    
    func setupCellWith(channel: Program) {
        self.channel = channel
        usernameButton.setTitle(channel.username, for: .normal)
        displayNameLabel.text = channel.name
        
        if let imageID = channel.imageID {
            FileManager.getImageWith(imageID: imageID) { image in
                DispatchQueue.main.async {
                    self.profileImageButton.setImage(image, for: .normal)
                }
            }
        } else {
            profileImageButton.setImage(channel.image, for: .normal)
        }
        
    }
    
    func configureViews() {
        contentView.addSubview(profileImageButton)
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14).isActive = true
        profileImageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        contentView.addSubview(allowButton)
        allowButton.translatesAutoresizingMaskIntoConstraints = false
        allowButton.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor).isActive = true
        allowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        allowButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        contentView.addSubview(removeButton)
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor).isActive = true
        removeButton.trailingAnchor.constraint(equalTo: allowButton.leadingAnchor, constant: -16).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        contentView.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.topAnchor.constraint(equalTo: profileImageButton.topAnchor, constant: 5).isActive = true
        usernameButton.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        usernameButton.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -10).isActive = true
        usernameButton.heightAnchor.constraint(equalToConstant: usernameButton.titleLabel!.font.lineHeight).isActive = true
        
        contentView.addSubview(displayNameLabel)
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        displayNameLabel.topAnchor.constraint(equalTo: usernameButton.bottomAnchor, constant: 2).isActive = true
        displayNameLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 7).isActive = true
        displayNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -10).isActive = true
        displayNameLabel.heightAnchor.constraint(equalToConstant: usernameButton.titleLabel!.font.lineHeight).isActive = true
    }

    @objc func allowPress() {
        if allowButton.titleLabel?.text == "Allow" && removeButton.titleLabel?.text == "Remove" {
            allowButton.setTitle("Allowed", for: .normal)
            removeButton.setTitle("Remove", for: .normal)
            inviteCellDelegate.approveRequestFor(channel.ID)
        } else if allowButton.titleLabel?.text == "Allow" && removeButton.titleLabel?.text == "Removed" {
            removeButton.setTitle("Remove", for: .normal)
            allowButton.setTitle("Allowed", for: .normal)
            inviteCellDelegate.approveRequestFor(channel.ID)
            inviteCellDelegate.returnRemovedFor(channel.ID)
        } else if allowButton.titleLabel?.text == "Allowed" && removeButton.titleLabel?.text == "Remove" {
            allowButton.setTitle("Allow", for: .normal)
            inviteCellDelegate.returnAllowedFor(channel.ID)
        }
    }
    
    @objc func removePress() {
        if removeButton.titleLabel?.text == "Remove" && allowButton.titleLabel?.text == "Allow" {
            removeButton.setTitle("Removed", for: .normal)
            allowButton.setTitle("Allow", for: .normal)
            inviteCellDelegate.denyRequestFor(channel.ID)
        } else if removeButton.titleLabel?.text == "Remove" && allowButton.titleLabel?.text == "Allowed" {
            removeButton.setTitle("Removed", for: .normal)
            allowButton.setTitle("Allow", for: .normal)
            inviteCellDelegate.returnAllowedFor(channel.ID)
            inviteCellDelegate.denyRequestFor(channel.ID)
        } else if removeButton.titleLabel?.text == "Removed" && allowButton.titleLabel?.text == "Allow" {
            removeButton.setTitle("Remove", for: .normal)
            inviteCellDelegate.returnRemovedFor(channel.ID)
        }
    }

}
