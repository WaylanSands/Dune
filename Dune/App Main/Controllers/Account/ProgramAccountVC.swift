////
////  ProgramAccountVC.swift
////  Dune
////
////  Created by Waylan Sands on 4/3/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ProgramAccountVC: UIViewController {
//
//    var summaryHeightClosed: CGFloat = 0
//    var tagContentWidth: NSLayoutConstraint!
//    var summaryViewHeight: NSLayoutConstraint!
//    var tableViewHeight: NSLayoutConstraint!
//    var largeImageSize: CGFloat = 80.0
//    var fontNameSize: CGFloat = 16
//    var fontIDSize: CGFloat = 14
//    var unwrapped = false
//    
//    var selectedCellRow: Int?
//    
//    var contentViewHeight: NSLayoutConstraint!
//    var flexHeightConstraint: NSLayoutConstraint!
//    
//     var tableViewBottomConstraint: NSLayoutConstraint!
//     var subscriptionBottomConstraint: NSLayoutConstraint!
//    
//    var topSectionHeightMin: CGFloat = UIDevice.current.navBarHeight() + 40
//    var topSectionHeightMax: CGFloat = 0
//    
//    // Episode Table view
//    var batchLimit = 10
////    var subscriptionIDs = [String]()
//    var programIDs = [String]()
//    var fetchedEpisodeIDs = [String]()
//    var episodesToFetch = [String]()
//    var episodeIDs = [String]()
//    
//    let episodeLoadingView = TVLoadingAnimationView(topHeight: 15)
//    let programLoadingView = TVLoadingAnimationView(topHeight: 15)
//    
//    var initialEpisodesSnapshot = [QueryDocumentSnapshot]()
//    var downloadedEpisodes = [Episode]()
////    var episodesFetched = [String]()
////    var episodeIDs = [String]()
//    
//    var lastEpisodeSnapshot: DocumentSnapshot?
//    var moreEpisodesToLoad = false
//    
//    var subAccounts = [Program]()
//    let maxPrograms = 10
//
//    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
//    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
//    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
//    
//
//    let introPlayer = DuneIntroPlayer()
//    var activeProgramCell: ProgramCell?
//    
//    let audioPlayer = DuneAudioPlayer()
//    var activeEpisodeCell: EpisodeCell?
//
//
//    let episodeTV = UITableView()
//    let subscriptionTV = ProgramSubscriptionTV()
//  
//    lazy var headerBarButtons: [UIButton] = [episodesButton, subscriptionsButton]
//
//    let flexView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let contentView: UIView = {
//         let view = UIView()
//         return view
//     }()
//    
//    let coverView: PassThoughView = {
//        let view = PassThoughView()
//        view.backgroundColor = .black
//        view.alpha = 0
//        return view
//     }()
//
//    let topDetailsView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    lazy var mainImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 7
//        imageView.clipsToBounds = true
//        imageView.frame.size = CGSize(width: 74, height: 74)
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//
//    let topMiddleStackedView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 3
//        return view
//    }()
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        label.textColor = CustomStyle.primaryBlack
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 2
//        return label
//    }()
//
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = CustomStyle.primaryBlue
//        return label
//    }()
//
//    let categoryLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = CustomStyle.fourthShade
//        return label
//    }()
//
//    // Intro button
//    let playIntroButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 13
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        return button
//    }()
//
//    let summaryTextView: UITextView = {
//        let view = UITextView()
//        view.isScrollEnabled = false
//        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        view.textContainer.lineBreakMode = .byTruncatingTail
//        view.textContainer.maximumNumberOfLines = 3
//        view.isUserInteractionEnabled = false
//        view.textContainerInset = .zero
//        view.textContainer.lineFragmentPadding = 0
//        view.textColor = CustomStyle.sixthShade
//        view.backgroundColor = .clear
//        return view
//    }()
//
//    let moreButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("more", for: .normal)
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
//        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
//        return button
//    }()
//
//    let statsView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    lazy var subscriberCountLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.sixthShade
//        label.text = "\(CurrentProgram.subscriberCount!.roundedWithAbbreviations)"
//        return label
//    }()
//
//    let subscribersLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.fourthShade
//        return label
//    }()
//
//    lazy var episodeCountLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.sixthShade
//        label.text = "\(CurrentProgram.episodeIDs!.count)"
//        return label
//    }()
//
//    let episodesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.fourthShade
//        return label
//    }()
//
//    let buttonsStackedView: UIStackView = {
//        let view = UIStackView()
//        view.distribution = .fillEqually
//        view.spacing = 10.0
//        return view
//    }()
//
//    let editProgramButton: AccountButton = {
//        let button = AccountButton()
//        button.setImage(UIImage(named: "edit-account-icon"), for: .normal)
//        button.setTitle("Edit Program", for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(editProgramButtonPress), for: .touchUpInside)
//        return button
//    }()
//
//    let shareProgramButton: AccountButton = {
//        let button = AccountButton()
//        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
//        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
//        button.setTitle("Share Program", for: .normal)
//        return button
//    }()
//
//    let multipleProgramsLabelView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let multipleProgramsLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = CustomStyle.primaryBlack
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.text = "Multiple programs"
//        return label
//    }()
//
//    let multipleProgramsSubLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = CustomStyle.primaryBlack
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.text = "Create multiple programs for @\(User.username!)"
//        return label
//    }()
//
//    let programsScrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.showsHorizontalScrollIndicator = false
//        return view
//    }()
//
//    let programsStackView: UIStackView = {
//        let view = UIStackView()
//        view.spacing = 10
//        return view
//    }()
//
//    let addIconView: UIImageView = {
//        let view = UIImageView()
//        view.image = UIImage(named: "add-program-icon")
//        return view
//    }()
//
//    let createLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = CustomStyle.primaryBlack
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.text = "Create"
//        label.textAlignment = .center
//        return label
//    }()
//
//    let tableViewButtons: UIView = {
//        let view = UIView()
//        return view
//    }()
//    
//    let tableViewButtonsLine: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomStyle.secondShade
//        return view
//    }()
//
//    let episodesButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Episodes", for: .normal)
//        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
//        return button
//    }()
//    
//    let subscriptionsButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Subscriptions", for: .normal)
//        button.setTitleColor(CustomStyle.thirdShade, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.hidesBottomBarWhenPushed = false
//        styleForScreens()
//        configureViews()
//        configureDelegates()
//        addLoadingView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        subscriptionTV.setScrollBarToTopLeft()
//        subscriptionTV.setScrollBarToTopLeft()
//        episodeTV.setScrollBarToTopLeft()
//        configureSubAccounts()
//        configureIntroButton()
//        setupTopBar()
//
//        mainImage.image = CurrentProgram.image!
//        nameLabel.text = CurrentProgram.name
//        usernameLabel.text = "@\(User.username!)"
//        categoryLabel.text = CurrentProgram.primaryCategory
//        summaryTextView.text = CurrentProgram.summary
//
//        subscriptionTV.isHidden = true
//        programIDs = programsIDs()
//        fetchEpisodeIDsForUser()
//                
//        let episodes = CurrentProgram.episodeIDs
//        let subscribers = CurrentProgram.subscriberCount
//
//        if episodes!.count == 1 {
//            episodesLabel.text = "Episode"
//        } else {
//            episodesLabel.text = "Episodes"
//        }
//
//        if subscribers == 1 {
//            subscribersLabel.text = "Subscriber"
//        } else {
//             subscribersLabel.text = "Subscribers"
//        }
//
//        if unwrapped {
//            summaryTextView.textContainer.maximumNumberOfLines = 3
//            unwrapped = false
//        }
//    }
//    
//    func programsIDs() -> [String] {
//        if CurrentProgram.hasMultiplePrograms! {
//            var ids = CurrentProgram.programIDs!
//            ids.append(CurrentProgram.ID!)
//            return ids
//        } else {
//            return [CurrentProgram.ID!]
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        setupHeightForViews()
//        if summaryTextView.lineCount() > 3 {
//            addMoreButton()
//        }
//    }
//    
//    func setupHeightForViews() {
//        var height: CGFloat = 140 + UIDevice.current.navBarHeight()
//        
//        for each in contentView.subviews {
//            height += each.frame.height
//        }
//        
//        if contentView.subviews.contains(moreButton) {
//            height -= 16
//        }
//        
//        print("This was the final height \(height)")
//        topSectionHeightMax = height
//        flexHeightConstraint.constant = topSectionHeightMax
//        contentViewHeight.constant = topSectionHeightMax
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        audioPlayer.finishSession()
//        introPlayer.finishSession()
//        subscriptionTV.downloadedPrograms.removeAll()
//        tableViewTabButtonPress(sender: episodesButton)
//        moreEpisodesToLoad = false
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        createLabel.removeFromSuperview()
//        addIconView.removeFromSuperview()
//
//        for each in programsScrollView.subviews {
//            if each is UILabel {
//                each.removeFromSuperview()
//            }
//        }
//
//        let buttons = programsStackView.subviews as! [UIButton]
//            for each in buttons {
//                each.setImage(UIImage(), for: .normal)
//                each.removeTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
//                each.removeTarget(self, action: #selector(createProgram), for: .touchUpInside)
//            }
//    }
//
//    func configureDelegates() {
//        subscriptionTV.delegate = self
//        subscriptionTV.dataSource = self
//        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
//        ownEpisodeSettings.settingsDelegate = self
//
//        episodeTV.dataSource = self
//        episodeTV.delegate = self
//        audioPlayer.playbackDelegate = self
//        introPlayer.playbackDelegate = self
//        subscriptionTV.registerCustomCell()
//    }
//    
//    func setupTopBar() {
//        let navBar = navigationController?.navigationBar
//        navigationController?.isNavigationBarHidden = false
//        navBar?.setBackgroundImage(nil, for: .default)
//        navBar?.barStyle = .default
//        navBar?.shadowImage = UIImage()
//        navBar?.tintColor = .black
//
//        navBar?.titleTextAttributes = CustomStyle.blackNavBarAttributes
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
//
//        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
//        navBar?.backIndicatorImage = imgBackArrow
//        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//    }
//
//    func styleForScreens() {
//        switch UIDevice.current.deviceType {
//        case .iPhone4S:
//            break
//        case .iPhoneSE:
//            largeImageSize = 60
//            fontNameSize = 14
//            fontIDSize = 12
//        case .iPhone8:
//            break
//        case .iPhone8Plus:
//            break
//        case .iPhone11:
//            break
//        case .iPhone11Pro:
//            break
//        case .iPhone11ProMax:
//            break
//        case .unknown:
//            break
//        }
//    }
//
//    func configureIntroButton() {
//        if CurrentProgram.hasIntro == true {
//            playIntroButton.setTitle("Play Intro", for: .normal)
//            playIntroButton.backgroundColor = CustomStyle.primaryYellow
//            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
//            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
//            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
//            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
//            playIntroButton.removeTarget(self, action:  #selector(recordIntro), for: .touchUpInside)
//            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
//        } else {
//            playIntroButton.setImage(nil, for: .normal)
//            playIntroButton.setTitle("Add Intro", for: .normal)
//            playIntroButton.setTitleColor(.white, for: .normal)
//            playIntroButton.backgroundColor = CustomStyle.primaryBlue
//            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//            playIntroButton.removeTarget(self, action: #selector(playIntro), for: .touchUpInside)
//            playIntroButton.addTarget(self, action: #selector(recordIntro), for: .touchUpInside)
//        }
//    }
//
//    func configureViews() {
//        view.backgroundColor = .white
//        
//        view.addSubview(flexView)
//        flexView.translatesAutoresizingMaskIntoConstraints = false
//        flexView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        flexView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        flexView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        flexHeightConstraint = flexView.heightAnchor.constraint(equalToConstant: topSectionHeightMax)
//        flexHeightConstraint.isActive = true
//        
//        view.addSubview(subscriptionTV)
//        subscriptionTV.translatesAutoresizingMaskIntoConstraints = false
//        subscriptionTV.topAnchor.constraint(equalTo: flexView.bottomAnchor).isActive = true
//        subscriptionTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        subscriptionTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        subscriptionBottomConstraint = subscriptionTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        subscriptionBottomConstraint.isActive = true
//        subscriptionTV.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
//        
//        view.addSubview(episodeTV)
//        episodeTV.translatesAutoresizingMaskIntoConstraints = false
//        episodeTV.topAnchor.constraint(equalTo: flexView.bottomAnchor).isActive = true
//        episodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        episodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableViewBottomConstraint = episodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        tableViewBottomConstraint.isActive = true
//        episodeTV.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
//
//        view.addSubview(contentView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.bottomAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
//        contentViewHeight.isActive = true
//        
//        contentView.addSubview(tableViewButtons)
//        tableViewButtons.translatesAutoresizingMaskIntoConstraints = false
//        tableViewButtons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        tableViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableViewButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        
//        tableViewButtons.addSubview(tableViewButtonsLine)
//        tableViewButtonsLine.translatesAutoresizingMaskIntoConstraints = false
//        tableViewButtonsLine.bottomAnchor.constraint(equalTo: tableViewButtons.bottomAnchor).isActive = true
//        tableViewButtonsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableViewButtonsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableViewButtonsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        
//        tableViewButtons.addSubview(episodesButton)
//        episodesButton.translatesAutoresizingMaskIntoConstraints = false
//        episodesButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor).isActive = true
//        episodesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        
//        tableViewButtons.addSubview(subscriptionsButton)
//        subscriptionsButton.translatesAutoresizingMaskIntoConstraints = false
//        subscriptionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor).isActive = true
//        subscriptionsButton.leadingAnchor.constraint(equalTo: episodesButton.trailingAnchor, constant: 20).isActive = true
//        
//        contentView.addSubview(programsScrollView)
//        programsScrollView.translatesAutoresizingMaskIntoConstraints = false
//        programsScrollView.bottomAnchor.constraint(equalTo: tableViewButtons.topAnchor, constant: -20).isActive = true
//        programsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        programsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        programsScrollView.heightAnchor.constraint(equalToConstant: 85).isActive = true
//
//        programsScrollView.addSubview(programsStackView)
//        programsStackView.translatesAutoresizingMaskIntoConstraints = false
//        programsStackView.topAnchor.constraint(equalTo: programsScrollView.topAnchor).isActive = true
//        programsStackView.bottomAnchor.constraint(equalTo: programsScrollView.bottomAnchor).isActive = true
//        programsStackView.leadingAnchor.constraint(equalTo: programsScrollView.leadingAnchor, constant: 16).isActive = true
//        programsStackView.trailingAnchor.constraint(equalTo: programsScrollView.trailingAnchor, constant: -16).isActive = true
//
//        createProgramButtons()
//        
//        contentView.addSubview(multipleProgramsLabelView)
//        multipleProgramsLabelView.translatesAutoresizingMaskIntoConstraints = false
//        multipleProgramsLabelView.bottomAnchor.constraint(equalTo: programsScrollView.topAnchor, constant: -20).isActive = true
//        multipleProgramsLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        multipleProgramsLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        multipleProgramsLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        multipleProgramsLabelView.addSubview(multipleProgramsLabel)
//        multipleProgramsLabel.translatesAutoresizingMaskIntoConstraints = false
//        multipleProgramsLabel.topAnchor.constraint(equalTo: multipleProgramsLabelView.topAnchor, constant: 5).isActive = true
//        multipleProgramsLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true
//
//        multipleProgramsLabelView.addSubview(multipleProgramsSubLabel)
//        multipleProgramsSubLabel.translatesAutoresizingMaskIntoConstraints = false
//        multipleProgramsSubLabel.topAnchor.constraint(equalTo: multipleProgramsLabel.bottomAnchor, constant: 5).isActive = true
//        multipleProgramsSubLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true
//        
//        contentView.addSubview(buttonsStackedView)
//        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsStackedView.bottomAnchor.constraint(equalTo: multipleProgramsLabelView.topAnchor, constant: -20).isActive = true
//        buttonsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        buttonsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
//
//        buttonsStackedView.addArrangedSubview(editProgramButton)
//        buttonsStackedView.addArrangedSubview(shareProgramButton)
//        
//        contentView.addSubview(statsView)
//        statsView.translatesAutoresizingMaskIntoConstraints = false
//        statsView.bottomAnchor.constraint(equalTo: buttonsStackedView.topAnchor, constant: -20).isActive = true
//        statsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        statsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        statsView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        statsView.addSubview(subscriberCountLabel)
//        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
//        subscriberCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        subscriberCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//
//        statsView.addSubview(subscribersLabel)
//        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
//        subscribersLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        subscribersLabel.leadingAnchor.constraint(equalTo: subscriberCountLabel.trailingAnchor, constant: 5).isActive = true
//
//        statsView.addSubview(episodeCountLabel)
//        episodeCountLabel.translatesAutoresizingMaskIntoConstraints = false
//        episodeCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        episodeCountLabel.leadingAnchor.constraint(equalTo: subscribersLabel.trailingAnchor, constant: 15).isActive = true
//
//        statsView.addSubview(episodesLabel)
//        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
//        episodesLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        episodesLabel.leadingAnchor.constraint(equalTo: episodeCountLabel.trailingAnchor, constant: 5).isActive = true
//        
//        contentView.addSubview(summaryTextView)
//        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
//        summaryTextView.bottomAnchor.constraint(equalTo: subscriberCountLabel.topAnchor, constant: -20).isActive = true
//        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        
//        contentView.addSubview(topDetailsView)
//        topDetailsView.translatesAutoresizingMaskIntoConstraints = false
//        topDetailsView.bottomAnchor.constraint(equalTo: summaryTextView.topAnchor, constant: -20).isActive = true
//        topDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        topDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        topDetailsView.heightAnchor.constraint(equalToConstant: 80).isActive = true
//
//        topDetailsView.addSubview(mainImage)
//        mainImage.translatesAutoresizingMaskIntoConstraints = false
//        mainImage.topAnchor.constraint(equalTo:topDetailsView.topAnchor, constant: 0).isActive = true
//        mainImage.leadingAnchor.constraint(equalTo:topDetailsView.leadingAnchor).isActive = true
//        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//
//        topDetailsView.addSubview(playIntroButton)
//        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
//        playIntroButton.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
//        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
//
//        topDetailsView.addSubview(topMiddleStackedView)
//        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
//        topMiddleStackedView.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
//        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
//        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: playIntroButton.leadingAnchor, constant: -20).isActive = true
//        topMiddleStackedView.addArrangedSubview(nameLabel)
//        topMiddleStackedView.addArrangedSubview(usernameLabel)
//        topMiddleStackedView.addArrangedSubview(categoryLabel)
//
//        view.addSubview(introPlayer)
//        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
//        
//        view.addSubview(audioPlayer)
//        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
//    }
//    
//    func addLoadingView() {
//        view.addSubview(episodeLoadingView)
//        episodeLoadingView.translatesAutoresizingMaskIntoConstraints = false
//        episodeLoadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
//        episodeLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        episodeLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        episodeLoadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
//        
//        view.bringSubviewToFront(introPlayer)
//        view.bringSubviewToFront(audioPlayer)
//    }
//    
//    func addProgramLoadingView() {
//        view.addSubview(programLoadingView)
//        programLoadingView.translatesAutoresizingMaskIntoConstraints = false
//        programLoadingView.topAnchor.constraint(equalTo: subscriptionTV.topAnchor).isActive = true
//        programLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        programLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        programLoadingView.bottomAnchor.constraint(equalTo: subscriptionTV.bottomAnchor).isActive = true
//        
//        view.bringSubviewToFront(introPlayer)
//        view.bringSubviewToFront(audioPlayer)
//    }
//    
//    func resetTableView() {
//        print("Reset")
//        addLoadingView()
//        navigationItem.title = ""
//        fetchedEpisodeIDs = [String]()
//        downloadedEpisodes = [Episode]()
//        episodeIDs = [String]()
//        episodeTV.isHidden = false
//        episodeTV.reloadData()
//    }
//    
//    // MARK: Fetch batch of episode IDs
//    func fetchEpisodeIDsForUser() {
//        FireStoreManager.fetchEpisodesIDsWith(with: programIDs) { ids in
//            
//            if ids.isEmpty {
//                print("No episodes to display")
//                self.resetTableView()
//                self.episodeTV.isHidden = true
//                self.navigationItem.title = ""
//            } else {
//                 if ids.count != self.episodeIDs.count {
//                    self.resetTableView()
//                    self.episodeIDs = ids
//                    self.loadFirstBatch()
//                }
//            }
//        }
//    }
//
//    func loadFirstBatch() {
//         var endIndex = batchLimit
//        
//         if episodeIDs.count < batchLimit {
//             endIndex = episodeIDs.count
//         }
//         
//         episodesToFetch = Array(episodeIDs[0..<endIndex])
//        
//        for eachID in episodesToFetch {
//             downloadEpisodeWith(ID: eachID)
//        }
//    }
//    
//    func  loadNextBatch() {
//        var endIndex = batchLimit
//        
//        if (episodeIDs.count - fetchedEpisodeIDs.count) < batchLimit {
//             endIndex = episodeIDs.count - fetchedEpisodeIDs.count
//         }
//
//        let lastEp = fetchedEpisodeIDs.last!
//        let startIndex = episodeIDs.firstIndex(of: lastEp)
//        endIndex += startIndex!
//        
//        episodesToFetch = Array(episodeIDs[startIndex!..<endIndex])
//        
//        for eachID in episodesToFetch {
//             downloadEpisodeWith(ID: eachID)
//        }
//    }
//    
//    // MARK: Download episodes
//    var batch = [Episode]()
//    
//    func downloadEpisodeWith(ID: String) {
//                        
//        let alreadyDownloaded = self.fetchedEpisodeIDs.contains(where: { $0 == ID })
//               
//        if !alreadyDownloaded {
//            FireStoreManager.getEpisodeDataWith(ID: ID) { (data) in
//                
//                let episode = Episode(data: data)
//                self.batch.append(episode)
//                
//                if self.batch.count == self.episodesToFetch.count{
//                   
//                    let orderedBatch = self.batch.sorted { (epA , epB) -> Bool in
//                        let dateA = epA.timeStamp.dateValue()
//                        let dateB = epB.timeStamp.dateValue()
//                        return dateA > dateB
//                    }
//                    
//                    for each in orderedBatch {
//                        self.downloadedEpisodes.append(each)
//                        self.audioPlayer.downloadedEpisodes.append(each)
//                        self.audioPlayer.audioIDs.append(each.audioID)
//                    }
//                    
//                    print("Im here")
//                    self.fetchedEpisodeIDs += self.episodesToFetch
//                    self.episodeLoadingView.removeFromSuperview()
//                    self.episodesToFetch.removeAll()
//                    self.episodeTV.reloadData()
//                    self.batch.removeAll()
//                }
//            }
//        }
//    }
//
//
//    func configureSubAccounts() {
//        let buttons = programsStackView.subviews as! [UIButton]
//
//        if CurrentProgram.hasMultiplePrograms! && CurrentProgram.programIDs!.count == maxPrograms {
//
//            for (index, item) in CurrentProgram.subPrograms!.enumerated() {
//                if item.image == nil {
//                    FileManager.getImageWith(imageID: item.imageID!) { image in
//                        DispatchQueue.main.async {
//                            buttons[index].setImage(image, for: .normal)
//                        }
//                    }
//                } else {
//                    buttons[index].setImage(item.image, for: .normal)
//                }
//                buttons[index].addTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
//            }
//
//            createProgramLabels()
//        } else if CurrentProgram.hasMultiplePrograms! && CurrentProgram.programIDs!.count < maxPrograms {
//            configureCreationButton()
//
//            for (index, item) in CurrentProgram.subPrograms!.enumerated() {
//                if item.image == nil {
//                    FileManager.getImageWith(imageID: item.imageID!) { image in
//                        DispatchQueue.main.async {
//                            buttons[index + 1].setImage(image, for: .normal)
//                        }
//                    }
//                } else {
//                     buttons[index + 1].setImage(item.image, for: .normal)
//                }
//                buttons[index + 1].addTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
//            }
//            createProgramLabels()
//        } else {
//            configureCreationButton()
//        }
//    }
//
//    @objc func programSelection(sender: UIButton) {
//        let buttons = programsStackView.subviews as! [UIButton]
//        let programs = CurrentProgram.subPrograms!
//        var index = buttons.firstIndex(of: sender)!
//
//        print("Current program count \(CurrentProgram.programIDs!.count)")
//        if CurrentProgram.programIDs!.count != maxPrograms {
//            index -= 1
//        }
//
//        let program = programs[index]
//
//        let subProgramVC = SubProgramAccountVC(program: program)
//        navigationController?.pushViewController(subProgramVC, animated: true)
//    }
//
//    func configureCreationButton() {
//        let firstView = programsStackView.arrangedSubviews[0] as! UIButton
//        firstView.addTarget(self, action: #selector(createProgram), for: .touchUpInside)
//        firstView.addSubview(addIconView)
//        addIconView.translatesAutoresizingMaskIntoConstraints = false
//        addIconView.centerYAnchor.constraint(equalTo: firstView.centerYAnchor).isActive = true
//        addIconView.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
//
//        programsScrollView.addSubview(createLabel)
//        createLabel.translatesAutoresizingMaskIntoConstraints = false
//        createLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 5).isActive = true
//        createLabel.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
//        createLabel.widthAnchor.constraint(equalTo: firstView.widthAnchor).isActive = true
//    }
//
//    func createProgramButtons() {
//        for _ in 1...maxPrograms {
//            let button = program()
//            programsStackView.addArrangedSubview(button)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            button.heightAnchor.constraint(equalToConstant: 64).isActive = true
//            button.widthAnchor.constraint(equalToConstant: 64).isActive = true
//        }
//    }
//
//    func createProgramLabels() {
//        for (index, item) in CurrentProgram.subPrograms!.enumerated() {
//            let label = programLabel()
//            label.text = item.name
//
//            if CurrentProgram.subPrograms!.count == 10 {
//                let button = programsStackView.arrangedSubviews[index]
//                addConstraintsToProgram(label: label, with: button)
//            } else {
//                let button = programsStackView.arrangedSubviews[index + 1]
//                addConstraintsToProgram(label: label, with: button)
//            }
//        }
//    }
//
//    func addConstraintsToProgram(label: UILabel, with button: UIView) {
//        programsScrollView.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
//        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
//        label.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
//    }
//
//    @objc func createProgram() {
//        let createProgramVC = CreateProgramVC()
//        createProgramVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(createProgramVC, animated: true)
//    }
//
//    func program() -> UIButton {
//        let button = UIButton()
//        button.backgroundColor = CustomStyle.secondShade
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        return button
//    }
//
//    func programLabel() -> UILabel {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
//        label.textColor = CustomStyle.fifthShade
//        label.textAlignment = .center
//        return label
//    }
//    
//    // MARK: Play Intro
//
//    @objc func playIntro() {
//        
//        introPlayer.isProgramPageIntro = true
//        if !audioPlayer.isOutOfPosition {
//            audioPlayer.finishSession()
//        }
//        
//        print("Height is \(view.frame.height - tabBarController!.tabBar.frame.height - introPlayer.frame.height)")
//        
//        introPlayer.yPosition = view.frame.height - tabBarController!.tabBar.frame.height - introPlayer.frame.height
//
//        introPlayer.getAudioWith(audioID: CurrentProgram.introID!) { url in
//            self.introPlayer.playOrPauseWith(url: url, name: CurrentProgram.name!, image: CurrentProgram.image!)
//        }
//        print("Play intro")
//    }
//
//    @objc func recordIntro() {
//        let recordBoothVC = RecordBoothVC()
//        recordBoothVC.currentScope = .intro
//        navigationController?.pushViewController(recordBoothVC, animated: true)
//    }
//
//
//    func addMoreButton() {
//        DispatchQueue.main.async {
//            self.contentView.addSubview(self.moreButton)
//            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
//            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
//            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
//            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
//
//            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
//                   let path = UIBezierPath(rect: rect)
//            self.summaryTextView.textContainer.exclusionPaths = [path]
//        }
//        
//    }
//    
//    // MARK: Select TV tab button
//    @objc func tableViewTabButtonPress(sender: UIButton) {
//        
//        sender.setTitleColor(CustomStyle.primaryBlack, for: .normal)
//        let nonSelectedButtons = headerBarButtons.filter() { $0 != sender }
//        for each in nonSelectedButtons {
//            each.setTitleColor(CustomStyle.thirdShade, for: .normal)
//        }
//        
//        switch sender.titleLabel?.text {
//        case "Episodes":
//            episodeTV.isHidden = false
//            subscriptionTV.isHidden = true
//            episodeLoadingView.isHidden = false
//            programLoadingView.removeFromSuperview()
//            tableViewBottomConstraint.isActive = true
//            subscriptionBottomConstraint.isActive = false
//        case "Subscriptions":
//            episodeTV.isHidden = true
//            episodeLoadingView.isHidden = true
//            subscriptionTV.isHidden = false
//           
//            if subscriptionTV.downloadedPrograms.isEmpty {
//               addProgramLoadingView()
//            }
//            
//            if User.subscriptionIDs?.count != subscriptionTV.downloadedPrograms.count - programsIDs().count {
//                subscriptionTV.fetchProgramsSubscriptions()
//                tableViewBottomConstraint.isActive = false
//                subscriptionBottomConstraint.isActive = true
//            }
//        default:
//            break
//        }
//    }
//
//    @objc func settingsButtonPress() {
//        let settingsVC = AccountSettingsVC()
//        settingsVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(settingsVC, animated: true)
//    }
//
//    @objc func moreUnwrap() {
//        let heightBefore = summaryTextView.frame.height
//        print("Height before : \(heightBefore)")
//        unwrapped = true
//        summaryTextView.textContainer.maximumNumberOfLines = 0
//        summaryTextView.text = "\(CurrentProgram.summary!) "
//        moreButton.removeFromSuperview()
//        summaryTextView.textContainer.exclusionPaths.removeAll()
//
//        if UIDevice.current.deviceType == .iPhoneSE {
//        }
//        summaryTextView.layoutIfNeeded()
//        contentView.layoutIfNeeded()
//        
//        let heighAfter = summaryTextView.frame.height
//        print("Height after : \(heighAfter)")
//
//        
//        let difference =  heighAfter - heightBefore
//        
//         topSectionHeightMax += difference
//         contentViewHeight.constant = topSectionHeightMax
//         flexHeightConstraint.constant = topSectionHeightMax
//         contentViewHeight.constant = topSectionHeightMax
//    }
//
//    @objc func editProgramButtonPress() {
//        let editProgramVC = EditProgramVC()
//        editProgramVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(editProgramVC, animated: true)
//    }
//
//    @objc func shareButtonPress() {
//        settingsLauncher.showSettings()
//    }
//
//}
//
//extension ProgramAccountVC: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView {
//        case episodeTV:
//            return downloadedEpisodes.count
//        case subscriptionTV:
//            return subscriptionTV.downloadedPrograms.count
//        default:
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        switch tableView {
//        case episodeTV:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
//            cell.moreButton.addTarget(cell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
//            cell.programImageButton.addTarget(cell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
//            cell.episodeSettingsButton.addTarget(cell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
//            cell.likeButton.addTarget(cell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
//
//            let episode = downloadedEpisodes[indexPath.row]
//            cell.episode = episode
//            if episode.likeCount >= 10 {
//                cell.configureCellWithOptions()
//            }
//            cell.cellDelegate = self
//            cell.normalSetUp(episode: episode)
//            return cell
//        case subscriptionTV:
//            programLoadingView.removeFromSuperview()
//            let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
//             programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
//             programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
//             programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
//             programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
//             programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
//        
//            let program = subscriptionTV.downloadedPrograms[indexPath.row]
//             programCell.program = program
//             
//             programCell.cellDelegate = self
//             programCell.normalSetUp(program: program)
//             return programCell
//        default:
//            return UITableViewCell()
//        }
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        // UITableView only moves in one direction, y axis
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//        
//        if scrollView == episodeTV {
//            if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs != episodeIDs {
//                print("loading more episodes")
//                loadNextBatch()
//            }
//        }
//    }
//
//}
//
//extension ProgramAccountVC :EpisodeCellDelegate {
//    
//    func tagSelected(tag: String) {
//        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
//        navigationController?.pushViewController(tagSelectedVC, animated: true)
//    }
//    
//    func updateRows() {
//        //
//    }
//
//    func addTappedProgram(programName: String) {
//        //
//    }
//
//    func playEpisode(cell: EpisodeCell) {
//        
//        if introPlayer.isInPosition {
//            introPlayer.finishSession()
//        }
//        
//        activeEpisodeCell = cell
//        
//        if !cell.playbackBarView.playbackBarIsSetup {
//            cell.playbackBarView.setupPlaybackBar()
//        }
//        audioPlayer.yPosition = self.tabBarController?.tabBar.frame.height
//        
//        let image = cell.programImageButton.imageView?.image
//        let audioID = cell.episode.audioID
//        
//        audioPlayer.getAudioWith(audioID: audioID) { url in
//            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
//        }
//    }
//
//    func showSettings(cell: EpisodeCell) {
//        
//        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
//        ownEpisodeSettings.showSettings()
//    }
//
//    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
//        //
//    }
//
//}
//
//extension ProgramAccountVC: SettingsLauncherDelegate {
//    
//    func selectionOf(setting: String) {
//        switch setting {
//        case "Delete":
//            deleteOwnEpisode()
//        case "Edit":
//            let episode = downloadedEpisodes[selectedCellRow!]
//            let editEpisodeVC = EditPublishedEpisode(episode: episode)
//            editEpisodeVC.delegate = self
//            navigationController?.present(editEpisodeVC, animated: true, completion: nil)
//        default:
//            break
//        }
//    }
//    
//    func deleteOwnEpisode() {
//        guard let row = self.selectedCellRow else { return }
//        print("Downloaded eps before \(downloadedEpisodes.count)")
//        let episode = downloadedEpisodes[row]
//        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
//        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp)
//        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
//        CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
//        
//        let index = IndexPath(item: row, section: 0)
//        downloadedEpisodes.remove(at: row)
//        print("Downloaded eps after \(downloadedEpisodes.count)")
//
//        episodeTV.deleteRows(at: [index], with: .fade)
//        
//        if downloadedEpisodes.count == 0 {
//            resetTableView()
//        }
//        
//        audioPlayer.transitionOutOfView()
//        
//    }
//}
//
//extension ProgramAccountVC: EpisodeEditorDelegate {
//    
//    func updateCell(episode: Episode) {
//        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
//        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
//
//        downloadedEpisodes[episodeIndex!] = episode
//        episodeTV.reloadRows(at: [indexPath], with: .fade)
//    }
// 
//}
//
//
//extension ProgramAccountVC: UIScrollViewDelegate {
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let fadeTextAnimation = CATransition()
//        fadeTextAnimation.duration = 0.5
//        fadeTextAnimation.type = CATransitionType.fade
//        
//        if flexView.frame.height != 0 && flexView.frame.height <= topSectionHeightMax - 100 {
//            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
//            navigationItem.title = User.username
//        } else {
//            navigationItem.title = ""
//        }
//        
//        let y: CGFloat = scrollView.contentOffset.y
//        let newHeaderViewHeight: CGFloat = flexHeightConstraint.constant - y
//        if newHeaderViewHeight > topSectionHeightMax {
//            flexHeightConstraint.constant = topSectionHeightMax
//        } else if newHeaderViewHeight <= topSectionHeightMin {
//            flexHeightConstraint.constant = topSectionHeightMin
//        } else {
//            flexHeightConstraint.constant = newHeaderViewHeight
//            scrollView.contentOffset.y = 0 // block scroll view
//        }
//    }
//}
//
//extension ProgramAccountVC: PlaybackBarDelegate {
//   
//    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType) {
//        switch forType {
//            case .episode:
//            guard let cell = activeEpisodeCell else { return }
//            cell.playbackBarView.progressUpdateWith(percentage: percentage)
//            case .program:
//            guard let cell = activeProgramCell else { return }
//            cell.playbackBarView.progressUpdateWith(percentage: percentage)
//        }
//    }
//    
//    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
//        switch forType {
//            case .episode:
//            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
//            cell.playbackBarView.setupPlaybackBar()
//            activeEpisodeCell = cell
//            case .program:
//            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
//            cell.playbackBarView.setupPlaybackBar()
//            activeProgramCell = cell
//        }
//    }
//
//}
//
//extension ProgramAccountVC: ProgramCellDelegate {
// 
//    func visitProfile(program: Program) {
//        print("This was hit")
//        if program.isPrimaryProgram && program.hasMultiplePrograms!  {
//            let programVC = TProgramProfileVC()
//            programVC.program = program
//            navigationController?.pushViewController(programVC, animated: true)
//        } else {
//            let programVC = SubProgramProfileVC(program: program)
//            navigationController?.present(programVC, animated: true, completion: nil)
//        }
//    }
//     
//    func playProgramIntro(cell: ProgramCell) {
//        introPlayer.isProgramPageIntro = false
//        activeProgramCell = cell
//        
//        if !audioPlayer.isOutOfPosition {
//            audioPlayer.finishSession()
//        }
//        
//        let programIntro = cell.program.introID!
//        let programImage = cell.program.image!
//        let programName = cell.program.name
//        
//        introPlayer.yPosition = view.frame.height - tabBarController!.tabBar.frame.height - introPlayer.frame.height
//        
//        introPlayer.getAudioWith(audioID: programIntro) { url in
//            self.introPlayer.playOrPauseWith(url: url, name: programName, image: programImage)
//        }
//        print("Play intro")
//    }
//    
//    func showSettings(cell: ProgramCell) {
//        programSettings.showSettings()
//    }
//
//    
//}
//
//
//
