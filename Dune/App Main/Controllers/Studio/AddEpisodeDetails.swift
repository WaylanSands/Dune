//
//  AddEpisodeDetails.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import ActiveLabel
import AVFoundation
import SwiftLinkPreview

class AddEpisodeDetails: UIViewController {
    
    let maxCaptionCharacters = 240
    let maxTagCharacters = 45
    
    var selectedProgram: Program?
    var isDraft = false
    var draftID: String?
    
    var episodeFileName: String?
    var recordingURL: URL!
    var wasTrimmed = false
    var startTime: Double = 0
    var endTime: Double = 0
    var duration: Double!
    
    var richLink: String?
    var linkIsSmall: Bool?
    var linkButton: RichLinkGenerator!
    var richLinkPresented = false
    
    // For screen-size adjustment
    var imageViewSize:CGFloat = 55.0
    var floatingBarHeight:CGFloat = 65.0
    var imageBarViewSize:CGFloat = 45.0
    var scrollHeightPadding: CGFloat = 60
    
    var scrollContentHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    var captionPlaceholderIsActive = true
    var captionLabelPlaceholderText = true
    var tagPlaceholderIsActive = true
    var tagsUsed = [String]()
    var tagCount: Int = 0
    var caption: String?
    
    var successfulStorage = false
    var successfulStore = false
    
    lazy var screenHeight = view.frame.height
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    
    let hashTagAlert = CustomAlertView(alertType: .hashTagUsed)
    let unsafeLinkAlert = CustomAlertView(alertType: .linkNotSecure)
    
    let swiftLinkPreview = SwiftLinkPreview(session: URLSession.shared, workQueue: SwiftLinkPreview.defaultWorkQueue, responseQueue: DispatchQueue.main, cache: DisabledCache.instance)
    
    var networkingIndicator = NetworkingProgress()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()
    
    let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.seventhShade
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.handleMentionTap { userHandle in print("\(userHandle) tapped") }
        label.mentionColor = CustomStyle.linkBlue
        label.enabledTypes = [.mention]
        return label
    }()
    
    let linkStackedView: UIStackView = {
        let view = UIStackView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let linkCoverView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(linkTouched), for: .touchUpInside)
        return button
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
    
    lazy var firstTagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let secondTagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let thirdTagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let captionBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let captionBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode caption"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var captionCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxCaptionCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add a caption to your episode."
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 12
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        return textView
    }()
    
    let tagBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let tagBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Episodes tags"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var tagCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxCaptionCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let tagTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add three tags"
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.autocapitalizationType = .none
        return textView
    }()
    
    lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
    
    let floatingDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryBlack
        return view
    }()
    
    let bottomBarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let bottomBarProgramNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let bottomBarUsernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let publishButton: UIButton = {
        let button = UIButton()
        button.alpha = 0.2
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = CustomStyle.white.cgColor
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.layer.borderWidth = 1
        button.setTitle("Publish", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.addTarget(self, action: #selector(publishButtonPress), for: .touchUpInside)
        button.addTarget(self, action: #selector(publishButtonTouch), for: .touchDown)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        button.isEnabled = false
        return button
    }()
    
    
    let bottomFill: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryBlack
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTagButtonsWithTags()
        removeEmptyTags()
        configureNavBar()
        checkIfAbleToPublish()
        styleForScreens()
        setupViews()
        addFloatingView()
        captionTextView.delegate = self
        tagTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if caption != nil {
            captionLabel.text = caption
            captionTextView.text = caption
            captionLabel.textColor = CustomStyle.sixthShade
            captionTextView.textColor = CustomStyle.fifthShade
            captionPlaceholderIsActive = false
        }
        
        let startPosition: UITextPosition = self.captionTextView.beginningOfDocument
        self.captionTextView.selectedTextRange = self.captionTextView.textRange(from: startPosition, to: startPosition)
        self.floatingDetailsView.frame.origin.y =  self.view.frame.height - ( self.floatingDetailsView.frame.height +  self.homeIndicatorHeight)
        setProgramImage()
        
        if selectedProgram == nil {
            programNameLabel.text = CurrentProgram.name
            bottomBarProgramNameLabel.text = CurrentProgram.name
        } else {
            programNameLabel.text = selectedProgram!.name
            bottomBarProgramNameLabel.text = selectedProgram!.name
        }
        
        usernameLabel.text = "@\(User.username!)"
        bottomBarUsernameLabel.text = "@\(User.username!)"
        
        successfulStorage = false
        successfulStore = false
    }
    
    func setUpTagButtonsWithTags() {
        if !tagsUsed.isEmpty {
            tagTextView.text = ""
            tagTextView.textColor = CustomStyle.fifthShade
            tagPlaceholderIsActive = false
            
            for (index, item) in tagsUsed.enumerated() {
                tagCount += 1
                
                if index < 2 {
                    tagTextView.text.append("\(item) ")
                } else {
                    tagTextView.text.append("\(item)")
                }
                
                switch index {
                case 0:
                    firstTagButton.setTitle(item, for: .normal)
                case 1:
                    secondTagButton.setTitle(item, for: .normal)
                case 2:
                    thirdTagButton.setTitle(item, for: .normal)
                default:
                    break
                }
            }
        }
    }
    
    func removeEmptyTags() {
        for eachTag in tagButtons {
            if eachTag.titleLabel?.text == nil {
                eachTag.setTitle("", for: .normal)
                eachTag.isHidden = true
            }
        }
        tagCounterLabel.text = String(maxTagCharacters - tagTextView.text.count)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captionTextView.becomeFirstResponder()
        checkIfAbleToPublish()
        addGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captionTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func setProgramImage() {
        
        if selectedProgram == nil {
            mainImage.image = CurrentProgram.image
            bottomBarImageView.image = CurrentProgram.image
        } else {
            mainImage.image = selectedProgram!.image
            bottomBarImageView.image = selectedProgram!.image
        }
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  floatingDetailsView.frame.height
    }
    
    func configureNavBar() {
        self.title = "New Episode"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-button-white"), style: .plain, target: self, action: #selector(popVC))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPress))
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
     
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhoneSE:
            floatingBarHeight = 50.0
            imageBarViewSize = 36.0
            scrollHeightPadding = 140
            imageViewSize = 50
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
        default:
            break
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight + scrollHeightPadding)
        scrollContentHeightConstraint.isActive = true
        
        scrollContentView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight() + 15).isActive = true
        mainImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        scrollContentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20).isActive = true
        
        programNameStackedView.addArrangedSubview(programNameLabel)
        programNameStackedView.addArrangedSubview(usernameLabel)
        
        scrollContentView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 2).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
        
        scrollContentView.addSubview(linkStackedView)
        linkStackedView.translatesAutoresizingMaskIntoConstraints = false
        linkStackedView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
        linkStackedView.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        linkStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: linkStackedView.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: captionLabel.trailingAnchor,constant: 10).isActive = true
        
        tagScrollView.addSubview(tagContentView)
        tagContentView.translatesAutoresizingMaskIntoConstraints = false
        tagContentView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContentView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContentView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContentView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
        tagContentWidthConstraint = tagContentView.widthAnchor.constraint(equalToConstant: tagScrollViewWidth)
        tagContentWidthConstraint.isActive = true
        
        scrollContentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagContentView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor).isActive = true
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
        
        scrollContentView.addSubview(captionBar)
        captionBar.translatesAutoresizingMaskIntoConstraints = false
        captionBar.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        captionBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        captionBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        captionBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        captionBar.addSubview(captionBarLabel)
        captionBarLabel.translatesAutoresizingMaskIntoConstraints = false
        captionBarLabel.centerYAnchor.constraint(equalTo: captionBar.centerYAnchor).isActive = true
        captionBarLabel.leadingAnchor.constraint(equalTo: captionBar.leadingAnchor, constant: 16).isActive = true
        
        captionBar.addSubview(captionCounterLabel)
        captionCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        captionCounterLabel.centerYAnchor.constraint(equalTo: captionBar.centerYAnchor).isActive = true
        captionCounterLabel.trailingAnchor.constraint(equalTo: captionBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: captionBar.bottomAnchor, constant: 10).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
        captionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        scrollContentView.addSubview(tagBar)
        tagBar.translatesAutoresizingMaskIntoConstraints = false
        tagBar.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 10).isActive = true
        tagBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tagBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        tagBar.addSubview(tagBarLabel)
        tagBarLabel.translatesAutoresizingMaskIntoConstraints = false
        tagBarLabel.centerYAnchor.constraint(equalTo: tagBar.centerYAnchor).isActive = true
        tagBarLabel.leadingAnchor.constraint(equalTo: tagBar.leadingAnchor, constant: 16).isActive = true
        
        tagBar.addSubview(tagCounterLabel)
        tagCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        tagCounterLabel.centerYAnchor.constraint(equalTo: tagBar.centerYAnchor).isActive = true
        tagCounterLabel.trailingAnchor.constraint(equalTo: tagBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(tagTextView)
        tagTextView.translatesAutoresizingMaskIntoConstraints = false
        tagTextView.topAnchor.constraint(equalTo: tagBar.bottomAnchor, constant: 10).isActive = true
        tagTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        tagTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addFloatingView() {
        view.addSubview(passThoughView)
        passThoughView.addSubview(floatingDetailsView)
        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        floatingDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        floatingDetailsView.heightAnchor.constraint(equalToConstant: floatingBarHeight).isActive = true
        
        floatingDetailsView.addSubview(bottomBarImageView)
        bottomBarImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
        bottomBarImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
        bottomBarImageView.heightAnchor.constraint(equalToConstant: imageBarViewSize).isActive = true
        bottomBarImageView.widthAnchor.constraint(equalToConstant: imageBarViewSize).isActive = true
        
        floatingDetailsView.addSubview(bottomBarProgramNameLabel)
        bottomBarProgramNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarProgramNameLabel.topAnchor.constraint(equalTo: bottomBarImageView.topAnchor, constant: 1).isActive = true
        bottomBarProgramNameLabel.leadingAnchor.constraint(equalTo: bottomBarImageView.trailingAnchor, constant: 10.0).isActive = true
        
        floatingDetailsView.addSubview(bottomBarUsernameLabel)
        bottomBarUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarUsernameLabel.topAnchor.constraint(equalTo: bottomBarProgramNameLabel.bottomAnchor).isActive = true
        bottomBarUsernameLabel.leadingAnchor.constraint(equalTo: bottomBarProgramNameLabel.leadingAnchor).isActive = true
        
        floatingDetailsView.addSubview(publishButton)
        publishButton.translatesAutoresizingMaskIntoConstraints = false
        publishButton.centerYAnchor.constraint(equalTo: bottomBarImageView.centerYAnchor).isActive = true
        publishButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
        publishButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
    }
    
    func addBottomFill() {
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
            //            eachTag.isHidden = true
            eachTag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
            eachTag.isUserInteractionEnabled = false
        }
    }
    
    func updateCharacterCount(textView: UITextView) {
        
        if !captionPlaceholderIsActive {
            captionCounterLabel.text =  String(maxCaptionCharacters - captionTextView.text!.count)
        } else {
            captionCounterLabel.text =  String(maxCaptionCharacters)
        }
        
        if !tagPlaceholderIsActive {
            tagCounterLabel.text =  String(maxTagCharacters - tagTextView.text!.count)
        } else {
            tagCounterLabel.text =  String(maxTagCharacters)
        }
        
        if Int(captionCounterLabel.text!)! < 0 {
            captionCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            captionCounterLabel.textColor = CustomStyle.warningRed
        } else {
            captionCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            captionCounterLabel.textColor = CustomStyle.fourthShade
        }
        
        if Int(tagCounterLabel.text!)! < 0 {
            tagCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            tagCounterLabel.textColor = CustomStyle.warningRed
        } else {
            tagCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            tagCounterLabel.textColor = CustomStyle.fourthShade
        }
    }
    
    func updateTagContentWidth() {
        var totalWidth: CGFloat
        let scrollPadding: CGFloat = 18.0
        
        totalWidth = firstTagButton.frame.width + secondTagButton.frame.width + thirdTagButton.frame.width + scrollPadding
        
        if totalWidth > tagScrollView.frame.width {
            tagContentWidthConstraint.constant = totalWidth
        } else {
            tagContentWidthConstraint.constant = tagScrollView.frame.width
        }
    }
    
    func addCaptionPlaceholderText() {
        DispatchQueue.main.async {
            self.captionTextView.text = "Add a caption to your episode."
            let startPosition: UITextPosition = self.captionTextView.beginningOfDocument
            self.captionTextView.selectedTextRange = self.captionTextView.textRange(from: startPosition, to: startPosition)
            self.captionTextView.textColor = CustomStyle.fourthShade
            self.captionPlaceholderIsActive = true
            
            self.captionLabel.text = "placeholder"
            self.captionLabel.textColor = .white
            self.disablePublishButton()
        }
    }
    
    func addTagPlaceholderText() {
        DispatchQueue.main.async {
            self.tagTextView.text = "Add three tags"
            let startPosition: UITextPosition = self.tagTextView.beginningOfDocument
            self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: startPosition, to: startPosition)
            self.tagTextView.textColor = CustomStyle.fourthShade
            self.tagPlaceholderIsActive = true
        }
    }
    
    func enablePublishButton() {
        publishButton.isEnabled = true
        publishButton.alpha = 1
    }
    
    func disablePublishButton() {
        publishButton.isEnabled = false
        publishButton.alpha = 0.2
    }
    
    @objc func publishButtonTouch() {
        publishButton.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
    }
    
    
    // MARK: Save Episode
    
    @objc func saveButtonPress() {
        print("Storing draft episode on Firebase")
        print("Is a draft? \(isDraft)")
        networkingIndicator.taskLabel.text = "Saving Episode"
        UIApplication.shared.windows.last?.addSubview(networkingIndicator)
        
        let fileExtension = ".\(recordingURL.pathExtension)"
        
        let audioTrack = FileManager.getAudioFileFromTempDirectory(fileName: episodeFileName!, fileExtension: fileExtension)
        
        guard let episode = audioTrack else { return }
        
        var programID: String
        var programName: String
        
        if selectedProgram == nil {
            programID = CurrentProgram.ID!
            programName = CurrentProgram.name!
        } else {
            programID = selectedProgram!.ID
            programName = selectedProgram!.name
        }
        
        var audioID: String
        var ID: String
        
        if episodeFileName!.contains(".") {
            audioID = episodeFileName!
        } else {
            audioID = episodeFileName! + fileExtension
        }
        
        if isDraft {
            ID = self.draftID!
            User.draftEpisodeIDs?.removeAll(where: { $0 == ID})
        } else {
            ID = NSUUID().uuidString
        }
        
        print("Content before \(FileManager.printContentsOfTempDirectory())")
        FireStorageManager.storeDraftEpisodeAudio(audioID: audioID, data: episode) {  url in
            print("This was the ID \(audioID)")
            
            let length = String.timeString(time: self.duration)
            FireStoreManager.saveDraftEpisode(ID: ID, fileName: audioID, programID: programID, programName: programName, wasTrimmed: self.wasTrimmed, startTime: self.startTime, endTime: self.endTime, caption: self.captionTextView.text, tags: self.tagsUsed, audioURL: url, duration: length) { success in
                if success {
                    self.presentStudioVC()
                    FileManager.removeFileFromTempDirectory(fileName: self.episodeFileName! + fileExtension)
                    print("Content after \(FileManager.printContentsOfTempDirectory())")
                }
            }
        }
    }
    
    // MARK: Publish Episode
    func storePublishedEpisodeOnFirebase() {
        print("Storing episode on Firebase")
        
        var linkImage: UIImage!
        
        if self.linkButton != nil {
            if self.linkButton.largeImage != nil {
                self.linkIsSmall = false
                linkImage = self.linkButton.largeImage!
            } else if self.linkButton.squareImage != nil {
                self.linkIsSmall = true
                linkImage = self.linkButton.squareImage!
            } else {
                richLinkPresented = false
            }
        } else {
            richLinkPresented = false
        }
        
        print(richLinkPresented)
        
        var caption = captionTextView.text!
        caption = caption.trimmingTrailingSpaces
        
        let fileExtension = ".\(recordingURL.pathExtension)"
        let audioTrack = FileManager.getAudioFileFromTempDirectory(fileName: episodeFileName!, fileExtension: fileExtension)
        
        guard let episode = audioTrack else { return }
        
        var programID: String
        var programName: String
        var imageID: String
        var imagePath: String
        
        if selectedProgram == nil {
            programID = CurrentProgram.ID!
            programName = CurrentProgram.name!
            imageID =  CurrentProgram.imageID!
            imagePath = CurrentProgram.imagePath!
        } else {
            programID = selectedProgram!.ID
            programName = selectedProgram!.name
            imageID = selectedProgram!.imageID!
            imagePath = selectedProgram!.imagePath!
        }
        
        if isDraft {
            User.draftEpisodeIDs?.removeAll(where: { $0 == draftID })
            FireStoreManager.deleteDraftEpisodeWith(ID: draftID!)
            FireStoreManager.removeDraftIDFromUser(episodeID: draftID!)
            FireStorageManager.deleteDraftFileFromStorage(fileName: episodeFileName!)
        }
        
        var fileName: String
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: episodeFileName!, rep: 5)
        
        if episodeFileName!.contains(".") {
            fileName = episodeFileName!
        } else {
            fileName = episodeFileName! + fileExtension
        }
        
        FireStorageManager.storeEpisodeAudio(fileName: fileName, data: episode) { url in
            let length = String.timeString(time: self.duration)
            
            if self.richLinkPresented {
                FireStoreManager.publishEpisodeWithLinkMedia(programID: programID, imageID: imageID, imagePath: imagePath, programName: programName, caption: caption, richLink: self.richLink!, linkIsSmall: self.linkIsSmall!, linkImage: linkImage, linkHeadline: self.linkButton.mainTitle!, canonicalUrl: self.linkButton.canonicalUrl!, tags: self.tagsUsed, audioID: fileName, audioURL: url, duration: length) { success in
                    if success {
                        self.presentDailyFeedVC()
                    }
                }
            } else {
                
                FireStoreManager.publishEpisode(programID: programID, imageID: imageID, imagePath: imagePath, programName: programName, caption: caption, tags: self.tagsUsed, audioID: fileName, audioURL: url, duration: length) { success in
                    if success {
                        self.presentDailyFeedVC()
                    }
                }
            }
        }
    }
    
    func linkWithPrefix(urlString: String) -> String {
        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            print("Added https")
            return "https://\(urlString)"
        } else if urlString.hasPrefix("http://") {
            let url = urlString.dropFirst("http://".count)
            print("switched to https")
            return "https://" + url
        } else {
            return urlString
        }
    }
    
    func storeTrimmedEpisodeOnFirebase(fileName: String, url: URL) {
        print("Storing episode on Firebase")
        let audioTrack = FileManager.getTrimmedAudioFileFromTempDirectory(fileName: fileName)
        
        var linkImage: UIImage!
        
        if self.linkButton != nil {
            if self.linkButton.largeImage != nil {
                self.linkIsSmall = false
                linkImage = self.linkButton.largeImage!
            } else if self.linkButton.squareImage != nil {
                linkImage = self.linkButton.squareImage!
                self.linkIsSmall = true
            } else {
                richLinkPresented = false
            }
        } else {
            richLinkPresented = false
        }
        
        var caption = captionTextView.text!
        caption = caption.trimmingTrailingSpaces
        
        guard let episode = audioTrack else { return }
        
        var programID: String
        var programName: String
        var imageID: String
        var imagePath: String
        
        if selectedProgram == nil {
            programID = CurrentProgram.ID!
            programName = CurrentProgram.name!
            imageID =  CurrentProgram.imageID!
            imagePath = CurrentProgram.imagePath!
        } else {
            programID = selectedProgram!.ID
            programName = selectedProgram!.name
            imageID = selectedProgram!.imageID!
            imagePath = selectedProgram!.imagePath!
        }
        
        if isDraft {
            User.draftEpisodeIDs?.removeAll(where: { $0 == draftID })
            FireStoreManager.deleteDraftEpisodeWith(ID: draftID!)
            FireStoreManager.removeDraftIDFromUser(episodeID: draftID!)
            FireStorageManager.deleteDraftFileFromStorage(fileName: episodeFileName!)
        }
        
        FireStorageManager.storeEpisodeAudio(fileName: fileName, data: episode) { url in
            
            let length = String.timeString(time: self.duration)
            
            if self.richLinkPresented {
                FireStoreManager.publishEpisodeWithLinkMedia(programID: programID, imageID: imageID, imagePath: imagePath, programName: programName, caption: caption, richLink: self.richLink!, linkIsSmall: self.linkIsSmall!, linkImage: linkImage, linkHeadline: self.linkButton.mainTitle!, canonicalUrl: self.linkButton.canonicalUrl!, tags: self.tagsUsed, audioID: fileName, audioURL: url, duration: length) { success in
                    if success {
                        self.presentDailyFeedVC()
                    }
                }
            } else {
                FireStoreManager.publishEpisode(programID: programID, imageID: imageID, imagePath: imagePath, programName: programName, caption: caption, tags: self.tagsUsed, audioID: fileName, audioURL: url, duration: length) { success in
                    if success {
                        self.presentDailyFeedVC()
                    }
                }
            }
        }
    }
    
    func presentStudioVC() {
        networkingIndicator.removeFromSuperview()
//        duneTabBar.tabButtonSelection(2)
        duneTabBar.visit(screen: .studio)

//        let tabBar = MainTabController()
//        tabBar.selectedIndex = 2
//        DuneDelegate.newRootView(tabBar)
    }
    
    @objc func publishButtonPress() {
        UIApplication.shared.windows.last?.addSubview(networkingIndicator)
        publishButton.layer.borderColor = CustomStyle.white.cgColor
        networkingIndicator.taskLabel.text = "Publishing Episode"
        
        if wasTrimmed {
            trimThanStoreEpisodeOnFirebase()
        } else {
            storePublishedEpisodeOnFirebase()
        }
    }
    
    func presentDailyFeedVC() {
        networkingIndicator.removeFromSuperview()
//        let tabBar = MainTabController()
        duneTabBar.isHidden = false
        duneTabBar.visit(screen: .dailyFeed)
//        duneTabBar.tabButtonSelection(0)
    }
    
    func trimThanStoreEpisodeOnFirebase() {
        let fileName = "\(NSUUID().uuidString).m4a"
        
        let asset = AVAsset(url: recordingURL)
        let tempDirectory = FileManager.getTempDirectory()
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        let filePath = fileURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try fileManager.removeItem(atPath: filePath)
                print("Removing file from \(fileURL.path)")
            }
            catch {
                print("Couldn't remove existing destination file: \(error)")
            }
        }
        print("creating export session")
        
        if let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
            exporter.outputFileType = AVFileType.m4a
            exporter.outputURL = fileURL
            
            let start = CMTime(seconds: startTime, preferredTimescale: 1)
            let stop = CMTime(seconds: duration, preferredTimescale: 1)
            exporter.timeRange = CMTimeRangeFromTimeToTime(start: start, end: stop)
            
            
            exporter.exportAsynchronously(completionHandler: {
                switch exporter.status {
                case AVAssetExportSessionStatus.failed:
                    print("failed \(exporter.error!)")
                case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(exporter.error!)")
                case AVAssetExportSessionStatus.unknown:
                    print("unknown\(exporter.error!)")
                case AVAssetExportSessionStatus.waiting:
                    print("waiting\(exporter.error!)")
                case AVAssetExportSessionStatus.exporting:
                    print("exporting\(exporter.error!)")
                default:
                    print("complete")
                    DispatchQueue.main.async {
                        self.storeTrimmedEpisodeOnFirebase(fileName: fileName, url: fileURL)
                    }
                }
            })
        } else {
            print("cannot create AVAssetExportSession for asset \(asset)")
        }
    }
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    func checkIfAbleToPublish() {
        if captionPlaceholderIsActive == false && captionTextView.text.count < maxCaptionCharacters && tagTextView.text.count < maxTagCharacters {
            enablePublishButton()
        } else {
            disablePublishButton()
        }
    }
    
    // MARK: Creating Rich Link
    
    func checkIfLinkWasCreatedWith(input: String) {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        if matches.count > 0 && richLinkPresented == false {
            let range = Range(matches[0].range, in: input)!
            let url = input[range]
            let urlString = String(url)
            richLink = linkWithPrefix(urlString: urlString)
            swiftLinkPreview.preview(richLink!, onSuccess: { result in
                DispatchQueue.main.async {
                    
                    self.linkButton = RichLinkGenerator(response: result)
                    
                    if self.linkButton.linkIsRich() {
                        self.captionLabel.text = self.captionTextView.text!.replacingOccurrences(of: "\(urlString) ", with: "")
                        self.captionTextView.text! = self.captionTextView.text!.replacingOccurrences(of: "\(urlString) ", with: "")
                        self.linkButton.addRichLinkTo(stackedView: self.linkStackedView)
                        self.linkButton.imageButton.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
                        self.linkButton.linkBackgroundView.addTarget(self, action: #selector(self.linkTouched), for: .touchUpInside)
                        self.richLinkPresented = true
                    } else {
                        print("Link is not rich")
                    }
                }
                
            }, onError: { error in
                print(error.localizedDescription)
                print("This link is not secure")
                UIApplication.shared.windows.last?.addSubview(self.unsafeLinkAlert)
            })
        }
    }
    
    @objc func linkTouched() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Remove Link", style: .default, handler: { [weak self] (_) in
            print("User clicked remove")
            guard let self = self else { return }
            self.richLinkPresented = false
            self.richLink = nil
            self.linkStackedView.removeAllArrangedSubviews()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension AddEpisodeDetails: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == captionTextView {
            if captionPlaceholderIsActive == true {
                addCaptionPlaceholderText()
            }
        }
        
        if textView == tagTextView {
            if tagPlaceholderIsActive == true {
                addTagPlaceholderText()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        checkIfAbleToPublish()
        
        if textView == captionTextView {
            if captionTextView.text.isEmpty {
                addCaptionPlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height + scrollHeightPadding + linkStackedView.frame.height
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + captionTextView.frame.height + scrollHeightPadding + linkStackedView.frame.height
                captionLabel.textColor = CustomStyle.sixthShade
                captionLabel.text = captionTextView.text
            }
        }
        
        if textView == tagTextView {
            tagsUsed = tagTextView.text.split(separator: " ").map { String($0) }
            if tagTextView.text.isEmpty {
                addTagPlaceholderText()
            }
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
                updateTagContentWidth()
            case 2:
                secondTagButton.setTitle(tagsUsed[1], for: .normal)
                secondTagButton.isHidden = false
                thirdTagButton.isHidden = true
                updateTagContentWidth()
            case 3:
                thirdTagButton.setTitle(tagsUsed[2], for: .normal)
                thirdTagButton.isHidden = false
                updateTagContentWidth()
            default:
                return
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        tagCount = tagTextView.text.filter() {$0 == " "}.count
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            updateTagContentWidth()
            return true
        }
        
        if text == "#" {
            UIApplication.shared.windows.last?.addSubview(hashTagAlert)
        }
        
        if text == " " {
            checkIfLinkWasCreatedWith(input: captionTextView.text)
        }
        
        // Should change captionTextView
        if textView == captionTextView {
            if captionPlaceholderIsActive == true {
                captionTextView.text.removeAll()
                captionTextView.textColor = CustomStyle.fifthShade
                captionPlaceholderIsActive = false
            }
        }
        
        // Should change tagTextView
        if textView == tagTextView {
            if tagPlaceholderIsActive == true {
                tagTextView.text.removeAll()
                self.tagTextView.textColor = CustomStyle.fifthShade
                tagPlaceholderIsActive = false
            } else {
                return tagsUsed.count < 4 && tagCount <= 2
            }
        }
        
        return true
    }
}
