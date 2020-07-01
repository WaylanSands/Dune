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
    var cellHeight: NSLayoutConstraint!
    var tagScrollViewHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
        
    // Used for modifying space when adding/removing options
    var summaryViewHeight: NSLayoutConstraint!
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    var tagContentSizeWidth: CGFloat = 0
    
    // For screen-size adjustment
    var usernameSize: CGFloat = 14
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
    
    lazy var playProgramButton: UIButton = {
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
    
    let programSettingsButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(#imageLiteral(resourceName: "episode-settings") , for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.padding = 10
        return button
    }()
    
    lazy var programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: nameSize, weight: .bold)
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
        button.titleLabel!.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 1, right: 15)
        button.layer.cornerRadius = 12
        return button
    }()
    
    let programStatsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.primaryBlack
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
        captionTextView.textContainer.maximumNumberOfLines = 3
        clearTagButtons()
    }
    
    // MARK: Setup Cell
    func normalSetUp(program: Program) {
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
        
        if let programIDs = CurrentProgram.programIDs {
            if programIDs.contains(program.ID) || program.ID == CurrentProgram.ID {
                subscribeButton.isHidden = true
            } else {
                configureSubscribeButton()
                subscribeButton.isHidden = false
            }
            
        } else if CurrentProgram.ID == program.ID {
            subscribeButton.isHidden = true
        } else {
            configureSubscribeButton()
            subscribeButton.isHidden = false
        }
    
        programNameLabel.text = program.name
        usernameButton.setTitle("@\(program.username)", for: .normal)
        captionTextView.text = program.summary
        programTags = program.tags
        
        configureStats()
        setupProgressBar()
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
    
    func setupProgressBar() {
        if program.hasIntro {
            playProgramButton.isHidden = false
            playProgramButton.setImage(UIImage(named: "play-episode-btn"), for: .normal)
            if program.hasBeenPlayed {
                playbackBarView.isHidden = false
                playbackBarView.setupPlaybackBar()
                playProgramButton.setImage(nil, for: .normal)
                playbackBarView.setProgressWith(percentage: program.playBackProgress)
            }
         } else {
            playbackBarView.isHidden = true
            playProgramButton.isHidden = true
         }
    }
    
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
        
        programStatsLabel.text = "\(subscribers) \(subs)  |  \(episodes.count) \(eps) |  Rep \(program.rep)"
    }
    
    func configureSubscribeButton() {
        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
            setupUnsubscribeButton()
        } else {
            setupSubscribeButton()
        }
    }
    
    func setupSubscribeButton() {
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.backgroundColor = CustomStyle.primaryYellow
        subscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
    }
    
    func setupUnsubscribeButton() {
        subscribeButton.setTitle("Subscribed", for: .normal)
        subscribeButton.backgroundColor = CustomStyle.sixthShade
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            usernameSize = 14
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
        playbackBarView.widthAnchor.constraint(equalToConstant: imageSize - 5).isActive = true
        
        self.addSubview(playProgramButton)
        playProgramButton.translatesAutoresizingMaskIntoConstraints = false
        playProgramButton.centerXAnchor.constraint(equalTo: programImageButton.centerXAnchor).isActive = true
        playProgramButton.topAnchor.constraint(equalTo: programImageButton.bottomAnchor, constant: 3).isActive = true
        playProgramButton.widthAnchor.constraint(equalTo: programImageButton.widthAnchor).isActive = true
        playProgramButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.addSubview(programSettingsButton)
        programSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        programSettingsButton.topAnchor.constraint(equalTo: programImageButton.topAnchor, constant: 0).isActive = true
        programSettingsButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        self.addSubview(subscribeButton)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        subscribeButton.trailingAnchor.constraint(equalTo: programSettingsButton.trailingAnchor, constant: -20).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: subscribeButton.intrinsicContentSize.width + 5).isActive = true

        self.addSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        programNameLabel.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 12).isActive = true
        programNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: subscribeButton.leadingAnchor, constant: -10).isActive = true
        
        self.addSubview(usernameButton)
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor, constant: 3).isActive = true
        usernameButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        usernameButton.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor, constant: -2).isActive = true
        usernameButton.trailingAnchor.constraint(lessThanOrEqualTo: subscribeButton.leadingAnchor, constant: -20).isActive = true
        
        self.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: usernameButton.bottomAnchor, constant: 2).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: usernameButton.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
        tagScrollViewHeightConstraint = tagScrollView.heightAnchor.constraint(equalToConstant: 22)
        tagScrollViewHeightConstraint.isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        self.addSubview(programStatsLabel)
        programStatsLabel.translatesAutoresizingMaskIntoConstraints = false
        programStatsLabel.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor,constant: 15).isActive = true
        programStatsLabel.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor, constant: 5).isActive = true
        programStatsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
        self.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        self.addSubview(self.moreButton)
        self.moreButton.translatesAutoresizingMaskIntoConstraints = false
        self.moreButton.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
        self.moreButton.trailingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor).isActive = true
        self.moreButton.heightAnchor.constraint(equalToConstant: self.captionTextView.font!.lineHeight).isActive = true
        self.moreButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.captionTextView.addSubview(self.moreGradientView)
        self.moreGradientView.translatesAutoresizingMaskIntoConstraints = false
        self.moreGradientView.centerYAnchor.constraint(equalTo: self.moreButton.centerYAnchor).isActive = true
        self.moreGradientView.trailingAnchor.constraint(equalTo: self.moreButton.leadingAnchor).isActive = true
        self.moreGradientView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.moreGradientView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        self.moreButtonGradient.frame = CGRect(x: 0, y: 0, width: 18, height: 20)
        let whiteColor = UIColor.white
        self.moreButtonGradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(5.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]

        self.moreGradientView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
        self.moreGradientView.layer.insertSublayer(self.moreButtonGradient, at: 0)
        self.bringSubviewToFront(self.moreButton)
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
        tagContainingStackView.removeAllArrangedSubviewsCompletely()
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
//            self.cellDelegate?.addTappedProgram(programName: self.programNameLabel.text!)
        }
    }
    
    @objc func visitProfile() {
        cellDelegate!.visitProfile(program: program)
    }
    
    
    @objc func playProgramIntro(cell: ProgramCell) {
        if program.hasIntro {
            playbackBarView.isHidden = false
            cellDelegate?.playProgramIntro(cell: self)
            playProgramButton.setImage(nil, for: .normal)
        } else {
            cellDelegate.noIntroAlert()
        }
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettings(cell: self )
    }
    
    @objc func subscribeButtonPress() {
        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
            setupSubscribeButton()
            CurrentProgram.subscriptionIDs!.removeAll(where: { $0 == program.ID })
            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            cellDelegate.unsubscribeFrom(program: program)
            program.subscriberCount -= 1
            configureStats()
        } else {
            setupUnsubscribeButton()
            CurrentProgram.subscriptionIDs!.append(program.ID)
            FireStoreManager.addSubscriptionToProgramWith(programID: program.ID)
            FireStoreManager.subscribeToProgramWith(programID: program.ID)
            program.subscriberCount += 1
            configureStats()
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


