//
//  EditPublishedEpisode.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftLinkPreview

protocol EpisodeEditorDelegate {
    func updateCell(episode: Episode)
}

class EditPublishedEpisode: UIViewController {
    
    let maxCaptionCharacters = 500
    let maxTagCharacters = 45
    
    var episode: Episode!
    var tagsUsed = [String]()
    var tagCount = 0
    var delegate: EpisodeEditorDelegate!

    var scrollContentHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    var captionPlaceholderText = false
    var tagPlaceholderText = false
    var linkPlaceholderText = false

  
    lazy var screenHeight = view.frame.height
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    
    // For screen-size adjustment
    var imageViewSize:CGFloat = 55.0
    var scrollHeightPadding: CGFloat = 60
    
    var networkingIndicator = NetworkingProgress()
    
    // Rich Link preview
    var richLink: String?
    var linkIsSmall: Bool?
    var linkButton: RichLinkGenerator!
    var richLinkPresented = false
    let unsafeLinkAlert = CustomAlertView(alertType: .linkNotSecure)
    let swiftLinkPreview = SwiftLinkPreview(session: URLSession.shared,
                                            workQueue: SwiftLinkPreview.defaultWorkQueue,
                                            responseQueue: DispatchQueue.main,
                                            cache: DisabledCache.instance)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Edit Episode"
        nav.rightButton.isHidden =  true
        nav.titleLabel.textColor = .white
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "placeholder"
        label.numberOfLines = 7
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.sixthShade
        return label
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
     
    //MARK: - Rich link
    
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
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 12
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fifthShade
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
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.autocapitalizationType = .none
        return textView
    }()
    
    let linkBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let linkBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Optional link"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var linkToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = CustomStyle.primaryBlue
        toggle.addTarget(self, action: #selector(checkRichLink), for: .valueChanged)
        toggle.isOn = false
        toggle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        if episode.richLink != nil {
            toggle.isOn = true
        }
        return toggle
    }()
    
    lazy var linkTextView: UITextView = {
        let textView = UITextView()
        if self.episode.richLink != nil {
            textView.text = episode.richLink
        } else {
            textView.text = "Include a link"
        }
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 0
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.autocapitalizationType = .none
        return textView
    }()
        
    init(episode: Episode) {
        self.episode = episode
        captionLabel.text = episode.caption
        captionTextView.text = episode.caption
        programNameLabel.text = episode.programName
        usernameLabel.text = "@\(User.username!)"
        mainImage.image = CurrentProgram.image
       
        if episode.tags != nil {
            tagsUsed = episode.tags!
            tagCount = episode.tags!.count
            
            if tagCount == 0 {
                tagPlaceholderText = true
            }
        }
        super.init(nibName: nil, bundle: nil)
        
        if episode.richLink != nil {
            self.linkTextView.text = episode.richLink!
            self.richLink =  episode.richLink!
            checkRichLink()
        } else {
            linkPlaceholderText = true
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
        tagTextView.delegate = self
        setUpTagButtonsWithTags()
        removeEmptyTags()
        configureNavBar()
        styleForScreens()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateFrameHeight()
        addGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captionTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
    
    func setUpTagButtonsWithTags() {
        if !tagsUsed.isEmpty {
            tagTextView.text = ""
            tagTextView.textColor = CustomStyle.fifthShade
            tagPlaceholderText = false
            
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
    
    func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            scrollHeightPadding = 180
            imageViewSize = 50
        case .iPhone8:
            scrollHeightPadding = 180
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
        mainImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight() + 10).isActive = true
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
        
        scrollContentView.addSubview(linkBar)
        linkBar.translatesAutoresizingMaskIntoConstraints = false
        linkBar.topAnchor.constraint(equalTo: tagTextView.bottomAnchor, constant: 10).isActive = true
        linkBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        linkBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        linkBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        linkBar.addSubview(linkBarLabel)
        linkBarLabel.translatesAutoresizingMaskIntoConstraints = false
        linkBarLabel.centerYAnchor.constraint(equalTo: linkBar.centerYAnchor).isActive = true
        linkBarLabel.leadingAnchor.constraint(equalTo: linkBar.leadingAnchor, constant: 16).isActive = true
        
        linkBar.addSubview(linkToggle)
        linkToggle.translatesAutoresizingMaskIntoConstraints = false
        linkToggle.centerYAnchor.constraint(equalTo: linkBar.centerYAnchor).isActive = true
        linkToggle.trailingAnchor.constraint(equalTo: linkBar.trailingAnchor, constant: -10).isActive = true
        
        scrollContentView.addSubview(linkTextView)
        linkTextView.translatesAutoresizingMaskIntoConstraints = false
        linkTextView.topAnchor.constraint(equalTo: linkBar.bottomAnchor, constant: 10).isActive = true
        linkTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        linkTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
        linkTextView.delegate = self
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
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
            eachTag.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
            eachTag.isUserInteractionEnabled = false
        }
    }
    
    func updateCharacterCount(textView: UITextView) {
        captionCounterLabel.text =  String(maxCaptionCharacters - captionTextView.text!.count)
        tagCounterLabel.text =  String(maxTagCharacters - tagTextView.text!.count)
        
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
    
    @objc func checkRichLink() {
        guard linkToggle.isOn else {
            removeRichLink()
            return
        }
        if linkTextView.text != "" {
            let possibleURL = linkTextView.text.trimmingTrailingSpaces
            let urlString = String(possibleURL)
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
                        self.updateFrameHeight()
                    } else {
                        print("Link is not rich")
                    }
                }

            }, onError: { error in
                print("This link is not secure or a dude")
                self.linkToggle.isOn = false
                UIApplication.shared.windows.last?.addSubview(self.unsafeLinkAlert)
            })
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
    
    func updateFrameHeight() {
        var richLinkPadding: CGFloat = 0.0
        if richLinkPresented {
            richLinkPadding = 100
        }
        scrollContentHeightConstraint.constant = scrollView.frame.height
            + captionTextView.frame.height
            + captionLabel.frame.height
            + scrollHeightPadding
            + richLinkPadding
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
            self.captionLabel.text = "placeholder"
            self.captionLabel.textColor = .white
            self.captionPlaceholderText = true
            self.checkIfAbleToPublish()
        }
    }
    
    func addTagPlaceholderText() {
        DispatchQueue.main.async {
            self.tagTextView.text = "Add three tags"
            let startPosition: UITextPosition = self.tagTextView.beginningOfDocument
            self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: startPosition, to: startPosition)
            self.tagTextView.textColor = CustomStyle.fourthShade
            self.tagPlaceholderText = true
        }
    }
    
    func addLinkPlaceholderText() {
        DispatchQueue.main.async {
            self.linkTextView.text = "Include a link"
            let startPosition: UITextPosition = self.linkTextView.beginningOfDocument
            self.linkTextView.selectedTextRange = self.linkTextView.textRange(from: startPosition, to: startPosition)
            self.linkTextView.textColor = CustomStyle.fourthShade
            self.linkPlaceholderText = true
        }
    }
    
    // MARK: Save Episode
    @objc func publishButtonPress() {
        print("Saving episode")
        networkingIndicator.taskLabel.text = "Saving Episode"
        UIApplication.shared.windows.last?.addSubview(networkingIndicator)
        episode.caption = captionTextView.text.trimmingTrailingSpaces
        episode.tags = tagsUsed
        
        if linkToggle.isOn == false {
            episode.richLink = nil
        }
        
        if richLinkPresented && episode.richLink != richLink {
            
            var linkImage: UIImage
            let linkImageID = NSUUID().uuidString
            
            if self.linkButton.largeImage != nil {
                self.linkIsSmall = false
                linkImage = self.linkButton.largeImage!
            } else {
                self.linkIsSmall = true
                linkImage = self.linkButton.squareImage!
            }
            
            FireStoreManager.updatePublishedEpisodeWithLinkFor(episodeID: episode.ID, caption: episode.caption, tags: episode.tags, richLink: self.richLink!, linkImageID: linkImageID, linkIsSmall: self.linkIsSmall!, linkImage: linkImage, linkHeadline: self.linkButton.mainTitle!, canonicalUrl: self.linkButton.canonicalUrl!) { success in
                if success {
                    self.episode.linkImageID = linkImageID
                    self.episode.richLink = self.richLink!
                    self.episode.linkIsSmall = self.linkIsSmall!
                    self.episode.linkHeadline = self.linkButton.mainTitle!
                    self.episode.canonicalUrl = self.linkButton.canonicalUrl!

                    self.delegate.updateCell(episode: self.episode)
                    self.networkingIndicator.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.networkingIndicator.removeFromSuperview()
                    print("Failed")
                }
            }
            
        } else {
            FireStoreManager.updatePublishedEpisodeWith(richLink: episode.richLink, episodeID: episode.ID, caption: episode.caption, tags: episode.tags) { success in
                if success {
                    self.delegate.updateCell(episode: self.episode)
                    self.networkingIndicator.removeFromSuperview()
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.networkingIndicator.removeFromSuperview()
                    print("Failed")
                }
            }
        }
    }
    
//    func enablePublishButton() {
//
//    }
//
//    func disablePublishButton() {
//
//    }
    
    func checkIfAbleToPublish() {
        if captionPlaceholderText == false && captionTextView.text.count < maxCaptionCharacters && tagTextView.text.count < maxTagCharacters {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(publishButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.whiteNavbarAttributes, for: .normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
    }
    
    @objc func linkTouched() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Remove Link", style: .default, handler: { [weak self] (_) in
            print("User clicked remove")
            guard let self = self else { return }
            self.linkToggle.isOn = false
            self.removeRichLink()
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

extension EditPublishedEpisode: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == captionTextView {
            if captionPlaceholderText == true {
                addCaptionPlaceholderText()
            }
        }
        
        if textView == tagTextView {
            if tagPlaceholderText == true {
                addTagPlaceholderText()
            }
        }
        
        if textView == linkTextView {
            if linkPlaceholderText == true {
                addLinkPlaceholderText()
            }
        }
        
    }
    
    func removeRichLink() {
        linkStackedView.removeAllArrangedSubviews()
        richLinkPresented = false
        updateFrameHeight()
        richLink = nil
        checkIfAbleToPublish()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        checkIfAbleToPublish()
        updateFrameHeight()
        
        if textView == captionTextView {
            if captionTextView.text.isEmpty {
                addCaptionPlaceholderText()
            } else {
                captionLabel.textColor = CustomStyle.sixthShade
                captionLabel.text = captionTextView.text
            }
        }
        
        if textView == linkTextView {
            if linkTextView.text.isEmpty {
                addLinkPlaceholderText()
            } else {
                linkTextView.textColor = CustomStyle.sixthShade
                linkToggle.isOn = false
                removeRichLink()
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
        
        // Should change captionTextView
        if textView == captionTextView {
            if captionPlaceholderText == true {
                captionTextView.text.removeAll()
                captionTextView.textColor = CustomStyle.fifthShade
                captionPlaceholderText = false
            }
        }
        
        // Should change tagTextView
        if textView == tagTextView {
            if tagPlaceholderText == true {
                tagTextView.text.removeAll()
                tagTextView.textColor = CustomStyle.fifthShade
                tagPlaceholderText = false
            } else {
                return tagsUsed.count < 4 && tagCount <= 2
            }
        }
        
        // Should change linkTextView
        if textView == linkTextView {
            if linkPlaceholderText == true {
                linkTextView.text.removeAll()
                linkTextView.textColor = CustomStyle.fifthShade
                linkPlaceholderText = false
            }
        }
        
        return true
    }
}

