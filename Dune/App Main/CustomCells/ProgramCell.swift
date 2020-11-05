//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


protocol ProgramCellDelegate {
    func playProgramIntro(cell: ProgramCell)
    func unsubscribeFrom(program: Program)
    func showSettings(cell: ProgramCell)
    func visitProfile(program: Program)
    func programTagSelected(tag: String)
    func noIntroAlert()
    func updateRows()
}

class ProgramCell: UITableViewCell {
    var cellDelegate: ProgramCellDelegate!
    var program: Program!
    var moreButtonPress = false
    var unwrapped = false
    let scrollPadding: CGFloat = 40.0
    var programTags: [String]!
   
    var subscribeButtonWidth: NSLayoutConstraint!
    var tagScrollViewHeight: NSLayoutConstraint!
    var tagScrollViewTop: NSLayoutConstraint!
        
    // Used for modifying space when adding/removing options
    var summaryViewHeight: NSLayoutConstraint!
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    var tagContentSizeWidth: CGFloat = 0
    
    // For screen-size adjustment
    var usernameSize: CGFloat = 14
    var playBarWidth: CGFloat = 50
    var imageSize:CGFloat = 50.0
    var nameSize: CGFloat = 14
    
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
    
//    lazy var playProgramButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "play-episode-btn"), for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize + 15, bottom: 0, right: 0)
//        return button
//    }()
    
//    let playEpisodeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "play-episode-btn")
//        return imageView
//    }()
//
//    let playBarButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = CustomStyle.thirdShade
//        button.isUserInteractionEnabled = false
//        button.layer.cornerRadius = 2
//        return button
//    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
//    let programSettingsButton: ExtendedButton = {
//        let button = ExtendedButton()
//        button.setImage(#imageLiteral(resourceName: "episode-settings") , for: .normal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
//        button.padding = 10
//        return button
//    }()
    
    lazy var programNameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: nameSize, weight: .bold)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.allowsDefaultTighteningForTruncation = true
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        return button
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
        view.backgroundColor = .clear
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
    
    let firstTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("one", for: .normal)
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()
    
    let secondTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("two", for: .normal)
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()
    
    let thirdTagButton: UIButton = {
        let button = UIButton()
        button.setTitle("three", for: .normal)
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()
    
    let moreButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        button.backgroundColor = .white
        button.padding = 10
        return button
    }()
    
    let moreButtonGradient = CAGradientLayer()
    
    let moreGradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.backgroundColor = CustomStyle.primaryYellow
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 1, right: 13)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: -10, bottom: 0, right: 0)
        button.layer.cornerRadius = 11
        return button
    }()
    
//    let visitButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Visit", for: .normal)
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        button.setTitleColor(CustomStyle.secondShade, for: .normal)
//        button.backgroundColor = CustomStyle.linkBlue
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 1, right: 15)
//        button.layer.cornerRadius = 12
//        return button
//    }()
    
    let programStatsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fifthShade
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
        captionTextView.textContainer.maximumNumberOfLines = 3
        clearTagButtons()
    }
    
    // MARK: Setup Cell
    func normalSetUp(program: Program) {
        if self.program != program {
            programImageButton.setImage(nil, for: .normal)
        }
        
        self.program = program
       
        if program.imageID != nil {
            FileManager.getImageWith(imageID: program.imageID!) { image in
                DispatchQueue.main.async {
                    self.programImageButton.setImage(image, for: .normal)
                }
            }
        } else {
            self.programImageButton.setImage(#imageLiteral(resourceName: "missing-image-large"), for: .normal)
        }
        
        if CurrentProgram.programsIDs().contains(program.ID) {
            subscribeButton.isHidden = true
//            subscribeButton.setTitle("Visit", for: .normal)
        } else {
            configureSubscribeButton()
            subscribeButton.isHidden = false
        }
    
        programNameButton.setTitle(program.name, for: .normal)
        usernameButton.setTitle("@\(program.username)", for: .normal)
        captionTextView.text = program.summary
        
        if captionTextView.text == "" {
            captionTextView.text = "Still getting set up"
        }
        
        programTags = program.tags
        
        if programTags.count == 0 {
            tagScrollViewTop.constant = 0
            tagScrollViewHeight.constant = 0
            gradientOverlayView.isHidden = true
        } else {
            tagScrollViewTop.constant = 10
            tagScrollViewHeight.constant = 22
            gradientOverlayView.isHidden = false
        }
        
        configureStats()
//        setupProgressBar()
        createTagButtons()
        
        DispatchQueue.main.async {
            self.addGradient()
            if self.captionTextView.lineCount() > 3 && !self.unwrapped {
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
    
//    func setupProgressBar() {
//        if program.hasIntro {
//            playBarButton.isHidden = false
//            playEpisodeImageView.isHidden = false
//            if program.hasBeenPlayed {
//                playBarButton.isHidden = true
//                playbackBarView.isHidden = false
//                playEpisodeImageView.isHidden = true
//                playbackBarView.setupPlaybackBar()
//                playbackBarView.setProgressWith(percentage: program.playBackProgress)
//            }
//         } else {
//            playBarButton.isHidden = true
//            playbackBarView.isHidden = true
//            playEpisodeImageView.isHidden = true
//         }
//    }
    
    func configureStats() {
        let episodes = program.episodeIDs
        let subscribers = program.subscriberCount
        var subs = "Subscribers"
        var eps = "Episodes"
               
        
        if episodes.count == 1 {
            eps = "Episode"
        }
        
        if subscribers == 1 {
            subs = "Subscriber"
        }
        
        programStatsLabel.text = "\(subscribers) \(subs)  |  \(episodes.count) \(eps) |  Cred \(program.rep)"
    }
    
//    func configureSubscribeButton() {
//        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
//            setupUnsubscribeButton()
//        } else {
//            setupSubscribeButton()
//        }
//    }
    
    func configureSubscribeButton() {
        if program.channelState == .madePublic {
            subscribeButton.removeTarget(nil, action: nil, for: .allEvents)
            subscribeButton.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
            if !CurrentProgram.subscriptionIDs!.contains(program.ID) {
                subscribeButton.setTitle("Subscribe", for: .normal)
                subscribeButton.setImage(UIImage(named: "subscribe-pill-icon"), for: .normal)
                subscribeButton.backgroundColor = CustomStyle.primaryYellow
                subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            } else {
                subscribeButton.setTitle("Subscribed", for: .normal)
                subscribeButton.setImage(UIImage(named: "subscribed-pill-icon"), for: .normal)
                subscribeButton.backgroundColor = CustomStyle.sixthShade
                subscribeButton.setTitleColor(.white, for: .normal)
            }
        } else {
            subscribeButton.removeTarget(nil, action: nil, for: .allEvents)
            subscribeButton.addTarget(self, action: #selector(requestInvite), for: .touchUpInside)
            if program.pendingChannels.contains(CurrentProgram.ID!) {
                subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
                subscribeButton.setTitle("Pending invite", for: .normal)
                subscribeButton.backgroundColor = CustomStyle.secondShade
                subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            }  else if program.deniedChannels.contains(CurrentProgram.ID!) {
                subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
                subscribeButton.setTitle("Pending invite", for: .normal)
                subscribeButton.backgroundColor = CustomStyle.secondShade
                subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            } else if CurrentProgram.subscriptionIDs!.contains(program.ID) {
               subscribeButton.setTitle("Subscribed", for: .normal)
               subscribeButton.setImage(UIImage(named: "subscribed-pill-icon"), for: .normal)
                subscribeButton.backgroundColor = CustomStyle.sixthShade
                subscribeButton.setTitleColor(.white, for: .normal)
            } else {
                subscribeButton.setTitle("Request invite", for: .normal)
                subscribeButton.setImage(UIImage(named: "request-invite"), for: .normal)
                subscribeButton.backgroundColor = CustomStyle.primaryYellow
                subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            }
        }
        subscribeButtonWidth.constant = subscribeButton.intrinsicContentSize.width
    }
    
//    func setupSubscribeButton() {
//        subscribeButton.setTitle("Subscribe", for: .normal)
//        subscribeButton.backgroundColor = CustomStyle.primaryYellow
//        subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
//    }
//
//    func setupUnsubscribeButton() {
//        subscribeButton.setTitle("Subscribed", for: .normal)
//        subscribeButton.backgroundColor = CustomStyle.sixthShade
//        subscribeButton.setTitleColor(.white, for: .normal)
//        subscribeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
//    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            usernameSize = 14
            playBarWidth = 40
            imageSize = 45.0
            nameSize = 14
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
        
//        self.addSubview(playEpisodeImageView)
//        playEpisodeImageView.translatesAutoresizingMaskIntoConstraints = false
//        playEpisodeImageView.leadingAnchor.constraint(equalTo: programImageButton.leadingAnchor, constant: 0).isActive = true
//        playEpisodeImageView.centerYAnchor.constraint(equalTo: playbackBarView.centerYAnchor).isActive = true
//        playEpisodeImageView.widthAnchor.constraint(equalToConstant: 7).isActive = true
//        playEpisodeImageView.heightAnchor.constraint(equalToConstant: 7).isActive = true
//
//        self.addSubview(playBarButton)
//        playBarButton.translatesAutoresizingMaskIntoConstraints = false
//        playBarButton.leadingAnchor.constraint(equalTo: playEpisodeImageView.trailingAnchor, constant: 4).isActive = true
//        playBarButton.trailingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: -1).isActive = true
//        playBarButton.centerYAnchor.constraint(equalTo: playbackBarView.centerYAnchor).isActive = true
//        playBarButton.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
//        self.addSubview(playProgramButton)
//        playProgramButton.translatesAutoresizingMaskIntoConstraints = false
//        playProgramButton.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
//        playProgramButton.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 3).isActive = true
//        playProgramButton.widthAnchor.constraint(equalTo: programImageButton.widthAnchor).isActive = true
//        playProgramButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
//        self.addSubview(programSettingsButton)
//        programSettingsButton.translatesAutoresizingMaskIntoConstraints = false
//        programSettingsButton.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: 0).isActive = true
//        programSettingsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(subscribeButton)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: -4).isActive = true
        subscribeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        subscribeButtonWidth = subscribeButton.widthAnchor.constraint(equalToConstant: subscribeButton.intrinsicContentSize.width)
        subscribeButtonWidth.isActive = true
        
        contentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: -5).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: subscribeButton.leadingAnchor, constant: -10).isActive = true
        programNameStackedView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        programNameStackedView.addArrangedSubview(programNameButton)
//        programNameStackedView.addArrangedSubview(usernameButton)

//        self.addSubview(programNameLabel)
//        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        programNameLabel.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
//        programNameLabel.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 12).isActive = true
//        programNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: subscribeButton.leadingAnchor, constant: -10).isActive = true
//
//        self.addSubview(usernameButton)
//        usernameButton.translatesAutoresizingMaskIntoConstraints = false
//        usernameButton.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor, constant: 3).isActive = true
//        usernameButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        usernameButton.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor, constant: -2).isActive = true
//        usernameButton.trailingAnchor.constraint(lessThanOrEqualTo: subscribeButton.leadingAnchor, constant: -20).isActive = true
        
        contentView.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 2).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0).isActive = true
        
        contentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollViewTop = tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10)
        tagScrollViewTop.isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16).isActive = true
        tagScrollViewHeight = tagScrollView.heightAnchor.constraint(equalToConstant: 22)
        tagScrollViewHeight.isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        contentView.addSubview(programStatsLabel)
        programStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        programStatsLabel.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor,constant: 15).isActive = true
        programStatsLabel.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor, constant: 5).isActive = true
        programStatsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15).isActive = true
        
        contentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        contentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: captionTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: captionTextView.trailingAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: captionTextView.font!.lineHeight).isActive = true
        moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        captionTextView.addSubview(moreGradientView)
        moreGradientView.translatesAutoresizingMaskIntoConstraints = false
        moreGradientView.centerYAnchor.constraint(equalTo: moreButton.centerYAnchor).isActive = true
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
    
    func clearTagButtons() {
        for eachButton in tagButtons {
            eachButton.setTitle("", for: .normal)
        }
    }
    
    func addMoreButton() {
        DispatchQueue.main.async {
            if !self.unwrapped {
                
//                self.addSubview(self.moreButton)
//                self.moreButton.translatesAutoresizingMaskIntoConstraints = false
//                self.moreButton.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
//                self.moreButton.trailingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor, constant: -3).isActive = true
//                self.moreButton.heightAnchor.constraint(equalToConstant: self.captionTextView.font!.lineHeight).isActive = true
//                let rect = CGRect(x: self.captionTextView.frame.width - 40, y: self.captionTextView.frame.height - 10, width: 40, height: 10)
//                let path = UIBezierPath(rect: rect)
//                self.captionTextView.textContainer.exclusionPaths = [path]
                
            }
        }
    }
    
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviews()
        for eachTag in programTags {
            let button = tagButton(with: eachTag)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButton(with title: String) -> TagButton {
        let button = TagButton(title: title)
        button.addTarget(self, action: #selector(programTagSelected), for: .touchUpInside)
        return button
    }
    
    @objc func programTagSelected(sender: UIButton) {
        let tag = sender.titleLabel!.text!
        cellDelegate?.programTagSelected(tag: tag)
    }
    
    @objc func moreUnwrap() {
        captionTextView.textContainer.maximumNumberOfLines = 0
        captionTextView.text = "\(captionTextView.text!) "
        
        self.moreButtonGradient.isHidden = true
        self.moreGradientView.isHidden = true
        self.moreButton.isHidden = true
        
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        captionTextView.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.cellDelegate?.updateRows()
        }
    }
    
    @objc func visitProfile() {
        cellDelegate!.visitProfile(program: program)
    }
    
    
    @objc func playProgramIntro(cell: ProgramCell) {
//        if program.hasIntro {
//            playbackBarView.isHidden = false
//            cellDelegate?.playProgramIntro(cell: self)
//            playEpisodeImageView.isHidden = true
//            playBarButton.isHidden = true
//        } else {
//            cellDelegate.noIntroAlert()
//        }
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettings(cell: self )
    }
    
//    @objc func subscribeButtonPress() {
//        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
//            setupSubscribeButton()
//            CurrentProgram.subscriptionIDs!.removeAll(where: { $0 == program.ID })
//            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
//            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
//            cellDelegate.unsubscribeFrom(program: program)
//            program.subscriberCount -= 1
//            configureStats()
//        } else {
//            setupUnsubscribeButton()
//            CurrentProgram.subscriptionIDs!.append(program.ID)
//            FireStoreManager.addSubscriptionToProgramWith(programID: program.ID)
//            FireStoreManager.subscribeToProgramWith(programID: program.ID)
//            program.subscriberCount += 1
//            configureStats()
//        }
//    }
    
    @objc func subscribeButtonPress() {
        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            CurrentProgram.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            configureStats()
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-pill-icon"), for: .normal)
            subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            subscribeButton.backgroundColor = CustomStyle.primaryYellow
        } else {
            FireStoreManager.addSubscriptionToProgramWith(programID: program.ID)
            FireStoreManager.subscribeToProgramWith(programID: program.ID)
            CurrentProgram.subscriptionIDs!.append(program.ID)
            program.subscriberCount += 1
            configureStats()
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-pill-icon"), for: .normal)
            subscribeButton.setTitleColor(CustomStyle.white, for: .normal)
            subscribeButton.backgroundColor = CustomStyle.primaryBlack
        }
        subscribeButtonWidth.constant = subscribeButton.intrinsicContentSize.width
    }
    
    @objc func requestInvite() {
        if subscribeButton.titleLabel?.text == "Request invite" {
            subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
            subscribeButton.setTitle("Pending invite", for: .normal)
            FireStoreManager.requestInviteFor(channelID: program.ID)
            program.pendingChannels.append(CurrentProgram.ID!)
        } else if subscribeButton.titleLabel?.text == "Subscribed" {
            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            CurrentProgram.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            configureStats()
            subscribeButton.setTitle("Request invite", for: .normal)
            subscribeButton.setImage(UIImage(named: "request-invite"), for: .normal)
            subscribeButton.backgroundColor = CustomStyle.primaryYellow
            subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        }
        subscribeButtonWidth.constant = subscribeButton.intrinsicContentSize.width
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


