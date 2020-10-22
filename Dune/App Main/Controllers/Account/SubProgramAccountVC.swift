//
//  SubProgramAccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class SubProgramAccountVC: UIViewController {
    
    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 74.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var unwrapped = false
    
    var program: Program!
    var programIDs = [String]()

    var listenCountUpdated = false
    var lastProgress: CGFloat = 0
    var activeCell: EpisodeCell?
    var selectedCellRow: Int?
    var lastPlayedID: String?
        
    //Episodes
    let episodeTV = UITableView()
    var downloadedEpisodes = [Episode]()
    var episodeItems = [EpisodeItem]()
    var isFetchingEpisodes = false
    var epsStartingIndex: Int = 0

//    lazy var tabBar = navigationController?.tabBarController?.tabBar
    let loadingView = TVLoadingAnimationView(topHeight: 15)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    
    let introPlayer = DuneIntroPlayer()
    
    var commentVC: CommentThreadVC!
                
    let programView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mainImage: UIImageView = {
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
    
    let subscribersButton: UIButton = {
        let button = UIButton()
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(pushSubscribersVC), for: .touchUpInside)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    lazy var episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        label.text = "\(program.episodeIDs.count)"
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
        label.text = "\(program.rep)"
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
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(editProgramButtonPress), for: .touchUpInside)
        return button
    }()
    
    let shareProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.setTitle("Share Program", for: .normal)
        return button
    }()
    
    let emptyTableView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyHeadingLabel: UILabel = {
       let label = UILabel()
        label.text = "Published episodes"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var emptySubLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "Episodes published by @\(program!.name) will also appear here."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let emptyButton: UIButton = {
       let button = UIButton()
        button.setTitle("Publish an episode", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(continueToView), for: .touchUpInside)
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 13
        return button
    }()
    
    let requestButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "requests-pending"), for: .normal)
        button.contentEdgeInsets  = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
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
//        self.hidesBottomBarWhenPushed = false
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTV.setScrollBarToTopLeft()
        configureIntroButton()
        setupTopBar()
        addWebLink()
        
        nameLabel.text = program.name
        mainImage.image = program.image
        summaryTextView.text = program.summary
        repCountLabel.text = String(program.rep)
        usernameLabel.text = "@\(program.username)"
        categoryLabel.text = program.primaryCategory
        subscriberCountLabel.text = "\(program.subscriberCount.roundedWithAbbreviations)"
        
        fetchEpisodeIDs()
        
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
        
        if  unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if summaryTextView.lineCount() > 3 {
            addMoreButton()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        websiteLinkButton.removeConstraints(websiteLinkButton.constraints)
        websiteLinkButton.removeFromSuperview()
        introPlayer.finishSession()
    }
    
    func configureDelegates() {
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        ownEpisodeSettings.settingsDelegate = self
        settingsLauncher.settingsDelegate = self
        episodeTV.dataSource = self
        episodeTV.delegate = self
    }
    
    func setupTopBar() {
        let navBar = navigationController?.navigationBar
        navigationController?.isNavigationBarHidden = false
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.tintColor = CustomStyle.primaryBlack
        navBar?.shadowImage = UIImage()
        navBar?.barStyle = .default
        
        navBar?.titleTextAttributes = CustomStyle.blackNavBarAttributes
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
        let requestsButton = UIBarButtonItem(image: privacyImage(), style: .plain, target: self, action: #selector(viewPendingRequests))
        
        navigationItem.rightBarButtonItems = nil
        switch program.channelState {
        case .madePublic:
            navigationItem.rightBarButtonItem = settingsButton
        case .madePrivate:
            navigationItem.rightBarButtonItems = [settingsButton, requestsButton]
        }
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func privacyImage() -> UIImage {
        if program.pendingChannels.isEmpty {
            return UIImage(named: "no-requests-pending")!
        } else {
           return UIImage(named: "requests-pending")!
        }
    }
    
    
    func fetchEpisodeIDs() {
        FireStoreManager.fetchEpisodesItemsWith(with: [program!.ID]) { items in
            DispatchQueue.main.async {
                if items.isEmpty {
                    self.loadingView.isHidden = true
                    self.emptyTableView.isHidden = false
                } else {
                    if items != self.episodeItems {
                        self.emptyTableView.isHidden = true
                        self.episodeItems = items
                        self.fetchEpisodes()
                    }
                }
            }
        }
    }
    
    func fetchEpisodes() {
        if downloadedEpisodes.count != episodeItems.count {
            var endIndex = 10
            
            if program.episodeIDs.count - downloadedEpisodes.count < endIndex {
                endIndex = episodeItems.count - downloadedEpisodes.count
            }
            
            endIndex += epsStartingIndex

            let items = Array(episodeItems[epsStartingIndex..<endIndex])
            epsStartingIndex = downloadedEpisodes.count + items.count
            
            self.isFetchingEpisodes = true
            FireStoreManager.fetchEpisodesWith(episodeItems: items) { episodes in
                DispatchQueue.main.async {
                    if !episodes.isEmpty {
                        self.downloadedEpisodes += episodes
                        self.episodeTV.reloadData()
                        self.loadingView.isHidden = true
                        self.isFetchingEpisodes = false
                        self.emptyTableView.isHidden = true
                    }  else {
                        self.emptyTableView.isHidden = false
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
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
            playIntroButton.setTitleColor(.black, for: .normal)
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
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(programView)
        programView.translatesAutoresizingMaskIntoConstraints = false
        programView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIDevice.current.navBarHeight()).isActive = true
        programView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        programView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: programView.topAnchor, constant:20).isActive = true
        topView.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16).isActive = true
        topView.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        topView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo:topView.topAnchor, constant: 0).isActive = true
        mainImage.leadingAnchor.constraint(equalTo:topView.leadingAnchor).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        
        topView.addSubview(playIntroButton)
        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
        playIntroButton.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        topView.addSubview(topMiddleStackedView)
        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
        topMiddleStackedView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: playIntroButton.leadingAnchor, constant: -20).isActive = true
        topMiddleStackedView.addArrangedSubview(nameLabel)
        topMiddleStackedView.addArrangedSubview(usernameLabel)
        topMiddleStackedView.addArrangedSubview(categoryLabel)
        
        view.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(linkAndStatsStackedView)
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
        subscriberCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
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
        
        view.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: linkAndStatsStackedView.bottomAnchor, constant: 20.0).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16.0).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16.0).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        view.addSubview(episodeTV)
        episodeTV.translatesAutoresizingMaskIntoConstraints = false
        episodeTV.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 15.0).isActive = true
        episodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        episodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        episodeTV.backgroundColor = CustomStyle.secondShade
        episodeTV.tableFooterView = UIView()
        episodeTV.addTopBounceAreaView()
        
        view.addSubview(emptyTableView)
        emptyTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableView.topAnchor.constraint(equalTo: episodeTV.topAnchor, constant: 80).isActive = true
        emptyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emptyTableView.addSubview(emptyHeadingLabel)
        emptyHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyHeadingLabel.topAnchor.constraint(equalTo: emptyTableView.topAnchor).isActive = true
        emptyHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyHeadingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emptyTableView.addSubview(emptySubLabel)
        emptySubLabel.translatesAutoresizingMaskIntoConstraints = false
        emptySubLabel.topAnchor.constraint(equalTo: emptyHeadingLabel.bottomAnchor).isActive = true
        emptySubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        emptySubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        emptyTableView.addSubview(emptyButton)
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
        emptyButton.topAnchor.constraint(equalTo: emptySubLabel.bottomAnchor, constant: 15).isActive = true
        emptyButton.widthAnchor.constraint(equalToConstant: emptyButton.intrinsicContentSize.width).isActive = true
        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
        
        buttonsStackedView.addArrangedSubview(editProgramButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 64)
        introPlayer.offset = 64
    }
    
    func addWebLink() {
        if program.webLink != nil && program.webLink != "" {
        linkAndStatsStackedView.insertArrangedSubview(websiteLinkButton, at: 0)
        websiteLinkButton.setTitle(program.webLink?.lowercased(), for: .normal)
        websiteLinkButton.widthAnchor.constraint(equalToConstant: websiteLinkButton.intrinsicContentSize.width + 15).isActive = true
        websiteLinkButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
    }
    
    @objc func playIntro() {
        dunePlayBar.finishSession()
        introPlayer.setProgramDetailsWith(name: program.name, username: program.username, image: program.image!)
        introPlayer.playOrPauseIntroWith(audioID: program.introID!)
    }
    
    @objc func recordIntro() {
        let recordBoothVC = RecordBoothVC()
        recordBoothVC.selectedProgram = program
        recordBoothVC.currentScope = .intro
        navigationController?.pushViewController(recordBoothVC, animated: true)
    }
    
    func addMoreButton() {
        DispatchQueue.main.async {
            self.view.addSubview(self.moreButton)
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
            
            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
            let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
    }
    
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
//        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func moreUnwrap() {
        unwrapped = true
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(program.summary) "
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
        
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        summaryTextView.layoutIfNeeded()
        programView.layoutIfNeeded()
    }
    
    @objc func editProgramButtonPress() {
        let editSubProgramVC = EditSubProgramVC(program: program)
//        editSubProgramVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editSubProgramVC, animated: true)
    }
    
    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }
    
    @objc func pushSubscribersVC() {
        let subscribersVC = SubscribersVC(programName: program.name, programID: program.ID, programIDs: program.programsIDs(), subscriberIDs: program.subscriberIDs)
//        subscribersVC.hidesBottomBarWhenPushed = true
        subscribersVC.isPublic = program.isPrivate
        subscribersVC.requestDelegate = self
        subscribersVC.program = program
        navigationController?.pushViewController(subscribersVC, animated: true)
    }
    
    @objc func continueToView() {
        duneTabBar.visit(screen: .studio)
//        duneTabBar.tabButtonSelection(2)
//        let tabBar = MainTabController()
//        tabBar.selectedIndex = 2
//        DuneDelegate.newRootView(tabBar)
    }
    
    @objc func viewPendingRequests() {
        let requests = PendingRequestsVC(pendingIDs: program.pendingChannels)
        requests.requestDelegate = self
        requests.subChannel = program
        navigationController?.pushViewController(requests, animated: true)
    }
    
}

extension SubProgramAccountVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if scrollView == episodeTV {
            if maximumOffset - currentOffset <= 90.0 {
                fetchEpisodes()
            }
        }
    }
    
}

extension SubProgramAccountVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var episodeCell: EpisodeCell
        let episode = downloadedEpisodes[indexPath.row]
        
        if episode.richLink == nil {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        } else if episode.linkIsSmall! {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCellSmlLink") as! EpisodeCellSmlLink
        } else {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCellRegLink") as! EpisodeCellRegLink
        }
        
        episodeCell.episode = episode
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.normalSetUp(episode: episode)
        episodeCell.cellDelegate = self
        
//        if episode.likeCount >= 10 && episodeCell.optionsConfigured == false {
//            episodeCell.configureCellWithOptions()
//            episodeCell.optionsConfigured = true
//        } else if episode.likeCount < 10 && episodeCell.optionsConfigured {
//            episodeCell.configureWithoutOptions()
//            episodeCell.optionsConfigured = false
//        }
        
        if let playerEpisode = dunePlayBar.episode  {
            if episode.ID == playerEpisode.ID {
                episodeCell.episode.hasBeenPlayed = true
                episodeCell.episode.playBackProgress = dunePlayBar.currentProgress
                episodeCell.setupProgressBar()
                activeCell = episodeCell
            }
        }
        return episodeCell
    }
}

extension SubProgramAccountVC :EpisodeCellDelegate {
    
    func visitLinkWith(url: URL) {
        let webView = WebVC(url: url)
        webView.delegate = self
        
        switch dunePlayBar.currentState {
        case .loading:
             webView.currentStatus = .ready
        case .ready:
             webView.currentStatus = .ready
        case .playing:
             webView.currentStatus = .playing
        case .paused:
             webView.currentStatus = .paused
        case .fetching:
            webView.currentStatus = .ready
        }
        
        dunePlayBar.audioPlayerDelegate = webView
        navigationController?.present(webView, animated: true, completion: nil)
    }
    
    func episodeTagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func visitProfile(program: Program) {
        if program.ID == self.program.ID {
            return
        }
        
        if CurrentProgram.programsIDs().contains(program.ID) {
             duneTabBar.visit(screen: .account)
        } else if program.isPublisher {
            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                let programVC = ProgramProfileVC()
                programVC.program = program
                navigationController?.pushViewController(programVC, animated: true)
            } else {
                let programVC = SingleProgramProfileVC(program: program)
                navigationController?.pushViewController(programVC, animated: true)
            }
        } else {
            let programVC = ListenerProfileVC(program: program)
            navigationController?.pushViewController(programVC, animated: true)
        }
    }
    
    
    func updateRows() {
        //
    }
    
    func addTappedProgram(programName: String) {
        //
    }
    
    func playEpisode(cell: EpisodeCell) {
        
        if introPlayer.isInPosition {
            introPlayer.finishSession()
        }
        
        activeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
                
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        // Update play bar with active episode list
        dunePlayBar.activeController = .account
        dunePlayBar.downloadedEpisodes = downloadedEpisodes
        dunePlayBar.itemCount = episodeItems.count
        
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        ownEpisodeSettings.showSettings()
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
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

extension SubProgramAccountVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        default:
            break
        }
    }
    
    func deleteOwnEpisode() {
        guard let row = self.selectedCellRow else { return }
        let episode = downloadedEpisodes[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        guard let item = episodeItems.first(where: { $0.id == episode.ID }) else { return }
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp, category: item.category)
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: episode.ID, rep: -7)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        program.episodeIDs.removeAll { $0["ID"] as! String == episode.ID }
        
        let index = IndexPath(item: row, section: 0)
        downloadedEpisodes.remove(at: row)
        episodeTV.deleteRows(at: [index], with: .fade)
        
        if downloadedEpisodes.count == 0 {
            emptyTableView.isHidden = false
        }
    }
}

extension SubProgramAccountVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }
    
    func showCommentsFor(episode: Episode) {
        dunePlayBar.isHidden = true
        commentVC = CommentThreadVC(episode: episode)
        commentVC.currentState = dunePlayBar.currentState
        dunePlayBar.audioPlayerDelegate = commentVC
        commentVC.delegate = self
        navigationController?.pushViewController(commentVC, animated: true)
    }
   
    func makeActive(episode: Episode) {
        episode.hasBeenPlayed = true
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID }) else { return }
        downloadedEpisodes[index] = episode
    }
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {

        if lastPlayedID != episodeID {
            updatePastEpisodeProgress()
            listenCountUpdated = false
        }
        
        lastPlayedID = episodeID
        guard let cell = activeCell else { return }
        if percentage > 0.01 {
            cell.playbackBarView.progressUpdateWith(percentage: percentage)
            lastProgress = percentage
            
            if percentage > 0.90 && !listenCountUpdated && cell.episode.listenCount < 1000 {
                let listenCount = Int(cell.listenCountLabel.text!)
                if let count = listenCount {
                    cell.listenCountLabel.text = String(count + 1)
                    listenCountUpdated = true
                }
            }
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let indexPath = IndexPath(item: atIndex, section: 0)
        if episodeTV.indexPathsForVisibleRows!.contains(indexPath) {
            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
            cell.playbackBarView.setupPlaybackBar()
            cell.removePlayIcon()
            activeCell = cell
        }
    }
    
    func updatePastEpisodeProgress() {
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
        let episode = downloadedEpisodes[index]
        episode.playBackProgress = lastProgress
        downloadedEpisodes[index] = episode
        User.appendPlayedEpisode(ID: episode.ID, progress: lastProgress)
    }
    
}

extension SubProgramAccountVC: NavPlayerDelegate {
    
    func playOrPauseEpisode() {
        if dunePlayBar.isOutOfPosition {
            activeCell = nil
        }
        
        if let cell = activeCell {
            print("NOPE")
            dunePlayBar.playOrPauseEpisodeWith(audioID: cell.episode.audioID)
        } else {
            if let cellIndex = downloadedEpisodes.firstIndex(of: commentVC.episode) {
                let indexPath = IndexPath(item: cellIndex, section: 0)
                guard let episodeCell = episodeTV.cellForRow(at: indexPath) as? EpisodeCell else { return }
                playEpisode(cell: episodeCell)
                episodeCell.removePlayIcon()
                dunePlayBar.audioPlayerDelegate = commentVC
            }
        }
    }
    
}

extension SubProgramAccountVC: RequestsDelegate {
    
    func updateChannelWith(_ channel: Program) {
        program = channel
    }

}





