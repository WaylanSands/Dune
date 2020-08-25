//
//  ListenerCell.swift
//  Dune
//
//  Created by Waylan Sands on 30/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//


import UIKit
import ActiveLabel

class ListenerCell: ProgramCell {
        
    let userNotFoundAlert = CustomAlertView(alertType: .userNotFound)
    
    let settingsButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(#imageLiteral(resourceName: "episode-settings") , for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.padding = 10
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
    
    // MARK: Cell setup
    override func normalSetUp(program: Program) {
        self.program = program
        if let imageID = program.imageID {
            FileManager.getImageWith(imageID: imageID) { image in
                DispatchQueue.main.async {
                    self.programImageButton.setImage(image, for: .normal)
                }
            }
        } else {
            self.programImageButton.setImage(#imageLiteral(resourceName: "missing-image-large"), for: .normal)
        }
        
        programImageButton.layer.cornerRadius = imageSize / 2
        
        programNameLabel.text = program.name
        usernameButton.setTitle("@\(program.username)", for: .normal)
        captionTextView.text = program.summary
        
        if program.summary == "" {
             captionTextView.text = "Still getting setup"
        }
                
        DispatchQueue.main.async {
            if self.captionTextView.lineCount() > 3 {
                self.moreButtonGradient.isHidden = false
                self.moreGradientView.isHidden = false
                self.moreButton.isHidden = false
            } else {
                self.moreButtonGradient.isHidden = true
                self.moreGradientView.isHidden = true
                self.moreButton.isHidden = true
            }
        }
    }
    
    override func configureViews() {
        self.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        self.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: -5).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -35).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameStackedView.addArrangedSubview(usernameButton)
        
        self.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor, constant: 0).isActive = true
        settingsButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16).isActive = true
        
        self.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: -5).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        captionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        captionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15.0).isActive = true
        
        addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: captionTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: captionTextView.trailingAnchor, constant: -3).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: captionTextView.font!.lineHeight).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        captionTextView.addSubview(moreGradientView)
        moreGradientView.translatesAutoresizingMaskIntoConstraints = false
        moreGradientView.bottomAnchor.constraint(equalTo: captionTextView.bottomAnchor).isActive = true
        moreGradientView.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor).isActive = true
        moreGradientView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        moreGradientView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        moreButtonGradient.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let whiteColor = UIColor.white
        moreButtonGradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(5.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        
        moreGradientView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
        moreGradientView.layer.insertSublayer(moreButtonGradient, at: 0)
        bringSubviewToFront(moreButton)
    }
    
    @objc override func visitProfile() {
        cellDelegate?.visitProfile(program: program)
    }
    
}


