//
//  SingleProgramProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class SingleProgramProfileVC: UIViewController {
    
    let minHeight = UIDevice.current.navBarHeight() + 40
    let navHeight = UIDevice.current.navBarHeight()
    
    var largeImageSize: CGFloat = 80.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    let maxPrograms = 10
    
    var unwrapped = false
    var unwrapDifference: CGFloat = 0
    
    let viewFrame = UIScreen.main.bounds
    var headerHeight: ClosedRange<CGFloat>!
    var tableViews: [Int: UIView] = [:]
    var currentIndex: Int = 0
    
    var selectedCellRow: Int?
    var program: Program!
    
    lazy var headerBarButtons: [UIButton] = [episodesButton, subscriptionsButton, mentionsButton]
    
    lazy var accountBottomVC = ProgramProfileBottomVC(program: program)
    
    let sharingSettings = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.9
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.doNotAdjustContentInset()
        return view
    }()
    
    let overlayScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.showsVerticalScrollIndicator = false
        view.doNotAdjustContentInset()
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    let topDetailsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.frame.size = CGSize(width: 74, height: 74)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let topMiddleStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 3
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlue
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    // Intro button
    let playIntroButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    let summaryTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = 3
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = CustomStyle.sixthShade
        view.backgroundColor = .clear
        return view
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        return button
    }()
    
    let websiteLinkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "website-link"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.primaryBlue, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(websiteButtonPress), for: .touchUpInside)
        return button
    }()
    
    let linkAndStatsStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .leading
        return view
    }()
    
    let statsView: UIView = {
        let view = UIView()
        return view
    }()
    
    let subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    let subscribersButton: ExtendedButton = {
        let button = ExtendedButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(pushSubscribersVC), for: .touchUpInside)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.padding = 10
        return button
    }()
    
    let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let repCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    let repLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        label.text = "Cred"
        return label
    }()
    
    let buttonsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 10.0
        return view
    }()
    
    let subscribeButton: AccountButton = {
        let button = AccountButton()
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        //        button.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return button
    }()
    
    let shareProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitle("Share Channel", for: .normal)
        return button
    }()
    
    let tableViewButtons: UIView = {
        let view = UIView()
        return view
    }()
    
    let episodesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Episodes", for: .normal)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let mentionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mentions", for: .normal)
        button.setTitleColor(CustomStyle.thirdShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let subscriptionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscriptions", for: .normal)
        button.setTitleColor(CustomStyle.thirdShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let tableViewButtonsLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    required init(program: Program) {
        self.program = program
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hidesBottomBarWhenPushed = false
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.setScrollBarToTopLeft()
        configureSubscribeButton()
        configureProgramStats()
        configureIntroButton()
        configureIfPrivate()
        setupTopBar()
        addWebLink()
        
        nameLabel.text = program.name
        repCountLabel.text = program.rep.roundedWithAbbreviations
        categoryLabel.text = program.primaryCategory
        usernameLabel.text = "@\(program.username)"
        summaryTextView.text = program.summary
        setMainImage()
        
        if  unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
        }
    }
    
    func configureIfPrivate() {
        if program.isPrivate && !CurrentProgram.subscriptionIDs!.contains(program.ID) {
            subscriptionsButton.isEnabled = false
            subscribersButton.isEnabled = false
            episodesButton.isEnabled = false
            mentionsButton.isEnabled = false
        }
    }
    
    func setMainImage() {
        if program.imageID != nil {
            FileManager.getImageWith(imageID: program.imageID!) { image in
                DispatchQueue.main.async {
                    self.mainImage.image = image
                }
            }
        } else {
            mainImage.image = #imageLiteral(resourceName: "missing-image-large")
        }
    }
    
    func  configureDelegates() {
        sharingSettings.settingsDelegate = self
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
    }
    
    func configureProgramStats() {
        subscriberCountLabel.text = "\(program.subscriberCount.roundedWithAbbreviations)"
        episodeCountLabel.text = "\(program.episodeIDs.count)"
        
        let episodes = program.episodeIDs
        let subscribers = program.subscriberCount
        
        if episodes.count == 1 {
            episodesLabel.text = "Episode"
        } else {
            episodesLabel.text = "Episodes"
        }
        
        if subscribers == 1 {
            subscribersButton.setTitle("Subscriber", for: .normal)
        } else {
            subscribersButton.setTitle("Subscribers", for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headerHeight = (minHeight)...headerHeightCalculated()
        prepareSetup()
        updateScrollContent()
        if summaryTextView.lineCount() > 3 {
            addMoreButton()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func prepareSetup() {
        headerView.frame = CGRect(x: viewFrame.minX, y: CGFloat(0), width: viewFrame.width, height: CGFloat(headerHeight.upperBound))
        scrollView.contentSize = CGSize.init(width: viewFrame.width, height: viewFrame.height + CGFloat(headerHeight.upperBound))
        
        overlayScrollView.frame = CGRect(x: viewFrame.minX, y: viewFrame.minY, width: viewFrame.width, height: viewFrame.height)
        overlayScrollView.contentSize = self.scrollView.contentSize
        overlayScrollView.layer.zPosition = 999
        overlayScrollView.delegate = self
        
        self.add(accountBottomVC, to: scrollView, frame:  CGRect(x: viewFrame.minX, y: headerHeight.upperBound, width: viewFrame.width, height: viewFrame.height))
        
        self.tableViews[currentIndex] = accountBottomVC.activeTableView()
        if let scrollView = self.tableViews[currentIndex] as? UIScrollView {
            scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
            scrollView.doNotAdjustContentInset()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIScrollView, let scroll = self.tableViews[currentIndex] as? UIScrollView {
            if obj == scroll && keyPath == #keyPath(UIScrollView.contentSize) {
                self.overlayScrollView.contentSize = getContentSize(for: scroll)
            }
        }
    }
    
    func headerHeightCalculated() -> CGFloat {
        var height: CGFloat = 76 + navHeight
        
        for each in headerView.subviews {
            height += each.frame.height
        }
        
        if headerView.subviews.contains(moreButton) {
            height -= moreButton.frame.height
        }
        
        accountBottomVC.headerHeight = height
        return height
    }
    
    func setupTopBar() {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: CustomStyle.primaryBlack]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.tintColor = CustomStyle.primaryBlack
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
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
    
    func configureIntroButton() {
        if program.hasIntro == true {
            playIntroButton.setTitle("Play Intro", for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryYellow
            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
        } else {
            playIntroButton.isHidden = true
        }
    }
    
    func configureViews() {
        view.addSubview(overlayScrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        
        headerView.addSubview(topDetailsView)
        topDetailsView.translatesAutoresizingMaskIntoConstraints = false
        topDetailsView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: navHeight + 10).isActive = true
        topDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        topDetailsView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        topDetailsView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo:topDetailsView.topAnchor, constant: 0).isActive = true
        mainImage.leadingAnchor.constraint(equalTo:topDetailsView.leadingAnchor).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        
        topDetailsView.addSubview(playIntroButton)
        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
        playIntroButton.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        topDetailsView.addSubview(topMiddleStackedView)
        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
        topMiddleStackedView.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: playIntroButton.leadingAnchor, constant: -20).isActive = true
        topMiddleStackedView.addArrangedSubview(nameLabel)
        topMiddleStackedView.addArrangedSubview(usernameLabel)
        topMiddleStackedView.addArrangedSubview(categoryLabel)
        
        headerView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: topDetailsView.bottomAnchor, constant: 20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        headerView.addSubview(linkAndStatsStackedView)
        linkAndStatsStackedView.translatesAutoresizingMaskIntoConstraints = false
        linkAndStatsStackedView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        linkAndStatsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        linkAndStatsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        linkAndStatsStackedView.addArrangedSubview(statsView)
        statsView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        statsView.widthAnchor.constraint(equalTo: linkAndStatsStackedView.widthAnchor).isActive = true
        
        statsView.addSubview(subscriberCountLabel)
        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        
        statsView.addSubview(subscribersButton)
        subscribersButton.translatesAutoresizingMaskIntoConstraints = false
        subscribersButton.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscribersButton.leadingAnchor.constraint(equalTo: subscriberCountLabel.trailingAnchor, constant: 5).isActive = true
        subscribersButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        statsView.addSubview(episodeCountLabel)
        episodeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        episodeCountLabel.leadingAnchor.constraint(equalTo: subscribersButton.trailingAnchor, constant: 15).isActive = true
        
        statsView.addSubview(episodesLabel)
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        episodesLabel.leadingAnchor.constraint(equalTo: episodeCountLabel.trailingAnchor, constant: 5).isActive = true
        
        statsView.addSubview(repCountLabel)
        repCountLabel.translatesAutoresizingMaskIntoConstraints = false
        repCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        repCountLabel.leadingAnchor.constraint(equalTo: episodesLabel.trailingAnchor, constant: 15).isActive = true
        
        statsView.addSubview(repLabel)
        repLabel.translatesAutoresizingMaskIntoConstraints = false
        repLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        repLabel.leadingAnchor.constraint(equalTo: repCountLabel.trailingAnchor, constant: 5).isActive = true
        
        headerView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: linkAndStatsStackedView.bottomAnchor, constant: 20).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(subscribeButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        headerView.addSubview(tableViewButtons)
        tableViewButtons.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtons.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 10).isActive = true
        tableViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableViewButtons.addSubview(episodesButton)
        episodesButton.translatesAutoresizingMaskIntoConstraints = false
        episodesButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: 0).isActive = true
        episodesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        tableViewButtons.addSubview(subscriptionsButton)
        subscriptionsButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: 0).isActive = true
        subscriptionsButton.leadingAnchor.constraint(equalTo: episodesButton.trailingAnchor, constant: 20).isActive = true
        
        tableViewButtons.addSubview(mentionsButton)
        mentionsButton.translatesAutoresizingMaskIntoConstraints = false
        mentionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: 0).isActive = true
        mentionsButton.leadingAnchor.constraint(equalTo: subscriptionsButton.trailingAnchor, constant: 20).isActive = true
        
        tableViewButtons.addSubview(tableViewButtonsLine)
        tableViewButtonsLine.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtonsLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableViewButtonsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtonsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtonsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addMoreButton() {
        DispatchQueue.main.async {
            self.headerView.addSubview(self.moreButton)
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
            
            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
            let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
    }
    
    @objc func playIntro() {
        dunePlayBar.finishSession()
        accountBottomVC.playIntro()
    }
    
    func updateScrollContent() {
        let vc = accountBottomVC
        if self.tableViews[currentIndex] == nil{
            self.tableViews[currentIndex] = vc.activeTableView()
            if let scrollView = self.tableViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
                scrollView.doNotAdjustContentInset()
            }
        }
        
        if let scrollView = self.tableViews[currentIndex] as? UIScrollView{
            self.overlayScrollView.contentSize = getContentSize(for: scrollView)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        }else if let bottomView = self.tableViews[currentIndex]{
            self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        }
    }
    
    func getContentSize(for bottomView: UIView) -> CGSize {
        if let scroll = bottomView as? UIScrollView {
            let bottomHeight = max(scroll.contentSize.height, self.view.frame.height - CGFloat(headerHeight.lowerBound))
            return CGSize.init(width: scroll.contentSize.width, height: bottomHeight + CGFloat(headerHeight.upperBound))
        } else {
            let bottomHeight = self.view.frame.height - CGFloat(headerHeight.lowerBound)
            return CGSize.init(width: bottomView.frame.width, height: bottomHeight + CGFloat(headerHeight.upperBound))
        }
    }
    
    func configureSubscribeButton() {
        if program.channelState == .madePublic {
            subscribeButton.removeTarget(nil, action: nil, for: .allEvents)
            subscribeButton.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
            if !CurrentProgram.subscriptionIDs!.contains(program.ID) {
                subscribeButton.setTitle("Subscribe", for: .normal)
                subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
            } else {
                subscribeButton.setTitle("Subscribed", for: .normal)
                subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            }
        } else {
            subscribeButton.removeTarget(nil, action: nil, for: .allEvents)
            subscribeButton.addTarget(self, action: #selector(requestInvite), for: .touchUpInside)
            if program.pendingChannels.contains(CurrentProgram.ID!) {
                subscribeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
                subscribeButton.setTitle("Pending invite", for: .normal)
            }  else if program.deniedChannels.contains(CurrentProgram.ID!) {
                subscribeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
                subscribeButton.setTitle("Pending invite", for: .normal)
            } else if CurrentProgram.subscriptionIDs!.contains(program.ID) {
               subscribeButton.setTitle("Subscribed", for: .normal)
               subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            } else {
                subscribeButton.setTitle("Request invite", for: .normal)
                subscribeButton.setImage(UIImage(named: "request-invite"), for: .normal)
            }
        }
    }
    
    @objc func requestInvite() {
        if subscribeButton.titleLabel?.text == "Request invite" {
            subscribeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            subscribeButton.setImage(UIImage(named: "pending-invite"), for: .normal)
            subscribeButton.setTitle("Pending invite", for: .normal)
            FireStoreManager.requestInviteFor(channelID: program.ID)
        }
    }
    
    // MARK: Subscribe button press
    @objc func subscribeButtonPress() {
        print("Trigger")
        if CurrentProgram.subscriptionIDs!.contains(program.ID) {
            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            CurrentProgram.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
            configureProgramStats()
        } else {
            FireStoreManager.addSubscriptionToProgramWith(programID: program.ID)
            FireStoreManager.subscribeToProgramWith(programID: program.ID)
            CurrentProgram.subscriptionIDs!.append(program.ID)
            program.subscriberCount += 1
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            configureProgramStats()
        }
    }
    
    @objc func shareButtonPress() {
        print("shareButtonPress")
        sharingSettings.showSettings()
    }
    
    @objc func settingsButtonPress() {
        print("settingsButtonPress")
        programSettings.showSettings()
    }
    
    @objc func moreUnwrap() {
        let heightBefore = summaryTextView.frame.height
        unwrapped = true
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(program.summary) "
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
        
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        summaryTextView.layoutIfNeeded()
        view.layoutIfNeeded()
        
        let heighAfter = summaryTextView.frame.height
        unwrapDifference = heighAfter - heightBefore
        accountBottomVC.unwrapDifference = unwrapDifference
        updateHeaderHeight()
    }
    
    func updateHeaderHeight() {
        headerHeight = (minHeight)...headerHeightCalculated()
        prepareSetup()
        updateScrollContent()
    }
    
    func addWebLink() {
        if program.webLink != nil && program.webLink != "" {
            linkAndStatsStackedView.insertArrangedSubview(websiteLinkButton, at: 0)
            websiteLinkButton.setTitle(program.webLink?.lowercased(), for: .normal)
            websiteLinkButton.widthAnchor.constraint(equalToConstant: websiteLinkButton.intrinsicContentSize.width + 15).isActive = true
            websiteLinkButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
    }
    
    @objc func tableViewTabButtonPress(sender: UIButton) {
        sender.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        let nonSelectedButtons = headerBarButtons.filter() { $0 != sender }
        for each in nonSelectedButtons {
            each.setTitleColor(CustomStyle.thirdShade, for: .normal)
        }
        
        let title = sender.titleLabel!.text!
        accountBottomVC.updateTableViewWith(title: title)
        
        switch title {
        case "Episodes":
            currentIndex = 0
        case "Subscriptions":
            currentIndex = 1
        case "Mentions":
            currentIndex = 2
        default:
            break
        }
        
        updateScrollContent()
    }
    
    @objc func websiteButtonPress() {
        let link = linkWithPrefix(urlString: program.webLink!)
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func linkWithPrefix(urlString: String) -> String {
        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            return "http://\(urlString)"
        } else {
            return urlString
        }
    }
    
    @objc func pushSubscribersVC() {
        let subscribersVC = SubscribersVC(programName: program.name, programID: program.ID, programIDs: program.programsIDs(), subscriberIDs: program.subscriberIDs)
//        subscribersVC.hidesBottomBarWhenPushed = true
        subscribersVC.isPublic = program.isPrivate
        subscribersVC.program = program
        navigationController?.pushViewController(subscribersVC, animated: true)
    }
    
}

extension SingleProgramProfileVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let topHeight = CGFloat(headerHeight.upperBound) - CGFloat(headerHeight.lowerBound)
        
        if scrollView.contentOffset.y < topHeight {
            self.scrollView.contentOffset.y = scrollView.contentOffset.y
            accountBottomVC.activeTV.contentOffset.y = 0
        } else {
            self.scrollView.contentOffset.y = CGFloat(headerHeight.upperBound) - CGFloat(headerHeight.lowerBound)
            (self.tableViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.scrollView.contentOffset.y
        }
        
        if scrollView.contentOffset.y < 0{
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: min(topHeight, scrollView.contentOffset.y),
                                      width: headerView.frame.width,
                                      height: max(CGFloat(headerHeight.lowerBound), CGFloat(headerHeight.upperBound) + -scrollView.contentOffset.y))
            
        } else {
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: 0,
                                      width: headerView.frame.width,
                                      height: CGFloat(headerHeight.upperBound))
        }
        
        //        let offset = self.scrollView.contentOffset.y + unwrapDifference
        //        let difference = UIScreen.main.bounds.height - headerHeight.upperBound
        //
        //        guard let tabBarHeight = tabBarController?.tabBar.frame.height else { return }
        //
        //        let introPosition = (difference - tabBarHeight - 70) + offset
        //        let audioPosition = (difference - tabBarHeight) + offset
        //
        //        accountBottomVC.yOffset = self.scrollView.contentOffset.y
        //        accountBottomVC.introPlayer.updateYPositionWith(value: introPosition)
        //        accountBottomVC.audioPlayer.updateYPositionWith(value: audioPosition)
        
        let progress = self.scrollView.contentOffset.y / topHeight
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade
        
        if progress > 0.2 {
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = program.username
        } else {
            navigationItem.title = ""
        }
        
        if progress > 0.97 {
            customNavBar.alpha = 1
        } else {
            customNavBar.alpha = 0.9
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 90.0 {
            switch accountBottomVC.activeTV {
            case accountBottomVC.episodeTV:
                if !accountBottomVC.isFetchingEpisodes {
                    accountBottomVC.fetchProgramsEpisodes()
                }
            case accountBottomVC.mentionTV:
                print("mentionTV")
            case accountBottomVC.subscriptionTV:
                print("subscriptionTV")
            default:
                break
            }
        }
    }
}

extension SingleProgramProfileVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        print("LANDED")

        switch setting {
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
        case "Share via...":
            DynamicLinkHandler.createLinkFor(program: program) { [weak self] url in
                guard let self = self else { return }
                let promoText = "Check out \(self.program.name) on Dune."
                let items: [Any] = [promoText, url]
                let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                DispatchQueue.main.async {
                    self.present(ac, animated: true)
                }
            }
        case "Share via SMS":
            DynamicLinkHandler.createLinkFor(program: program) { [weak self] url in
                guard let self = self else { return }
                let promoText = "Check out \(self.program.name) on Dune. \(url)"
                DispatchQueue.main.async {
                    self.shareViaSMSWith(messageBody: promoText)
                }
            }
        default:
            break
        }
    }
}

extension SingleProgramProfileVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        FireStoreManager.reportProgramWith(programID: program.ID)
    }
    
    func cancelButtonPress() {
        //
    }
    
}

extension SingleProgramProfileVC: MFMessageComposeViewControllerDelegate {
    
    func shareViaSMSWith(messageBody: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = messageBody
            controller.messageComposeDelegate = self
            present(controller, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        dismiss(animated: true, completion: nil)
    }

}







