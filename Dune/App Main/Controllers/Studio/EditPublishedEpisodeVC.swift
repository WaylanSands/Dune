//
//  EditPublishedEpisode.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

protocol EpisodeEditorDelegate {
    func updateCell(episode: Episode)
}

class EditPublishedEpisode: UIViewController {
    
    let imageViewSize:CGFloat = 65.0
    let maxCaptionCharacters = 240
    let maxTagCharacters = 45
    
    var episode: Episode!
    var tagsUsed = [String]()
    var tagCount = 0
    var delegate: EpisodeEditorDelegate!

    var scrollContentHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    var captionPlaceholderText = false
    var captionLabelPlaceholderText = false
    var tagPlaceholderText = false
  
    lazy var screenHeight = view.frame.height
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    
    var networkingIndicator = NetworkingProgress()
    
//    let customNavBar: CustomNavBar = {
//        let nav = CustomNavBar()
//        nav.leftButton.isHidden = true
//        return nav
//    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        view.keyboardDismissMode = .interactive
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
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
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
        button.setTitle("Save", for: .normal)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Custom Init
    
    init(episode: Episode) {
        self.episode = episode
        captionLabel.text = episode.caption
        captionTextView.text = episode.caption
        programNameLabel.text = episode.programName
        usernameLabel.text = "@\(User.username!)"
        mainImage.image = CurrentProgram.image
        bottomBarUsernameLabel.text = "@\(User.username!)"
        bottomBarImageView.image = CurrentProgram.image
        bottomBarProgramNameLabel.text = episode.programName
       
        if episode.tags != nil {
            tagsUsed = episode.tags!
            tagCount = episode.tags!.count
            
            if tagCount == 0 {
                tagPlaceholderText = true
            }
        }
        
        super.init(nibName: nil, bundle: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        captionTextView.delegate = self
        tagTextView.delegate = self
        setUpTagButtonsWithTags()
        removeEmptyTags()
        configureNavBar()
        setupViews()
        addFloatingView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfAbleToPublish()
        addGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        captionTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  (floatingDetailsView.frame.height - 70)
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
        self.title = "Edit Episode"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
        scrollContentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight)
        scrollContentHeightConstraint.isActive = true
        
        scrollContentView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: 20).isActive = true
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
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
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
    }
    
    func addFloatingView() {
        view.addSubview(passThoughView)
        
        passThoughView.addSubview(floatingDetailsView)
        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        floatingDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        floatingDetailsView.heightAnchor.constraint(equalToConstant: 135.0).isActive = true
        
        floatingDetailsView.addSubview(bottomBarImageView)
        bottomBarImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarImageView.topAnchor.constraint(equalTo: floatingDetailsView.topAnchor, constant: 10).isActive = true
        bottomBarImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
        bottomBarImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        bottomBarImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        floatingDetailsView.addSubview(bottomBarProgramNameLabel)
        bottomBarProgramNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarProgramNameLabel.topAnchor.constraint(equalTo: floatingDetailsView.topAnchor, constant: 12.0).isActive = true
        bottomBarProgramNameLabel.leadingAnchor.constraint(equalTo: bottomBarImageView.trailingAnchor, constant: 10.0).isActive = true
        bottomBarProgramNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        floatingDetailsView.addSubview(bottomBarUsernameLabel)
        bottomBarUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBarUsernameLabel.topAnchor.constraint(equalTo: bottomBarProgramNameLabel.bottomAnchor).isActive = true
        bottomBarUsernameLabel.leadingAnchor.constraint(equalTo: bottomBarProgramNameLabel.leadingAnchor).isActive = true
        bottomBarUsernameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
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
    
    
    // MARK: Save Episode
    @objc func publishButtonPress() {
        print("Saving episode")
        networkingIndicator.taskLabel.text = "Saving Episode"
        UIApplication.shared.windows.last?.addSubview(networkingIndicator)
        episode.caption = captionTextView.text.trimmingTrailingSpaces
        episode.tags = tagsUsed
        FireStoreManager.updatePublishedEpisodeWith(episodeID: episode.ID, caption: episode.caption, tags: episode.tags) { success in
            if success {
                self.delegate.updateCell(episode: self.episode)
                self.networkingIndicator.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            } else {
                self.networkingIndicator.removeFromSuperview()
               print("Failed")
            }
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
    
    func checkIfAbleToPublish() {
        if captionPlaceholderText == false && captionTextView.text.count < maxCaptionCharacters && tagTextView.text.count < maxTagCharacters {
            enablePublishButton()
        } else {
            disablePublishButton()
        }
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
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        checkIfAbleToPublish()
        
        if textView == captionTextView {
            if captionTextView.text.isEmpty {
                addCaptionPlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + captionTextView.frame.height
                captionLabel.textColor = CustomStyle.sixthShade
                captionLabel.text = captionTextView.text
            }
        }
        
        if textView == tagTextView {
            tagsUsed = tagTextView.text.split(separator: " ").map { String($0).lowercased() }
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
                self.tagTextView.textColor = CustomStyle.fifthShade
                tagPlaceholderText = false
            } else {
                return tagsUsed.count < 4 && tagCount <= 2
            }
        }
        
        return true
    }
}

