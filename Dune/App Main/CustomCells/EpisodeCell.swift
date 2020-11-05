//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import ActiveLabel

protocol EpisodeCellDelegate {
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath)
    func showCommentsFor(episode: Episode)
    func showSettingsFor(cell: EpisodeCell)
    func episodeTagSelected(tag: String)
    func playEpisode(cell: EpisodeCell )
    func visitProfile(program: Program)
    func visitLinkWith(url: URL)
    func updateRows()
}

class EpisodeCell: UITableViewCell {
    
    var cellDelegate: EpisodeCellDelegate?
    let scrollPadding: CGFloat = 40.0
    var episodeTags: [String] = []
    var likedEpisode = false
    var episode: Episode!
    var fetching = false
    
    var tagScrollViewTop: NSLayoutConstraint!
    var tagScrollViewHeight: NSLayoutConstraint!
    
    // For various screen sizes
    var imageSize: CGFloat = 50
    var playBarWidth: CGFloat = 50
    
    let userNotFoundAlert = CustomAlertView(alertType: .userNotFound)
    let playbackBarView = PlaybackBarView()
    
    let programImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.backgroundColor = CustomStyle.secondShade
        button.isOpaque = true
        return button
    }()
    
    let playEpisodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "play-episode-btn")
        return imageView
    }()
    
    let playBarButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.thirdShade
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 2
        return button
    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
    let episodeSettingsButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(#imageLiteral(resourceName: "episode-settings") , for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.padding = 10
        return button
    }()
    
    lazy var programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        return button
    }()
    
    lazy var captionTextView: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.seventhShade
        label.numberOfLines = 3
        label.enabledTypes = [.mention, .url]
        label.lineBreakMode = .byWordWrapping
        label.urlMaximumLength = 30
        label.sizeToFit()
        label.handleMentionTap { username in
            if !self.fetching {
                self.fetching = true
                FireStoreManager.getProgramWith(username: username) { program in
                    self.fetching = false
                    if program != nil {
                        self.cellDelegate?.visitProfile(program: program!)
                    } else {
                        UIApplication.shared.windows.last?.addSubview(self.userNotFoundAlert)
                    }
                }
            }
        }
        label.mentionColor = CustomStyle.linkBlue
        label.enabledTypes = [.mention, .url]
        return label
    }()
    
    let tagScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let tagContainingStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let gradientOverlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tagContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let timeSinceReleaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let moreButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        button.isHidden = true
        button.padding = 10
        return button
    }()
    
    let moreButtonGradient = CAGradientLayer()
    
    let moreGradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    // Episode Options
    let episodeOptions: UIView = {
        let view = UIView()
        return view
    }()
    
    let likeButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "cell-like-button"), for: .normal)
        button.isOpaque = true
        button.padding = 20
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let commentButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "cell-comment-button"), for: .normal)
        button.isOpaque = true
        button.padding = 10
        return button
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let shareButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "cell-share-button"), for: .normal)
        button.isOpaque = true
        button.padding = 10
        return button
    }()
    
    lazy var shareCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let listenIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell-listen-icon")
        imageView.isOpaque = true
        return imageView
    }()
    
    let listenCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.fourthShade
        return label
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
    
    override func prepareForReuse() {
        captionTextView.numberOfLines = 3
        playbackBarView.resetPlaybackBar()
    }
    
    // MARK: Cell setup
    func normalSetUp(episode: Episode) {
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
        captionTextView.text = episode.caption.trimmingTrailingSpaces
        episodeTags = episode.tags!
                
        if episodeTags.count == 0 {
            tagScrollViewTop.constant = 0
            tagScrollViewHeight.constant = 0
            gradientOverlayView.isHidden = true
        } else {
            tagScrollViewTop.constant = 10
            tagScrollViewHeight.constant = 22
            gradientOverlayView.isHidden = false
        }
        
        commentCountLabel.text = "\(episode.commentCount.roundedWithAbbreviations)"
        
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
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageSize = 45.0
            playBarWidth = 40
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func setupProgressBar() {
//        print("episode.hasBeenPlayed: \(episode.hasBeenPlayed) for: \(episode.programName)")
        if episode.hasBeenPlayed {
            playEpisodeImageView.isHidden = true
            playBarButton.isHidden = true
            playbackBarView.setupPlaybackBar()
            
            if let previousSessionProgress = User.progressFor(ID: episode.ID) {
                playbackBarView.setProgressWith(percentage: previousSessionProgress)
            } else {
                playbackBarView.setProgressWith(percentage: episode.playBackProgress)
            }
        } else {
            playEpisodeImageView.isHidden = false
            playBarButton.isHidden = false
        }
        
        if episode.hasBeenPlayed == false && playbackBarView.playbackBarIsSetup  {
            playEpisodeImageView.isHidden = false
            playBarButton.isHidden = false
            playbackBarView.resetPlaybackBar()
        }
    }
    
    func configureViews() {
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
        
        contentView.addSubview(moreButton)
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
        
        contentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollViewTop = tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10)
        tagScrollViewTop.isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollViewHeight = tagScrollView.heightAnchor.constraint(equalToConstant: 22)
        tagScrollViewHeight.isActive = true
        
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
    }
    
    func addGradient() {
        if gradientOverlayView.layer.sublayers == nil {
            let gradient = CAGradientLayer()
            gradient.frame = gradientOverlayView.bounds
            let whiteColor = UIColor.white
            gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
            gradientOverlayView.layer.insertSublayer(gradient, at: 0)
            gradientOverlayView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
            gradientOverlayView.backgroundColor = .clear
        }
    }
    
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviews()
        for eachTag in episodeTags {
            let button = tagButton(with: eachTag)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButton(with title: String) -> TagButton {
        let button = TagButton(title: title)
        button.addTarget(self, action: #selector(tagSelected), for: .touchUpInside)
        return button
    }
    
    @objc func tagSelected(sender: UIButton) {
        let tag = sender.titleLabel!.text!
        cellDelegate?.episodeTagSelected(tag: tag)
    }
    
    @objc func captionPress() {
        if captionTextView.numberOfLines != 0 && captionTextView.lineCount() > 3 {
            moreUnwrap()
        } else {
            self.cellDelegate?.showCommentsFor(episode: episode)
        }
    }
    
    @objc func moreUnwrap() {
        captionTextView.numberOfLines = 0
        captionTextView.text = "\(captionTextView.text!) "
        
        moreButtonGradient.isHidden = true
        moreGradientView.isHidden = true
        moreButton.isHidden = true
        
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        captionTextView.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.cellDelegate?.updateRows()
        }
    }
    
    func setupLikeButtonAndCounterFor(episode: Episode) {
        
        if let likedEpisodes = User.likedEpisodes {
            if likedEpisodes.contains(episode.ID) {
                likedEpisode = true
                likeButton.setImage(UIImage(named: "cell-liked-button"), for: .normal)
                likeCountLabel.textColor = CustomStyle.fourthShade
            } else {
                likedEpisode = false
                likeButton.setImage(UIImage(named: "cell-like-button"), for: .normal)
                likeCountLabel.textColor = CustomStyle.fourthShade
            }
        }
        
        if episode.likeCount == 0 {
            likeCountLabel.text = ""
            likedEpisode = false
        } else {
            likeCountLabel.text = episode.likeCount.roundedWithAbbreviations
        }
        
        if episode.commentCount == 0 {
            commentCountLabel.isHidden = true
        } else {
            commentCountLabel.text = episode.commentCount.roundedWithAbbreviations
            commentCountLabel.isHidden = false
        }
        
        if episode.shareCount == 0 {
            shareCountLabel.isHidden = true
        } else {
            shareCountLabel.isHidden = false
            shareCountLabel.text = episode.shareCount.roundedWithAbbreviations
        }
        
    }
    
    @objc func likeButtonPress() {
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
            if !CurrentProgram.repMethods!.contains(episode.ID) {
                FireStoreManager.updateProgramRep(programID: episode.programID, repMethod: episode.programID, rep: 6)
                FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: episode.programID)
                CurrentProgram.repMethods?.append(episode.ID)
            }
        } else {
            likedEpisode = false
            likeCount -= 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "cell-like-button"), for: .normal)
            likeCountLabel.textColor = CustomStyle.fourthShade
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episode.ID, by: .decrease)
            
            episode.likeCount -= 1
            cellDelegate?.updateLikeCountFor(episode: episode, at: indexPath)
            
            if likeCount == 0 {
                likeCountLabel.text = ""
            }
        }
    }
    
    @objc func showComments() {
        cellDelegate?.showCommentsFor(episode: episode)
    }
    
    @objc func playEpisode() {
        cellDelegate?.playEpisode(cell: self )
        playEpisodeImageView.isHidden = true
        playBarButton.isHidden = true
    }
    
    func removePlayIcon() {
        playEpisodeImageView.isHidden = true
        playBarButton.isHidden = true
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettingsFor(cell: self )
    }
    
    
    @objc func visitProfile() {
        if !fetching {
            fetching = true
            FireStoreManager.fetchAndCreateProgramWith(programID: episode.programID) { program in
                self.cellDelegate!.visitProfile(program: program)
                self.fetching = false
            }
        }
    }
    
    func getIndexPath() -> IndexPath? {
        var indexPath: IndexPath!
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        indexPath = superView.indexPath(for: self)
        return indexPath
    }
    
}


