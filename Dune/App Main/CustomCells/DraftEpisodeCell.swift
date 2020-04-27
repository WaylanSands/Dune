//
//  draftEpisodeCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol DraftCellDelegate {
    func selectedCell(programName: String)
    
}

class DraftEpisodeCell: UITableViewCell {
    
    var row: Int?
    var cellDelegate: DraftCellDelegate?
    let imageViewSize:CGFloat = 65.0
    var largeImageSize: CGFloat = 65.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var episodeTags: [String] = []
    var tagContentWidthConstraint: NSLayoutConstraint!
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
//    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    var tagContentSizeWidth: CGFloat = 0
    
    let cellContentView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.sixthShade
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    
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
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let datePostedLabel: UILabel = {
        let label = UILabel()
        label.text = "10th Dec"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.buttonBlue
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let captionTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.textContainer.maximumNumberOfLines = 2
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = .white
        view.backgroundColor = .clear
        return view
    }()
    
    let tagScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let tagContainingStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let gradientOverlayView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let tagContentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
//    let firstTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("one", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.fifthShade
//        return button
//    }()
//
//    let secondTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("two", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.fifthShade
//        return button
//    }()
//
//    let thirdTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("three", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.fifthShade
//        return button
//    }()
    
    let episodeDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        label.isUserInteractionEnabled = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        styleForScreens()
        configureViews()
    }
    
    override func prepareForReuse() {
//        clearTagButtons()
        captionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
        
    func normalSetUp(episode: DraftEpisode) {
        self.programImageButton.setImage(Program.image, for: .normal)
        
//        FileManager.getAndStoreImageInCustomFolder(withUrl: episode.imageURL) { image in
//            DispatchQueue.main.async {
//                self.programImageButton.setImage(image, for: .normal)
//            }
//        }
        
        programNameLabel.text = episode.programName
        usernameLabel.text = "@\(episode.username)"
        captionTextView.text = episode.caption
        datePostedLabel.text = episode.addedAt
        episodeDurationLabel.text = episode.duration
        
        episodeTags = episode.tags!
        createTagButtons()
        
        DispatchQueue.main.async {
            self.addGradient()
        }
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
        self.addSubview(cellContentView)
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        cellContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        cellContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        cellContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        cellContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        cellContentView.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: cellContentView.topAnchor, constant: 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: 14).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellContentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: cellContentView.trailingAnchor, constant: 20).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        programNameStackedView.addArrangedSubview(usernameLabel)
        
        cellContentView.addSubview(datePostedLabel)
        datePostedLabel.translatesAutoresizingMaskIntoConstraints = false
        datePostedLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 0).isActive = true
        datePostedLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellContentView.trailingAnchor, constant: -16).isActive = true
        
        cellContentView.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 4).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -16.0).isActive = true
        
        cellContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionTextView.leadingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor,constant: -35).isActive = true
        tagScrollView.bottomAnchor.constraint(equalTo: cellContentView.bottomAnchor, constant: -15).isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        
        cellContentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        cellContentView.addSubview(episodeDurationLabel)
        episodeDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeDurationLabel.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        episodeDurationLabel.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor,constant: -16).isActive = true
    }
    
    func addGradient() {
        if gradientOverlayView.layer.sublayers == nil {
            let gradient = CAGradientLayer()
            gradient.frame = gradientOverlayView.bounds
            let gradientColor = CustomStyle.sixthShade
            gradient.colors = [gradientColor.withAlphaComponent(0.0).cgColor, gradientColor.withAlphaComponent(1.0).cgColor, gradientColor.withAlphaComponent(1.0).cgColor]
            gradientOverlayView.layer.insertSublayer(gradient, at: 0)
            gradientOverlayView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
            gradientOverlayView.backgroundColor = .clear
        }
    }
    
//    func clearTagButtons() {
//        for eachButton in tagButtons {
//            eachButton.setTitle("", for: .normal)
//        }
//    }
    
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviewsCompletely()
        for eachTag in episodeTags {
            let button = tagButton(with: eachTag)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButton(with title: String) -> DraftTagButton {
        let button = DraftTagButton(title: title)
        button.isUserInteractionEnabled = false
        return button
    }
    
    @objc func playEpisode() {
//        cellDelegate?.playEpisode(cell: self )
    }

}


