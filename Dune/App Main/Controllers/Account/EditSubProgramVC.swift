//
//  EditSubProgramVC.swift
//  Dune
//
//  Created by Waylan Sands on 12/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class EditSubProgramVC: UIViewController {
    
    var tagContentWidth: NSLayoutConstraint!
    var tags: [String]?
    var program: Program!
    
    var removeIntroPress = false
    var deleteProgramPress = false
    
    let headerViewHeight: CGFloat = 300
    lazy var viewHeight = view.frame.height
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    
    let invalidURLAlert = CustomAlertView(alertType: .invalidURL)
    let deleteIntroAlert = CustomAlertView(alertType: .removeIntro)
    let deleteProgramAlert = CustomAlertView(alertType: .deleteProgram)
    let settingsLauncher = SettingsLauncher(options: SettingOptions.categories, type: .categories)
    let db = Firestore.firestore()
    
    // For various screen-sizes
    var imageSize: CGFloat = 90
    var imageViewTopConstant: CGFloat = 120
    var headerViewHeightConstant: CGFloat = 300
    var deleteButtonHeight: CGFloat = -150
    var scrollPadding: CGFloat = 100
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.alpha = 0
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change program image", for: .normal)
        button.setTitleColor(hexStringToUIColor(hex: "#4875FF"), for: .normal)
        button.setTitleColor(hexStringToUIColor(hex: "#4875FF").withAlphaComponent(0.8), for: .highlighted)
        button.addTarget(self, action: #selector(changeImageButtonPress), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    let profileInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileInfoStackedView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let userFieldsStackedView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
        return stackView
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Channel Name"
        return label
    }()
    
    let programNameTextView: UITextField = {
        let textField = UITextField()
        textField.text = ""
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.addTarget(self, action: #selector(nameFieldChanged), for: UIControl.Event.editingChanged)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.keyboardType = .default
        textField.returnKeyType = .done
        return textField
    }()
    
    let programNameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Summary"
        return label
    }()
    
    lazy var summaryTextLabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateProgramDetails))
        label.addGestureRecognizer(tapGesture)
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let summaryUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Optional Link"
        return label
    }()
    
    let websiteTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.addTarget(self, action: #selector(linkFieldChanged), for: UIControl.Event.editingChanged)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let websiteUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Channel tags"
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
    
    let tagContainingStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let tagsUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let primaryGenreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Primary Genre"
        return label
    }()
    
    let primaryGenreButton: UIButton = {
        let button = UIButton()
        button.setTitle(CurrentProgram.primaryCategory, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    let primaryGenreUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let programIntroLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Channel Intro"
        return label
    }()
    
    let privacyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Private"
        return label
    }()
    
    let privacyUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let removeIntroButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.buttonBlue, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.addTarget(self, action: #selector(removeIntroButtonPress), for: .touchUpInside)
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 13
        return button
    }()
    
    let recordIntroButton: UIButton = {
        let button = UIButton()
        button.setTitle("Record", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.buttonBlue, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.addTarget(self, action: #selector(recordIntroButtonPress), for: .touchUpInside)
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 13
        return button
    }()
    
    let topUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let bottomlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let firstCustomCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        cell.frame.size = CGSize(width: 200, height: 100)
        return cell
    }()
    
    let blackBGView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let privateSegment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Public", "Private"])
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.linkBlue,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .semibold)], for: .selected)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade,  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .medium)], for: .normal)
        control.addTarget(self, action: #selector(privacySelection), for: .valueChanged)
        return control
    }()

    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete channel", for: .normal)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.addTarget(self, action: #selector(deleteProgram), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    init(program: Program) {
        super.init(nibName: nil, bundle: nil)
        self.program = program
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryGenreButton.isEnabled = true
        styleForScreens()
        configureViews()
        configureNavBar()
        scrollView.delegate = self
        settingsLauncher.settingsDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        tagScrollView.setScrollBarToTopLeft()
        scrollView.setScrollBarToTopLeft()
        configureSegmentControl()
        createTagButtons()
        
        profileImageView.image = program.image
        summaryTextLabel.text = program.summary
        let placeholder = NSAttributedString(string: program.name, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        programNameTextView.attributedPlaceholder = placeholder;
        
        var weblink: String
        
        if program.webLink == nil ||  program.webLink == "" {
            weblink = "www.example.com"
        } else {
            weblink = program.webLink!
        }
        
        websiteTextView.text = weblink
        websiteTextView.textColor = CustomStyle.fourthShade
    }
    
    func  configureSegmentControl() {
        switch program.channelState {
        case .madePublic:
            privateSegment.selectedSegmentIndex = 0
        case .madePrivate:
            privateSegment.selectedSegmentIndex = 1
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Edit Channel"
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
    
    override func viewDidAppear(_ animated: Bool) {
        addGradient()
    }
    
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageSize = 80
            headerViewHeightConstant = 260
            imageViewTopConstant = 90
            scrollPadding = 140
        case .iPhone8:
            headerViewHeightConstant = 260
            imageViewTopConstant = 90
            deleteButtonHeight = -50
        case .iPhone8Plus:
            imageViewTopConstant = 110
        case .iPhone11:
              deleteButtonHeight = -180
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
        
        view.addSubview(blackBGView)
        blackBGView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight)
        
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.heightAnchor.constraint(equalToConstant: viewHeight + scrollPadding).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollContentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: headerViewHeightConstant).isActive = true
        
        headerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor , constant: imageViewTopConstant).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        headerView.addSubview(changeImageButton)
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 10).isActive = true
        
        scrollContentView.addSubview(profileInfoView)
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        profileInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        profileInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        profileInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileInfoView.addSubview(userFieldsStackedView)
        userFieldsStackedView.translatesAutoresizingMaskIntoConstraints = false
        userFieldsStackedView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 20).isActive = true
        userFieldsStackedView.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor).isActive = true
        userFieldsStackedView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        // Add user fields
        
        userFieldsStackedView.addArrangedSubview(programNameLabel)
        userFieldsStackedView.addArrangedSubview(summaryLabel)
        userFieldsStackedView.addArrangedSubview(websiteLabel)
        userFieldsStackedView.addArrangedSubview(primaryGenreLabel)
        userFieldsStackedView.addArrangedSubview(tagsLabel)
        userFieldsStackedView.addArrangedSubview(programIntroLabel)
        userFieldsStackedView.addArrangedSubview(privacyLabel)
        
        // Add user values
        
        scrollContentView.addSubview(programNameTextView)
        programNameTextView.translatesAutoresizingMaskIntoConstraints = false
        programNameTextView.centerYAnchor.constraint(equalTo: programNameLabel.centerYAnchor).isActive = true
        programNameTextView.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        programNameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        programNameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(programNameUnderlineView)
        programNameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        programNameUnderlineView.topAnchor.constraint(equalTo: programNameTextView.bottomAnchor, constant: 10).isActive = true
        programNameUnderlineView.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        programNameUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programNameUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(summaryTextLabel)
        summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryTextLabel.centerYAnchor.constraint(equalTo: summaryLabel.centerYAnchor).isActive = true
        summaryTextLabel.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        summaryTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        summaryTextLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(summaryUnderlineView)
        summaryUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        summaryUnderlineView.topAnchor.constraint(equalTo: summaryTextLabel.bottomAnchor, constant: 10).isActive = true
        summaryUnderlineView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        summaryUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(websiteTextView)
        websiteTextView.translatesAutoresizingMaskIntoConstraints = false
        websiteTextView.centerYAnchor.constraint(equalTo: websiteLabel.centerYAnchor).isActive = true
        websiteTextView.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        websiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        websiteTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(websiteUnderlineView)
        websiteUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        websiteUnderlineView.topAnchor.constraint(equalTo: websiteTextView.bottomAnchor, constant: 10).isActive = true
        websiteUnderlineView.leadingAnchor.constraint(equalTo: websiteTextView.leadingAnchor).isActive = true
        websiteUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        websiteUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.centerYAnchor.constraint(equalTo: tagsLabel.centerYAnchor).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor, constant: -20).isActive = true
        
        scrollContentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        scrollContentView.addSubview(tagsUnderlineView)
        tagsUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        tagsUnderlineView.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        tagsUnderlineView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        tagsUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagsUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(primaryGenreButton)
        primaryGenreButton.translatesAutoresizingMaskIntoConstraints = false
        primaryGenreButton.topAnchor.constraint(equalTo: primaryGenreLabel.topAnchor, constant: -5).isActive = true
        primaryGenreButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        primaryGenreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(primaryGenreUnderlineView)
        primaryGenreUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        primaryGenreUnderlineView.topAnchor.constraint(equalTo: primaryGenreButton.bottomAnchor, constant: 10).isActive = true
        primaryGenreUnderlineView.leadingAnchor.constraint(equalTo: primaryGenreButton.leadingAnchor).isActive = true
        primaryGenreUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        primaryGenreUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(privacyUnderlineView)
        privacyUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        privacyUnderlineView.topAnchor.constraint(equalTo: programIntroLabel.bottomAnchor, constant: 25).isActive = true
        privacyUnderlineView.leadingAnchor.constraint(equalTo: primaryGenreButton.leadingAnchor).isActive = true
        privacyUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        privacyUnderlineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        scrollContentView.addSubview(privateSegment)
        privateSegment.translatesAutoresizingMaskIntoConstraints = false
        privateSegment.centerYAnchor.constraint(equalTo: privacyLabel.centerYAnchor, constant: 3).isActive = true
        privateSegment.leadingAnchor.constraint(equalTo: primaryGenreButton.leadingAnchor).isActive = true
        privateSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        if program.hasIntro {
            scrollContentView.addSubview(recordIntroButton)
            recordIntroButton.translatesAutoresizingMaskIntoConstraints = false
            recordIntroButton.topAnchor.constraint(equalTo: programIntroLabel.topAnchor).isActive = true
            recordIntroButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
            recordIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
            recordIntroButton.titleLabel?.text = "Replace"
            
            scrollContentView.addSubview(removeIntroButton)
            removeIntroButton.translatesAutoresizingMaskIntoConstraints = false
            removeIntroButton.topAnchor.constraint(equalTo: programIntroLabel.topAnchor).isActive = true
            removeIntroButton.leadingAnchor.constraint(equalTo: recordIntroButton.trailingAnchor, constant: 15).isActive = true
            removeIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        } else {
            scrollContentView.addSubview(recordIntroButton)
            recordIntroButton.translatesAutoresizingMaskIntoConstraints = false
            recordIntroButton.topAnchor.constraint(equalTo: programIntroLabel.topAnchor).isActive = true
            recordIntroButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
            recordIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
            recordIntroButton.titleLabel?.text = "Record"
        }
        
        scrollContentView.addSubview(topUnlineView)
        topUnlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(bottomlineView)
        bottomlineView.translatesAutoresizingMaskIntoConstraints = false
        bottomlineView.topAnchor.constraint(equalTo: privacyLabel.bottomAnchor, constant: 20).isActive = true
        bottomlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: deleteButtonHeight).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    // Program tag creation
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviews()
        for eachTag in program.tags {
            let button = tagButton(with: eachTag)
            button.addTarget(self, action: #selector(updateProgramDetails), for: .touchUpInside)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButton(with title: String) -> TagButton {
        let button = TagButton(title: title)
        return button
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
    
    @objc func updateProgramDetails() {
        programNameTextView.resignFirstResponder()
        let programDetailsVC = UpdateProgramDetails()
        programDetailsVC.program = program
        navigationController?.pushViewController(programDetailsVC, animated: true)
    }
    
    @objc func selectGenrePress() {
        programNameTextView.resignFirstResponder()
        settingsLauncher.showSettings()
    }
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func recordIntroButtonPress() {
        let recordBoothVC = RecordBoothVC()
        recordBoothVC.currentScope = .intro
        navigationController?.pushViewController(recordBoothVC, animated: true)
    }
    
    @objc func removeIntroButtonPress () {
        removeIntroPress = true
        deleteIntroAlert.alertDelegate = self
        UIApplication.shared.windows.last?.addSubview(deleteIntroAlert)
    }
    
    @objc func privacySelection() {
        switch privateSegment.selectedSegmentIndex {
        case 0:
            FireStoreManager.changeSubChannelWith(channelID: program.ID, to: .madePublic)
            program.channelState = .madePublic
        case 1:
            FireStoreManager.changeSubChannelWith(channelID: program.ID, to: .madePrivate)
            program.channelState = .madePrivate
        default:
            break
        }
    }
    
    @objc func deleteProgram() {
        deleteProgramPress = true
        deleteProgramAlert.alertDelegate = self
        UIApplication.shared.keyWindow!.addSubview(deleteProgramAlert)
    }
    
    @objc func nameFieldChanged() {
        if programNameTextView.text != program.name && programNameTextView.text != "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            programNameTextView.textColor = CustomStyle.primaryBlack
        } else {
            programNameTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    @objc func linkFieldChanged() {
        if  websiteTextView.text != program.webLink {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            websiteTextView.textColor = CustomStyle.primaryBlack
        } else {
            websiteTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    
    @objc func saveChanges() {
        if programNameTextView.text != program.name && programNameTextView.text != "" {
            programNameTextView.textColor = CustomStyle.fourthShade
            program.name = programNameTextView.text!.trimmingTrailingSpaces
            FireStoreManager.updateSubProgramWith(name: program.name, programID: program.ID)
        }
        
        if websiteTextView.text != program.webLink && websiteTextView.text != "www.example.com" {
            guard let webLink = websiteTextView.text else { return }
            if webLink.isValidURL || webLink == "" {
                FireStoreManager.updateProgramsWeblinkWith(urlString: webLink, programID: program.ID)
                websiteTextView.textColor = CustomStyle.fourthShade
                program.webLink = webLink
            } else {
                print("Not valid")
                UIApplication.shared.windows.last?.addSubview(invalidURLAlert)
            }
        }
        
        if websiteTextView.text == "" {
            websiteTextView.textColor = CustomStyle.fourthShade
            websiteTextView.text = "www.example.com"
            program.webLink = nil
        }
        programNameTextView.resignFirstResponder()
        websiteTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// Manage Navbar Opacity while scrolling
extension EditSubProgramVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        customNavBar.alpha = y / 100
    }
    
}

// Manage primary category selection
extension EditSubProgramVC: SettingsLauncherDelegate {
    
    // Disabled
    func selectionOf(setting: String) {
        primaryGenreButton.setTitle(setting, for: .normal)
        FireStoreManager.updatePrimaryCategory()
    }
}

extension EditSubProgramVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            program.image = selectedImage
            profileImageView.image = selectedImage
            
            FileManager.storeSelectedProgramImage(image: selectedImage, imageID: program.imageID, programID: program.ID)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension EditSubProgramVC: CustomAlertDelegate {
    func primaryButtonPress() {
        if removeIntroPress {
            program.hasIntro = false
            FireStoreManager.removeIntroFromProgram()
            FireStorageManager.deleteIntroAudioFromStorage(audioID: CurrentProgram.introID!)
            recordIntroButton.titleLabel?.text = "Record"
            removeIntroButton.removeFromSuperview()
        } else if deleteProgramPress {
            FireStoreManager.deleteProgram(with: program.ID, introID: program.introID, imageID: program.imageID)
            let programIndex = CurrentProgram.subPrograms?.firstIndex(where: { program in
                program.ID == self.program.ID
            })
            let idIndex = CurrentProgram.programIDs?.firstIndex(of: program.ID)
            CurrentProgram.subPrograms?.remove(at: programIndex!)
            CurrentProgram.programIDs?.remove(at: idIndex!)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func cancelButtonPress() {
        removeIntroPress = false
        deleteProgramPress = false
    }
    
}

