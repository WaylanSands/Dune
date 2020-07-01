//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import WebKit
import ActiveLabel

protocol EpisodeCellDelegate {
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath)
    func addTappedProgram(programName: String)
    func showCommentsFor(episode: Episode)
    func showSettings(cell: EpisodeCell )
    func episodeTagSelected(tag: String)
    func playEpisode(cell: EpisodeCell )
    func visitProfile(program: Program)
    func updateRows()
}

class EpisodeCell: UITableViewCell {
    
    var cellDelegate: EpisodeCellDelegate?
    let scrollPadding: CGFloat = 40.0
    var episodeTags: [String] = []
    var likedEpisode = false
    var episode: Episode!
    var fetching = false
        
    // For various screen sizes
    var imageSize: CGFloat = 50
    var playBarWidth: CGFloat = 50
//    var optionSpacing: CGFloat = 7
    
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
    
    lazy var playEpisodeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "play-episode-btn"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize + 15, bottom: 0, right: 0)
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
        button.titleLabel!.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
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
        self.layer.shouldRasterize = true
        self.selectionStyle = .none
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
        captionTextView.text = episode.caption
        episodeTags = episode.tags!
        
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
        if episode.hasBeenPlayed {
            playEpisodeButton.setImage(nil, for: .normal)
            print("Made nil")
            playbackBarView.setupPlaybackBar()
            playbackBarView.setProgressWith(percentage: episode.playBackProgress)
        } else {
            playEpisodeButton.setImage(UIImage(named: "play-episode-btn"), for: .normal)
        }
        
        if episode.hasBeenPlayed == false && playbackBarView.playbackBarIsSetup  {
            playEpisodeButton.setImage(UIImage(named: "play-episode-btn"), for: .normal)
            playbackBarView.resetPlaybackBar()
        }
    }
    
    func configureViews() {
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
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
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
        tagContainingStackView.removeAllArrangedSubviewsCompletely()
        for eachTag in episodeTags {
            let button = tagButtton(with: eachTag)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButtton(with title: String) -> TagButton {
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
            self.cellDelegate?.addTappedProgram(programName: self.programNameLabel.text!)
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
        playEpisodeButton.setImage(nil, for: .normal)
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettings(cell: self )
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

extension EpisodeCell: WKNavigationDelegate {
    
}

