//
//  PublisherTagController.swift
//  Snippets
//
//  Created by Waylan Sands on 11/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PublisherTagController: UIViewController, UITextViewDelegate  {
    
    var navbarHeight: CGFloat = 90.0
    var largeImageSize: CGFloat = 74.0
    var confirmPress = false
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var summaryBarPadding: CGFloat  = 45
    var accountSummary: String?
    let maxCharacters = 40
    var tagsUsed: [String] = []
    var tagsSelected = false
    var textPlacement = true
    var isTruncated = false
    var summaryHeightClosed: CGFloat = 0
    var tagsWidthAnchor: NSLayoutConstraint!
    var summaryViewHeightAnchor: NSLayoutConstraint!
    var scrollHeight: NSLayoutConstraint!
    var summaryBarYAnchor: NSLayoutConstraint!
    
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    lazy var screenHeight: CGFloat = view.frame.height
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.navBarTitleLabel.text = "Custom tags"
        navBar.skipButton.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
        navBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    // Styling device to device
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
    
    lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
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
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let topRightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10.0
        view.distribution = .fill
        return view
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "The Daily"
        return label
    }()
    
    let summaryTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = 3
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
        return view
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.fithShade, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    let summaryView: UIView = {
        let view = UIView()
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
    
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    
    
    let summaryBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let summaryBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Add three tags seperated by a space"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fithShade
        return label
    }()
    
    lazy var summaryBarCounter: UILabel = {
        let label = UILabel()
        label.text = String(maxCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let tagTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Write a short summary highlighting what your program iss about."
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = CustomStyle.fourthShade
        textView.isScrollEnabled = false
        return textView
    }()
    
    let floatingDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryblack
        return view
    }()
    
    let secondaryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "missing-imag-small")
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let secondaryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "The Daily"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let secondaryUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@TheDaily"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.2
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = CustomStyle.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        return button
    }()
    
    let bottomFill: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryblack
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        styleForScreens()
        setupViews()
        setupAccountLabel()
        styleTags()
        tagTextView.delegate = self
        summaryBarCounter.text = String(maxCharacters)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.tagTextView.becomeFirstResponder()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addGradient()
        let rect = CGRect(x: (summaryTextView.frame.width - moreButton.frame.width) + 4, y: summaryTextView.frame.height - moreButton.frame.height, width: moreButton.frame.width, height: summaryTextView.font!.lineHeight)
        
        let path = UIBezierPath(rect: rect)
        summaryTextView.textContainer.exclusionPaths = [path]
        print(summaryTextView.layoutManager.glyphRange(for: summaryTextView.textContainer).length)
        
        print(summaryTextView.text.count)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
            addFloatingView()
        case .iPhone8Plus:
            addFloatingView()
        case .iPhone11:
            addFloatingView()
            callBottomFill()
        case .iPhone11Pro:
            addFloatingView()
            callBottomFill()
        case .iPhone11ProMax:
            addFloatingView()
            callBottomFill()
        case .unknown:
            addFloatingView()
        }
    }
    
    func setupViews() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollHeight = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight)
        scrollHeight.isActive = true
        
        scrollContentView.addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: dynamicNavbarHeight + 15.0 ).isActive = true
        topStackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        topStackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16).isActive = true
        
        topStackView.addArrangedSubview(largeUserImage)
        largeUserImage.translatesAutoresizingMaskIntoConstraints = false
        largeUserImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        largeUserImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        
        topStackView.addArrangedSubview(topRightStackView)
        
        topRightStackView.addArrangedSubview(accountLabel)
        accountLabel.translatesAutoresizingMaskIntoConstraints = false
        accountLabel.topAnchor.constraint(equalTo: topRightStackView.topAnchor).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
        accountLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        topRightStackView.addArrangedSubview(summaryView)
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        summaryView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: accountLabel.bottomAnchor).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor, constant: -20.0).isActive = true
        summaryViewHeightAnchor = summaryTextView.heightAnchor.constraint(equalToConstant: (summaryTextView.font!.lineHeight * 3) + 1 )
        summaryViewHeightAnchor.isActive = true
        
        scrollContentView.addSubview(moreButton)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.bottomAnchor.constraint(equalTo: summaryTextView.bottomAnchor).isActive = true
        moreButton.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor).isActive = true
        moreButton.heightAnchor.constraint(equalToConstant: summaryTextView.font!.lineHeight).isActive = true
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 5).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: summaryTextView.leadingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor,constant: 10).isActive = true
        
        tagScrollView.addSubview(tagContentView)
        tagContentView.translatesAutoresizingMaskIntoConstraints = false
        tagContentView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContentView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContentView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContentView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagsWidthAnchor = tagContentView.widthAnchor.constraint(equalToConstant: tagscrollViewWidth)
        tagsWidthAnchor.isActive = true
        
        scrollContentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: summaryTextView.trailingAnchor, constant: 10).isActive = true
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
        
        scrollContentView.addSubview(summaryBar)
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        summaryBarYAnchor = summaryBar.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: summaryBarPadding)
        summaryBarYAnchor.isActive = true
        summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        summaryBar.addSubview(summaryBarLabel)
        summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
        
        summaryBar.addSubview(summaryBarCounter)
        summaryBarCounter.translatesAutoresizingMaskIntoConstraints = false
        summaryBarCounter.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryBarCounter.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(tagTextView)
        tagTextView.translatesAutoresizingMaskIntoConstraints = false
        tagTextView.topAnchor.constraint(equalTo: summaryBarCounter.bottomAnchor, constant: 15.0).isActive = true
        tagTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        tagTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        let newPosition = self.tagTextView.beginningOfDocument
        self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: newPosition, to: newPosition)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
        
        if view.subviews.contains(passThoughView) {
            view.bringSubviewToFront(passThoughView)
        }
    }
    
    func addFloatingView() {
        view.addSubview(passThoughView)
        
        passThoughView.addSubview(floatingDetailsView)
        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        floatingDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        floatingDetailsView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
        
        floatingDetailsView.addSubview(secondaryImageView)
        secondaryImageView.translatesAutoresizingMaskIntoConstraints = false
        secondaryImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
        secondaryImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
        secondaryImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        secondaryImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        floatingDetailsView.addSubview(secondaryNameLabel)
        secondaryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryNameLabel.topAnchor.constraint(equalTo: floatingDetailsView.topAnchor, constant: 12.0).isActive = true
        secondaryNameLabel.leadingAnchor.constraint(equalTo: secondaryImageView.trailingAnchor, constant: 10.0).isActive = true
        secondaryNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        floatingDetailsView.addSubview(secondaryUserNameLabel)
        secondaryUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryUserNameLabel.topAnchor.constraint(equalTo: secondaryNameLabel.bottomAnchor).isActive = true
        secondaryUserNameLabel.leadingAnchor.constraint(equalTo: secondaryNameLabel.leadingAnchor).isActive = true
        secondaryUserNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        floatingDetailsView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    }
    
    func callBottomFill() {
        view.addSubview(bottomFill)
        view.sendSubviewToBack(bottomFill)
        bottomFill.translatesAutoresizingMaskIntoConstraints = false
        bottomFill.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomFill.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomFill.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomFill.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientOverlayView.bounds
        print(gradientOverlayView.bounds)
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        gradientOverlayView.layer.insertSublayer(gradient, at: 0)
        gradientOverlayView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
        gradientOverlayView.backgroundColor = .clear
    }
    
    func styleTags() {
        for eachTag in tagButtons {
            eachTag.setTitle("", for: .normal)
            eachTag.backgroundColor = CustomStyle.secondShade
            eachTag.layer.cornerRadius = 11
            eachTag.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            eachTag.setTitleColor(CustomStyle.fourthShade, for: .normal)
            eachTag.isHidden = true
            eachTag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            eachTag.isUserInteractionEnabled = false
        }
    }
    
    func updateCharacterCount(textView: UITextView) {
        summaryBarCounter.text =  String(maxCharacters - textView.text!.count)
        
        if Int(summaryBarCounter.text!)! < 0 {
            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            summaryBarCounter.textColor = CustomStyle.primaryBlue
        } else {
            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            summaryBarCounter.textColor = CustomStyle.fourthShade
        }
    }
    
    func updateWidthWith() {
        var totalWidth: CGFloat
        let scrollPadding: CGFloat = 18.0
        
        totalWidth = firstTagButton.frame.width + secondTagButton.frame.width + thirdTagButton.frame.width + scrollPadding
        
        if totalWidth > tagScrollView.frame.width {
            tagsWidthAnchor.constant = totalWidth
        } else {
             tagsWidthAnchor.constant = tagScrollView.frame.width
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  floatingDetailsView.frame.height
    }
    
    func setupAccountLabel() {
        let programName = "The Daily "
        let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .bold)
        let programNameAttributedString = NSMutableAttributedString(string: programName)
        let programNameAttributes: [NSAttributedString.Key: Any] = [
            .font: programNameFont,
            .foregroundColor: CustomStyle.sixthShade
            
        ]
        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
        
        let userId = " @TheDaily"
        let userIdFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        let userIdAttributedString = NSMutableAttributedString(string: userId)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
            .foregroundColor: CustomStyle.fourthShade
        ]
        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
        programNameAttributedString.append(userIdAttributedString)
        accountLabel.attributedText = programNameAttributedString
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tagTextView.textColor == CustomStyle.fourthShade {
            tagTextView.text = nil
            tagTextView.textColor = CustomStyle.primaryblack
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
            updateCharacterCount(textView: textView)
            
            tagsUsed = textView.text.split(separator: " ").map { String($0) }
            print(tagsUsed)
            
            switch tagsUsed.count {
            case 0:
                firstTagButton.isHidden = true
                secondTagButton.isHidden = true
                thirdTagButton.isHidden = true
            case 1:
                firstTagButton.setTitle(tagsUsed[0], for: .normal)
                firstTagButton.isHidden = false
                secondTagButton.isHidden = true
                thirdTagButton.isHidden = true
                updateWidthWith()
            case 2:
                secondTagButton.setTitle(tagsUsed[1], for: .normal)
                secondTagButton.isHidden = false
                thirdTagButton.isHidden = true
                updateWidthWith()
            case 3:
                thirdTagButton.setTitle(tagsUsed[2], for: .normal)
                thirdTagButton.isHidden = false
                updateWidthWith()
            default:
                return
            }
        
        if tagTextView.text.isEmpty {
//            returnScreenToSize()
        }
    }
    
    func returnScreenToSize() {
        self.tagTextView.text = "Write a short summary highlighting what your program iss about."
        self.tagTextView.textColor = CustomStyle.fourthShade
        
        let newPosition = self.tagTextView.beginningOfDocument
        self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: newPosition, to: newPosition)
        self.textPlacement = true
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(tagsSelected)
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }
        
        let tagCount = textView.text.filter() {$0 == " "}.count
        return tagsUsed.count < 4 && tagCount <= 2
    }
    
    @objc func moreUnwrap() {
        summaryHeightClosed = summaryTextView.frame.height
        summaryTextView.textContainer.maximumNumberOfLines = 0
        moreButton.removeFromSuperview()

        let positionDifference = summaryTextView.intrinsicContentSize.height - summaryHeightClosed
        
        if deviceType == .iPhoneSE {
            scrollHeight.constant = screenHeight + positionDifference
        }
        
        summaryViewHeightAnchor.constant = summaryTextView.intrinsicContentSize.height
        summaryBarYAnchor.constant = positionDifference + summaryBarPadding
        scrollContentView.layoutIfNeeded()
        summaryTextView.layoutIfNeeded()
        summaryBar.layoutIfNeeded()
    }
    
    @objc func skipButtonPress() {
        print("Skip")
    }
    
    @objc func backButtonPress() {
        tagTextView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmButtonPress() {
        tagTextView.resignFirstResponder()
    }
}

