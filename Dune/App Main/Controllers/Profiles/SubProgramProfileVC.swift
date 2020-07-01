////
////  SubProgramProfileVC.swift
////  Dune
////
////  Created by Waylan Sands on 4/3/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class SubProgramProfileVC: UIViewController {
//
//    var summaryHeightClosed: CGFloat = 0
//    var tagContentWidth: NSLayoutConstraint!
//    var settingsButtonYConstraint: NSLayoutConstraint!
//    var summaryViewHeight: NSLayoutConstraint!
//    var largeImageSize: CGFloat = 74.0
//    var fontNameSize: CGFloat = 16
//    var fontIDSize: CGFloat = 14
//    var unwrapped = false
//    var pushedFromListener = false
//
//    // Episode Table view
//    let loadingView = TVLoadingAnimationView(topHeight: 15)
//    var selectedCellRow: Int?
//
//    var lastProgress: CGFloat = 0
//    var lastPlayedID: String?
//    var listenCountUpdated = false
//
//    var downloadedEpisodes = [Episode]()
//    var episodeItems = [EpisodeItem]()
//    var batchLimit = 10
//    var programIDs = [String]()
//    var fetchedEpisodeIDs = [String]()
//    var episodesToFetch = [String]()
//
//    var activeCell: EpisodeCell?
//    var subAccounts = [Program]()
//    let maxPrograms = 10
//
//    lazy var tabBar = navigationController?.tabBarController?.tabBar
//
//    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
//    let publisherProgramSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
//
//    let introPlayer = DuneIntroPlayer()
//    let audioPlayer = DuneAudioPlayer()
//
//    var program: Program!
//
//    let episodeTV = UITableView()
//
//    let programView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let topView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let mainImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 7
//        imageView.clipsToBounds = true
//        imageView.frame.size = CGSize(width: 74, height: 74)
//        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = CustomStyle.secondShade
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
//    let settingsButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "black-settings-icon"), for: .normal)
//        button.addTarget(self, action: #selector(showProgramSettings), for: .touchUpInside)
//        button.alpha = 0.9
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
//    let websiteLinkButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "website-link"), for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        button.setTitleColor(CustomStyle.primaryBlue, for: .normal)
//        button.titleLabel?.textAlignment = .left
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(websiteButtonPress), for: .touchUpInside)
//        return button
//    }()
//
//    let linkAndStatsStackedView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 20
//        view.alignment = .leading
//        return view
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
//        label.text = "\(program.subscriberCount.roundedWithAbbreviations)"
//        return label
//    }()
//
//    lazy var subscribersLabel: UILabel = {
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
//        label.text = "\(program.episodeIDs.count)"
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
//    let repCountLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.sixthShade
//        return label
//    }()
//
//    let repLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = CustomStyle.fourthShade
//        label.text = "Rep"
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
//    let subscribeButton: AccountButton = {
//        let button = AccountButton()
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        return button
//    }()
//
//    let shareProgramButton: AccountButton = {
//        let button = AccountButton()
//        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
//        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
//        button.setTitle("Share Program", for: .normal)
//        return button
//    }()
//
//
//    init(program: Program) {
//        super.init(nibName: nil, bundle: nil)
//        self.program = program
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.hidesBottomBarWhenPushed = false
//        configureDelegates()
//        styleForScreens()
//        configureViews()
//        addLoadingView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        episodeTV.setScrollBarToTopLeft()
//        configureIntroButton()
//        setupTopBar()
//        addWebLink()
//
//        mainImage.image = program.image
//        nameLabel.text = program.name
//        usernameLabel.text = "@\(program.username)"
//        categoryLabel.text = program.primaryCategory
//        repCountLabel.text = String(program.rep)
//        summaryTextView.text = program.summary
//
//        programIDs = [program.ID]
//        fetchEpisodeIDsForUser()
//
//        configureSubscribeButton()
//        configureProgramStats()
//
//        if  unwrapped {
//            summaryTextView.textContainer.maximumNumberOfLines = 3
//            unwrapped = false
//        }
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        mainImage.image = program.image
//
//        if summaryTextView.lineCount() > 3 {
//            addMoreButton()
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        introPlayer.finishSession()
//        audioPlayer.finishSession()
//    }
//
//    func configureProgramStats() {
//        subscriberCountLabel.text = "\(program.subscriberCount.roundedWithAbbreviations)"
//        episodeCountLabel.text = "\(program.episodeIDs.count)"
//
//        let episodes = program.episodeIDs
//        let subscribers = program.subscriberCount
//
//        if episodes.count == 1 {
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
//    }
//
//    func configureDelegates() {
//        audioPlayer.audioPlayerDelegate = self
//        episodeTV.delegate = self
//        episodeTV.dataSource = self
//        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
//        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
//        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
//    }
//
//    func setupTopBar() {
//        navigationController?.isNavigationBarHidden = true
//    }
//
//    // MARK: Fetch batch of episode IDs
//    func fetchEpisodeIDsForUser() {
//        FireStoreManager.fetchEpisodesItemsWith(with: programIDs) { items in
//
//            if items.isEmpty {
//                self.episodeTV.isHidden = true
//                self.navigationItem.title = ""
//            } else {
//                 if items.count != self.episodeItems.count {
//                    self.resetTableView()
//                    self.episodeItems = items
//                    self.loadFirstBatch()
//                }
//            }
//        }
//    }
//
//    func resetTableView() {
//        addLoadingView()
//        navigationItem.title = ""
//        fetchedEpisodeIDs = [String]()
//        downloadedEpisodes = [Episode]()
//        episodeItems = []
//        episodeTV.isHidden = false
//        episodeTV.reloadData()
//    }
//
//    func loadFirstBatch() {
//        var endIndex = batchLimit
//
//        if episodeItems.count < batchLimit {
//            endIndex = episodeItems.count
//        }
//
//        episodesToFetch = Array(episodeItems[0..<endIndex])
//
//        for eachID in episodesToFetch {
//            downloadEpisodeWith(ID: eachID)
//        }
//    }
//
//    func  loadNextBatch() {
//        var endIndex = batchLimit
//
//        if (episodeItems.count - fetchedEpisodeIDs.count) < batchLimit {
//            endIndex = episodeItems.count - fetchedEpisodeIDs.count
//        }
//
//        let lastEp = fetchedEpisodeIDs.last!
//        let startIndex = episodeItems.firstIndex(of: lastEp)
//        endIndex += startIndex!
//
//        episodesToFetch = Array(episodeItems[startIndex!..<endIndex])
//
//        for eachID in episodesToFetch {
//            downloadEpisodeWith(ID: eachID)
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
//                    }
//
//                    self.fetchedEpisodeIDs += self.episodesToFetch
//                    self.loadingView.removeFromSuperview()
//                    self.episodesToFetch.removeAll()
//                    self.episodeTV.reloadData()
//                    self.batch.removeAll()
//                }
//            }
//        }
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
//        if program.hasIntro == true {
//            playIntroButton.setTitle("Play Intro", for: .normal)
//            playIntroButton.backgroundColor = CustomStyle.primaryYellow
//            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
//            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
//            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
//            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
//            playIntroButton.removeTarget(self, action:  #selector(recordIntro), for: .touchUpInside)
//            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
//        } else {
//            playIntroButton.isHidden = true
//            settingsButtonYConstraint.constant = -40
//        }
//    }
//
//    func configureViews() {
//        view.backgroundColor = .white
//
//        view.addSubview(programView)
//        programView.translatesAutoresizingMaskIntoConstraints = false
//        programView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        programView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        programView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        view.addSubview(topView)
//        topView.translatesAutoresizingMaskIntoConstraints = false
//        topView.topAnchor.constraint(equalTo: programView.topAnchor, constant:20).isActive = true
//        topView.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16).isActive = true
//        topView.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16).isActive = true
//        topView.heightAnchor.constraint(equalToConstant: 74).isActive = true
//
//        topView.addSubview(mainImage)
//        mainImage.translatesAutoresizingMaskIntoConstraints = false
//        mainImage.topAnchor.constraint(equalTo:topView.topAnchor, constant: 0).isActive = true
//        mainImage.leadingAnchor.constraint(equalTo:topView.leadingAnchor).isActive = true
//        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//
//        topView.addSubview(playIntroButton)
//        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
//        settingsButtonYConstraint = playIntroButton.topAnchor.constraint(equalTo: mainImage.topAnchor)
//        settingsButtonYConstraint.isActive = true
//        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
//
//        topView.addSubview(settingsButton)
//        settingsButton.translatesAutoresizingMaskIntoConstraints = false
//        settingsButton.topAnchor.constraint(equalTo: playIntroButton.bottomAnchor, constant: 10).isActive = true
//        settingsButton.trailingAnchor.constraint(equalTo: playIntroButton.trailingAnchor, constant: -5).isActive = true
//
//        topView.addSubview(topMiddleStackedView)
//        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
//        topMiddleStackedView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
//        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
//        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: playIntroButton.leadingAnchor, constant: -20).isActive = true
//        topMiddleStackedView.addArrangedSubview(nameLabel)
//        topMiddleStackedView.addArrangedSubview(usernameLabel)
//        topMiddleStackedView.addArrangedSubview(categoryLabel)
//
//        view.addSubview(summaryTextView)
//        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
//        summaryTextView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20).isActive = true
//        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//
//        view.addSubview(linkAndStatsStackedView)
//        linkAndStatsStackedView.translatesAutoresizingMaskIntoConstraints = false
//        linkAndStatsStackedView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
//        linkAndStatsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        linkAndStatsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//
//        linkAndStatsStackedView.addArrangedSubview(statsView)
//        statsView.heightAnchor.constraint(equalToConstant: 15).isActive = true
//        statsView.widthAnchor.constraint(equalTo: linkAndStatsStackedView.widthAnchor).isActive = true
//
//        statsView.addSubview(subscriberCountLabel)
//        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
//        subscriberCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
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
//        statsView.addSubview(repCountLabel)
//        repCountLabel.translatesAutoresizingMaskIntoConstraints = false
//        repCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        repCountLabel.leadingAnchor.constraint(equalTo: episodesLabel.trailingAnchor, constant: 15).isActive = true
//
//        statsView.addSubview(repLabel)
//        repLabel.translatesAutoresizingMaskIntoConstraints = false
//        repLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
//        repLabel.leadingAnchor.constraint(equalTo: repCountLabel.trailingAnchor, constant: 5).isActive = true
//
//        view.addSubview(buttonsStackedView)
//        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
//        buttonsStackedView.topAnchor.constraint(equalTo: linkAndStatsStackedView.bottomAnchor, constant: 20.0).isActive = true
//        buttonsStackedView.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16.0).isActive = true
//        buttonsStackedView.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16.0).isActive = true
//        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
//
//        buttonsStackedView.addArrangedSubview(subscribeButton)
//        buttonsStackedView.addArrangedSubview(shareProgramButton)
//
//        view.addSubview(episodeTV)
//        episodeTV.translatesAutoresizingMaskIntoConstraints = false
//        episodeTV.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 15.0).isActive = true
//        episodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        episodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        episodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        view.addSubview(introPlayer)
//        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
//
//        view.addSubview(audioPlayer)
//        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
//    }
//
//    func addWebLink() {
//        if program.webLink != nil && program.webLink != "" {
//        linkAndStatsStackedView.insertArrangedSubview(websiteLinkButton, at: 0)
//        websiteLinkButton.setTitle(program.webLink?.lowercased(), for: .normal)
//        websiteLinkButton.widthAnchor.constraint(equalToConstant: websiteLinkButton.intrinsicContentSize.width + 15).isActive = true
//        websiteLinkButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
//        }
//    }
//
//    func addLoadingView() {
//        view.addSubview(loadingView)
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
//        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        loadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
//
//        view.bringSubviewToFront(introPlayer)
//        view.bringSubviewToFront(audioPlayer)
//    }
//
//    // MARK: Play Program's Intro
//
//    @objc func playIntro() {
//        introPlayer.isProgramPageIntro = true
//        introPlayer.addBottomSection()
//
//        if !audioPlayer.isOutOfPosition {
//            audioPlayer.finishSession()
//        }
//
//        introPlayer.yPosition = view.frame.height - (introPlayer.frame.height + 70)
//
//        self.introPlayer.setProgramDetailsWith(program: program, image: program.image!)
//        self.introPlayer.playOrPauseIntroWith(audioID: program.introID!)
//    }
//
//    @objc func recordIntro() {
//        let recordBoothVC = RecordBoothVC()
//        recordBoothVC.currentScope = .intro
//        navigationController?.pushViewController(recordBoothVC, animated: true)
//    }
//
//    func addMoreButton() {
//        DispatchQueue.main.async {
//            self.view.addSubview(self.moreButton)
//            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
//            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
//            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
//            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
//
//            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
//            let path = UIBezierPath(rect: rect)
//            self.summaryTextView.textContainer.exclusionPaths = [path]
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
//        print("Wammy")
//        unwrapped = true
//        summaryTextView.textContainer.maximumNumberOfLines = 0
//        summaryTextView.text = "\(program.summary) "
//        moreButton.removeFromSuperview()
//        summaryTextView.textContainer.exclusionPaths.removeAll()
//
//        if UIDevice.current.deviceType == .iPhoneSE {
//        }
//        summaryTextView.layoutIfNeeded()
//        programView.layoutIfNeeded()
//    }
//
//    @objc func editProgramButtonPress() {
//        let editSubProgramVC = EditSubProgramVC(program: program)
//        editSubProgramVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(editSubProgramVC, animated: true)
//    }
//
//    @objc func shareButtonPress() {
//        settingsLauncher.showSettings()
//    }
//
//    func configureSubscribeButton() {
//        if !CurrentProgram.subscriptionIDs!.contains(program.ID) {
//            subscribeButton.setTitle("Subscribe", for: .normal)
//            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
//        } else {
//            subscribeButton.setTitle("Subscribed", for: .normal)
//            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
//        }
//    }
//
//    // MARK: Subscribe button press
//    @objc func subscribeButtonPress() {
//        if  CurrentProgram.subscriptionIDs!.contains(program.ID) {
//            FireStoreManager.removeSubscriptionFromProgramWith(programID: program.ID)
//            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
//            CurrentProgram.subscriptionIDs!.removeAll(where: {$0 == program.ID})
//            program.subscriberCount -= 1
//            subscribeButton.setTitle("Subscribe", for: .normal)
//            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
//            configureProgramStats()
//        } else {
//            FireStoreManager.addSubscriptionToProgramWith(programID: program.ID)
//            FireStoreManager.subscribeToProgramWith(programID: program.ID)
//            CurrentProgram.subscriptionIDs!.append(program.ID)
//            program.subscriberCount += 1
//            subscribeButton.setTitle("Subscribed", for: .normal)
//            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
//            configureProgramStats()
//        }
//    }
//
//    @objc func showProgramSettings() {
//        publisherProgramSettings.showSettings()
//    }
//
//    @objc func websiteButtonPress() {
//        let link = linkWithPrefix(urlString: program.webLink!)
//        print("The link is \(link)")
//        if let url = URL(string: link) {
//            UIApplication.shared.open(url, options: [:])
//        }
//    }
//
//    func linkWithPrefix(urlString: String) -> String {
//        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
//            return "http://\(urlString)"
//        } else {
//            return urlString
//        }
//    }
//
//}
//
//extension SubProgramProfileVC: UIScrollViewDelegate {
//
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let fadeTextAnimation = CATransition()
//        fadeTextAnimation.duration = 0.5
//        fadeTextAnimation.type = CATransitionType.fade
//
//        if scrollView.contentOffset.y >= -45.5 {
//            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
//            navigationItem.title = User.username
//        } else {
//            navigationItem.title = ""
//        }
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//        if scrollView == episodeTV {
//            if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs != episodeItems {
//                print("loading more episodes")
//                loadNextBatch()
//            }
//        }
//    }
//
//}
//
//extension SubProgramProfileVC: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return downloadedEpisodes.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var episodeCell: EpisodeCell
//        let episode = downloadedEpisodes[indexPath.row]
//
//        if episode.richLink == nil {
//            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
//        } else if episode.linkIsSmall! {
//            episodeCell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCellSmlLink") as! EpisodeCellSmlLink
//        } else {
//            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCellRegLink") as! EpisodeCellRegLink
//        }
//
//        episodeCell.episode = episode
//        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
//        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
//        episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
//        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
//        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
//        episodeCell.normalSetUp(episode: episode)
//        episodeCell.cellDelegate = self
//
////        if episode.likeCount >= 10 && episodeCell.optionsConfigured == false {
////            episodeCell.configureCellWithOptions()
////            episodeCell.optionsConfigured = true
////        } else if episode.likeCount < 10 && episodeCell.optionsConfigured {
////            episodeCell.configureWithoutOptions()
////            episodeCell.optionsConfigured = false
////        }
//
//        if let playerEpisode = audioPlayer.episode  {
//            if episode.ID == playerEpisode.ID {
//                activeCell = episodeCell
//            }
//        }
//        return episodeCell
//    }
//}
//
//extension SubProgramProfileVC :EpisodeCellDelegate {
//
//    func showCommentsFor(episode: Episode) {
//        dismiss(animated: true) {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil, userInfo: ["ID": episode.ID])
//        }
//    }
//
//    func episodeTagSelected(tag: String) {
//        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
//        present(tagSelectedVC, animated: true, completion: nil)
//    }
//
//    func visitProfile(program: Program) {
//        if User.isPublisher! && CurrentProgram.programsIDs().contains(program.ID) {
//            let tabBar = MainTabController()
//            tabBar.selectedIndex = 4
//            if #available(iOS 13.0, *) {
//                let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
//                sceneDelegate.window?.rootViewController = tabBar
//            } else {
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = tabBar
//            }
//        } else {
//            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
//                let programVC = ProgramProfileVC()
//                programVC.program = program
//                navigationController?.pushViewController(programVC, animated: true)
//            } else {
//                let programVC = SingleProgramProfileVC(program: program)
//                navigationController?.pushViewController(programVC, animated: true)
//            }
//        }
//    }
//
//
//    func updateRows() {
//        //
//    }
//
//    func addTappedProgram(programName: String) {
//        //
//    }
//
//    // MARK: Play Episode
//    func playEpisode(cell: EpisodeCell) {
//        audioPlayer.addBottomSection()
//
//        if introPlayer.isInPosition {
//            introPlayer.finishSession()
//        }
//
//        activeCell = cell
//
//        if !cell.playbackBarView.playbackBarIsSetup {
//            cell.playbackBarView.setupPlaybackBar()
//        }
//
//        audioPlayer.yPosition = view.frame.height - self.tabBarController!.tabBar.frame.height
//
//        let image = cell.programImageButton.imageView?.image
//        let audioID = cell.episode.audioID
//
//        self.audioPlayer.setEpisodeDetailsWith(episode: cell.episode, image: image!)
//        self.audioPlayer.animateToPositionIfNeeded()
//        self.audioPlayer.playOrPauseEpisodeWith(audioID: audioID)
//    }
//
//    func showSettings(cell: EpisodeCell) {
//        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
//        settingsLauncher.showSettings()
//    }
//
//    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
//        //
//    }
//
//}
//
//extension SubProgramProfileVC: SettingsLauncherDelegate {
//
//    func selectionOf(setting: String) {
//        switch setting {
//        case "Delete":
//            deleteOwnEpisode()
//        default:
//            break
//        }
//    }
//
//    func deleteOwnEpisode() {
//        guard let row = self.selectedCellRow else { return }
//        print("Downloaded eps before \(downloadedEpisodes.count)")
//        //Delete own episode
//        let episode = downloadedEpisodes[row]
//        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
//        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp)
//        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
//        program.episodeIDs.removeAll { $0["ID"] as! String == episode.ID }
//
//        let index = IndexPath(item: row, section: 0)
//        downloadedEpisodes.remove(at: row)
//        print("Downloaded eps after \(downloadedEpisodes.count)")
//
//        episodeTV.deleteRows(at: [index], with: .fade)
//
//        audioPlayer.transitionOutOfView()
//
//    }
//}
//
//extension SubProgramProfileVC: DuneAudioPlayerDelegate {
//
//    func playedEpisode(episode: Episode) {
//        episode.hasBeenPlayed = true
//        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID }) else { return }
//        downloadedEpisodes[index] = episode
//    }
//
//    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
//        guard let cell = activeCell else { return }
//        cell.playbackBarView.progressUpdateWith(percentage: percentage)
//    }
//
//    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
//        let indexPath = IndexPath(item: atIndex, section: 0)
//        if episodeTV.indexPathsForVisibleRows!.contains(indexPath) {
//            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
//            cell.playEpisodeButton.setImage(nil, for: .normal)
//            cell.playbackBarView.setupPlaybackBar()
//            activeCell = cell
//        }
//    }
//
//    func updatePastEpisodeProgress() {
//        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
//        let episode = downloadedEpisodes[index]
//        episode.playBackProgress = lastProgress
//        downloadedEpisodes[index] = episode
//    }
//
//}
//
//
//
//
//
//
