//
//  EpisodeCellSmlLink.swift
//  Dune
//
//  Created by Waylan Sands on 20/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


class EpisodeCellSmlLink: EpisodeCell {
        
    let linkStackView: UIStackView = {
        let view = UIStackView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let squarePreview = DuneSquareLinkPreview()
   
    
    override func configureViews() {
        self.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: programImageSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: programImageSize).isActive = true
        
        self.addSubview(playbackBarView)
        playbackBarView.translatesAutoresizingMaskIntoConstraints = false
        playbackBarView.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
        playbackBarView.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 10).isActive = true
        playbackBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        playbackBarView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -35).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameStackedView.addArrangedSubview(usernameButton)
        
        self.addSubview(episodeSettingsButton)
        episodeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        episodeSettingsButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor, constant: 0).isActive = true
        episodeSettingsButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16).isActive = true
        
        self.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: -2).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(linkStackView)
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        linkStackView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        linkStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        linkStackView.addArrangedSubview(squarePreview)
        squarePreview.translatesAutoresizingMaskIntoConstraints = false
        squarePreview.leadingAnchor.constraint(equalTo: linkStackView.leadingAnchor).isActive = true
        squarePreview.trailingAnchor.constraint(equalTo: linkStackView.trailingAnchor).isActive = true
        squarePreview.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: linkStackView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -35).isActive = true
        tagContentBottomConstraint = tagScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        tagScrollViewHeightConstraint = tagScrollView.heightAnchor.constraint(equalToConstant: 22)
        tagScrollViewHeightConstraint.isActive = true
        tagContentBottomConstraint.isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        self.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        self.addSubview(timeSinceReleaseLabel)
        timeSinceReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSinceReleaseLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
        timeSinceReleaseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
    }

    
    override func normalSetUp(episode: Episode) {
        includeRichLink()
        setupLikeButtonAndCounterFor(Episode: episode)
        
        FileManager.getImageWith(imageID: episode.imageID) { image in
            DispatchQueue.main.async {
                self.programImageButton.setImage(image, for: .normal)
            }
        }
                
        programNameLabel.text = episode.programName
        usernameButton.setTitle("@\(episode.username)", for: .normal)
        timeSinceReleaseLabel.text = episode.timeSince
        captionTextView.text = episode.caption
        episodeTags = episode.tags!
        
        if episodeTags.count == 0 && episode.likeCount > 10 {
            tagScrollViewHeightConstraint.constant = 0
        }
        
        createTagButtons()
        
        DispatchQueue.main.async {
            self.addGradient()
            if self.captionTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
    }
    
    // MARK: Rich Link
    func includeRichLink() {
        configureRegularPreview { (result) in
            DispatchQueue.main.async {
                if result == true {
                    self.squarePreview.imageButton.setImage(self.richLinkGenerator.squareImage, for: .normal)
                    self.squarePreview.imageButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
                    self.squarePreview.backgroundButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
                    self.squarePreview.squareLabel.text = self.richLinkGenerator.mainTitle
                    self.squarePreview.urlLabel.text = self.richLinkGenerator.canonicalUrl
                }
            }
        }
    }

    func configureRegularPreview(completion: @escaping (Bool) -> ()) {
        swiftLinkPreview.preview(episode.richLink!, onSuccess: { result in
            self.richLinkGenerator = RichLinkGenerator(response: result)
            self.richLinkGenerator.isImageLarge(completion: { result in
                if result != true {
                    completion(true)
                }
            })
        }, onError: { error in
            print("\(error)")
            completion(false)
        })
    }
    
    @objc override func linkTouched() {
        print("link touched")

        guard let url = URL(string: episode.richLink!) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc override func likeButtonPress() {
        guard let indexPath = getIndexPath() else { return }
        var likeCount = episode.likeCount
        
        if likedEpisode == false {
            
            likedEpisode = true
            likeCount += 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "cell-liked-button"), for: .normal)
            likeCountLabel.textColor = CustomStyle.fourthShade
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episode.ID, by: .increase)
            
            episode.likeCount += 1
            cellDelegate?.updateLikeCountFor(episode: episode, at: indexPath)
            
        } else {
            likedEpisode = false
            likeCount -= 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "cell-like-button"), for: .normal)
            likeCountLabel.textColor = CustomStyle.thirdShade
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episode.ID, by: .decrease)
            
            episode.likeCount -= 1
            cellDelegate?.updateLikeCountFor(episode: episode, at: indexPath)
            
            if likeCount == 0 {
                likeCountLabel.text = ""
            }
        }
    }
    
    @objc override func playEpisode() {
        cellDelegate!.playEpisode(cell: self )
    }
    
    @objc override func showSettings() {
        print("Reached")
        cellDelegate!.showSettings(cell: self )
    }
    
    @objc override func visitProfile() {
        
        if User.isPublisher! && CurrentProgram.programsIDs().contains(episode.programID) {
            let tabBar = MainTabController()
            tabBar.selectedIndex = 4
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBar
        } else {
            FireStoreManager.fetchAndCreateProgramWith(programID: episode.programID) { program in
                if program.isPrimaryProgram && program.hasMultiplePrograms! {
                    FireStoreManager.fetchSubProgramsWithIDs(programIDs: program.programIDs!, for: program) {
                        self.cellDelegate!.visitProfile(program: program)
                    }
                } else {
                     self.cellDelegate!.visitProfile(program: program)
                }
            }
        }
    }
    
    
    
}

