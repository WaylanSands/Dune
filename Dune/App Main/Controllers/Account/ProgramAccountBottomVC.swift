//
//  BottomViewController.swift
//  profileScroll
//
//  Created by Waylan Sands on 21/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MessageUI

class ProgramAccountBottomVC: UIViewController {
    
    lazy var activeTV: UITableView = episodeTV
    lazy var vFrame = view.frame
    var headerHeight: CGFloat?
    var yOffset: CGFloat?
    var unwrapDifference: CGFloat = 0
    var scrollContentDelegate: updateProgramAccountScrollDelegate!
    
    var programsOwnIDs = [String]()
    
    //Settings
    var selectedEpisodeCellRow: Int?
    var selectedProgramCellRow: Int?
    var selectedEpisodeSetting = false
    var selectedProgramSetting = false
    
    //Episodes
    let episodeTV = UITableView()
    var downloadedEpisodes = [Episode]()
    var episodeItems = [EpisodeItem]()
    var isFetchingEpisodes = false
    var epsStartingIndex: Int = 0
    
    //Subscriptions
    let subscriptionTV = UITableView()
    var currentSubscriptions = [String]()
    var downloadedPrograms = [Program]()
    var fetchedProgramsIDs = [String]()
    var isFetchingPrograms = false
    var subsStartingIndex: Int = 0
    
    //Mentions
    let mentionTV = UITableView()
    var downloadedMentions = [Mention]()
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let loadingView = TVLoadingAnimationView(topHeight: 15)
    var pageIndex:Int = 3
    
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var emptyTableViewTopConstant: CGFloat = 50
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?
    
    var commentVC: CommentThreadVC!

//    let audioPlayer = DunePlayBar()
    var activeEpisodeCell: EpisodeCell?
    
    let playerMask: UIView = {
       let view = UIView()
        view.backgroundColor = .red
        return view
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
        label.text = "Episodes published by @\(CurrentProgram.username!) will appear here."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.subTextColor
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setTitle("Visit The Studio", for: .normal)
        button.backgroundColor = CustomStyle.onBoardingBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 1, right: 25)
        button.addTarget(self, action: #selector(continueToView), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        programsOwnIDs = CurrentProgram.programsIDs()
        subscriptionTV.setScrollBarToTopLeft()
        episodeTV.setScrollBarToTopLeft()
        mentionTV.setScrollBarToTopLeft()
        subscriptionTV.isHidden = true
        mentionTV.isHidden = true
        fetchEpisodeIDs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        introPlayer.finishSession()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            emptyTableViewTopConstant = 130
        case .iPhone8:
             emptyTableViewTopConstant = 130
        case .iPhone8Plus:
            break
        case .iPhone11:
            emptyTableViewTopConstant = 80
        case .iPhone11Pro, .iPhone12:
            break
        case .iPhone11ProMax, .iPhone12ProMax:
             emptyTableViewTopConstant = 80
        case .unknown:
            break
        }
    }
    
    func configureDelegates() {
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        subscriptionTV.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        mentionTV.register(MentionCell.self, forCellReuseIdentifier: "mentionCell")
        ownEpisodeSettings.settingsDelegate = self
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        subscriptionTV.backgroundColor = .clear
        mentionTV.backgroundColor = .clear
        episodeTV.backgroundColor = .clear
        episodeTV.dataSource = self
        mentionTV.dataSource = self
        mentionTV.delegate = self
        episodeTV.delegate = self
//        audioPlayer.audioPlayerDelegate = self
        introPlayer.playbackDelegate = self
    }
    
    func resetSubscriptionTV() {
        downloadedPrograms = [Program]()
        fetchedProgramsIDs = [String]()
        isFetchingPrograms = false
        subsStartingIndex = 0
    }
    
    func configureViews() {
        self.view.backgroundColor = CustomStyle.secondShade
        view.addSubview(subscriptionTV)
        subscriptionTV.frame = CGRect(x:0, y: 0, width: vFrame.width, height: vFrame.height)
//        subscriptionTV.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: subscriptionTV.safeDunePlayBarHeight, right: 0.0)

        view.addSubview(episodeTV)
        episodeTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
//        episodeTV.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: episodeTV.safeDunePlayBarHeight, right: 0.0)
        
        view.addSubview(mentionTV)
        mentionTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
//        mentionTV.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: mentionTV.safeDunePlayBarHeight, right: 0.0)
        
        view.addSubview(emptyTableView)
        emptyTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: emptyTableViewTopConstant).isActive = true
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
        emptyButton.topAnchor.constraint(equalTo: emptySubLabel.bottomAnchor, constant: 20).isActive = true
        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
        
        navigationController?.visibleViewController?.view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 64)
        introPlayer.offset = 64 + duneTabBar.frame.height
                
//        navigationController?.visibleViewController?.view.addSubview(audioPlayer)
//        audioPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 600)
    }
    
    func configureEmptyTableViewFor(tableView: UITableView) {
        switch tableView {
        case episodeTV:
            emptyHeadingLabel.text = "Published episodes"
            emptySubLabel.text = "Episodes published by @\(CurrentProgram.username!) will appear here."
            emptyButton.setTitle("Visit The Studio", for: .normal)
            loadingView.isHidden = true
            emptyButton.isHidden = false
            pageIndex = 2
        case subscriptionTV:
            resetSubscriptionTV()
            subscriptionTV.reloadData()
            emptyHeadingLabel.text = "Subscribe to programs"
            emptySubLabel.text = "You will be able to manage your subscriptions here."
            emptyButton.setTitle("Visit Search", for: .normal)
            emptyButton.isHidden = false
            pageIndex = 3
        case mentionTV:
            emptyHeadingLabel.text = "View mentions"
            emptySubLabel.text = "Episodes and comments which you have been tagged in will appear here."
            emptyButton.isHidden = true
        default:
            break
        }
        loadingView.isHidden = true
        emptyTableView.isHidden = false
    }
    
    func resetTableView() {
        downloadedEpisodes = [Episode]()
        episodeTV.isHidden = false
        epsStartingIndex = 0
        episodeItems = []
        episodeTV.reloadData()
    }
    
    func fetchEpisodeIDs() {
        FireStoreManager.fetchEpisodesItemsWith(with: programsOwnIDs) { items in
            DispatchQueue.main.async {
                if items.isEmpty {
                    self.episodeTV.isHidden = true
                    self.configureEmptyTableViewFor(tableView: self.episodeTV)
                } else {
                    if items != self.episodeItems {
                        self.emptyTableView.isHidden = true
                        self.loadingView.isHidden = true
                        self.resetTableView()
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
            
            if episodeItems.count - downloadedEpisodes.count < endIndex {
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
                        self.checkPlayBarActiveController()
                        self.episodeTV.reloadData()
                        self.loadingView.isHidden = true
                        self.isFetchingEpisodes = false
                    }  else {
                        self.episodeTV.isHidden = true
                        self.configureEmptyTableViewFor(tableView: self.episodeTV)
                    }
                }
            }
        }
    }
    
    func checkPlayBarActiveController() {
        if dunePlayBar.activeController == .account {
            dunePlayBar.audioPlayerDelegate = self
            dunePlayBar.downloadedEpisodes = downloadedEpisodes
            dunePlayBar.itemCount = episodeItems.count
        }
    }
       
    func fetchProgramsSubscriptions() {
        var subscriptionIDs = CurrentProgram.subscriptionIDs!
        subscriptionIDs.removeAll(where: { programsOwnIDs.contains($0) })
        
        if currentSubscriptions != subscriptionIDs {
            resetSubscriptionTV()
        }
        
        //        currentSubscriptions = subscriptionIDs
        //
        //        if downloadedPrograms.count != subscriptionIDs.count {
        //            var subsEndIndex = 20
        //
        //            if subscriptionIDs.count - fetchedProgramsIDs.count < subsEndIndex {
        //                subsEndIndex = subscriptionIDs.count - fetchedProgramsIDs.count
        //            }
        //
        //            subsEndIndex += subsStartingIndex
        //
        //            let programIDs = Array(subscriptionIDs[subsStartingIndex..<subsEndIndex])
        //            fetchedProgramsIDs += programIDs
        //            subsStartingIndex = fetchedProgramsIDs.count
        
        self.isFetchingPrograms = true
        FireStoreManager.fetchProgramsWith(IDs: subscriptionIDs) { programs in
            if programs != nil {
                DispatchQueue.main.async {
                    self.downloadedPrograms += programs!
                    self.subscriptionTV.reloadData()
                    self.loadingView.isHidden = true
                    self.isFetchingPrograms = false
                }
            }
        }
    }
    
    func fetchProgramsMentions() {
        FireStoreManager.fetchMentionsFor(programID: CurrentProgram.ID!) { mentions in
            DispatchQueue.main.async {
                if mentions != nil {
                    self.downloadedMentions = mentions!
                    self.loadingView.isHidden = true
                    self.mentionTV.reloadData()
                }
            }
        }
    }
    
    func updateTableViewWith(title: String) {
        emptyTableView.isHidden = true
        switch title {
        case "Episodes":
            activeTV = episodeTV
            mentionTV.isHidden = true
            episodeTV.isHidden = false
            subscriptionTV.isHidden = true
            mentionTV.setScrollBarToTopLeft()
            subscriptionTV.setScrollBarToTopLeft()
            if downloadedEpisodes.isEmpty {
                configureEmptyTableViewFor(tableView: episodeTV)
            }
        case "Subscriptions":
            activeTV = subscriptionTV
            episodeTV.isHidden = true
            mentionTV.isHidden = true
            subscriptionTV.isHidden = false
            episodeTV.setScrollBarToTopLeft()
            mentionTV.setScrollBarToTopLeft()
            if CurrentProgram.subscriptionIDs!.count - programsOwnIDs.count == 0 {
                configureEmptyTableViewFor(tableView: subscriptionTV)
                loadingView.isHidden = true
            } else if downloadedPrograms.count != CurrentProgram.subscriptionIDs!.count - programsOwnIDs.count {
                loadingView.isHidden = false
                fetchProgramsSubscriptions()
            }
        case "Mentions":
            activeTV = mentionTV
            episodeTV.isHidden = true
            mentionTV.isHidden = false
            subscriptionTV.isHidden = true
            episodeTV.setScrollBarToTopLeft()
            subscriptionTV.setScrollBarToTopLeft()
            if !CurrentProgram.hasMentions! {
                configureEmptyTableViewFor(tableView: mentionTV)
            } else if downloadedMentions.isEmpty {
                loadingView.isHidden = false
                fetchProgramsMentions()
            }
        default:
            break
        }
    }
    
    func activeTableView() -> UIView {
        return activeTV
    }
    
    // MARK: Play account's intro
    
    @objc func playIntro() {
        dunePlayBar.finishSession()
        introPlayer.setProgramDetailsWith(name: CurrentProgram.name!, username: CurrentProgram.username!, image: CurrentProgram.image!)
        introPlayer.playOrPauseIntroWith(audioID: CurrentProgram.introID!)
    }
    
    @objc func continueToView() {
        switch pageIndex {
        case 2:
            duneTabBar.visit(screen: .studio)
        case 3:
            duneTabBar.visit(screen: .search)
        default:
            break
        }
//        duneTabBar.tabButtonSelection(pageIndex)
//        let tabBar = MainTabController()
//        tabBar.selectedIndex = pageIndex
//        DuneDelegate.newRootView(tabBar)
    }
}

extension ProgramAccountBottomVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case episodeTV:
            return downloadedEpisodes.count
        case subscriptionTV:
            return downloadedPrograms.count
        case mentionTV:
            return downloadedMentions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView {
        case episodeTV:
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
            episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
            episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
            episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
            episodeCell.shareButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
            episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
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
                    activeEpisodeCell = episodeCell
                }
            }
            return episodeCell
        case subscriptionTV:
            let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
            programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
            programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
            programCell.programNameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
//            programCell.playProgramButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
//            programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
            programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
            programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
            
            let program = downloadedPrograms[indexPath.row]
            programCell.program = program
            
            programCell.cellDelegate = self
            programCell.normalSetUp(program: program)
            return programCell
        case mentionTV:
            let mentionCell = tableView.dequeueReusableCell(withIdentifier: "mentionCell") as! MentionCell
            mentionCell.actionButton.addTarget(mentionCell, action: #selector(MentionCell.actionButtonPress), for: .touchUpInside)
            mentionCell.profileImageButton.addTarget(mentionCell, action: #selector(MentionCell.visitProfile), for: .touchUpInside)
            mentionCell.usernameButton.addTarget(mentionCell, action: #selector(MentionCell.visitProfile), for: .touchUpInside)
            let mention = downloadedMentions[indexPath.row]
            mentionCell.cellDelegate = self
            mentionCell.cellSetup(mention: mention)
            return mentionCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  duneTabBar.frame.height + 64
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: duneTabBar.frame.height + 64)
        return view
    }
    
}

// MARK: Settings Launcher Delegate
extension ProgramAccountBottomVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        var episode: Episode
        
        if dunePlayBar.activeController != .account {
             episode = downloadedEpisodes[selectedEpisodeCellRow!]
        } else {
            episode = dunePlayBar.episode
        }
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        case "Edit":
            let episode = downloadedEpisodes[selectedEpisodeCellRow!]
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
            //            editEpisodeVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editEpisodeVC, animated: true)
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
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
                let promoText = "Check out my latest episode on Dune. \(url)"
                DispatchQueue.main.async {
                    self?.shareViaSMSWith(messageBody: promoText)
                }
            }
        default:
            break
        }
    }
    
    func deleteOwnEpisode() {
        guard let row = self.selectedEpisodeCellRow else { return }
        let episode = downloadedEpisodes[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        guard let item = episodeItems.first(where: { $0.id == episode.ID }) else { return }
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp,  category: item.category)
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: episode.ID, rep: -7)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
        
        let index = IndexPath(item: row, section: 0)
        downloadedEpisodes.remove(at: row)
        episodeTV.deleteRows(at: [index], with: .fade)
        
        if downloadedEpisodes.count == 0 {
            configureEmptyTableViewFor(tableView: episodeTV)
            resetTableView()
        }
//        audioPlayer.transitionOutOfView()
    }
}

// MARK: Episode Editor Delegate
extension ProgramAccountBottomVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedEpisodeCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        episodeTV.reloadRows(at: [indexPath], with: .fade)
    }
    
}

// MARK: PlaybackBar Delegate
extension ProgramAccountBottomVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        
        if lastPlayedID != episodeID {
            updatePastEpisodeProgress()
            listenCountUpdated = false
        }
        lastPlayedID = episodeID
        
        if forType == .episode {
            guard let cell = activeEpisodeCell else { return }
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
        } else {
            guard let cell = activeProgramCell else { return }
            if percentage > 0.0 {
                cell.playbackBarView.progressUpdateWith(percentage: percentage)
                lastProgress = percentage
            }
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let indexPath = IndexPath(item: atIndex, section: 0)

        switch forType {
        case .episode:
            if episodeTV.indexPathsForVisibleRows!.contains(indexPath) {
                let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
                cell.playbackBarView.setupPlaybackBar()
                cell.removePlayIcon()
                activeEpisodeCell = cell
            }
        case .program:
            if subscriptionTV.indexPathsForVisibleRows!.contains(indexPath) {
                let cell = subscriptionTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
                cell.playbackBarView.setupPlaybackBar()
                activeProgramCell = cell
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
    
    func showSettingsFor(episode: Episode) {
        selectedEpisodeCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID })
        ownEpisodeSettings.showSettings()
    }
    
}

// MARK: ProgramCell Delegate
extension ProgramAccountBottomVC: ProgramCellDelegate, MentionCellDelegate {
  
    func programTagSelected(tag: String) {
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
   
    func noIntroAlert() {
//         view.addSubview(noIntroRecordedAlert)
    }
    
    func unsubscribeFrom(program: Program) {
        guard let index =  downloadedPrograms.firstIndex(where: {$0.ID == program.ID}) else { return }
        downloadedPrograms.remove(at: index)
        subscriptionTV.reloadData()
        
        if downloadedPrograms.count == 0 {
            configureEmptyTableViewFor(tableView: subscriptionTV)
        }
    }
    
    func visitProfile(program: Program) {
        if program.ID == CurrentProgram.ID {
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
    
    //MARK: Play program's cell
    
    func playProgramIntro(cell: ProgramCell) {
        activeProgramCell = cell
        
//        if !audioPlayer.isOutOfPosition {
//            audioPlayer.finishSession()
//        }
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
//        let difference = UIScreen.main.bounds.height - headerHeight! + unwrapDifference
//        let position = difference - tabBarController!.tabBar.frame.height - 70
//        let offset = position + (yOffset ?? 0)
//
        
        let image = cell.programImageButton.imageView!.image!
        let audioID = cell.program.introID
        
        self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
        self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
        
        let program = cell.program!
        program.hasBeenPlayed = true
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == program.ID }) else { return }
        downloadedPrograms[index] = program
    }
    
    func showSettings(cell: ProgramCell) {
        programSettings.showSettings()
        selectedProgramCellRow = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        selectedProgramSetting = true
    }
   
}

// MARK: EpisodeCell Delegate
extension ProgramAccountBottomVC :EpisodeCellDelegate {
   
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
    
    func updateRows() {
        DispatchQueue.main.async {
            self.episodeTV.beginUpdates()
            self.episodeTV.endUpdates()
        }
    }
    
    // MARK: Play Episode
    func playEpisode(cell: EpisodeCell) {
        
        if introPlayer.isInPosition {
            introPlayer.finishSession()
        }
        
        activeEpisodeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }

        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        // Update play bar with active episode list
        dunePlayBar.activeController = .account
        dunePlayBar.activeViewController = self

        dunePlayBar.downloadedEpisodes = downloadedEpisodes
        dunePlayBar.itemCount = episodeItems.count
        
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
    
    }
    
    func showSettingsFor(cell: EpisodeCell) {
        selectedEpisodeCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        ownEpisodeSettings.showSettings()
        selectedEpisodeSetting = true
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
    func showCommentsFor(episode: Episode) {
        commentVC = CommentThreadVC(episode: episode)
        commentVC.currentState = dunePlayBar.currentState
        dunePlayBar.audioPlayerDelegate = commentVC
        dunePlayBar.isHidden = true
        commentVC.delegate = self
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
}

extension ProgramAccountBottomVC: CustomAlertDelegate {
  
    func primaryButtonPress() {
        if selectedEpisodeSetting {
            selectedEpisodeSetting = false
        } else if selectedProgramSetting {
            let program = downloadedPrograms[selectedProgramCellRow!]
            FireStoreManager.reportProgramWith(programID: program.ID)
            selectedProgramSetting = false
        }
    }
    
    func cancelButtonPress() {
        selectedProgramSetting = false
        selectedEpisodeSetting = false
    } 
    
}

extension ProgramAccountBottomVC: NavBarPlayerDelegate {
    
    func playOrPauseEpisode() {
        if dunePlayBar.isOutOfPosition {
            activeEpisodeCell = nil
        }
        
        if let cell = activeEpisodeCell {
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

extension ProgramAccountBottomVC: MFMessageComposeViewControllerDelegate {
    
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



