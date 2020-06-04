//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import WebKit
import SwiftLinkPreview

protocol EpisodeCellDelegate {
    func updateRows()
    func addTappedProgram(programName: String)
    func playEpisode(cell: EpisodeCell )
    func showSettings(cell: EpisodeCell )
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath)
    func visitProfile(program: Program)
    func showCommentsFor(episode: Episode)
    func tagSelected(tag: String)
}

class EpisodeCell: UITableViewCell {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cellDelegate: EpisodeCellDelegate?
    var episode: Episode!
    var link: String?
    var moreButtonPress = false
    let programImageSize:CGFloat = 55.0
    var unwrapped = false
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    let scrollPadding: CGFloat = 40.0
    var episodeTags: [String] = []
    var cellHeight: NSLayoutConstraint!
  
    var tagScrollViewHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    var likedEpisode = false
    var richLinkGenerator: RichLinkGenerator!
    
    // Used for modifying space when adding/removing options
    var tagContentBottomConstraint: NSLayoutConstraint!
    var optionsConfigured = false
    
    var summaryViewHeight: NSLayoutConstraint!
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
    var tagContentSizeWidth: CGFloat = 0
    
    let swiftLinkPreview = SwiftLinkPreview(session: URLSession.shared, workQueue: SwiftLinkPreview.defaultWorkQueue, responseQueue: DispatchQueue.main, cache: InMemoryCache())
    
    let playbackBarView = PlaybackBarView()
    
    let programImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.backgroundColor = CustomStyle.secondShade
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
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let usernameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        return button
    }()
    
    let captionTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.isScrollEnabled = false
        view.textContainer.maximumNumberOfLines = 3
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = CustomStyle.sixthShade
        return view
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
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        return button
    }()
    
    // Episode Options
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cell-like-button"), for: .normal)
        return button
    }()
    
    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.text = "\(episode.likeCount.roundedWithAbbreviations)"
        label.textColor = CustomStyle.thirdShade
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cell-comment-button"), for: .normal)
        return button
    }()
    
    lazy var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.thirdShade
        label.text = "\(episode.commentCount.roundedWithAbbreviations)"
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cell-share-button"), for: .normal)
        return button
    }()
    
    lazy var shareCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.thirdShade
        label.text = "\(episode.shareCount.roundedWithAbbreviations)"
        return label
    }()
    
    let listenIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cell-listen-icon")
        return imageView
    }()
    
    lazy var listenCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = CustomStyle.thirdShade
        label.text = "\(episode.listenCount.roundedWithAbbreviations)"
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        styleForScreens()
        configureViews()
    }
    
    override func prepareForReuse() {
        playbackBarView.resetPlaybackBar()
        moreButton.removeFromSuperview()
    }
    
    // MARK: Cell setup
    
    func normalSetUp(episode: Episode) {
        setupLikeButtonAndCounterFor(episode: episode)
        
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
        
//        if episodeTags.count == 0 && episode.likeCount > 10 {
//            tagScrollViewHeightConstraint.constant = 0
//        } else if episodeTags.count > 0 {
//            tagScrollViewHeightConstraint.constant = 22
//        }
        
        createTagButtons()
        setupProgressBar()
        
        DispatchQueue.main.async {
            self.addGradient()
            if self.captionTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
    }
    
    func setupProgressBar() {
        if episode.hasBeenPlayed {
            playbackBarView.setupPlaybackBar()
            playbackBarView.setProgressWith(percentage: episode.playBackProgress)
        }
        
        if episode.hasBeenPlayed == false && playbackBarView.playbackBarIsSetup  {
            playbackBarView.resetPlaybackBar()
        }
    }
    
    @objc func linkTouched() {
        print("link touched")

        guard let url = URL(string: link!) else { return }
        UIApplication.shared.open(url)
    }

    func configureWithoutOptions() {
        tagContentBottomConstraint.constant = -15
        likeButton.removeFromSuperview()
        likeCountLabel.removeFromSuperview()
        commentButton.removeFromSuperview()
        commentCountLabel.removeFromSuperview()
        shareButton.removeFromSuperview()
        shareCountLabel.removeFromSuperview()
        listenIconImage.removeFromSuperview()
        listenCountLabel.removeFromSuperview()
    }
    
    func refreshSetupMoreTapFalse() {
        captionTextView.textContainer.maximumNumberOfLines = 3
        moreButton.isHidden = false
        moreButtonPress = false
    }
    
    func refreshSetupMoreTapTrue() {
        captionTextView.textContainer.maximumNumberOfLines = 0
        captionTextView.textContainer.exclusionPaths.removeAll()
        moreButton.isHidden = true
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            fontNameSize = 14
            fontIDSize = 12
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
    
    func configureViews() {
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
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
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
    
    func configureCellWithOptions() {
        tagContentBottomConstraint.constant = -40
        
        self.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 10).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addSubview(likeCountLabel)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5).isActive = true
        likeCountLabel.widthAnchor.constraint(equalToConstant: 29).isActive = true
        
        self.addSubview(commentButton)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 10).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 15).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addSubview(commentCountLabel)
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 5).isActive = true
        commentCountLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 10).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: commentCountLabel.trailingAnchor, constant: 15).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addSubview(shareCountLabel)
        shareCountLabel.translatesAutoresizingMaskIntoConstraints = false
        shareCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        shareCountLabel.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 5).isActive = true
        shareCountLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.addSubview(listenIconImage)
        listenIconImage.translatesAutoresizingMaskIntoConstraints = false
        listenIconImage.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 10).isActive = true
        listenIconImage.leadingAnchor.constraint(equalTo: shareCountLabel.trailingAnchor, constant: 7).isActive = true
        listenIconImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        listenIconImage.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addSubview(listenCountLabel)
        listenCountLabel.translatesAutoresizingMaskIntoConstraints = false
        listenCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        listenCountLabel.leadingAnchor.constraint(equalTo: listenIconImage.trailingAnchor, constant: 5).isActive = true
        listenCountLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        DispatchQueue.main.async {
            self.cellDelegate?.updateRows()
        }
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
    
    func addMoreButton() {
        DispatchQueue.main.async {
            if !self.unwrapped {
                self.addSubview(self.moreButton)
                self.moreButton.translatesAutoresizingMaskIntoConstraints = false
                self.moreButton.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
                self.moreButton.trailingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor, constant: -3).isActive = true
                self.moreButton.heightAnchor.constraint(equalToConstant: self.captionTextView.font!.lineHeight).isActive = true
                let rect = CGRect(x: self.captionTextView.frame.width - 40, y: self.captionTextView.frame.height - 10, width: 40, height: 10)
                let path = UIBezierPath(rect: rect)
                self.captionTextView.textContainer.exclusionPaths = [path]
            }
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
        cellDelegate?.tagSelected(tag: tag)
    }
    
    @objc func moreUnwrap() {
        unwrapped = true
        captionTextView.textContainer.maximumNumberOfLines = 0
        captionTextView.textContainer.exclusionPaths.removeAll()
        captionTextView.text = "\(captionTextView.text!) "
        moreButton.removeFromSuperview()
        
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
                likeCountLabel.textColor = CustomStyle.thirdShade
            }
        }
        
        if episode.likeCount == 0 {
            likeCountLabel.text = ""
            likedEpisode = false
        } else {
            likeCountLabel.text = String(episode.likeCount.roundedWithAbbreviations)
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
    
    @objc func showComments() {
        cellDelegate?.showCommentsFor(episode: episode)
    }
    
    @objc func playEpisode() {
        cellDelegate?.playEpisode(cell: self )
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettings(cell: self )
    }
    
    @objc func visitProfile() {
        
        if User.isPublisher! && CurrentProgram.programsIDs().contains(episode.programID) {
            let tabBar = MainTabController()
            tabBar.selectedIndex = 4
            
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                 sceneDelegate.window?.rootViewController = tabBar
            } else {
                 appDelegate.window?.rootViewController = tabBar
            }
            
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
    
    // Helper functions
    
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

