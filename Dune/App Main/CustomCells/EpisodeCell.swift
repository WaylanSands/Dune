//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol EpisodeCellDelegate {
    func updateRows()
    func addTappedProgram(programName: String)
    func playEpisode(cell: EpisodeCell )
    func showSettings(cell: EpisodeCell )
}

class EpisodeCell: UITableViewCell {
    
    var cellDelegate: EpisodeCellDelegate?
    var episodeID: String?
    var moreButtonPress = false
    let imageViewSize:CGFloat = 65.0
    var unwrapped = false
    var largeImageSize: CGFloat = 65.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    let scrollPadding: CGFloat = 40.0
    var episodeTags: [String] = []
    var cellHeight: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    var tagContentSizeWidth: CGFloat = 0
//    var row: Int?
    
    let programImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFit
        button.backgroundColor = CustomStyle.secondShade
        return button
    }()
    
    let programeNameStackedView: UIStackView = {
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
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()

    
    let captionTextView: UITextView = {
        let view = UITextView()
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
    
    let timeSinceReleaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        return button
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
        clearTagButtons()
        captionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        moreButton.removeFromSuperview()
    }
    
    func normalSetUp(episode: Episode) {
//        self.programImageButton.setImage(nil, for: .normal)
        episodeID = episode.ID
        
        if episode.programID == Program.ID {
                self.programImageButton.setImage(Program.image, for: .normal)
        } else {
            CacheControl.loadImageFromFolderOrDownloadAndSave(programID: episode.programID, imageID: episode.imageID, imagePath: episode.imagePath) { image in
                DispatchQueue.main.async {
                    self.programImageButton.setImage(image, for: .normal)
                }
            }
        }
        
//        FileManager.getAndStoreImage(withUrl: episode.imagePath) { image in
//            DispatchQueue.main.async {
//                self.programImageButton.setImage(image, for: .normal)
//            }
//        }
        
        programNameLabel.text = episode.programName
        usernameLabel.text = "@\(episode.username)"
        timeSinceReleaseLabel.text = episode.addedAt
        
        // Episode caption
        CustomStyle.createCaptionWith(text: episode.caption, textView: captionTextView)
        
        episodeTags = episode.tags!
        createTagButtons()
        
        DispatchQueue.main.async {
            self.addGradient()
            if self.captionTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
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
            largeImageSize = 60
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
        programImageButton.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(programeNameStackedView)
        programeNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programeNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        programeNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programeNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 20).isActive = true
        
        programeNameStackedView.addArrangedSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        programeNameStackedView.addArrangedSubview(usernameLabel)
        
        self.addSubview(episodeSettingsButton)
        episodeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        episodeSettingsButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 0).isActive = true
        episodeSettingsButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -16).isActive = true
        
        self.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programeNameStackedView.bottomAnchor, constant: 2).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programeNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -35).isActive = true
        tagScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        
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
        timeSinceReleaseLabel.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
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
    
    func clearTagButtons() {
        for eachButton in tagButtons {
            eachButton.setTitle("", for: .normal)
        }
    }
    
    func addMoreButton() {
        DispatchQueue.main.async {
            if !self.unwrapped {
                self.captionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
                self.addSubview(self.moreButton)
                self.moreButton.translatesAutoresizingMaskIntoConstraints = false
                self.moreButton.bottomAnchor.constraint(equalTo: self.captionTextView.bottomAnchor).isActive = true
                self.moreButton.trailingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor).isActive = true
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
        return button
    }
    
    @objc func moreUnwrap() {
        unwrapped = true
        captionTextView.textContainer.maximumNumberOfLines = 0
        captionTextView.textContainer.exclusionPaths.removeAll()
        captionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    
    @objc func playEpisode() {
        cellDelegate?.playEpisode(cell: self )
    }
    
    @objc func showSettings() {
        cellDelegate?.showSettings(cell: self )
    }

}


