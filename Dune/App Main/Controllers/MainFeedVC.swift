//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import AVFoundation
import CoreLocation
import UserNotifications

class MainFeedVC: UIViewController {
    
    enum FilterMode {
        case all
        case today
    }
    
    let tableView = UITableView()
    var subscriptionIDs = [String]()
    
    // Tracking episode progress
    var listenCountUpdated = false
    var lastProgress: CGFloat = 0
    var activeCell: EpisodeCell?
    var lastPlayedID: String?
    
    //Episodes
    var filteredEpisodeItems = [EpisodeItem]()
    var downloadedEpisodes = [Episode]()
    var episodeItems = [EpisodeItem]()
    var isFetchingEpisodes = false
    var startingIndex: Int = 0
    var episodes = [Episode]()
    
    // Settings
    var selectedCellRow: Int?
    var episodeReported = false
    var programReported = false
    
    // Categories
    var categoryButtons = [UIButton]()
    var filterMode: FilterMode = .all
    var selectedCategory: String?
    
    
    // For various screen sizes
    var categoryInset: CGFloat = 16
    
    var autoSubscribeSpinner = UIActivityIndicatorView(style: .gray)
    var loadingView = TVLoadingAnimationView(topHeight: 20)
    var refreshControl: UIRefreshControl!
    //    var audioPlayer = DunePlayBar()
    
    var commentVC: CommentThreadVC!
    
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let reportEpisodeAlert = CustomAlertView(alertType: .reportEpisode)
    let notificationCenter = NotificationCenter.default
    
    let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.blackNavBar
        return view
    }()
    
    let fakeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily feed"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let fakeNavBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.blackNavBar
        view.isHidden = true
        return view
    }()
    
    let navLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nav-logo")
        return imageView
    }()
    
    let navLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily feed"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = CustomStyle.white
        return label
    }()
    
    let searchScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .clear
        return view
    }()
    
    let searchContentStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 7
        return view
    }()
    
    let allButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.setTitle("All", for: .normal)
        button.backgroundColor = CustomStyle.primaryYellow
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.addTarget(self, action: #selector(searchModePress), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let todayButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.setTitle("Today", for: .normal)
        button.backgroundColor = CustomStyle.sixthShade
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.addTarget(self, action: #selector(searchModePress), for: .touchUpInside)
        button.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
        return button
    }()
    
    let exampleChannelImages: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example-channels")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let noEpisodesMainLabel: UILabel = {
        let label = UILabel()
        label.text = "Subscribe to channels"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.textColor = CustomStyle.primaryBlack
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let noEpisodesLabel: UILabel = {
        let label = UILabel()
        label.text = "Subscribe to your interests for recent episodes to display here."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = CustomStyle.subTextColor
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    let autoSubscribeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setTitle("Auto Subscribe", for: .normal)
        button.backgroundColor = CustomStyle.primaryYellow
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 1, right: 25)
        button.addTarget(self, action: #selector(autoSubscribePress), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let visitSearchButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setTitle("Visit Search", for: .normal)
        button.backgroundColor = CustomStyle.onBoardingBlack
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 1, right: 25)
        button.addTarget(self, action: #selector(visitSearchPress), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRefreshControl()
        configureDelegates()
        configureTableView()
        styleForScreens()
        configureViews()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        subscriptionIDs = CurrentProgram.subscriptionIDs!
        setNeedsStatusBarAppearanceUpdate()
        selectedCellRow = nil
        configureNavigation()
        fetchEpisodeItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchScrollView.setScrollBarToTopLeft()
        removeObservers()

        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    func removeObservers() {
        notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        print("Claiming back Main")
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        fetchEpisodeItems()
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        reportEpisodeAlert.alertDelegate = self
    }
    
    func configureTableView() {
        tableView.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        tableView.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func resetTableView() {
        //        audioPlayer.downloadedEpisodes = [Episode]()
        noEpisodesMainLabel.isHidden = true
        downloadedEpisodes = [Episode]()
        noEpisodesLabel.isHidden = true
        startingIndex = 0
        episodeItems = []
        episodes = []
        tableView.reloadData()
    }
    
    func configureNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
//        tabBarController?.tabBar.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
//        tabBarController?.tabBar.backgroundImage = UIImage()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            categoryInset = 10
        case .iPhone8:
            categoryInset = 10
        case .iPhone8Plus:
            categoryInset = 10
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
        
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        navBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height).isActive = true
        
        view.addSubview(noEpisodesMainLabel)
        noEpisodesMainLabel.translatesAutoresizingMaskIntoConstraints = false
        noEpisodesMainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        noEpisodesMainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        noEpisodesMainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(exampleChannelImages)
        exampleChannelImages.translatesAutoresizingMaskIntoConstraints = false
        exampleChannelImages.bottomAnchor.constraint(equalTo: noEpisodesMainLabel.topAnchor, constant: -15).isActive = true
        exampleChannelImages.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        exampleChannelImages.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(noEpisodesLabel)
        noEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false
        noEpisodesLabel.topAnchor.constraint(equalTo: noEpisodesMainLabel.bottomAnchor, constant: 10).isActive = true
        noEpisodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        noEpisodesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        view.addSubview(autoSubscribeButton)
        autoSubscribeButton.translatesAutoresizingMaskIntoConstraints = false
        autoSubscribeButton.topAnchor.constraint(equalTo: noEpisodesLabel.bottomAnchor, constant: 20).isActive = true
        autoSubscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        autoSubscribeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        autoSubscribeButton.addSubview(autoSubscribeSpinner)
        autoSubscribeSpinner.translatesAutoresizingMaskIntoConstraints = false
        autoSubscribeSpinner.centerYAnchor.constraint(equalTo: autoSubscribeButton.centerYAnchor).isActive = true
        autoSubscribeSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        autoSubscribeSpinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        autoSubscribeSpinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        autoSubscribeSpinner.startAnimating()
        autoSubscribeSpinner.isHidden = true
        
        view.addSubview(visitSearchButton)
        visitSearchButton.translatesAutoresizingMaskIntoConstraints = false
        visitSearchButton.topAnchor.constraint(equalTo: autoSubscribeButton.bottomAnchor, constant: 18).isActive = true
        visitSearchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        visitSearchButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white
        tableView.contentInset = UIEdgeInsets(top: 45, left: 0, bottom: tableView.safeDunePlayBarHeight, right: 0)
        tableView.addTopBounceAreaView(color: hexStringToUIColor(hex: "191919"))
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.bringSubviewToFront(refreshControl)
        tableView.tableFooterView = UIView()
        
        tableView.addSubview(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.bottomAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchScrollView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        searchScrollView.addSubview(searchContentStackView)
        searchContentStackView.translatesAutoresizingMaskIntoConstraints = false
        searchContentStackView.centerYAnchor.constraint(equalTo: searchScrollView.centerYAnchor).isActive = true
        searchContentStackView.trailingAnchor.constraint(equalTo: searchScrollView.trailingAnchor, constant: -16).isActive = true
        searchContentStackView.leadingAnchor.constraint(equalTo: searchScrollView.leadingAnchor, constant: categoryInset).isActive = true
        searchContentStackView.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        
        searchContentStackView.addArrangedSubview(allButton)
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //        view.addSubview(audioPlayer)
        //        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 600)
        
        view.bringSubviewToFront(navBarView)
        
        view.addSubview(fakeNavBarView)
        fakeNavBarView.translatesAutoresizingMaskIntoConstraints = false
        fakeNavBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        fakeNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        fakeNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        fakeNavBarView.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight()).isActive = true
        
        fakeNavBarView.addSubview(fakeTitleLabel)
        fakeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        fakeTitleLabel.bottomAnchor.constraint(equalTo: fakeNavBarView.bottomAnchor, constant: -12).isActive = true
        fakeTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = CustomStyle.white.withAlphaComponent(0.95)
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(checkRefresh), for: .valueChanged)
        refreshControl.bounds = CGRect(x: 0, y: 50, width: refreshControl!.frame.width, height: refreshControl!.frame.height)
    }
    
    func handleRefreshControl() {
        if filterMode == .all && selectedCategory == nil {
            fetchEpisodeItems()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func fetchEpisodeItems() {
        FireStoreManager.fetchEpisodesItemsWith(with: CurrentProgram.subscriptionIDs!) { [unowned self] items in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                if items.isEmpty {
                    self.resetTableView()
                    self.setupEmptyTableView()
                } else {
                    if items != self.episodeItems {
                        //                        self.audioPlayer.itemCount = items.count
                        self.fakeNavBarView.isHidden = true
                        self.autoSubscribeSpinner.isHidden = true
                        self.autoSubscribeButton.setTitleColor(CustomStyle.primaryBlack, for: .normal)
                        self.exampleChannelImages.isHidden = true
                        self.autoSubscribeButton.isHidden = true
                        self.visitSearchButton.isHidden = true
                        self.loadingView.isHidden = false
                        self.navBarView.isHidden = false
                        self.tableView.isHidden = false
                        self.resetTableView()
                        self.episodeItems = items
                        self.recreateCategoryPills()
                        self.fetchEpisodes()
                    }
                }
            }
        }
    }
    
    func setupEmptyTableView() {
        noEpisodesMainLabel.isHidden = false
        exampleChannelImages.isHidden = false
        autoSubscribeButton.isHidden = false
        visitSearchButton.isHidden = false
        noEpisodesLabel.isHidden = false
        fakeNavBarView.isHidden = false
        loadingView.isHidden = true
        navBarView.isHidden = true
        tableView.isHidden = true
    }
    
    func recreateCategoryPills() {
        for each in searchContentStackView.arrangedSubviews {
            let button = each as! UIButton
            if button.titleLabel?.text != "All" && button.titleLabel?.text != "Today" {
                button.removeFromSuperview()
            }
        }
        createCategoryPills()
    }
    
    func fetchEpisodes() {
        if downloadedEpisodes.count != episodeItems.count {
            print(downloadedEpisodes.count)
            print(episodeItems.count)
            
            var endIndex = 10
            if episodeItems.count - downloadedEpisodes.count < endIndex {
                endIndex = episodeItems.count - downloadedEpisodes.count
            }
            endIndex += startingIndex
            var items = Array(episodeItems[startingIndex..<endIndex])
            
            for each in items {
                if downloadedEpisodes.contains(where: {$0.ID == each.id}) {
                    items.removeAll(where: {$0 == each})
                }
            }
            
            startingIndex = downloadedEpisodes.count + items.count
            
            if items.count == 0 {
                return
            }
            addBottomLoadingSpinner()
            self.isFetchingEpisodes = true
            FireStoreManager.fetchEpisodesWith(episodeItems: items) { [weak self] episodes in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if !episodes.isEmpty {
            //                        self.audioPlayer.downloadedEpisodes += episodes
                        self.tableView.tableFooterView = nil
                        self.downloadedEpisodes += episodes
                        self.episodes += episodes
                        self.episodes = self.episodes.sorted(by: >)
                        self.checkPlayBarActiveController()
                        self.isFetchingEpisodes = false
                        self.tableView.reloadData()
                        self.loadingView.isHidden = true
                        
                    }
                }
            }
        }
    }
    
    func checkPlayBarActiveController() {
        if dunePlayBar.activeController == .dailyFeed {
            dunePlayBar.downloadedEpisodes = episodes
            if selectedCategory != nil {
                dunePlayBar.itemCount = filteredEpisodeItems.count
            } else {
                dunePlayBar.itemCount = episodeItems.count
            }
        }
    }
    
    func fetchFilteredEpisodes() {
        if episodes.count != filteredEpisodeItems.count {
            var endIndex = 10
            
            if filteredEpisodeItems.count - episodes.count < endIndex {
                endIndex = filteredEpisodeItems.count - episodes.count
            }
            endIndex += startingIndex
            
            let items = Array(filteredEpisodeItems[startingIndex..<endIndex])
            startingIndex = episodes.count + items.count
            
            var itemsNeeded = [EpisodeItem]()
            
            for eachItem in items  {
                if let episode = downloadedEpisodes.first(where: {$0.ID == eachItem.id}) {
                    episodes.append(episode)
                } else {
                    itemsNeeded.append(eachItem)
                }
            }
            
            if itemsNeeded.count == 0 {
                episodes = episodes.sorted(by: >)
                loadingView.isHidden = true
                tableView.reloadData()
            } else {
                fetchEpisodesWith(items: itemsNeeded)
            }
        }
    }
    
    func fetchEpisodesWith(items: [EpisodeItem] ) {
        self.isFetchingEpisodes = true
        addBottomLoadingSpinner()
        FireStoreManager.fetchEpisodesWith(episodeItems: items) { episodes in
            DispatchQueue.main.async {
                if !episodes.isEmpty {
                    self.tableView.tableFooterView = nil
                    self.downloadedEpisodes += episodes
                    self.episodes += episodes
                    self.episodes = self.episodes.sorted(by: >)
                    self.checkPlayBarActiveController()
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    self.isFetchingEpisodes = false
                }
            }
        }
    }
    
    func addBottomLoadingSpinner() {
        var spinner: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = CustomStyle.fifthShade
        } else {
            spinner = UIActivityIndicatorView(style: .gray)
        }
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 60.0)
        
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    
    func availableCategories() -> [String] {
        var categories = [String]()
        for eachCategory in Category.allCases {
            if filterMode == .all {
                if episodeItems.contains(where: { $0.category == eachCategory.rawValue }) {
                    categories.append(eachCategory.rawValue)
                }
            } else if filterMode == .today {
                if episodeItems.contains(where: { $0.category == eachCategory.rawValue && Calendar.current.isDateInToday($0.postedDate) }) {
                    categories.append(eachCategory.rawValue)
                }
            }
        }
        return categories
    }
    
    func createCategoryPills() {
        for each in availableCategories() {
            let button = self.categoryPill()
            button.setTitle(each, for: .normal)
            button.addTarget(self, action: #selector(self.categoryButtonPress), for: .touchUpInside)
            self.searchContentStackView.addArrangedSubview(button)
            self.categoryButtons.append(button)
        }
        
        if !episodeItems.contains(where: { Calendar.current.isDateInToday($0.postedDate)}) {
            for each in searchContentStackView.arrangedSubviews {
                let button = each as! UIButton
                if button.titleLabel?.text == "Today" {
                    button.removeFromSuperview()
                }
            }
        } else {
            let buttons = searchContentStackView.arrangedSubviews as! [UIButton]
            if !buttons.contains(where: {$0.titleLabel?.text == "Today" }) {
                searchContentStackView.insertArrangedSubview(todayButton, at: 1)
            }
        }
    }
    
    @objc func categoryButtonPress(category: UIButton) {
        if selectedCategory == category.titleLabel?.text {
            category.backgroundColor = CustomStyle.sixthShade
            category.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            selectedCategory = nil
            removeCategorySelection()
        } else {
            if filterMode == .all {
                filteredEpisodeItems = episodeItems.filter({$0.category == category.titleLabel?.text})
                //                self.audioPlayer.itemCount = filteredEpisodeItems.count
            } else if filterMode == .today {
                filteredEpisodeItems = episodeItems.filter({$0.category == category.titleLabel?.text && Calendar.current.isDateInToday($0.postedDate)})
                //                self.audioPlayer.itemCount = filteredEpisodeItems.count
            }
            highLightButtonWith(title: category.titleLabel!.text!)
            loadingView.isHidden = false
            startingIndex = 0
            episodes = []
            fetchFilteredEpisodes()
        }
    }
    
    func removeCategorySelection() {
        if filterMode == .all {
            filteredEpisodeItems = []
            episodes = downloadedEpisodes
            //            self.audioPlayer.itemCount = episodeItems.count
            tableView.reloadData()
        } else if filterMode == .today {
            getTodaysEpisodes()
        }
    }
    
    func highLightButtonWith(title: String) {
        selectedCategory = title
        for each in categoryButtons {
            if each.titleLabel?.text != title {
                each.backgroundColor = CustomStyle.sixthShade
                each.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            } else {
                each.backgroundColor = CustomStyle.white
                each.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            }
        }
    }
    
    func categoryPill() -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.sixthShade
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        return button
    }
    
    @objc func searchModePress(sender: UIButton) {
        selectedCategory = nil
        if sender.titleLabel?.text == "All" {
            filterMode = .all
            allButton.backgroundColor = CustomStyle.primaryYellow
            allButton.setTitleColor(.black, for: .normal)
            todayButton.backgroundColor = CustomStyle.sixthShade
            todayButton.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            recreateCategoryPills()
            episodes = downloadedEpisodes.sorted(by: >)
            tableView.reloadData()
        } else if sender.titleLabel?.text == "Today" {
            filterMode = .today
            getTodaysEpisodes()
            allButton.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            allButton.backgroundColor = CustomStyle.sixthShade
            todayButton.backgroundColor = CustomStyle.primaryYellow
            todayButton.setTitleColor(.black, for: .normal)
            for each in categoryButtons {
                each.backgroundColor = CustomStyle.sixthShade
                each.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            }
            recreateCategoryPills()
        }
    }
    
    func getTodaysEpisodes() {
        let items = episodeItems.filter({Calendar.current.isDateInToday($0.postedDate)})
        //        self.audioPlayer.itemCount = items.count
        
        var itemsNeeded = [EpisodeItem]()
        episodes = []
        
        for eachItem in items  {
            if let episode = downloadedEpisodes.first(where: {$0.ID == eachItem.id}) {
                episodes.append(episode)
            } else {
                itemsNeeded.append(eachItem)
            }
        }
        
        if itemsNeeded.count == 0 {
            episodes = episodes.sorted(by: >)
            tableView.reloadData()
        } else {
            loadingView.isHidden = false
            fetchTodaysEpisodesWith(items: itemsNeeded)
            print("Fetching todays")
        }
    }
    
    func fetchTodaysEpisodesWith(items: [EpisodeItem] ) {
        self.isFetchingEpisodes = true
        FireStoreManager.fetchAllEpisodesWith(episodeItems: items) { episodes in
            DispatchQueue.main.async {
                if !episodes.isEmpty {
                    //                    self.audioPlayer.downloadedEpisodes = episodes
                    self.downloadedEpisodes += episodes
                    self.episodes += episodes
                    self.episodes = self.episodes.sorted(by: >)
                    self.tableView.reloadData()
                    self.loadingView.isHidden = true
                    self.isFetchingEpisodes = false
                }
            }
        }
    }
    
    @objc func updateCommentCount(_ notification: Notification) {
        let episodeID = notification.userInfo?["ID"] as! String
        let update = notification.userInfo?["update"] as! Int
        guard let episode = downloadedEpisodes.first(where: {$0.ID == episodeID}) else { return }
        guard let index = downloadedEpisodes.firstIndex(where: {$0.ID == episodeID}) else { return }
        episode.commentCount += update
        downloadedEpisodes[index] = episode
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .fade)
    }
    
//    @objc func showCommentFromModal(_ notification: Notification) {
//        let episodeID = notification.userInfo?["ID"] as! String
//        guard let episode = downloadedEpisodes.first(where: {$0.ID == episodeID}) else { return }
//        showCommentsFor(episode: episode)
//    }
    
    // May be used later
    func setCurrentDate() {
        let date = Date()
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        numberFormatter.locale = Locale.current
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let dayString = dayFormatter.string(from: date)
        let monthString = monthFormatter.string(from: date)
        
        let dayNumber = NSNumber(value: Int(dayString)!)
        let day = numberFormatter.string(from: dayNumber)!
        
        currentDateLabel.text = "\(day) \(monthString)"
    }
    
    @objc func autoSubscribePress() {
        autoSubscribeSpinner.isHidden = false
        Analytics.logEvent("auto_subscribe", parameters: nil)
        Analytics.setUserProperty("true", forName: "is_auto_subscriber")
        autoSubscribeButton.setTitleColor(CustomStyle.primaryYellow, for: .normal)
        if let interests = User.interests {
            if interests.count >= 2 {
                FireStoreManager.autoSubscribeToInterests() { success in
                    if success {
                        self.fetchEpisodeItems()
                    } else {
                        FireStoreManager.autoSubscribeToTop {
                            self.fetchEpisodeItems()
                        }
                    }
                }
            } else {
                FireStoreManager.autoSubscribeToTop {
                    self.fetchEpisodeItems()
                }
            }
        } else {
            FireStoreManager.autoSubscribeToTop {
                self.fetchEpisodeItems()
            }
        }
    }
    
    @objc func visitSearchPress() {
         duneTabBar.visit(screen: .search)
//        duneTabBar.tabButtonSelection(3)
//        let tabBar = MainTabController()
//        tabBar.selectedIndex = 3
//        DuneDelegate.newRootView(tabBar)
    }
    
}

extension MainFeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var episodeCell: EpisodeCell
        let episode = episodes[indexPath.row]
        
        if episode.richLink == nil {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        } else if episode.linkIsSmall! {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCellSmlLink") as! EpisodeCellSmlLink
        } else {
            episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCellRegLink") as! EpisodeCellRegLink
        }
        
        episodeCell.episode = episode
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
        episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
        episodeCell.shareButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.normalSetUp(episode: episode)
        episodeCell.cellDelegate = self
        
        let gestureRec = UITapGestureRecognizer(target: episodeCell, action: #selector(EpisodeCell.captionPress))
        if (episodeCell.captionTextView.gestureRecognizers?.count == 0 || episodeCell.captionTextView.gestureRecognizers?.count == nil)  && !episode.caption.contains("@") {
            episodeCell.captionTextView.addGestureRecognizer(gestureRec)
        } else if episode.caption.contains("@") {
            if let recognisers = episodeCell.captionTextView.gestureRecognizers {
                for gesture in recognisers  {
                    if let recogniser = gesture as? UITapGestureRecognizer {
                        episodeCell.captionTextView.removeGestureRecognizer(recogniser)
                    }
                }
            }
        }
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        
        if currentOffset > -45 {
            navBarView.backgroundColor = CustomStyle.blackNavBar
        } else {
            navBarView.backgroundColor = hexStringToUIColor(hex: "191919").withAlphaComponent(0.9)
            searchScrollView.setScrollBarToTopLeft()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if currentOffset < -120  && !self.refreshControl.isRefreshing {
            refreshControl.beginRefreshing()
            self.handleRefreshControl()
        }
        
        if maximumOffset - currentOffset <= 90.0 && isFetchingEpisodes == false {
            
            if filterMode == .all && selectedCategory == nil {
                fetchEpisodes()
            } else if filterMode == .all && selectedCategory != nil {
                fetchFilteredEpisodes()
            }
            
        } else {
            self.tableView.tableFooterView = nil
        }
    }
    
    @objc func checkRefresh() {
        if refreshControl.isRefreshing && isFetchingEpisodes == false {
            refreshControl.endRefreshing()
        }
    }
    
}

extension MainFeedVC: EpisodeCellDelegate {
    
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
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    //MARK: Play Episode
    func playEpisode(cell: EpisodeCell) {
        activeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        // Update play bar with active episode list
        dunePlayBar.downloadedEpisodes = episodes
        if selectedCategory != nil {
            dunePlayBar.itemCount = filteredEpisodeItems.count
        } else {
            dunePlayBar.itemCount = episodeItems.count
        }
        
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.activeController = .dailyFeed
        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
            
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        downloadedEpisodes[indexPath.row] = episode
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        
        if cell.episode.username == User.username! || User.username == "Master"  {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
        
    }
    
    func deleteOwnEpisode() {
        guard let row = selectedCellRow else { return }
        var episode: Episode
        
        if filterMode == .all && selectedCategory == nil  {
            episode = self.downloadedEpisodes[row]
        } else {
            episode = self.episodes[row]
        }
        
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        guard let item = episodeItems.first(where: { $0.id == episode.ID }) else { return }
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp, category: item.category)
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: episode.ID, rep: -7)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        
        if episode.programID == CurrentProgram.ID {
            CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
        }
        
        let index = IndexPath(item: row, section: 0)
        episodes.removeAll(where: { $0.ID == episode.ID })
        episodeItems.removeAll(where: { $0.id == episode.ID })
        downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        dunePlayBar.downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        tableView.deleteRows(at: [index], with: .fade)
//        audioPlayer.transitionOutOfView()
        recreateCategoryPills()
        startingIndex -= 1
        
        if episodeItems.count == 0 {
            fetchEpisodeItems()
        }
        
        if episodes.count == 0 {
            filterMode = .all
            allButton.setTitleColor(.black, for: .normal)
            todayButton.backgroundColor = CustomStyle.sixthShade
            allButton.backgroundColor = CustomStyle.primaryYellow
            todayButton.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            episodes = downloadedEpisodes.sorted(by: >)
            recreateCategoryPills()
            tableView.reloadData()
        }
    }
    
    func addTappedProgram(programName: String) {
        //
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}

extension MainFeedVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        let episode = downloadedEpisodes[selectedCellRow!]
        
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        case "Edit":
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
//            editEpisodeVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editEpisodeVC, animated: true)
        case "Report":
            episodeReported = true
            UIApplication.shared.windows.last?.addSubview(reportEpisodeAlert)
        case "Share via...":
            if episode.username != User.username {
                DynamicLinkHandler.createLinkFor(episode: episode) { [weak self] url in
                    let promoText = "Check out this episode published by \(episode.programName) on Dune."
                    let items: [Any] = [promoText, url]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    DispatchQueue.main.async {
                        self!.present(ac, animated: true)
                    }
                }
            } else {
                DynamicLinkHandler.createLinkFor(episode: episode) { [weak self] url in
                    let promoText = "Have a listen to my recent episode published on Dune."
                    let items: [Any] = [promoText, url]
                    let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    DispatchQueue.main.async {
                        self!.present(ac, animated: true)
                    }
                }
            }
        case "Share via SMS":
            DynamicLinkHandler.createLinkFor(episode: episode) { [weak self] url in
                let promoText = "Check out this episode published by \(episode.programName) on Dune. \(url)"
                DispatchQueue.main.async {
                    self?.shareViaSMSWith(messageBody: promoText)
                }
            }
        default:
            break
        }
    }
}

extension MainFeedVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

extension MainFeedVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        if isFetchingEpisodes == false {
            if filterMode == .all && selectedCategory == nil {
                fetchEpisodes()
            } else if filterMode == .all && selectedCategory != nil {
                fetchFilteredEpisodes()
            }
        }
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
        User.appendPlayedEpisode(ID: episode.ID, progress: 0.0)
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
        if tableView.indexPathsForVisibleRows!.contains(indexPath) {
            if let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as? EpisodeCell {
                cell.playbackBarView.setupPlaybackBar()
                cell.removePlayIcon()
                activeCell = cell
            }
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

extension MainFeedVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        if episodeReported {
            let episode = downloadedEpisodes[selectedCellRow!]
            FireStoreManager.reportEpisodeWith(episodeID: episode.ID)
            episodeReported = false
        }
    }
    
    func cancelButtonPress() {
        episodeReported = false
    }
    
}

extension MainFeedVC: NavPlayerDelegate {
    
    func playOrPauseEpisode() {
        if dunePlayBar.isOutOfPosition {
            activeCell = nil
        }
        
        if let cell = activeCell {
            dunePlayBar.playOrPauseEpisodeWith(audioID: cell.episode.audioID)
        } else {
            if let cellIndex = episodes.firstIndex(of: commentVC.episode) {
                let indexPath = IndexPath(item: cellIndex, section: 0)
                guard let episodeCell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
                playEpisode(cell: episodeCell)
                episodeCell.removePlayIcon()
                dunePlayBar.audioPlayerDelegate = commentVC
            }
        }
    }
    
}


extension MainFeedVC: MFMessageComposeViewControllerDelegate {
    
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
