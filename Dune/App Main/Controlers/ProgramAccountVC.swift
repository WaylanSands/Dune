//
//  ProgramAccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ProgramAccountVC: UIViewController {
   
//    lazy var tagscrollViewWidth = tagScrollView.frame.width
    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 74.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
//    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topSection: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.darkestBlack
        return view
    }()
    
    let topStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10.0
        return view
    }()
    
    let largeUserImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "missing-image-large")
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let IntroButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryYellow
        button.layer.cornerRadius = 12.5
        button.setTitle("Play Intro", for: .normal)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        return button
    }()
    
    let topRightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10.0
        view.distribution = .fill
        return view
    }()
    
    let accountName: UILabel = {
        let label = UILabel()
        label.text = "The Daily"
        label.textColor = .white
        return label
    }()
    
    let summaryTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = 3
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = CustomStyle.secondShade
        view.text = "The Daily is a daily news podcast and radio show by the American newspaper The New York Times and all the other things that go in here and make lines wrap."
        view.backgroundColor = .clear
        return view
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        button.backgroundColor = CustomStyle.darkestBlack
        return button
    }()
    
    let summaryView: UIView = {
        let view = UIView()
        return view
    }()
    
//    let tagScrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isScrollEnabled = true
//        view.showsHorizontalScrollIndicator = false
//        view.contentInsetAdjustmentBehavior = .never
//        return view
//    }()
//
//    let gradientOverlayView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let tagContentView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let firstTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("News", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.white
//        return button
//    }()
//
//    let secondTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Breaking", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.white
//        return button
//    }()
//
//    let thirdTagButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Stories", for: .normal)
//        button.titleLabel?.textColor = CustomStyle.white
//        return button
//    }()
    
//    let statsStackedView: UIStackView = {
//        let view = UIStackView()
//        view.alignment = .leading
//        view.spacing = 20
//        return view
//    }()
    
    let subscriberStatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "12.2K Subscribed  |  4 Programs"
        return label
    }()
    
//    let episodeStatLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        label.text = "54 Episodes"
//        return label
//    }()
    
//    let programStatLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        label.text = "4 Programs"
//        return label
//    }()
    
    let buttonsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 10.0
        return view
    }()
    
    let programSelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Programs", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.titleLabel?.textColor = CustomStyle.white
        button.backgroundColor = CustomStyle.sixthShade
        button.setImage(UIImage(named: "dropdown-icon-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.layer.cornerRadius = 6
        return button
    }()
    
    let shareChannelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share Channel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.titleLabel?.textColor = CustomStyle.white
        button.backgroundColor = CustomStyle.sixthShade
        button.layer.cornerRadius = 6
        button.setImage(UIImage(named: "share-icon-white"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.setImage(#imageLiteral(resourceName: "switch-account-icon"), for: .normal)
        nav.backgroundColor = CustomStyle.darkestBlack
        nav.rightButton.setImage(#imageLiteral(resourceName: "white-settings-icon"), for: .normal)
        //        nav.rightButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        setupAccountLabel()
//        styleTags()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        addGradient()
        if summaryTextView.lineCount() > 3 {
            addMoreButton()
        }
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
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
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        scrollContentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollContentView.addSubview(topSection)
        topSection.translatesAutoresizingMaskIntoConstraints = false
        topSection.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        topSection.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor).isActive = true
        topSection.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor).isActive = true
        topSection.heightAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        topSection.addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight()).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16).isActive = true
        
        topStackView.addArrangedSubview(largeUserImage)
        largeUserImage.translatesAutoresizingMaskIntoConstraints = false
        largeUserImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        largeUserImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true

        
        scrollContentView.addSubview(IntroButton)
        IntroButton.translatesAutoresizingMaskIntoConstraints = false
        IntroButton.topAnchor.constraint(equalTo: largeUserImage.bottomAnchor, constant: 10).isActive = true
        IntroButton.leadingAnchor.constraint(equalTo: largeUserImage.leadingAnchor).isActive = true
        IntroButton.trailingAnchor.constraint(equalTo: largeUserImage.trailingAnchor).isActive = true
        IntroButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        topStackView.addArrangedSubview(topRightStackView)
        
        topRightStackView.addArrangedSubview(accountName)
        accountName.translatesAutoresizingMaskIntoConstraints = false
        accountName.topAnchor.constraint(equalTo: topRightStackView.topAnchor).isActive = true
        accountName.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
        accountName.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor).isActive = true
        accountName.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        topRightStackView.addArrangedSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        summaryView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: accountName.bottomAnchor, constant: 3).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor, constant: -4.0).isActive = true
        summaryViewHeight = summaryTextView.heightAnchor.constraint(equalToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
        summaryViewHeight.isActive = true
        
        scrollContentView.addSubview(subscriberStatLabel)
        subscriberStatLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberStatLabel.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 10).isActive = true
        subscriberStatLabel.leadingAnchor.constraint(equalTo: summaryTextView.leadingAnchor).isActive = true
        subscriberStatLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor,constant: -16).isActive = true
        
//        scrollContentView.addSubview(tagScrollView)
//        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
//        tagScrollView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 5).isActive = true
//        tagScrollView.leadingAnchor.constraint(equalTo: summaryTextView.leadingAnchor).isActive = true
//        tagScrollView.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        tagScrollView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor,constant: 10).isActive = true
//
//        tagScrollView.addSubview(tagContentView)
//        tagContentView.translatesAutoresizingMaskIntoConstraints = false
//        tagContentView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
//        tagContentView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
//        tagContentView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
//        tagContentView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
//        tagContentWidth = tagContentView.widthAnchor.constraint(equalToConstant: tagscrollViewWidth)
//        tagContentWidth.isActive = true
//
//        scrollContentView.addSubview(gradientOverlayView)
//        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
//        gradientOverlayView.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
//        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
//        gradientOverlayView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor, constant: 10).isActive = true
//        gradientOverlayView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
//
//        tagContentView.addSubview(firstTagButton)
//        firstTagButton.translatesAutoresizingMaskIntoConstraints = false
//        firstTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
//        firstTagButton.leadingAnchor.constraint(equalTo: tagContentView.leadingAnchor).isActive = true
//        firstTagButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//        tagContentView.addSubview(secondTagButton)
//        secondTagButton.translatesAutoresizingMaskIntoConstraints = false
//        secondTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
//        secondTagButton.leadingAnchor.constraint(equalTo: firstTagButton.trailingAnchor,constant: 6).isActive = true
//        secondTagButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//        tagContentView.addSubview(thirdTagButton)
//        thirdTagButton.translatesAutoresizingMaskIntoConstraints = false
//        thirdTagButton.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
//        thirdTagButton.leadingAnchor.constraint(equalTo: secondTagButton.trailingAnchor,constant: 6).isActive = true
//        thirdTagButton.heightAnchor.constraint(equalToConstant: 25).isA
        
        scrollContentView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: subscriberStatLabel.bottomAnchor, constant: 20.0).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16.0).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(programSelectionButton)
        buttonsStackedView.addArrangedSubview(shareChannelButton)

        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
//    func styleTags() {
//        for eachTag in tagButtons {
//            eachTag.backgroundColor = CustomStyle.primaryBlue
//            eachTag.layer.cornerRadius = 12.5
//            eachTag.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
//            eachTag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//            eachTag.isUserInteractionEnabled = false
//        }
//    }
    
    func addMoreButton() {
        scrollContentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: summaryTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: summaryTextView.font!.lineHeight).isActive = true
        
        let rect = CGRect(x: summaryTextView.frame.width - moreButton.intrinsicContentSize.width, y: summaryTextView.frame.height - summaryTextView.font!.lineHeight, width: moreButton.intrinsicContentSize.width + 4, height: summaryTextView.font!.lineHeight)
        let path = UIBezierPath(rect: rect)
        summaryTextView.textContainer.exclusionPaths = [path]
    }
    
    @objc func moreUnwrap() {
        summaryHeightClosed = summaryTextView.frame.height
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryViewHeight.constant = summaryTextView.intrinsicContentSize.height
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
        
//        let positionDifference = summaryTextView.intrinsicContentSize.height - summaryHeightClosed
        
        if UIDevice.current.deviceType == .iPhoneSE {
//            scrollHeight.constant = screenHeight + positionDifference
        }
        
//        summaryBarYPosition.constant = positionDifference + summaryBarPadding
        summaryTextView.layoutIfNeeded()
        scrollContentView.layoutIfNeeded()
//        summaryBar.layoutIfNeeded()
    }
    
//    func addGradient() {
//        let gradient = CAGradientLayer()
//        gradient.frame = gradientOverlayView.bounds
//        print(gradientOverlayView.bounds)
//        let color = CustomStyle.darkestBlack
//        gradient.colors = [color.withAlphaComponent(0.0).cgColor, color.withAlphaComponent(1.0).cgColor, color.withAlphaComponent(1.0).cgColor]
//        gradientOverlayView.layer.insertSublayer(gradient, at: 0)
//        gradientOverlayView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
//        gradientOverlayView.backgroundColor = .clear
//    }
    
    func setupAccountLabel() {
        let programName = "The Daily "
        let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .heavy)
        let programNameAttributedString = NSMutableAttributedString(string: programName)
        let programNameAttributes: [NSAttributedString.Key: Any] = [
            .font: programNameFont,
            .foregroundColor: CustomStyle.white
            
        ]
        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
        
        let userId = " @TheDaily"
        let userIdFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let userIdAttributedString = NSMutableAttributedString(string: userId)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
            .foregroundColor: CustomStyle.fithShade
        ]
        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
        programNameAttributedString.append(userIdAttributedString)
        accountName.attributedText = programNameAttributedString
    }
    
    
}
