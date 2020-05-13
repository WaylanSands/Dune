//
//  SubProgramProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class SubProgramProfileVC: UIViewController {
    
    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var settingsButtonYConstraint: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 74.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var unwrapped = false
    
    // Episode Table view
    let loadingView = TVLoadingAnimationView(topHeight: 15)
    var selectedCellRow: Int?
    
    var downloadedEpisodes = [Episode]()
    var batchLimit = 10
    var programIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    
    var activeCell: EpisodeCell?
    var subAccounts = [Program]()
    let maxPrograms = 10
    
    lazy var tabBar = navigationController?.tabBarController?.tabBar
   
    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)

    let introPlayer = DuneIntroPlayer()
    let audioPlayer = DuneAudioPlayer()
    
    var program: Program!
    
    let episodeTV = UITableView()
    
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
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "black-settings-icon"), for: .normal)
        button.addTarget(self, action: #selector(showProgramSettings), for: .touchUpInside)
        button.alpha = 0.9
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
    
    lazy var subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        label.text = "\(program.subscriberCount.roundedWithAbbreviations)"
        return label
    }()
    
    lazy var subscribersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
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
    
    
    init(program: Program) {
        super.init(nibName: nil, bundle: nil)
        self.program = program
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        configureDelegates()
        styleForScreens()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTV.setScrollBarToTopLeft()
        configureIntroButton()
        setupTopBar()
        
        mainImage.image = program.image
        nameLabel.text = program.name
        usernameLabel.text = "@\(program.username)"
        categoryLabel.text = program.primaryCategory
        summaryTextView.text = program.summary
        
        programIDs = [program.ID]
        fetchEpisodeIDsForUser()
        
        configureSubscribeButton()
        configureProgramStats()
        
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
        introPlayer.finishSession()
        audioPlayer.finishSession()
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
            subscribersLabel.text = "Subscriber"
        } else {
             subscribersLabel.text = "Subscribers"
        }
    }
    
    func configureDelegates() {
        audioPlayer.playbackDelegate = self
        episodeTV.delegate = self
        episodeTV.dataSource = self
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
    }
    
    func setupTopBar() {
        navigationController?.isNavigationBarHidden = true
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
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
    }
        
    // MARK: Fetch batch of episode IDs
    func fetchEpisodeIDsForUser() {
        FireStoreManager.fetchEpisodesIDsWith(with: programIDs) { ids in
            
            if ids.isEmpty {
                print("No episodes to display")
                self.episodeTV.isHidden = true
                self.navigationItem.title = ""
            } else {
                 if ids.count != self.episodeIDs.count {
                    self.resetTableView()
                    self.episodeIDs = ids
                    self.loadFirstBatch()
                }
            }
        }
    }
    
    func resetTableView() {
        addLoadingView()
        navigationItem.title = ""
        fetchedEpisodeIDs = [String]()
        downloadedEpisodes = [Episode]()
        episodeIDs = [String]()
        episodeTV.isHidden = false
        episodeTV.reloadData()
    }
    
    func loadFirstBatch() {
        var endIndex = batchLimit
        
        if episodeIDs.count < batchLimit {
            endIndex = episodeIDs.count
        }
        
        episodesToFetch = Array(episodeIDs[0..<endIndex])
        
        for eachID in episodesToFetch {
            downloadEpisodeWith(ID: eachID)
        }
    }
    
    func  loadNextBatch() {
        var endIndex = batchLimit
        
        if (episodeIDs.count - fetchedEpisodeIDs.count) < batchLimit {
            endIndex = episodeIDs.count - fetchedEpisodeIDs.count
        }
        
        let lastEp = fetchedEpisodeIDs.last!
        let startIndex = episodeIDs.firstIndex(of: lastEp)
        endIndex += startIndex!
        
        episodesToFetch = Array(episodeIDs[startIndex!..<endIndex])
        
        for eachID in episodesToFetch {
            downloadEpisodeWith(ID: eachID)
        }
    }
    
    // MARK: Download episodes
    var batch = [Episode]()
    
    func downloadEpisodeWith(ID: String) {
                        
        let alreadyDownloaded = self.fetchedEpisodeIDs.contains(where: { $0 == ID })
               
        if !alreadyDownloaded {
            FireStoreManager.getEpisodeDataWith(ID: ID) { (data) in
                
                let episode = Episode(data: data)
                self.batch.append(episode)
                
                print("Batch count \(self.batch.count) eps to fetch count \(self.episodesToFetch.count)")
                if self.batch.count == self.episodesToFetch.count{
                   
                    let orderedBatch = self.batch.sorted { (epA , epB) -> Bool in
                        let dateA = epA.timeStamp.dateValue()
                        let dateB = epB.timeStamp.dateValue()
                        return dateA > dateB
                    }
                    
                    for each in orderedBatch {
                        self.downloadedEpisodes.append(each)
                        self.audioPlayer.downloadedEps.append(each)
                        self.audioPlayer.audioIDs.append(each.audioID)
                    }
                    
                    print("Im here")
                    self.fetchedEpisodeIDs += self.episodesToFetch
                    self.loadingView.removeFromSuperview()
                    self.episodesToFetch.removeAll()
                    self.episodeTV.reloadData()
                    self.batch.removeAll()
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
            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            playIntroButton.removeTarget(self, action:  #selector(recordIntro), for: .touchUpInside)
            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
        } else {
            playIntroButton.isHidden = true
            settingsButtonYConstraint.constant = -40
//            playIntroButton.setImage(nil, for: .normal)
//            playIntroButton.setTitle("Add Intro", for: .normal)
//            playIntroButton.setTitleColor(.white, for: .normal)
//            playIntroButton.backgroundColor = CustomStyle.primaryBlue
//            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//            playIntroButton.removeTarget(self, action: #selector(playIntro), for: .touchUpInside)
//            playIntroButton.addTarget(self, action: #selector(recordIntro), for: .touchUpInside)
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(programView)
        programView.translatesAutoresizingMaskIntoConstraints = false
        programView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
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
        settingsButtonYConstraint = playIntroButton.topAnchor.constraint(equalTo: mainImage.topAnchor)
        settingsButtonYConstraint.isActive = true
        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        topView.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: playIntroButton.bottomAnchor, constant: 10).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: playIntroButton.trailingAnchor, constant: -5).isActive = true
//        settingsButton.backgroundColor = .purple
        
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
        
        view.addSubview(subscriberCountLabel)
        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberCountLabel.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        subscriberCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(subscribersLabel)
        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribersLabel.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        subscribersLabel.leadingAnchor.constraint(equalTo: subscriberCountLabel.trailingAnchor, constant: 5).isActive = true
        
        view.addSubview(episodeCountLabel)
        episodeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeCountLabel.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        episodeCountLabel.leadingAnchor.constraint(equalTo: subscribersLabel.trailingAnchor, constant: 15).isActive = true
        
        view.addSubview(episodesLabel)
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        episodesLabel.leadingAnchor.constraint(equalTo: episodeCountLabel.trailingAnchor, constant: 5).isActive = true
        
        view.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: subscriberCountLabel.bottomAnchor, constant: 20.0).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: programView.leadingAnchor, constant: 16.0).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: programView.trailingAnchor, constant: -16.0).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(subscribeButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        view.addSubview(episodeTV)
        episodeTV.translatesAutoresizingMaskIntoConstraints = false
        episodeTV.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 15.0).isActive = true
        episodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        //        episodeTV.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        episodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        audioPlayer.addBottomSection()
    }
    
    @objc func playIntro() {
        
        if !audioPlayer.playerIsOutOfPosition {
            audioPlayer.finishSession()
        }
        
        introPlayer.navHeight = 100
        introPlayer.addBottomSection()
        introPlayer.getAudioWith(audioID: program.introID!) { url in
            self.introPlayer.playOrPauseWith(url: url, name: self.program.name, image: self.program.image!)
        }
        print("Play intro")
    }
    
    @objc func recordIntro() {
        let recordBoothVC = RecordBoothVC()
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
        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func moreUnwrap() {
        print("Wammy")
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
        editSubProgramVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editSubProgramVC, animated: true)
    }
    
    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }
    
    func configureSubscribeButton() {
        if !User.subscriptionIDs!.contains(program.ID) {
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
        } else {
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
        }
    }

    // MARK: Subscribe button press
    @objc func subscribeButtonPress() {
        if User.subscriptionIDs!.contains(program.ID) {
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithUnSubscribe(programID: program.ID)
            User.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
            configureProgramStats()
        } else {
            FireStoreManager.subscribeUserToProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithSubscription(programID: program.ID)
            User.subscriptionIDs!.append(program.ID)
            program.subscriberCount += 1
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            configureProgramStats()
        }
    }
    
    @objc func showProgramSettings() {
        programSettings.showSettings()
    }
    
}

extension SubProgramProfileVC: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade
        
        
        if scrollView.contentOffset.y >= -45.5 {
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = User.username
        } else {
            navigationItem.title = ""
        }
        
        //        if scrollView == scrollView {
        //            let offset = scrollView.contentOffset.y
        //        }
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if scrollView == episodeTV {
            if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs != episodeIDs {
                print("loading more episodes")
                loadNextBatch()
            }
        }
    }
    
}

extension SubProgramProfileVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        cell.moreButton.addTarget(cell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        cell.programImageButton.addTarget(cell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        cell.episodeSettingsButton.addTarget(cell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        cell.likeButton.addTarget(cell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        
        let episode = downloadedEpisodes[indexPath.row]
        cell.episode = episode
        if episode.likeCount >= 10 {
            cell.configureCellWithOptions()
        }
        cell.cellDelegate = self
        cell.normalSetUp(episode: episode)
        return cell
    }
}

extension SubProgramProfileVC :EpisodeCellDelegate {
    
    func updateRows() {
        //
    }
    
    func addTappedProgram(programName: String) {
        //
    }
    
    func playEpisode(cell: EpisodeCell) {
        
        if !introPlayer.playerIsOutOfPosition {
            introPlayer.finishSession()
        }
        
        activeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
        if tabBarController != nil {
            audioPlayer.navHeight = self.tabBarController!.tabBar.frame.height
        } else {
            audioPlayer.navHeight = 100
        }
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        audioPlayer.getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
        }
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        programSettings.showSettings()
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
}

extension SubProgramProfileVC: SettingsLauncherDelegate {
    
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
        print("Downloaded eps before \(downloadedEpisodes.count)")
        //Delete own episode
        let episode = downloadedEpisodes[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        program.episodeIDs.removeAll { $0["ID"] as! String == episode.ID }
        
        let index = IndexPath(item: row, section: 0)
        downloadedEpisodes.remove(at: row)
        print("Downloaded eps after \(downloadedEpisodes.count)")
        
        episodeTV.deleteRows(at: [index], with: .fade)
        
        audioPlayer.transitionOutOfView()
        
    }
}

extension SubProgramProfileVC: PlaybackBarDelegate {
    
    func updateProgressBarWith(percentage: CGFloat) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int) {
        let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }
    
}






