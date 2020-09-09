//
//  BottomViewController.swift
//  profileScroll
//
//  Created by Waylan Sands on 21/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ProgramProfileBottomVC: UIViewController {
    
    lazy var activeTV: UITableView = episodeTV
    lazy var vFrame = view.frame
    var headerHeight: CGFloat?
    var yOffset: CGFloat?
    var unwrapDifference: CGFloat = 0
    
    let program: Program!
    var programsOwnIDs = [String]()

    var listenCountUpdated = false
//    var pushingContent = false
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
        
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
    
    //Settings
    var selectedEpisodeCellRow: Int?
    var selectedProgramCellRow: Int?
    var selectedProgramSettings = false
    var selectedEpisodeSettings = false
    
    let loadingView = TVLoadingAnimationView(topHeight: 15)
    
    let episodeSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
   
    let noIntroRecordedAlert = CustomAlertView(alertType: .noIntroRecorded)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    let reportEpisodeAlert = CustomAlertView(alertType: .reportEpisode)
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?

//    let audioPlayer = DunePlayBar()
    var activeEpisodeCell: EpisodeCell?
    
    var commentVC: CommentThreadVC!
    
    required init(program: Program) {
        self.program = program
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let emptyTableView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyHeadingLabel: UILabel = {
       let label = UILabel()
        label.text = "Nothing to see here - yet."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var emptySubLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "\(program.name) is yet to publish any episodes."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.subTextColor
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscriptionTV.setScrollBarToTopLeft()
        programsOwnIDs = program.programsIDs()
        episodeTV.setScrollBarToTopLeft()
        mentionTV.setScrollBarToTopLeft()
        configureForPrivacy()
        hideTableViews()
    }
    
    func hideTableViews() {
        if mentionTV != activeTV {
            mentionTV.isHidden = true
        }
        
        if subscriptionTV != activeTV {
            subscriptionTV.isHidden = true
        }
    }
    
    func configureForPrivacy() {
        if program.isPrivate && !CurrentProgram.subscriptionIDs!.contains(program.ID) {
            emptyHeadingLabel.text = "Private Channel."
            emptySubLabel.text = "Only channels that have been invited by \(program.name) are able to view contnet."
            emptyTableView.isHidden = false
            loadingView.isHidden = true
        } else {
            fetchEpisodeIDs()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//         removeModalCommentObserver()
//        if !pushingContent {
//           audioPlayer.finishSession()
//        }
        introPlayer.finishSession()
    }
    
    func configureDelegates() {
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        reportProgramAlert.alertDelegate = self
        reportEpisodeAlert.alertDelegate = self
        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        subscriptionTV.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        mentionTV.register(MentionCell.self, forCellReuseIdentifier: "mentionCell")
        subscriptionTV.backgroundColor = .clear
        programSettings.settingsDelegate = self
        episodeSettings.settingsDelegate = self
        mentionTV.backgroundColor = .clear
        episodeTV.backgroundColor = .clear
        episodeTV.dataSource = self
        mentionTV.dataSource = self
        mentionTV.delegate = self
        episodeTV.delegate = self
        introPlayer.playbackDelegate = self
    }
    
    func activeTableView() -> UIView {
        return activeTV
    }
    
    func resetSubscriptionTV() {
        downloadedPrograms = [Program]()
        fetchedProgramsIDs = [String]()
        isFetchingPrograms = false
        subsStartingIndex = 0
    }
    
//    func setupModalCommentObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showCommentFromModal), name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
//    }
//
//    @objc func showCommentFromModal(_ notification: Notification) {
//        let episodeID = notification.userInfo?["ID"] as! String
//        let episode = downloadedEpisodes.first(where: {$0.ID == episodeID})
//        if episode != nil {
//             showCommentsFor(episode: episode!)
//        } else {
//            FireStoreManager.getEpisodeWith(episodeID: episodeID) { episode in
//                self.showCommentsFor(episode: episode)
//            }
//        }
//    }
    
//    func removeModalCommentObserver() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
//    }
    
    func configureViews() {
        self.view.backgroundColor = CustomStyle.secondShade
        view.addSubview(subscriptionTV)
        subscriptionTV.frame = CGRect(x:0, y: 0, width: vFrame.width, height: vFrame.height)

        view.addSubview(episodeTV)
        episodeTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(mentionTV)
        mentionTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(emptyTableView)
        emptyTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
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
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
        
//        view.addSubview(introPlayer)
        navigationController?.visibleViewController?.view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 64)
        introPlayer.offset = 64
        
//        navigationController?.visibleViewController?.view.addSubview(audioPlayer)
//        audioPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 600)
    }
    
    func configureEmptyTableViewFor(tableView: UITableView) {
        switch tableView {
        case episodeTV:
            emptyHeadingLabel.text = "Nothing to see here - yet."
            emptySubLabel.text = "\(program.name) is yet to publish any episodes."
            loadingView.isHidden = true
        case subscriptionTV:
            emptyHeadingLabel.text = "Zero subscriptions"
            emptySubLabel.text = "\(program.name) isn't following any programs at the moment."
        case mentionTV:
            emptyHeadingLabel.text = "Not yet mentioned"
            emptySubLabel.text = "\(program.name) is waiting to be mentioned."
        default:
            break
        }
        loadingView.isHidden = true
        emptyTableView.isHidden = false
    }
    
    func fetchEpisodeIDs() {
        FireStoreManager.fetchEpisodesItemsWith(with: programsOwnIDs) { items in
            if items.isEmpty {
                self.episodeTV.isHidden = true
                self.configureEmptyTableViewFor(tableView: self.episodeTV)
            } else {
                if items != self.episodeItems {
                    self.emptyTableView.isHidden = true
                    self.episodeItems = items
                    self.fetchProgramsEpisodes()
                }
            }
        }
    }
    
    func fetchProgramsEpisodes() {
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
        if dunePlayBar.activeController == .profile && dunePlayBar.activeProfile == program.username {
            dunePlayBar.downloadedEpisodes = downloadedEpisodes
            dunePlayBar.itemCount = episodeItems.count
        }
    }
    
    func fetchProgramsSubscriptions() {
        var subscriptionIDs = program.subscriptionIDs
        subscriptionIDs.removeAll(where: { programsOwnIDs.contains($0) })
        
        if currentSubscriptions != subscriptionIDs {
            resetSubscriptionTV()
        }
        
        currentSubscriptions = subscriptionIDs
        print(currentSubscriptions)
        
        if downloadedPrograms.count != subscriptionIDs.count {
            var subsEndIndex = 20
            
            if subscriptionIDs.count - fetchedProgramsIDs.count < subsEndIndex {
                subsEndIndex = subscriptionIDs.count
            }
            
            subsEndIndex += subsStartingIndex
            
            let programIDs = Array(subscriptionIDs[subsStartingIndex..<subsEndIndex])
            fetchedProgramsIDs += programIDs
            subsStartingIndex = fetchedProgramsIDs.count
            
            self.isFetchingPrograms = true
            FireStoreManager.fetchProgramsWith(IDs: programIDs) { programs in
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
    }
    
    func fetchProgramsMentions() {
        FireStoreManager.fetchMentionsFor(programID: program.ID) { mentions in

            if mentions != nil {
                self.downloadedMentions = mentions!
                self.loadingView.isHidden = true
                self.mentionTV.reloadData()
            }
        }
    }
    
    @objc func playIntro() {
        dunePlayBar.finishSession()
        introPlayer.setProgramDetailsWith(name: program.name, username: program.username, image: program.image!)
        introPlayer.playOrPauseIntroWith(audioID: program.introID!)
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
            print("downloadedPrograms.count \(downloadedPrograms.count)")
            print("program.subscriptionIDs.count \(program.subscriptionIDs.count)")
            print("programsOwnIDs.count \(programsOwnIDs.count)")
            if program.subscriptionIDs.count - programsOwnIDs.count == 0 {
                configureEmptyTableViewFor(tableView: subscriptionTV)
                loadingView.isHidden = true
            } else if downloadedPrograms.count != program.subscriptionIDs.count - programsOwnIDs.count {
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
            if !program.hasMentions {
                configureEmptyTableViewFor(tableView: mentionTV)
            } else if downloadedMentions.isEmpty {
                loadingView.isHidden = false
                fetchProgramsMentions()
            }
        default:
            break
        }
    }
    
}


// MARK: Settings Launcher
extension ProgramProfileBottomVC: UITableViewDelegate, UITableViewDataSource {
    
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
//            episodeCell.playEpisodeButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
            episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
            episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
            episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
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
       return duneTabBar.frame.height + 64
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: duneTabBar.frame.height + 64)
        return view
    }
}

// MARK: Settings Launcher Delegate
extension ProgramProfileBottomVC: SettingsLauncherDelegate {
   
    func selectionOf(setting: String) {
        switch setting {
        case "Report":
            if selectedEpisodeSettings {
                 UIApplication.shared.windows.last?.addSubview(reportEpisodeAlert)
            } else if selectedProgramSettings {
                 UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
            }
        default:
            break
        }
    }
}

// MARK: Episode Editor Delegate
extension ProgramProfileBottomVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedEpisodeCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        episodeTV.reloadRows(at: [indexPath], with: .fade)
    }
}

// MARK: PlaybackBar Delegate
extension ProgramProfileBottomVC: DuneAudioPlayerDelegate {
    
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
    }
}

// MARK: EpisodeCell Delegate
extension ProgramProfileBottomVC :EpisodeCellDelegate {
    
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
    
    func addTappedProgram(programName: String) {
        //
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
        
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.activeController = .profile
        dunePlayBar.activeProfile = program.username
        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image!)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
        
        // Update play bar with active episode list
        dunePlayBar.downloadedEpisodes = downloadedEpisodes
        dunePlayBar.itemCount = episodeItems.count
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedEpisodeCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        episodeSettings.showSettings()
        selectedEpisodeSettings = true
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
}

extension ProgramProfileBottomVC: ProgramCellDelegate, MentionCellDelegate {
   
    func programTagSelected(tag: String) {
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func noIntroAlert() {
        UIApplication.shared.windows.last?.addSubview(noIntroRecordedAlert)
    }
    
    func unsubscribeFrom(program: Program) {
        //
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
    
    func showSettings(cell: ProgramCell) {
        selectedProgramCellRow = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        programSettings.showSettings()
        selectedProgramSettings = true
    }
    
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
                
        let image = cell.programImageButton.imageView!.image!
        let audioID = cell.program.introID
        
        self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
        self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
    }
}

extension ProgramProfileBottomVC: CustomAlertDelegate {
  
    func primaryButtonPress() {
        if selectedEpisodeSettings {
            let episode = downloadedEpisodes[selectedEpisodeCellRow!]
            FireStoreManager.reportEpisodeWith(episodeID: episode.ID)
            selectedEpisodeSettings = false
        } else if selectedProgramSettings {
            let program = downloadedPrograms[selectedProgramCellRow!]
            FireStoreManager.reportProgramWith(programID: program.ID)
            selectedProgramSettings = false
        }
    }
    
    func cancelButtonPress() {
        selectedProgramSettings = false
        selectedEpisodeSettings = false
    }
    
}

extension ProgramProfileBottomVC: NavPlayerDelegate {
    
    func playOrPauseEpisode() {
        if dunePlayBar.isOutOfPosition {
            activeEpisodeCell = nil
        }
        
        if let cell = activeEpisodeCell {
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


