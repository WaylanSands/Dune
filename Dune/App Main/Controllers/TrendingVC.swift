//
//  PlaylistVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class TrendingVC: UIViewController {
    
    let loadingView = TVLoadingAnimationView(topHeight: 20)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedEpisodes = [Episode]()
    var lastSnapshot: DocumentSnapshot?
    var pushingContent = false
    var moreToLoad = true
    
    var audioPlayer = DunePlayBar()
    
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
//        fetchTrendingEpisodes()
//        audioPlayer.continueState()
        fetchEpisodes() 
        pushingContent = false
        configureNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableView.setScrollBarToTopLeft()
        if !pushingContent {
            audioPlayer.finishSession()
        }
        
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

        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        audioPlayer.audioPlayerDelegate = self
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
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.tableFooterView = UIView()
        tableView.addTopBounceAreaView()

        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 600)
        
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
        view.bringSubviewToFront(audioPlayer)
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedEpisodes = []
        initialSnapshot = []
        lastSnapshot = nil
        moreToLoad = true
    }
    
    func fetchEpisodes() {
        FireStoreManager.fetchTrendingEpisodes() { episodes in
            self.downloadedEpisodes = episodes.sortedByLikes()
            self.audioPlayer.downloadedEpisodes = episodes.sortedByLikes()
            self.audioPlayer.itemCount = episodes.count
            self.tableView.reloadData()
            self.loadingView.removeFromSuperview()
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
                    self.audioPlayer.downloadedEpisodes.append(episode)

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
                    self.audioPlayer.downloadedEpisodes.append(episode)

                    if counter == snapshots.count {
                        self.tableView.reloadData()
                    }
                }
            }
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
//        episodeCell.playEpisodeButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
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
        
        if let playerEpisode = audioPlayer.episode  {
            if episode.ID == playerEpisode.ID {
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
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        case "Edit":
            let episode = downloadedEpisodes[selectedCellRow!]
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
            editEpisodeVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editEpisodeVC, animated: true)
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
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
        pushingContent = true
        let webView = WebVC(url: url)
        webView.delegate = self
        
        switch audioPlayer.currentState {
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
        
        audioPlayer.audioPlayerDelegate = webView
        navigationController?.present(webView, animated: true, completion: nil)
    }
    
    func showCommentsFor(episode: Episode) {
        pushingContent = true
        if audioPlayer.audioPlayer != nil {
            audioPlayer.pauseSession()
        } else if audioPlayer.currentState == .loading {
            audioPlayer.cancelCurrentDownload()
            audioPlayer.finishSession()
        }
        
        let commentVC = CommentThreadVC(episode: episode)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func episodeTagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func visitProfile(program: Program) {
        if CurrentProgram.programsIDs().contains(program.ID) {
             let tabBar = MainTabController()
             tabBar.selectedIndex = 4
             if #available(iOS 13.0, *) {
                 let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
                  sceneDelegate.window?.rootViewController = tabBar
             } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  appDelegate.window?.rootViewController = tabBar
             }
         } else {
             if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                 let programVC = ProgramProfileVC()
                 programVC.program = program
                 navigationController?.pushViewController(programVC, animated: true)
             } else {
                 let programVC = SingleProgramProfileVC(program: program)
                 navigationController?.pushViewController(programVC, animated: true)
             }
         }
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
    func playEpisode(cell: EpisodeCell) {
         activeCell = cell
         
         if !cell.playbackBarView.playbackBarIsSetup {
             cell.playbackBarView.setupPlaybackBar()
         }
         
         audioPlayer.yPosition = view.frame.height - self.tabBarController!.tabBar.frame.height
         
         let image = cell.programImageButton.imageView?.image
         let audioID = cell.episode.audioID
         
         self.audioPlayer.setEpisodeDetailsWith(episode: cell.episode, image: image!)
         self.audioPlayer.animateToPositionIfNeeded()
         self.audioPlayer.playOrPauseEpisodeWith(audioID: audioID)
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
        audioPlayer.downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        tableView.deleteRows(at: [index], with: .fade)

        if downloadedEpisodes.count == 0 {
             resetTableView()
        }
        audioPlayer.transitionOutOfView()
    }
    
    func showSettings(cell: EpisodeCell) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        
        if cell.episode.username == User.username! {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
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

extension TrendingVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
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
            let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
//            cell.playEpisodeButton.setImage(nil, for: .normal)
            cell.playbackBarView.setupPlaybackBar()
            activeCell = cell
        }
    }
    
    func updatePastEpisodeProgress() {
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
        let episode = downloadedEpisodes[index]
        episode.playBackProgress = lastProgress
        downloadedEpisodes[index] = episode
    }
    
}


extension TrendingVC: WebViewDelegate {
    
    func playOrPauseEpisode() {
        if let cell = activeCell {
            audioPlayer.playOrPauseEpisodeWith(audioID: cell.episode.audioID)
        }
    }
    
}


