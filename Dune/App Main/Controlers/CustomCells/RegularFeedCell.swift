//
//  RegularFeedCell.swift
//  Dune
//
//  Created by Waylan Sands on 18/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol UpdateRowsDelegate {
    func updateRows()
    func addtappedProgram(programName: String)
}

class RegularFeedCell: UITableViewCell {

    var name: String?
    var handel: String?
    var textIsWithinBounds = false
    var updateRowsDelegate: UpdateRowsDelegate?
    var moreButtonPress = false
    var largeImageSize: CGFloat = 65.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    let scrollPadding: CGFloat = 40.0
    var tagsUsed: [String] = []
    var cellHeight: NSLayoutConstraint!
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var deviceType = UIDevice.current.deviceType
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    var tagContentSizeWidth: CGFloat = 0

    let topStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10.0
        return view
    }()

    let programImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let topRightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    
    let topRightTopStackView: UIStackView = {
         let view = UIStackView()
         view.spacing = 10.0
         return view
     }()

    let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "The Daily"
        return label
    }()
    
    let episodeSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "episode-settings") , for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
//        button.backgroundColor = .blue
        return button
    }()

    lazy var summaryTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = 3
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = CustomStyle.primaryblack
        return view
    }()
    
    let moreButton: UIButton = {
        let button = ExtendedButton()
        button.padding = 20
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
//      button.backgroundColor = .green
        return button
    }()

    let summaryView: UIView = {
        let view = UIView()
        view.sizeToFit()
        return view
    }()

    let tagScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    let gradientOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()

    let tagContentView: UIView = {
        let view = UIView()
        return view
    }()

    let firstTagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()

    let secondTagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()

    let thirdTagButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.textColor = CustomStyle.fourthShade
        return button
    }()
    
    let releaseTime: UILabel = {
        let label = UILabel()
        label.text = "2h"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()


    override func awakeFromNib() {
        super.awakeFromNib()
        print("Step 4")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        styleForScreens()
        setupViews()
    }
    
    override func prepareForReuse() {
        clearTagButttons()
    }

    func normalSetUp(program: Program) {
        name = program.name
        handel = program.handel
        programImage.image = program.image
        summaryTextView.text = program.summary
        setupAccountLabel()
        tagsUsed = program.tags!
        styleTags()
        
        DispatchQueue.main.async {
            self.tagContentWidth.constant = self.firstTagButton.frame.width + self.secondTagButton.frame.width + self.thirdTagButton.frame.width + self.scrollPadding
            self.tagContentView.layoutIfNeeded()
            self.addGradient()
            if self.summaryTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
    }
        
    func refreshSetupMoreTapFalse() {
        summaryTextView.textContainer.maximumNumberOfLines = 3
        moreButton.isHidden = false
        moreButtonPress = false
    }
    
    func refreshSetupMoreTapTrue() {
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.textContainer.exclusionPaths.removeAll()
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

    func setupViews() {
        self.addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,  constant: 16).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true

        topStackView.addArrangedSubview(programImage)
        programImage.translatesAutoresizingMaskIntoConstraints = false
        programImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        programImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true

        topStackView.addArrangedSubview(topRightStackView)
        topRightStackView.addArrangedSubview(topRightTopStackView)
        
        topRightTopStackView.addArrangedSubview(accountLabel)
        topRightTopStackView.addArrangedSubview(episodeSettingsButton)
        episodeSettingsButton.translatesAutoresizingMaskIntoConstraints = false
        episodeSettingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        accountLabel.backgroundColor = .blue

        topRightStackView.addArrangedSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
        summaryView.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor).isActive = true

        summaryView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: summaryView.topAnchor).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -10).isActive = true
//        summaryTextView.backgroundColor = .blue


        self.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 5).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: summaryTextView.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor, constant: -20).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
//        tagScrollView.backgroundColor = .red


        tagScrollView.addSubview(tagContentView)
        tagContentView.translatesAutoresizingMaskIntoConstraints = false
        tagContentView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContentView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContentView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContentView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagContentWidth = tagContentView.widthAnchor.constraint(equalToConstant: 0)
        tagContentWidth.isActive = true

        self.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor, constant: -20).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true

        tagContentView.addSubview(firstTagButton)
        firstTagButton.translatesAutoresizingMaskIntoConstraints = false
        firstTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        firstTagButton.leadingAnchor.constraint(equalTo: tagContentView.leadingAnchor).isActive = true
        firstTagButton.heightAnchor.constraint(equalToConstant: 22).isActive = true

        tagContentView.addSubview(secondTagButton)
        secondTagButton.translatesAutoresizingMaskIntoConstraints = false
        secondTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        secondTagButton.leadingAnchor.constraint(equalTo: firstTagButton.trailingAnchor,constant: 6).isActive = true
        secondTagButton.heightAnchor.constraint(equalToConstant: 22).isActive = true

        tagContentView.addSubview(thirdTagButton)
        thirdTagButton.translatesAutoresizingMaskIntoConstraints = false
        thirdTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        thirdTagButton.leadingAnchor.constraint(equalTo: secondTagButton.trailingAnchor,constant: 6).isActive = true
        thirdTagButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(releaseTime)
        releaseTime.translatesAutoresizingMaskIntoConstraints = false
        releaseTime.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        releaseTime.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16).isActive = true
//        releaseTime.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func addMoreButton() {
        self.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: summaryTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: summaryTextView.font!.lineHeight).isActive = true
        self.bringSubviewToFront(moreButton)

        let rect = CGRect(x: summaryTextView.frame.width - moreButton.intrinsicContentSize.width - 5, y: summaryTextView.frame.height - summaryTextView.font!.lineHeight, width: moreButton.intrinsicContentSize.width, height: summaryTextView.font!.lineHeight - 2)
        let path = UIBezierPath(rect: rect)
        summaryTextView.textContainer.exclusionPaths = [path]
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
    
    func clearTagButttons() {
        for eachButton in tagButtons {
            eachButton.setTitle("", for: .normal)
        }
    }

    func styleTags() {
        for eachTag in tagsUsed {
            tagButtons[tagsUsed.firstIndex(of: eachTag)!].setTitle(eachTag, for: .normal)
            tagButtons[tagsUsed.firstIndex(of: eachTag)!].isHidden = false
        }
        
        for eachButton in tagButtons {
            if eachButton.titleLabel!.text == nil || eachButton.title(for: .normal) == "" {
                eachButton.isHidden = true
            }
            
            eachButton.backgroundColor = CustomStyle.secondShade
            eachButton.layer.cornerRadius = 11
            eachButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            eachButton.setTitleColor(CustomStyle.fourthShade, for: .normal)
            eachButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
            eachButton.isUserInteractionEnabled = false
        }
    }

    func setupAccountLabel() {
        let programName = name!
        let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .bold)
        let programNameAttributedString = NSMutableAttributedString(string: programName)
        let programNameAttributes: [NSAttributedString.Key: Any] = [
            .font: programNameFont,
            .foregroundColor: CustomStyle.sixthShade

        ]
        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))

        let userId = " \(handel!)"
        let userIdFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        let userIdAttributedString = NSMutableAttributedString(string: userId)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
            .foregroundColor: CustomStyle.linkBlue
        ]
        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
        programNameAttributedString.append(userIdAttributedString)
        accountLabel.attributedText = programNameAttributedString
    }
    
    @objc func moreUnwrap() {
        moreButtonPress = true
        moreButton.isHidden = true
        summaryTextView.textContainer.exclusionPaths.removeAll()
        updateRowsDelegate!.addtappedProgram(programName: name!)
        summaryTextView.textContainer.maximumNumberOfLines = 0
        updateRowsDelegate!.updateRows()
        DispatchQueue.main.async {
            self.summaryTextView.updateConstraints()
            self.updateRowsDelegate!.updateRows()
        }

    }
}

