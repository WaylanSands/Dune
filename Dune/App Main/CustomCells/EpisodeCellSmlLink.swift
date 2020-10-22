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
    
    let imageButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.imageView!.contentMode = .scaleAspectFill
        return view
    }()
    
    let backgroundButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let squareLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.text = "Fetching"
        return label
    }()
    
    let urlLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = "Fetching"
        return label
    }()
    
    override func configureViews() {
        contentView.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        contentView.addSubview(playbackBarView)
        playbackBarView.translatesAutoresizingMaskIntoConstraints = false
        playbackBarView.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
        playbackBarView.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 7).isActive = true
        playbackBarView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        playbackBarView.widthAnchor.constraint(equalToConstant: playBarWidth).isActive = true
        
        contentView.addSubview(playEpisodeImageView)
        playEpisodeImageView.translatesAutoresizingMaskIntoConstraints = false
        playEpisodeImageView.leadingAnchor.constraint(equalTo: programImageButton.leadingAnchor, constant: 0).isActive = true
        playEpisodeImageView.centerYAnchor.constraint(equalTo: playbackBarView.centerYAnchor).isActive = true
        playEpisodeImageView.widthAnchor.constraint(equalToConstant: 7).isActive = true
        playEpisodeImageView.heightAnchor.constraint(equalToConstant: 7).isActive = true
        
        contentView.addSubview(playBarButton)
        playBarButton.translatesAutoresizingMaskIntoConstraints = false
        playBarButton.leadingAnchor.constraint(equalTo: playEpisodeImageView.trailingAnchor, constant: 4).isActive = true
        playBarButton.trailingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: -1).isActive = true
        playBarButton.centerYAnchor.constraint(equalTo: playbackBarView.centerYAnchor).isActive = true
        playBarButton.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
//        self.addSubview(playEpisodeButton)
//        playEpisodeButton.translatesAutoresizingMaskIntoConstraints = false
//        playEpisodeButton.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
//        playEpisodeButton.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 3).isActive = true
//        playEpisodeButton.widthAnchor.constraint(equalTo: programImageButton.widthAnchor).isActive = true
//        playEpisodeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        contentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: -7).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -35).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameStackedView.addArrangedSubview(usernameButton)
        
        contentView.addSubview(episodeSettingsButton)
        episodeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        episodeSettingsButton.centerYAnchor.constraint(equalTo: usernameButton.centerYAnchor, constant: 0).isActive = true
        episodeSettingsButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: -4).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
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
        
        contentView.addSubview(linkStackView)
        linkStackView.translatesAutoresizingMaskIntoConstraints = false
        linkStackView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        linkStackView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        linkStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
        linkStackView.addArrangedSubview(squarePreview)
        squarePreview.translatesAutoresizingMaskIntoConstraints = false
        squarePreview.leadingAnchor.constraint(equalTo: linkStackView.leadingAnchor).isActive = true
        squarePreview.trailingAnchor.constraint(equalTo: linkStackView.trailingAnchor).isActive = true
        squarePreview.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        contentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: linkStackView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        contentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        contentView.addSubview(episodeOptions)
        episodeOptions.translatesAutoresizingMaskIntoConstraints = false
        episodeOptions.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 5).isActive = true
        episodeOptions.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        episodeOptions.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        episodeOptions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
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
        timeSinceReleaseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        
        contentView.addSubview(timeSinceReleaseLabel)
        timeSinceReleaseLabel.translatesAutoresizingMaskIntoConstraints = false
        timeSinceReleaseLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14).isActive = true
        timeSinceReleaseLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
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
                self.squarePreview.imageButton.setImage(image, for: .normal)
            }
        }
        self.squarePreview.imageButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
        self.squarePreview.backgroundButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
        self.squarePreview.squareLabel.text = episode.linkHeadline!
        self.squarePreview.urlLabel.text = episode.canonicalUrl!
    }
    
    @objc func linkTouched() {
        print("link touched")
        guard let url = URL(string: episode.richLink!) else { return }
        cellDelegate!.visitLinkWith(url: url)
    }
    
}

