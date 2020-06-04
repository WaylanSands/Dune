//
//  ListenerProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class ListenerProfileVC: UIViewController {

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
    var subAccounts = [Program]()
    var listener: Listener!
    
    lazy var accountBottomVC = ListenerProfileBottomVC(listener: listener)

    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let favProgramSettings = SettingsLauncher(options: SettingOptions.favouriteProgramSettings, type: .program)
    let publisherProgramSettings = SettingsLauncher(options: SettingOptions.publisherProgramSettings, type: .program)
    let nonFavouriteProgramSettings = SettingsLauncher(options: SettingOptions.nonFavouriteProgramSettings, type: .program)
    
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
        view.backgroundColor = .clear
        view.doNotAdjustContentInset()
        return view
    }()
    
    let overlayScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
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
        imageView.layer.cornerRadius = largeImageSize / 2
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
        label.text = "Listener"
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
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(websiteButtonPress), for: .touchUpInside)
        return button
    }()
    
    let linkAndStatsStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        view.isLayoutMarginsRelativeArrangement = true
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

    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()

    let subscriptionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()

    let subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
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
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
        return button
    }()

    let shareProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.setTitle("Share Program", for: .normal)
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
        label.text = "Sub-programs"
        return label
    }()

    // Maybe remove
    let multipleProgramsSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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

    let tableViewButtons: UIView = {
        let view = UIView()
        return view
    }()
    
    let episodesTVLabel: UILabel = {
        let label = UILabel()
        label.text = "Episodes"
        label.font =  UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        return label
    }()
    
    let tableViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        configureDelegates()
        styleForScreens()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        programsScrollView.setScrollBarToTopLeft()
        scrollView.setScrollBarToTopLeft()
        configureSubscribeButton()
        configureProgramStats()
        configureSubAccounts()
        setupTopBar()
        addWebLink()

        nameLabel.text = listener.displayName
        mainImage.image = listener.image!
        usernameLabel.text = "@\(listener.username)"
        summaryTextView.text = listener.summary
    }
    
    func  configureDelegates() {
        nonFavouriteProgramSettings.settingsDelegate = self
        favProgramSettings.settingsDelegate = self
    }
    
    func configureProgramStats() {
        multipleProgramsSubLabel.text = "Programs promoted you by @\(listener.username)"
        subscriberCountLabel.text = "\(listener.subscriberCount.roundedWithAbbreviations)"
        subscriptionCountLabel.text = "\(listener.subscriptionIDs.count)"
        
        let subscriptions = User.subscriptionIDs
        let subscribers = User.subscriberCount

        if subscriptions!.count == 1 {
            subscriptionsLabel.text = "Subscription"
        } else {
            subscriptionsLabel.text = "Subscriptions"
        }

        if subscribers == 1 {
            subscribersLabel.text = "Subscriber"
        } else {
             subscribersLabel.text = "Subscribers"
        }

        if unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
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
        for each in programsScrollView.subviews {
            if each is UILabel {
                each.removeFromSuperview()
            }
        }

        let buttons = programsStackView.subviews as! [UIButton]
            for each in buttons {
                each.setImage(UIImage(), for: .normal)
                each.removeTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
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

        self.tableViews[currentIndex] = accountBottomVC.episodeTV
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
    
    func setupTopBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.tintColor = CustomStyle.primaryBlack
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .black
        navigationItem.largeTitleDisplayMode = .never
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
        view.backgroundColor = .white
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
        
        linkAndStatsStackedView.addArrangedSubview(statsView)
        statsView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        statsView.addSubview(subscriberCountLabel)
        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        
        statsView.addSubview(subscribersLabel)
        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribersLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscribersLabel.leadingAnchor.constraint(equalTo: subscriberCountLabel.trailingAnchor, constant: 5).isActive = true
        
        statsView.addSubview(subscriptionCountLabel)
        subscriptionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptionCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscriptionCountLabel.leadingAnchor.constraint(equalTo: subscribersLabel.trailingAnchor, constant: 15).isActive = true
        
        statsView.addSubview(subscriptionsLabel)
        subscriptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptionsLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscriptionsLabel.leadingAnchor.constraint(equalTo: subscriptionCountLabel.trailingAnchor, constant: 5).isActive = true
        
        headerView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: linkAndStatsStackedView.bottomAnchor, constant: 20).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(subscribeButton)
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
        
        createProgramButtons()
        
        headerView.addSubview(episodesTVLabel)
        episodesTVLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesTVLabel.topAnchor.constraint(equalTo: programsStackView.bottomAnchor, constant: 30).isActive = true
        episodesTVLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        episodesTVLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        headerView.addSubview(tableViewLine)
        tableViewLine.translatesAutoresizingMaskIntoConstraints = false
        tableViewLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableViewLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
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

    func configureSubAccounts() {
        let buttons = programsStackView.subviews as! [UIButton]
            for (index, item) in listener.favouritePrograms!.enumerated() {
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
    }

    @objc func programSelection(sender: UIButton) {
        let buttons = programsStackView.subviews as! [UIButton]
        let index = buttons.firstIndex(of: sender)
        let programs = listener.favouritePrograms!
        let program = programs[index!]

        let subProgramVC = SubProgramProfileVC(program: program)
        navigationController?.present(subProgramVC, animated: true, completion: nil)
    }

    func createProgramButtons() {
        for _ in 1...maxPrograms {
            let button = subProgramButton()
            programsStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 64).isActive = true
            button.widthAnchor.constraint(equalToConstant: 64).isActive = true
        }
    }
    
    func createProgramLabels() {
        for (index, item) in listener.favouritePrograms!.enumerated() {
            let label = programLabel()
            label.text = item.name
            
            let button = programsStackView.arrangedSubviews[index]
            addConstraintsToProgram(label: label, with: button)
        }
    }

    func addConstraintsToProgram(label: UILabel, with button: UIView) {
        programsScrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }

    func subProgramButton() -> UIButton {
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
        
        let offset = self.scrollView.contentOffset.y + unwrapDifference
        let difference = UIScreen.main.bounds.height - headerHeight.upperBound
        let position = (difference - tabBarController!.tabBar.frame.height - 70) + offset
        
        if !accountBottomVC.introPlayer.isInPosition {
            accountBottomVC.introPlayer.yPosition = position
        } else {
            accountBottomVC.introPlayer.updateYPositionWith(value: position)
        }
    }
    
    func updateScrollContent() {
        let vc = accountBottomVC
        if self.tableViews[currentIndex] == nil{
            self.tableViews[currentIndex] = vc.episodeTV
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
        if !User.subscriptionIDs!.contains(listener.ID) {
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
        } else {
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
        }
    }

    // MARK: Subscribe button press
    @objc func subscribeButtonPress() {
        if User.subscriptionIDs!.contains(listener.ID) {
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithUnSubscribe(programID: program.ID)
            User.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
            configureProgramStats()
        } else {
            if User.favouriteIDs != nil && User.favouriteIDs!.count < 10 {
                FireStoreManager.addFavouriteWith(programID: program.ID)
            }
            FireStoreManager.subscribeUserToProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithSubscription(programID: program.ID)
            User.subscriptionIDs!.append(program.ID)
            program.subscriberCount += 1
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            configureProgramStats()
        }
    }

    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }
    
    @objc func settingsButtonPress() {
        if !User.isPublisher! && User.favouriteIDs!.contains(program.ID) {
            favProgramSettings.showSettings()
        } else if !User.isPublisher! && !User.favouriteIDs!.contains(program.ID) {
            nonFavouriteProgramSettings.showSettings()
        } else {
            publisherProgramSettings.showSettings()
        }
    }
    
    @objc func moreUnwrap() {
        let heightBefore = summaryTextView.frame.height
        print("Height before : \(heightBefore)")
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
        print("Height after : \(heighAfter)")
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
    
    @objc func websiteButtonPress() {
        let link = linkWithPrefix(urlString: program.webLink!)
        print("The link is \(link)")
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

}

extension ListenerProfileVC: UIScrollViewDelegate {
   
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
        
        let offset = self.scrollView.contentOffset.y + unwrapDifference
        let difference = UIScreen.main.bounds.height - headerHeight.upperBound
        let introPosition = (difference - tabBarController!.tabBar.frame.height - 70) + offset
        let audioPosition = (difference - tabBarController!.tabBar.frame.height) + offset
        
        accountBottomVC.yOffset = self.scrollView.contentOffset.y
        accountBottomVC.introPlayer.updateYPositionWith(value: introPosition)
        accountBottomVC.audioPlayer.updateYPositionWith(value: audioPosition)

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
}

extension ListenerProfileVC: SettingsLauncherDelegate {
   
    func selectionOf(setting: String) {
        switch setting {
        case "Unfavourite":
            FireStoreManager.removeFavouriteWith(programID: program.ID)
        case "Favourite":
            print("Favourite")
            FireStoreManager.addFavouriteWith(programID: program.ID)
        default:
            break
        }
    }
}






