//
//  ViewController.swift
//  TwitterProfile
//
//  Created by OfTheWolf on 08/18/2019.
//  Copyright (c) 2019 OfTheWolf. All rights reserved.
//

import UIKit
import Firebase

protocol updateProgramAccountScrollDelegate {
    func updateScrollContent()
}

class ProgramAccountVC : UIViewController {
        
    let minHeight = UIDevice.current.navBarHeight() + 40
    let navHeight = UIDevice.current.navBarHeight()

    var imageSize: CGFloat = 80.0
    var subProgramSize: CGFloat = 64
    let maxPrograms = 10
    
    var unwrapped = false
    var unwrapDifference: CGFloat = 0
    
    let viewFrame = UIScreen.main.bounds
    var headerHeight: ClosedRange<CGFloat>!
    var tableViews: [Int: UIView] = [:]
    var currentIndex: Int = 0
    
    let accountBottomVC = ProgramAccountBottomVC()
   
    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)    
    let nonPublisherAlert = CustomAlertView(alertType: .notAPublisher)
    
    lazy var headerBarButtons: [UIButton] = [episodesButton, subscriptionsButton, mentionsButton]
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.9
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = UIScreen.main.bounds
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
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
    
    let playIntroButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
//    let requestButton: UIButton = {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "requests-pending"), for: .normal)
//        button.contentEdgeInsets  = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(viewPendingRequests), for: .touchUpInside)
//        button.isUserInteractionEnabled = true
//        return button
//    }()
    
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
    
    lazy var episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        label.text = "\(CurrentProgram.episodeIDs!.count)"
        return label
    }()
    
    let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var repCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        label.text = "\(CurrentProgram.rep!)"
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
    
    let editProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "edit-account-icon"), for: .normal)
        button.setTitle("Edit Channel", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(editProgramButtonPress), for: .touchUpInside)
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
    
    let multipleProgramsLabelView: UIView = {
        let view = UIView()
        return view
    }()
    
    let multipleProgramsLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Multiple channels"
        return label
    }()
    
    let multipleProgramsSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Create sub-channels for @\(User.username!)"
        return label
    }()
    
    let programsScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    let programsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let addIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add-program-icon")
        return view
    }()
    
    let createLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Create"
        label.textAlignment = .center
        return label
    }()
    
    let tableViewButtons: UIView = {
        let view = UIView()
        return view
    }()
    
    let tableViewButtonsLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        nonPublisherAlert.alertDelegate = self
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        programsScrollView.setScrollBarToTopLeft()
        overlayScrollView.setScrollBarToTopLeft()
        configurePrivacyState()
        configureSubAccounts()
        configureIntroButton()
        setupNavigationBar()
        addWebLink()

        nameLabel.text = CurrentProgram.name
        mainImage.image = CurrentProgram.image!
        usernameLabel.text = "@\(User.username!)"
        repCountLabel.text = String(CurrentProgram.rep!)
        categoryLabel.text = CurrentProgram.primaryCategory
        subscriberCountLabel.text = "\(CurrentProgram.subscriberCount!.roundedWithAbbreviations)"
        
        configureSummary()
        configureEpisodeLabel()

        if unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
        }
    }
    
    func  configurePrivacyState() {
        switch CurrentProgram.privacyStatus {
        case .madePrivate:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: privacyImage(), style: .plain, target: self, action: #selector(viewPendingRequests))
        case .madePublic:
            navigationItem.leftBarButtonItem = nil
        default:
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func privacyImage() -> UIImage {
        if CurrentProgram.pendingChannels!.isEmpty {
            return UIImage(named: "no-requests-pending")!
        } else {
           return UIImage(named: "requests-pending")!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {        
        headerHeight = (minHeight)...headerHeightCalculated()
        prepareSetup()
        updateScrollContent()
        DispatchQueue.main.async {
            if self.summaryTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewTabButtonPress(sender: episodesButton)
        websiteLinkButton.removeConstraints(websiteLinkButton.constraints)
        websiteLinkButton.removeFromSuperview()
        createLabel.removeFromSuperview()
        addIconView.removeFromSuperview()

        for each in programsScrollView.subviews {
            if each is UILabel {
                each.removeFromSuperview()
            }
        }

        let buttons = programsStackView.subviews as! [UIButton]
            for each in buttons {
                each.setImage(UIImage(), for: .normal)
                each.removeTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
                each.removeTarget(self, action: #selector(createProgram), for: .touchUpInside)
            }
    }
    
    func setupNavigationBar() {
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: CustomStyle.primaryBlack]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.tintColor = CustomStyle.primaryBlack
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
    }
    
    func configureEpisodeLabel() {
        let episodes = CurrentProgram.episodeIDs
        let subscribers = CurrentProgram.subscriberCount

        if episodes!.count == 1 {
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
    
    func configureSummary() {
        if CurrentProgram.summary != "" {
           summaryTextView.text = CurrentProgram.summary
        } else {
             summaryTextView.text = "Include a program summary. Why should people subscribe, what insights do you offer?"
        }
       
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
        var height: CGFloat = 120 + navHeight
        
        for each in headerView.subviews {
            height += each.frame.height
        }
        
        if headerView.subviews.contains(moreButton) {
            height -= moreButton.frame.height
        }
            
        accountBottomVC.headerHeight = height
        return height
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            imageSize = 60
            subProgramSize = 55
            editProgramButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            shareProgramButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
        view.addSubview(overlayScrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        
//        view.addSubview(navBarView)
//        navBarView.translatesAutoresizingMaskIntoConstraints = false
//        navBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        navBarView.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight()).isActive = true
        
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
        mainImage.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
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
        
        buttonsStackedView.addArrangedSubview(editProgramButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        headerView.addSubview(multipleProgramsLabelView)
        multipleProgramsLabelView.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsLabelView.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 20).isActive = true
        multipleProgramsLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        multipleProgramsLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        multipleProgramsLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        multipleProgramsLabelView.addSubview(multipleProgramsLabel)
        multipleProgramsLabel.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsLabel.topAnchor.constraint(equalTo: multipleProgramsLabelView.topAnchor, constant: 5).isActive = true
        multipleProgramsLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true
        
        multipleProgramsLabelView.addSubview(multipleProgramsSubLabel)
        multipleProgramsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsSubLabel.topAnchor.constraint(equalTo: multipleProgramsLabel.bottomAnchor, constant: 5).isActive = true
        multipleProgramsSubLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true
        
        headerView.addSubview(programsScrollView)
        programsScrollView.translatesAutoresizingMaskIntoConstraints = false
        programsScrollView.topAnchor.constraint(equalTo: multipleProgramsLabelView.bottomAnchor, constant: 20).isActive = true
        programsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        programsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programsScrollView.heightAnchor.constraint(equalToConstant: 85).isActive = true
        
        programsScrollView.addSubview(programsStackView)
        programsStackView.translatesAutoresizingMaskIntoConstraints = false
        programsStackView.topAnchor.constraint(equalTo: programsScrollView.topAnchor).isActive = true
        programsStackView.bottomAnchor.constraint(equalTo: programsScrollView.bottomAnchor).isActive = true
        programsStackView.leadingAnchor.constraint(equalTo: programsScrollView.leadingAnchor, constant: 16).isActive = true
        programsStackView.trailingAnchor.constraint(equalTo: programsScrollView.trailingAnchor, constant: -16).isActive = true
        
        headerView.addSubview(tableViewButtons)
        tableViewButtons.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtons.topAnchor.constraint(equalTo: programsStackView.bottomAnchor, constant: 40).isActive = true
        tableViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableViewButtons.addSubview(episodesButton)
        episodesButton.translatesAutoresizingMaskIntoConstraints = false
        episodesButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: -4).isActive = true
        episodesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        tableViewButtons.addSubview(subscriptionsButton)
        subscriptionsButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: -4).isActive = true
        subscriptionsButton.leadingAnchor.constraint(equalTo: episodesButton.trailingAnchor, constant: 20).isActive = true
        
        tableViewButtons.addSubview(mentionsButton)
        mentionsButton.translatesAutoresizingMaskIntoConstraints = false
        mentionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: -4).isActive = true
        mentionsButton.leadingAnchor.constraint(equalTo: subscriptionsButton.trailingAnchor, constant: 20).isActive = true
        
        tableViewButtons.addSubview(tableViewButtonsLine)
        tableViewButtonsLine.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtonsLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableViewButtonsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtonsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtonsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        createProgramButtons()
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addWebLink() {
        if CurrentProgram.webLink != nil && CurrentProgram.webLink != "" {
        linkAndStatsStackedView.insertArrangedSubview(websiteLinkButton, at: 0)
        websiteLinkButton.setTitle(CurrentProgram.webLink?.lowercased(), for: .normal)
        websiteLinkButton.widthAnchor.constraint(equalToConstant: websiteLinkButton.intrinsicContentSize.width + 15).isActive = true
        websiteLinkButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
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

    func configureIntroButton() {
        if CurrentProgram.hasIntro == true {
            playIntroButton.setTitle("Play Intro", for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryYellow
            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            playIntroButton.removeTarget(self, action:  #selector(recordIntro), for: .touchUpInside)
            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
        } else {
            playIntroButton.setImage(nil, for: .normal)
            playIntroButton.setTitle("Add Intro", for: .normal)
            playIntroButton.setTitleColor(.black, for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryYellow
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            playIntroButton.removeTarget(self, action: #selector(playIntro), for: .touchUpInside)
            playIntroButton.addTarget(self, action: #selector(recordIntro), for: .touchUpInside)
        }
    }
    
    func configureSubAccounts() {
        let buttons = programsStackView.subviews as! [UIButton]
        
        if CurrentProgram.programIDs!.count == maxPrograms {
            
            for (index, item) in CurrentProgram.subPrograms!.enumerated() {
                if item.image == nil {
                    FileManager.getImageWith(imageID: item.imageID!) { image in
                        DispatchQueue.main.async {
                            buttons[index].setImage(image, for: .normal)
                        }
                    }
                } else {
                    buttons[index].setImage(item.image, for: .normal)
                }
                buttons[index].addTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
            }
            
            createProgramLabels()
        } else if CurrentProgram.programIDs!.count < maxPrograms {
            configureCreationButton()
            
            for (index, item) in CurrentProgram.subPrograms!.enumerated() {
                if item.image == nil {
                    FileManager.getImageWith(imageID: item.imageID!) { image in
                        DispatchQueue.main.async {
                            buttons[index + 1].setImage(image, for: .normal)
                        }
                    }
                } else {
                    buttons[index + 1].setImage(item.image, for: .normal)
                }
                buttons[index + 1].addTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
            }
            createProgramLabels()
        } else {
            configureCreationButton()
        }
    }
    
    @objc func programSelection(sender: UIButton) {
        let buttons = programsStackView.subviews as! [UIButton]
        let programs = CurrentProgram.subPrograms!
        var index = buttons.firstIndex(of: sender)!
        
        if CurrentProgram.programIDs!.count != maxPrograms {
            index -= 1
        }
        
        let program = programs[index]
        
//        let subProgramVC = SingleProgramProfileVC(program: program)
        let subProgramVC = SubProgramAccountVC(program: program)
        navigationController?.pushViewController(subProgramVC, animated: true)
    }
    
    func configureCreationButton() {
        let firstView = programsStackView.arrangedSubviews[0] as! UIButton
        firstView.addTarget(self, action: #selector(createProgram), for: .touchUpInside)
        firstView.addSubview(addIconView)
        addIconView.translatesAutoresizingMaskIntoConstraints = false
        addIconView.centerYAnchor.constraint(equalTo: firstView.centerYAnchor).isActive = true
        addIconView.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        
        programsScrollView.addSubview(createLabel)
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        createLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 5).isActive = true
        createLabel.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        createLabel.widthAnchor.constraint(equalTo: firstView.widthAnchor).isActive = true
    }
    
    func createProgramButtons() {
        for _ in 1...maxPrograms {
            let button = program()
            programsStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: subProgramSize).isActive = true
            button.widthAnchor.constraint(equalToConstant: subProgramSize).isActive = true
        }
    }
    
    func createProgramLabels() {
        for (index, item) in CurrentProgram.subPrograms!.enumerated() {
            let label = programLabel()
            label.text = item.name
            
            if CurrentProgram.subPrograms!.count == 10 {
                let button = programsStackView.arrangedSubviews[index]
                addConstraintsToProgram(label: label, with: button)
            } else {
                let button = programsStackView.arrangedSubviews[index + 1]
                addConstraintsToProgram(label: label, with: button)
            }
        }
    }
    
    func addConstraintsToProgram(label: UILabel, with button: UIView) {
        programsScrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }
    
    @objc func createProgram() {
        if !User.isPublisher! {
            UIApplication.shared.keyWindow!.addSubview(nonPublisherAlert)
        } else {
            let createProgramVC = CreateProgramVC()
            createProgramVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(createProgramVC, animated: true)
        }
    }
    
    func program() -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
    
    func programLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = CustomStyle.fifthShade
        label.textAlignment = .center
        return label
    }
    
    // MARK: Play Intro
    @objc func playIntro() {
        accountBottomVC.playIntro()
    }
    
    @objc func recordIntro() {
        let recordBoothVC = RecordBoothVC()
        recordBoothVC.currentScope = .intro
        navigationController?.pushViewController(recordBoothVC, animated: true)
    }
    
    
    // MARK: Table View Tab Button
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
        let link = linkWithPrefix(urlString: CurrentProgram.webLink!)
    
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
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
 
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func moreUnwrap() {
        let heightBefore = summaryTextView.frame.height
        unwrapped = true
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(CurrentProgram.summary!) "
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
    
    @objc func editProgramButtonPress() {
        let editProgramVC = EditProgramVC()
        editProgramVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProgramVC, animated: true)
    }
    
    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }
    
    @objc func pushSubscribersVC() {
        let subscribersVC = SubscribersVC(programName: CurrentProgram.name!, programID: CurrentProgram.ID!, programIDs: CurrentProgram.programsIDs(), subscriberIDs: CurrentProgram.subscriberIDs!)
        subscribersVC.hidesBottomBarWhenPushed = true
        subscribersVC.isPublic = CurrentProgram.isPrivate!
        navigationController?.pushViewController(subscribersVC, animated: true)
    }
    
    @objc func viewPendingRequests() {
        let requests = PendingRequestsVC(pendingIDs: CurrentProgram.pendingChannels!)
        navigationController?.pushViewController(requests, animated: true)
    }
    
}

public extension UIScrollView{
    func doNotAdjustContentInset(){
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension ProgramAccountVC: UIScrollViewDelegate {
   
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
//
        let progress = self.scrollView.contentOffset.y / topHeight
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade
        
        if progress > 0.2 {
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = User.username
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
                accountBottomVC.fetchEpisodes()
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

extension ProgramAccountVC: CustomAlertDelegate {
   
    func primaryButtonPress() {
        editProgramButtonPress()
    }
    
    func cancelButtonPress() {
        //
    }
    
    
    
}




