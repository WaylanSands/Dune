//
//  ListenerAccountBottomVC.swift
//  Dune
//
//  Created by Waylan Sands on 3/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//


import UIKit

class ListenerAccountBottomVC: UIViewController {
    
    lazy var activeTV: UITableView = episodeTV
    lazy var vFrame = view.frame
    var headerHeight: CGFloat?
    var yOffset: CGFloat?
    var unwrapDifference: CGFloat = 0
    var scrollContentDelegate: updateProgramAccountScrollDelegate!

    var pushingComment = true
    let episodeTV = UITableView()
    let subscriptionTV = ProgramSubscriptionTV()
        
    var batchLimit = 10
    var programIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    var selectedCellRow: Int?
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let episodeLoadingView = TVLoadingAnimationView(topHeight: 15)
    let programLoadingView = TVLoadingAnimationView(topHeight: 15)
    var downloadedEpisodes = [Episode]()
    
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.nonFavouriteProgramSettings, type: .program)
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?

    let audioPlayer = DuneAudioPlayer()
    var activeEpisodeCell: EpisodeCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
        addEpisodeLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscriptionTV.setScrollBarToTopLeft()
        episodeTV.setScrollBarToTopLeft()
        setupModalCommentObserver()
        
        subscriptionTV.isHidden = true
        pushingComment = false

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        subscriptionTV.downloadedPrograms.removeAll()
        removeModalCommentObserver()
        if !pushingComment {
            audioPlayer.finishSession()
        }
        introPlayer.finishSession()
    }
    
    func configureDelegates() {
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        ownEpisodeSettings.settingsDelegate = self
        episodeTV.dataSource = self
        episodeTV.delegate = self
        audioPlayer.audioPlayerDelegate = self
        introPlayer.playbackDelegate = self
        subscriptionTV.registerCustomCell()
    }
    
    func setupModalCommentObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCommentFromModal), name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
    }
    
    @objc func showCommentFromModal(_ notification: Notification) {
        let episodeID = notification.userInfo?["ID"] as! String
        let episode = downloadedEpisodes.first(where: {$0.ID == episodeID})
        if episode != nil {
             showCommentsFor(episode: episode!)
        } else {
            FireStoreManager.getEpisodeWith(episodeID: episodeID) { episode in
                self.showCommentsFor(episode: episode)
            }
        }
    }
    
    func removeModalCommentObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
    }
    
    func configureViews() {
        view.addSubview(subscriptionTV)
        subscriptionTV.frame = CGRect(x:0, y: 0, width: vFrame.width, height: vFrame.height)

        view.addSubview(episodeTV)
        episodeTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 70)
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 70)
    }
    
    func resetTableView() {
        print("Reset")
        addEpisodeLoadingView()
        navigationItem.title = "Daily Feed"
        batchLimit = 10
        fetchedEpisodeIDs = [String]()
        downloadedEpisodes = [Episode]()
        episodeIDs = [String]()
        batch = [Episode]()
        episodeTV.isHidden = false
        episodeTV.reloadData()
    }
    
        func addEpisodeLoadingView() {
            view.addSubview(episodeLoadingView)
            episodeLoadingView.translatesAutoresizingMaskIntoConstraints = false
            episodeLoadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
            episodeLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            episodeLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            episodeLoadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
    
            view.bringSubviewToFront(introPlayer)
            view.bringSubviewToFront(audioPlayer)
        }

        func addProgramLoadingView() {
            view.addSubview(programLoadingView)
            programLoadingView.translatesAutoresizingMaskIntoConstraints = false
            programLoadingView.topAnchor.constraint(equalTo: subscriptionTV.topAnchor).isActive = true
            programLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            programLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            programLoadingView.bottomAnchor.constraint(equalTo: subscriptionTV.bottomAnchor).isActive = true
    
            view.bringSubviewToFront(introPlayer)
            view.bringSubviewToFront(audioPlayer)
        }
    
    // MARK: Fetch batch of episode IDs
    func fetchEpisodeIDsForUser() {
        FireStoreManager.fetchEpisodesIDsWith(with: programIDs) { ids in
            
            if ids.isEmpty {
                print("No episodes to display")
                self.resetTableView()
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
    
    func loadFirstBatch() {
        var endIndex = batchLimit
        print("Episode count \(episodeIDs.count)")
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
                
                if self.batch.count == self.episodesToFetch.count{
                    
                    let orderedBatch = self.batch.sorted { (epA , epB) -> Bool in
                        let dateA = epA.timeStamp.dateValue()
                        let dateB = epB.timeStamp.dateValue()
                        return dateA > dateB
                    }
                    
                    for each in orderedBatch {
                        self.downloadedEpisodes.append(each)
                        self.audioPlayer.downloadedEpisodes.append(each)
//                        self.audioPlayer.audioIDs.append(each.audioID)
                    }
            
                    self.fetchedEpisodeIDs += self.episodesToFetch
                    self.episodeLoadingView.removeFromSuperview()
                    self.episodesToFetch.removeAll()
                    self.episodeTV.reloadData()
                    self.batch.removeAll()
                }
            }
        }
    }
    
    func updateTableViewWith(title: String) {
        switch title {
        case "Episodes":
            activeTV = episodeTV
            episodeTV.isHidden = false
            subscriptionTV.isHidden = true
            episodeLoadingView.isHidden = false
            subscriptionTV.setScrollBarToTopLeft()
        case "Subscriptions":
            activeTV = subscriptionTV
            episodeTV.isHidden = true
            subscriptionTV.isHidden = false
            episodeTV.setScrollBarToTopLeft()
            episodeLoadingView.isHidden = true
            if subscriptionTV.downloadedPrograms.isEmpty {
            addProgramLoadingView()
            }
         if User.subscriptionIDs?.count != subscriptionTV.downloadedPrograms.count {
         subscriptionTV.fetchUserSubscriptions()
         }
        default:
            break
        }
    }
    
    func activeTableView() -> UIView {
       return activeTV
    }
    
    // MARK: Play Program's Intro
    @objc func playIntro() {
//
//        introPlayer.isProgramPageIntro = true
//        if !audioPlayer.isOutOfPosition {
//            audioPlayer.finishSession()
//        }
//
//        introPlayer.getAudioWith(audioID: CurrentProgram.introID!) { url in
//            self.introPlayer.playOrPauseWith(url: url, name: CurrentProgram.name!, image: CurrentProgram.image!)
//        }
//        print("Play intro")
    }
}


// MARK: Settings Launcher
extension ListenerAccountBottomVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case episodeTV:
            return downloadedEpisodes.count
        case subscriptionTV:
            return subscriptionTV.downloadedPrograms.count
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
            episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
            episodeCell.normalSetUp(episode: episode)
            episodeCell.cellDelegate = self

            if episode.likeCount >= 10 && episodeCell.optionsConfigured == false {
                episodeCell.configureCellWithOptions()
                episodeCell.optionsConfigured = true
            } else if episode.likeCount < 10 && episodeCell.optionsConfigured {
                episodeCell.configureWithoutOptions()
                episodeCell.optionsConfigured = false
            }
            
            if let playerEpisode = audioPlayer.episode  {
                if episode.ID == playerEpisode.ID {
                    activeEpisodeCell = episodeCell
                }
            }
            return episodeCell
            
        case subscriptionTV:
            programLoadingView.removeFromSuperview()
            let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
            programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
            programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
            programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
            programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
            programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
            
            let program = subscriptionTV.downloadedPrograms[indexPath.row]
            programCell.program = program
            
            programCell.cellDelegate = self
            programCell.normalSetUp(program: program)
            return programCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 100
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        return view
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

// MARK: Settings Launcher Delegate
extension ListenerAccountBottomVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Edit":
            let episode = downloadedEpisodes[selectedCellRow!]
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
            navigationController?.present(editEpisodeVC, animated: true, completion: nil)
        default:
            break
        }
    }

}

// MARK: Episode Editor Delegate
extension ListenerAccountBottomVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        episodeTV.reloadRows(at: [indexPath], with: .fade)
    }
    
}

// MARK: PlaybackBar Delegate
extension ListenerAccountBottomVC: DuneAudioPlayerDelegate {
    
    func showCommentsFor(episode: Episode) {
        pushingComment = true
        audioPlayer.pauseSession()
        let commentVC = CommentThreadVC(episode: episode)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
   
    func playedEpisode(episode: Episode) {
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
            if percentage > 0.0 {
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

// MARK: ProgramCell Delegate
extension ListenerAccountBottomVC: ProgramCellDelegate {
    
    func visitProfile(program: Program) {
        if program.isPrimaryProgram && program.hasMultiplePrograms!  {
            let programVC = ProgramProfileVC()
            programVC.program = program
            navigationController?.pushViewController(programVC, animated: true)
        } else {
            let programVC = SubProgramProfileVC(program: program)
            navigationController?.present(programVC, animated: true, completion: nil)
        }
    }
    
    func playProgramIntro(cell: ProgramCell) {
        introPlayer.isProgramPageIntro = false
        activeProgramCell = cell
        
        if !audioPlayer.isOutOfPosition {
            audioPlayer.finishSession()
        }
        
        let programIntro = cell.program.introID!
        let programImage = cell.program.image!
        let programName = cell.program.name
        
        let difference = UIScreen.main.bounds.height - headerHeight! + unwrapDifference
        let position = difference - tabBarController!.tabBar.frame.height - 70
        let offset = position + (yOffset ?? 0)

        introPlayer.yPosition = offset
        
        introPlayer.getAudioWith(audioID: programIntro) { url in
            self.introPlayer.playOrPauseWith(url: url, name: programName, image: programImage)
        }
        print("Play intro")
    }
    
    func showSettings(cell: ProgramCell) {
        programSettings.showSettings()
    }
   
}

// MARK: EpisodeCell Delegate
extension ListenerAccountBottomVC :EpisodeCellDelegate {
    
    func tagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func updateRows() {
        //
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
        
        let difference = UIScreen.main.bounds.height - headerHeight! + unwrapDifference
        let position = difference - tabBarController!.tabBar.frame.height
        let offset = position + (yOffset ?? 0)
       
        audioPlayer.yPosition = offset
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        audioPlayer.getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
        }
    }
    
    func showSettings(cell: EpisodeCell) {
        
        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        ownEpisodeSettings.showSettings()
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
}

