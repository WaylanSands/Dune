//
//  AddEpisodeDetails.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class UpdateProgramDetails: UIViewController {
    
    let maxCaptionCharacters = 240
    let maxTagCharacters = 45
    
    var program: Program?
    
    var scrollContentHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    var homeIndicatorHeight:CGFloat = 34.0
    var summaryPlaceholderIsActive = false
    var tagPlaceholderIsActive = false
    var tagsUsed = [String]()
    var tagCount: Int = 0
    
    let summaryPlaceHolder = "Why should people subscribe, what insights do you offer?"
    let tagsPlaceHolder = "Add three topics, each separated by a space"
    
    lazy var screenHeight = view.frame.height
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    
    // For screen-size adjustment
    var imageViewSize:CGFloat = 55.0
    
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(User.username!)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
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
    
    lazy var secondTagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.isUserInteractionEnabled = false
        return button
    }()
    
    lazy var thirdTagButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 11
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.backgroundColor = CustomStyle.secondShade
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let summaryBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let summaryBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Channel Summary"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var summaryCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxCaptionCharacters - CurrentProgram.summary!.count)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let summaryTextView: UITextView = {
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
        label.text = "Topics"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var tagCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxTagCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let tagTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fifthShade
        textView.keyboardType = .twitter
        textView.autocapitalizationType = .none
        return textView
    }()
    
    let locationTypeBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let locationTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Location Type"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    let locationTypeSegment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Global", "National", "Local"])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.linkBlue,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        control.addTarget(self, action: #selector(locationTypeSelection), for: .valueChanged)
        return control
    }()
    
    let countrySegment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["AUS", "NZ", "US", "CAN", "UK", "Other"])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.linkBlue,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        control.addTarget(self, action: #selector(locationTypeSelection), for: .valueChanged)
        return control
    }()
    
    let countryBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    @objc func locationTypeSelection() {
        switch locationTypeSegment.selectedSegmentIndex {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTextView.delegate = self
        tagTextView.delegate = self
        setUpTagButtonsWithTags()
        removeEmptyTags()
        configureNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.setScrollBarToTopLeft()
        tagScrollView.setScrollBarToTopLeft()
        configureSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height
        addGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        summaryTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
    
    func configureSummary() {
        usernameLabel.text = "@\(User.username!)"

        if program == nil {
            mainImage.image = CurrentProgram.image
            summaryLabel.text = CurrentProgram.summary
            summaryTextView.text = CurrentProgram.summary
            programNameLabel.text = CurrentProgram.name
        } else {
            mainImage.image = program?.image
            programNameLabel.text = program?.name
            summaryLabel.text = program?.summary
            summaryTextView.text = program?.summary
        }

        if summaryLabel.text == "" {
            summaryPlaceholderIsActive = true
            summaryTextView.text = summaryPlaceHolder
            summaryTextView.textColor = CustomStyle.fourthShade
        }
        if tagsUsed == [] {
            tagPlaceholderIsActive = true
            tagTextView.text = tagsPlaceHolder
            tagTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    func setUpTagButtonsWithTags() {
        var tags = [String]()
       
        if program == nil {
            tags = CurrentProgram.tags!
        } else {
            tags = program!.tags
        }
        
        for (index, item) in tags.enumerated() {
            tagsUsed.append(item)
            tagCount += 1
            
            if index <= 1 {
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
        navigationItem.title = "Channel Details"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-button-white"), style: .plain, target: self, action: #selector(popVC))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageViewSize = 50
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro, .iPhone12:
            break
        case .iPhone11ProMax, .iPhone12ProMax:
            break
        case .unknown:
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
        scrollContentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight)
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
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        
        programNameStackedView.addArrangedSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scrollContentView.addSubview(summaryLabel)
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryLabel.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 2).isActive = true
        summaryLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
        summaryLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
        summaryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: summaryLabel.font.lineHeight + 1).isActive = true
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 10).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: summaryLabel.leadingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor,constant: 10).isActive = true
        
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
        
        scrollContentView.addSubview(summaryBar)
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        summaryBar.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        summaryBar.addSubview(summaryBarLabel)
        summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
        
        summaryBar.addSubview(summaryCounterLabel)
        summaryCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryCounterLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
        summaryCounterLabel.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: summaryBar.bottomAnchor, constant: 10).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
        
        scrollContentView.addSubview(tagBar)
        tagBar.translatesAutoresizingMaskIntoConstraints = false
        tagBar.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 10).isActive = true
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
        
//        scrollContentView.addSubview(locationTypeBar)
//        locationTypeBar.translatesAutoresizingMaskIntoConstraints = false
//        locationTypeBar.topAnchor.constraint(equalTo: tagTextView.bottomAnchor, constant: 10).isActive = true
//        locationTypeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        locationTypeBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        locationTypeBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
//        
//        locationTypeBar.addSubview(locationTypeLabel)
//        locationTypeLabel.translatesAutoresizingMaskIntoConstraints = false
//        locationTypeLabel.centerYAnchor.constraint(equalTo: locationTypeBar.centerYAnchor).isActive = true
//        locationTypeLabel.leadingAnchor.constraint(equalTo: locationTypeBar.leadingAnchor, constant: 16).isActive = true
//
//        scrollContentView.addSubview(locationTypeSegment)
//        locationTypeSegment.translatesAutoresizingMaskIntoConstraints = false
//        locationTypeSegment.topAnchor.constraint(equalTo: locationTypeBar.bottomAnchor, constant: 15).isActive = true
//        locationTypeSegment.leadingAnchor.constraint(equalTo: locationTypeBar.leadingAnchor, constant: 16).isActive = true
//        locationTypeSegment.trailingAnchor.constraint(equalTo: locationTypeBar.trailingAnchor, constant: -16).isActive = true
//
//        scrollContentView.addSubview(countryBar)
//        countryBar.translatesAutoresizingMaskIntoConstraints = false
//        countryBar.topAnchor.constraint(equalTo: locationTypeSegment.bottomAnchor, constant: 15).isActive = true
//        countryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        countryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        countryBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
//
//        countryBar.addSubview(countryLabel)
//        countryLabel.translatesAutoresizingMaskIntoConstraints = false
//        countryLabel.centerYAnchor.constraint(equalTo: countryBar.centerYAnchor).isActive = true
//        countryLabel.leadingAnchor.constraint(equalTo: countryBar.leadingAnchor, constant: 16).isActive = true
//
//        scrollContentView.addSubview(countrySegment)
//        countrySegment.translatesAutoresizingMaskIntoConstraints = false
//        countrySegment.topAnchor.constraint(equalTo: countryBar.bottomAnchor, constant: 15).isActive = true
//        countrySegment.leadingAnchor.constraint(equalTo: countryBar.leadingAnchor, constant: 16).isActive = true
//        countrySegment.trailingAnchor.constraint(equalTo: countryBar.trailingAnchor, constant: -16).isActive = true
        
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
    
    func updateCharacterCount(textView: UITextView) {
        
        summaryCounterLabel.text =  String(maxCaptionCharacters - summaryTextView.text!.count)
        tagCounterLabel.text =  String(maxTagCharacters - tagTextView.text!.count)
        
        if Int(summaryCounterLabel.text!)! < 0 {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            summaryCounterLabel.textColor = CustomStyle.warningRed
        } else {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            summaryCounterLabel.textColor = CustomStyle.fourthShade
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
            self.summaryTextView.text = self.summaryPlaceHolder
            let startPosition: UITextPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: startPosition, to: startPosition)
            self.summaryTextView.textColor = CustomStyle.fourthShade
            self.summaryPlaceholderIsActive = true
            self.checkIfAbleToSave()
        }
    }
    
    func addTagPlaceholderText() {
        DispatchQueue.main.async {
            self.tagTextView.text = self.tagsPlaceHolder
            let startPosition: UITextPosition = self.tagTextView.beginningOfDocument
            self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: startPosition, to: startPosition)
            self.tagTextView.textColor = CustomStyle.fourthShade
            self.tagPlaceholderIsActive = true
            self.checkIfAbleToSave()
        }
    }
    
    func checkIfAbleToSave() {
        if summaryPlaceholderIsActive == false && tagPlaceholderIsActive == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
            
        }
    }
    
    // Save details to Firebase
    @objc func saveButtonPress() {
        if program == nil {
            CurrentProgram.summary = summaryTextView.text
            CurrentProgram.tags = tagsUsed
            FireStoreManager.updateProgram(summary: summaryTextView.text, tags: tagsUsed, for: CurrentProgram.ID!)
        } else {
            program?.tags = tagsUsed
            program?.summary = summaryTextView.text
            FireStoreManager.updateProgram(summary: summaryTextView.text, tags: tagsUsed, for: program!.ID)
        }
        navigationController?.popViewController(animated: true)
    }
    
}

extension UpdateProgramDetails: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        checkIfAbleToSave()
        
        if textView == summaryTextView {
            summaryLabel.text = summaryTextView.text
            if summaryTextView.text.isEmpty {
                addCaptionPlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height
                summaryLabel.textColor = CustomStyle.sixthShade
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
                firstTagButton.setTitle(tagsUsed[0], for: .normal)
                secondTagButton.setTitle(tagsUsed[1], for: .normal)
                secondTagButton.isHidden = false
                thirdTagButton.isHidden = true
                updateTagContentWidth()
            case 3:
                firstTagButton.setTitle(tagsUsed[0], for: .normal)
                secondTagButton.setTitle(tagsUsed[1], for: .normal)
                thirdTagButton.setTitle(tagsUsed[2], for: .normal)
                thirdTagButton.isHidden = false
                updateTagContentWidth()
            default:
                return
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case summaryTextView:
            if summaryPlaceholderIsActive == true {
                summaryTextView.text.removeAll()
                summaryTextView.textColor = CustomStyle.fifthShade
                summaryPlaceholderIsActive = false
            }
        case tagTextView:
            if tagPlaceholderIsActive == true {
                tagTextView.text.removeAll()
                self.tagTextView.textColor = CustomStyle.fifthShade
                tagPlaceholderIsActive = false
            }
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        tagCount = tagTextView.text.filter() {$0 == " "}.count
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            updateTagContentWidth()
            checkIfAbleToSave()
            return true
        }
        
        // Should change captionTextView
        if textView == summaryTextView {
            if summaryPlaceholderIsActive == true {
                summaryTextView.text.removeAll()
                summaryTextView.textColor = CustomStyle.fifthShade
                summaryPlaceholderIsActive = false
            }
        }
        
        // Should change tagTextView
        if textView == tagTextView {
            if tagPlaceholderIsActive == true {
                tagTextView.text.removeAll()
                self.tagTextView.textColor = CustomStyle.fifthShade
                tagPlaceholderIsActive = false
            } else {
                return tagsUsed.count <= 3 && tagCount <= 2
            }
        }
        
        return true
    }
}

