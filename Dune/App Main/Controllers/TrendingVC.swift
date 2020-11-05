//
//  PlaylistVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseFirestore

class TrendingVC: UIViewController {
    
    let loadingView = TVLoadingAnimationView(topHeight: 20)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedEpisodes = [Episode]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    
    var commentVC: CommentThreadVC!
    
    var activeCell: EpisodeCell?
    var selectedCellRow: Int?
    var episodeItems = [EpisodeItem]()
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    
    let tableView = UITableView()
    
    let navBarView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.blackNavBar
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPlayBarActiveController()
        configureNavigation()
        fetchEpisodes() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    func configureNavigation() {
        navigationItem.title = "Trending"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

//        tabBarController?.tabBar.backgroundImage = UIImage()
//        tabBarController?.tabBar.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        DispatchQueue.main.async {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        tableView.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        tableView.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        tableView.showsVerticalScrollIndicator = false
    }
    
    func configureViews() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.safeDunePlayBarHeight, right: 0)
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.tableFooterView = UIView()
        tableView.addTopBounceAreaView()

        
//        view.addSubview(audioPlayer)
//        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 600)
        
        view.addSubview(navBarView)
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        navBarView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        navBarView.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight()).isActive = true
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: UIDevice.current.navBarHeight()).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(navBarView)
//        view.bringSubviewToFront(audioPlayer)
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedEpisodes = []
        initialSnapshot = []
        lastSnapshot = nil
        moreToLoad = true
    }
    
    func fetchEpisodes() {
        FireStoreManager.testTrendingEpisodes() { episodes in
            if self.downloadedEpisodes != episodes.sortedByLikes() {
                self.downloadedEpisodes = episodes.sortedByLikes()
                self.tableView.reloadData()
                self.tableView.setScrollBarToTopLeft()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func fetchTrendingEpisodes() {
        print("Fetching trending episodes")
        
        FireStoreManager.fetchTrendingEpisodesWith(limit: 10) { snapshot in

            if snapshot.count == 0 {
                self.moreToLoad = false
            } else if self.initialSnapshot != snapshot {

                self.resetTableView()
                self.initialSnapshot = snapshot
                self.lastSnapshot = snapshot.last!
                var counter = 0

                for eachDocument in snapshot {
                    counter += 1

                    let data = eachDocument.data()
                    let episode = Episode(data: data)

                    self.downloadedEpisodes.append(episode)
//                    self.audioPlayer.downloadedEpisodes.append(episode)

                    if counter == snapshot.count {
                        self.tableView.reloadData()
                        self.loadingView.removeFromSuperview()
                    }
                }
            }
        }
    }

    func  fetchAnotherBatch() {
        FireStoreManager.fetchTrendingEpisodesFrom(lastSnapshot: lastSnapshot!, limit: 10) { snapshots in

            if snapshots.count == 0 {
                self.moreToLoad = false
            } else {

                self.lastSnapshot = snapshots.last!
                var counter = 0

                for eachDocument in snapshots {
                    counter += 1

                    let data = eachDocument.data()
                    let episode = Episode(data: data)

                    self.downloadedEpisodes.append(episode)
                    self.checkPlayBarActiveController()

                    if counter == snapshots.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func checkPlayBarActiveController() {
        if dunePlayBar.activeController == .trending {
            dunePlayBar.audioPlayerDelegate = self
            dunePlayBar.downloadedEpisodes = downloadedEpisodes
            dunePlayBar.itemCount = episodeItems.count
        }
    }
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let tempURL = FileManager.getTempDirectory()
        let fileURL = tempURL.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            FireStorageManager.downloadEpisodeAudio(audioID: audioID) { url in
                completion(url)
            }
        }
    }

}

extension TrendingVC: UITableViewDelegate, UITableViewDataSource {
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
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 90.0 {
            if moreToLoad == true {
//                fetchAnotherBatch()
            }
        }
    }
}

extension TrendingVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        var episode: Episode
        
        if dunePlayBar.activeController != .trending {
             episode = downloadedEpisodes[selectedCellRow!]
        } else {
            episode = dunePlayBar.episode
        }
                
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        case "Edit":
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
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

extension TrendingVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        if let row = selectedCellRow {
            let episode = downloadedEpisodes[row]
            FireStoreManager.reportEpisodeWith(episodeID: episode.ID)
        }
    }
    
    func cancelButtonPress() {
        //
    }

}

extension TrendingVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        downloadedEpisodes[episodeIndex!] = episode
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
 
}

extension TrendingVC: EpisodeCellDelegate {
    
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
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
    // MARK: Play Episode
    func playEpisode(cell: EpisodeCell) {
        activeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        // Update play bar with active episode list
        dunePlayBar.activeController = .trending
        dunePlayBar.activeViewController = self
        
        dunePlayBar.downloadedEpisodes = downloadedEpisodes
        dunePlayBar.itemCount = episodeItems.count
        
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
    }
    
    func deleteOwnEpisode() {
        guard let row = selectedCellRow else { return }
        let episode = self.downloadedEpisodes[row]
        guard let item = episodeItems.first(where: { $0.id == episode.ID }) else { return }
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp, category: item.category)
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)

        if episode.programID == CurrentProgram.ID {
            CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
        }

        let index = IndexPath(item: row, section: 0)
        downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        dunePlayBar.downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        tableView.deleteRows(at: [index], with: .fade)

        if downloadedEpisodes.count == 0 {
             resetTableView()
        }
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        
        if cell.episode.username == User.username! || User.username! == "Master" {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func showCommentsFor(episode: Episode) {
        commentVC = CommentThreadVC(episode: episode)
        commentVC.currentState = dunePlayBar.currentState
        dunePlayBar.audioPlayerDelegate = commentVC
        commentVC.delegate = self
        dunePlayBar.isHidden = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
}

extension TrendingVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
//        if isFetchingEpisodes == false {
//            if filterMode == .all && selectedCategory == nil {
//                fetchEpisodes()
//            } else if filterMode == .all && selectedCategory != nil {
//                fetchFilteredEpisodes()
//            }
//        }
    }
   
//    func makeActive(episode: Episode) {
//        episode.hasBeenPlayed = true
//        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID }) else { return }
//        downloadedEpisodes[index] = episode
//    }
   
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
    }
    
    func showSettingsFor(cell: EpisodeCell) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        if cell.episode.username == User.username! || User.username == "Master"  {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
    }
    
    func showSettingsFor(episode: Episode) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID })
                
        if episode.username == User.username! || User.username == "Master"  {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
    }
    
}


extension TrendingVC: NavBarPlayerDelegate {
    
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
                guard let episodeCell = tableView.cellForRow(at: indexPath) as? EpisodeCell else { return }
                playEpisode(cell: episodeCell)
                episodeCell.removePlayIcon()
                dunePlayBar.audioPlayerDelegate = commentVC
            }
        }
    }
    
}

extension TrendingVC: MFMessageComposeViewControllerDelegate {
    
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


