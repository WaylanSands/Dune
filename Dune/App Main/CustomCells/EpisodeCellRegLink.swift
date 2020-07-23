//
//  EpisodeCellRegLink.swift
//  Dune
//
//  Created by Waylan Sands on 20/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import WebKit

class EpisodeCellRegLink: EpisodeCell {
    
    let regularPreview = DuneLinkPreview()
    
    let linkStackView: UIStackView = {
        let view = UIStackView()
        view.contentMode = .scaleToFill
        return view
    }()
   
    override func configureViews() {
        self.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        self.addSubview(playbackBarView)
        playbackBarView.translatesAutoresizingMaskIntoConstraints = false
        playbackBarView.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
        playbackBarView.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 10).isActive = true
        playbackBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        playbackBarView.widthAnchor.constraint(equalToConstant: playBarWidth).isActive = true
        
        self.addSubview(playEpisodeButton)
        playEpisodeButton.translatesAutoresizingMaskIntoConstraints = false
        playEpisodeButton.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
        playEpisodeButton.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 3).isActive = true
        playEpisodeButton.widthAnchor.constraint(equalTo: programImageButton.widthAnchor).isActive = true
        playEpisodeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: -5).isActive = true
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
        
        addSubview(self.moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor, constant: -3).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: self.captionTextView.font!.lineHeight).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        captionTextView.addSubview(moreGradientView)
        moreGradientView.translatesAutoresizingMaskIntoConstraints = false
        moreGradientView.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
        moreGradientView.trailingAnchor.constraint(equalTo: self.moreButton.leadingAnchor).isActive = true
        moreGradientView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        moreGradientView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        moreButtonGradient.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let whiteColor = UIColor.white
        moreButtonGradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(5.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        
        moreGradientView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
        moreGradientView.layer.insertSublayer(moreButtonGradient, at: 0)
        bringSubviewToFront(self.moreButton)
        
        self.addSubview(linkStackView)
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        linkStackView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        linkStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        linkStackView.addArrangedSubview(regularPreview)
        regularPreview.translatesAutoresizingMaskIntoConstraints = false
        regularPreview.leadingAnchor.constraint(equalTo: linkStackView.leadingAnchor).isActive = true
        regularPreview.trailingAnchor.constraint(equalTo: linkStackView.trailingAnchor).isActive = true
        regularPreview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: linkStackView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
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
        
        self.addSubview(episodeOptions)
        episodeOptions.translatesAutoresizingMaskIntoConstraints = false
        episodeOptions.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 5).isActive = true
        episodeOptions.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        episodeOptions.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        episodeOptions.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        episodeOptions.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        episodeOptions.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: episodeOptions.leadingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        episodeOptions.addSubview(likeCountLabel)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5).isActive = true
        likeCountLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        episodeOptions.addSubview(commentButton)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 10).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        episodeOptions.addSubview(commentCountLabel)
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 5).isActive = true
        commentCountLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        episodeOptions.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: commentCountLabel.trailingAnchor, constant: 10).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        episodeOptions.addSubview(shareCountLabel)
        shareCountLabel.translatesAutoresizingMaskIntoConstraints = false
        shareCountLabel.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        shareCountLabel.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 5).isActive = true
        shareCountLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        if UIDevice.current.deviceType != .iPhone4S && UIDevice.current.deviceType != .iPhoneSE {
        episodeOptions.addSubview(listenIconImage)
        listenIconImage.translatesAutoresizingMaskIntoConstraints = false
        listenIconImage.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        listenIconImage.leadingAnchor.constraint(equalTo: shareCountLabel.trailingAnchor, constant: 7).isActive = true
        listenIconImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        listenIconImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        episodeOptions.addSubview(listenCountLabel)
        listenCountLabel.translatesAutoresizingMaskIntoConstraints = false
        listenCountLabel.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        listenCountLabel.leadingAnchor.constraint(equalTo: listenIconImage.trailingAnchor, constant: 5).isActive = true
        listenCountLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        }

        episodeOptions.addSubview(timeSinceReleaseLabel)
        timeSinceReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSinceReleaseLabel.centerYAnchor.constraint(equalTo: episodeOptions.centerYAnchor).isActive = true
        timeSinceReleaseLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
    }
    
    override func prepareForReuse() {
        captionTextView.numberOfLines = 3
     }
    
    override func normalSetUp(episode: Episode) {
        includeRichLink()
        setupLikeButtonAndCounterFor(episode: episode)
        
        FileManager.getImageWith(imageID: episode.imageID) { image in
            DispatchQueue.main.async {
                self.programImageButton.setImage(image, for: .normal)
            }
        }
        
        listenCountLabel.text = episode.listenCount.roundedWithAbbreviations
        programNameLabel.text = episode.programName
        usernameButton.setTitle("@\(episode.username)", for: .normal)
        timeSinceReleaseLabel.text = episode.timeSince
        captionTextView.text = episode.caption
        episodeTags = episode.tags!
        
        createTagButtons()
        setupProgressBar()
        
        DispatchQueue.main.async {
            self.addGradient()
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
    
    func includeRichLink() {
        FileManager.getLinkImageWith(imageID: episode.linkImageID!) { image in
            DispatchQueue.main.async {
                 self.regularPreview.imageButton.setImage(image, for: .normal)
            }
        }
        self.regularPreview.backgroundButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
        self.regularPreview.imageButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
        self.regularPreview.mainLabel.text = episode.linkHeadline!
        self.regularPreview.urlLabel.text = episode.canonicalUrl
    }
    
    @objc func linkTouched() {
        guard let url = URL(string: episode.richLink!) else { return }
        cellDelegate!.visitLinkWith(url: url)
    }

}
