//
//  AddEpisodeDetails.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CreateProgramVC: UIViewController {
    
    let imageViewSize:CGFloat = 65.0
    let maxCaptionCharacters = 240
    let maxNameCharacters = 20
    let maxTagCharacters = 45
    
    var scrollContentHeightConstraint: NSLayoutConstraint!
    var tagContentWidthConstraint: NSLayoutConstraint!
    
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    var homeIndicatorHeight:CGFloat = 34.0
    
    var summaryPlaceHolder = "Add a Summary to your channel"
    var namePlaceHolder = "Name of this channel"
    var tagPlaceHolder = "Add three tags"
    
    var summaryPlaceholderIsActive = true
    var namePlaceholderIsActive = true
    var tagPlaceholderIsActive = true
    var programImage: UIImage?
    var tagsUsed: [String] = []
    var tagCount: Int = 0
    
    lazy var screenHeight = view.frame.height
    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = CustomStyle.blackNavBar
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
    
    let programImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 7
        button.clipsToBounds = true
        button.setImage(UIImage(named: "add-program-icon"), for: .normal)
        button.addTarget(self, action: #selector(addProgramImage), for: .touchUpInside)
        return button
    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
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
        button.isHidden = true
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
        button.isHidden = true
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
        button.isHidden = true
        return button
    }()
    
      // Program name
    
    let programNameBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let programNameBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Channel Name"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var nameCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxNameCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 1
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.text = namePlaceHolder
        textView.keyboardType = .twitter
        return textView
    }()
    
    // Program summary
    
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
        label.text = String(maxCaptionCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var summaryTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 12
        textView.isScrollEnabled = false
        textView.text = summaryPlaceHolder
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        return textView
    }()
    
     // Program tags
    
    let tagBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let tagBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Channel tags"
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
    
    lazy var tagTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 2
        textView.isScrollEnabled = false
        textView.text = tagPlaceHolder
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.autocapitalizationType = .none
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpTagButtonsWithTags()
//        removeEmptyTags()
        configureNavBar()
        setupViews()
        summaryTextView.delegate = self
        nameTextView.delegate = self
        tagTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = "@\(User.username!)"
        
        scrollView.setScrollBarToTopLeft()
        tagScrollView.setScrollBarToTopLeft()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height
        addGradient()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        summaryTextView.resignFirstResponder()
        tagTextView.resignFirstResponder()
    }
    
//    func setUpTagButtonsWithTags() {
//        for (index, item) in CurrentProgram.tags!.enumerated() {
//            if item != nil {
//                tagsUsed.append(item!)
//                tagCount += 1
//
//                if index <= 1 {
//                    tagTextView.text.append("\(item!) ")
//                } else {
//                    tagTextView.text.append("\(item!)")
//                }
//
//                switch index {
//                case 0:
//                    firstTagButton.setTitle(item, for: .normal)
//                case 1:
//                    secondTagButton.setTitle(item, for: .normal)
//                case 2:
//                    thirdTagButton.setTitle(item, for: .normal)
//                default:
//                    break
//                }
//            }
//        }
//    }
    
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
        navigationItem.title = "Create Sub-Channel"
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
        navigationItem.rightBarButtonItem = UIBarButtonItem()
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
        
        scrollContentView.addSubview(programImageButton)
        programImageButton.translatesAutoresizingMaskIntoConstraints = false
        programImageButton.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight() + 15).isActive = true
        programImageButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        programImageButton.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        programImageButton.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        scrollContentView.addSubview(programNameStackedView)
        programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
        programNameStackedView.topAnchor.constraint(equalTo: programImageButton.topAnchor).isActive = true
        programNameStackedView.leadingAnchor.constraint(equalTo: programImageButton.trailingAnchor, constant: 10).isActive = true
        programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20).isActive = true
        
        programNameStackedView.addArrangedSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.font.lineHeight).isActive = true
//        programNameLabel.widthAnchor.constraint(equalToConstant: programNameLabel.intrinsicContentSize.width).isActive = true
        
        programNameStackedView.addArrangedSubview(usernameLabel)
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        usernameLabel.widthAnchor.constraint(equalToConstant: usernameLabel.intrinsicContentSize.width).isActive = true
        
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
        tagContentWidthConstraint = tagContentView.widthAnchor.constraint(equalToConstant: tagscrollViewWidth)
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
        
        // Program name
        
        scrollContentView.addSubview(programNameBar)
        programNameBar.translatesAutoresizingMaskIntoConstraints = false
        programNameBar.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        programNameBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        programNameBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programNameBar.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        programNameBar.addSubview(programNameBarLabel)
        programNameBarLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameBarLabel.centerYAnchor.constraint(equalTo: programNameBar.centerYAnchor).isActive = true
        programNameBarLabel.leadingAnchor.constraint(equalTo: programNameBar.leadingAnchor, constant: 16).isActive = true
        
        programNameBar.addSubview(nameCounterLabel)
        nameCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        nameCounterLabel.centerYAnchor.constraint(equalTo: programNameBar.centerYAnchor).isActive = true
        nameCounterLabel.trailingAnchor.constraint(equalTo: programNameBar.trailingAnchor, constant: -16).isActive = true
        
        scrollContentView.addSubview(nameTextView)
        nameTextView.translatesAutoresizingMaskIntoConstraints = false
        nameTextView.topAnchor.constraint(equalTo: programNameBar.bottomAnchor, constant: 10).isActive = true
        nameTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
        nameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
//        nameTextView.heightAnchor.constraint(equalToConstant: nameTextView.font!.lineHeight).isActive = true
        
        // Program Summary
        
        scrollContentView.addSubview(summaryBar)
        summaryBar.translatesAutoresizingMaskIntoConstraints = false
        summaryBar.topAnchor.constraint(equalTo: nameTextView.bottomAnchor, constant: 10).isActive = true
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
    
    func addNamePlaceholderText() {
        DispatchQueue.main.async {
            self.nameTextView.text = self.namePlaceHolder
            let startPosition: UITextPosition = self.nameTextView.beginningOfDocument
            self.nameTextView.selectedTextRange = self.nameTextView.textRange(from: startPosition, to: startPosition)
            self.nameTextView.textColor = CustomStyle.fourthShade
            self.namePlaceholderIsActive = true
            self.checkIfAbleToSave()
        }
    }
    
    func addSummaryPlaceholderText() {
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
            self.tagTextView.text = self.tagPlaceHolder
            let startPosition: UITextPosition = self.tagTextView.beginningOfDocument
            self.tagTextView.selectedTextRange = self.tagTextView.textRange(from: startPosition, to: startPosition)
            self.tagTextView.textColor = CustomStyle.fourthShade
            self.tagPlaceholderIsActive = true
            self.checkIfAbleToSave()
        }
    }
    
    func checkIfAbleToSave() {
        if !summaryPlaceholderIsActive && !tagPlaceholderIsActive && !namePlaceholderIsActive && programImage != nil  {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
    
    // MARK: Save button action
    @objc func saveButtonPress() {
        FireStoreManager.createAdditionalProgramWith(programName: nameTextView.text, summary: summaryTextView.text, tags: tagsUsed, image: programImage!) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addProgramImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

extension CreateProgramVC: UITextViewDelegate {
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView == summaryTextView {
            if summaryPlaceholderIsActive == true {
                addSummaryPlaceholderText()
            }
        }
        
        if textView == tagTextView {
            if tagPlaceholderIsActive == true {
                addTagPlaceholderText()
            }
        }
        
        if textView == nameTextView {
            if namePlaceholderIsActive == true {
                addNamePlaceholderText()
            }
        }
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        checkIfAbleToSave()
        
        if textView == summaryTextView {
            summaryLabel.text = summaryTextView.text
            if summaryTextView.text.isEmpty {
                addSummaryPlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height
                summaryLabel.textColor = CustomStyle.sixthShade
            }
        }
        if textView == nameTextView {
            nameLabel.text = nameTextView.text
            if nameTextView.text.isEmpty {
                addNamePlaceholderText()
                scrollContentHeightConstraint.constant = scrollView.frame.height
            } else {
                scrollContentHeightConstraint.constant = scrollView.frame.height + nameTextView.frame.height
                nameLabel.textColor = CustomStyle.sixthShade
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        tagCount = tagTextView.text.filter() {$0 == " "}.count
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            updateTagContentWidth()
            checkIfAbleToSave()
            return true
        }
        
        
        // Should change nameTextView
        if textView == nameTextView {
            if namePlaceholderIsActive == true {
                nameTextView.text.removeAll()
                nameTextView.textColor = CustomStyle.fifthShade
                namePlaceholderIsActive = false
            }
            
            if nameTextView.text.count == maxNameCharacters {
                return false
            }
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

extension CreateProgramVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            programImageButton.setImage(selectedImage, for: .normal)
            programImage = selectedImage
            checkIfAbleToSave()
            dismiss(animated: true, completion: nil)
        }
    }
}

