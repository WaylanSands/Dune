//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVFoundation
import FirebaseFirestore


class MainFeedVC: UIViewController {
   
    let tableView = UITableView()
    var audioPlayer = DuneAudioPlayer()
    var audioPlayerInPosition = false
    
    var firstBatchAmount = 10
    var episodeIDs = [String]()
    var tappedPrograms = [String]()
    var downloadedEps = [Episode]()
    var audioUrls = [String]()
    var downloadedIndexes = [Int]()
    var episodesToDisplay = true
    var activeCell: EpisodeCell?
    var selectedCellRow: Int?
    
    var audioIDs = [String]()
    var downloadedAudioIDs = [String]()

    let loadingView = TVLoadingAnimationView(topHeight: 150)
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "23 Feb"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let noEpisodesLabel: UILabel = {
        let label = UILabel()
        label.text = "Currently no episodes to display"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureViews()
        configureDelegates()
        addLoadingView()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedForward), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationItem.title = "Daily Feed"
       selectedCellRow = nil
        
        if User.ID == nil {
            getUserData()
        } else {
            checkUserHasSubscriptions()
        }
        
        if episodesToDisplay == false {
            addLoadingView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.finishSession()

        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    @objc func appMovedToBackground() {
        tableView.setScrollBarToTopLeft()
        audioPlayer.finishSession()
    }
    
    @objc func appMovedForward() {
        tableView.setScrollBarToTopLeft()
        getUserData()
    }
    
    func resetTableView() {
        addLoadingView()
        navigationItem.title = "Daily Feed"
        noEpisodesLabel.isHidden = true
        downloadedEps = [Episode]()
        downloadedIndexes = [Int]()
        episodeIDs = [String]()
        tableView.isHidden = false
        tableView.reloadData()
        firstBatchAmount = 10
    }
    
    func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavbarAttributes
        navigationItem.title = "Daily Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func getUserData() {
        print("getting user data")
        FireStoreManager.getUserData() {
            self.resetTableView()
            self.checkUserHasSubscriptions()
        }
    }
    
    func newEpisodesHaveBeenAdded(episodeIDs : [String]) -> Bool {
        if episodeIDs != self.episodeIDs {
            // Reset tableView
            print("New episodes added")
            resetTableView()
            return true
        } else {
            return false
        }
    }
    
    func checkUserHasSubscriptions() {
        print("checking user subscriptions")
        FireStoreManager.getEpisodesFromPrograms { (ids) in
            
            if ids != nil {
                if self.newEpisodesHaveBeenAdded(episodeIDs: ids!) {
                    self.episodeIDs = ids!
                    self.checkToLoadFirstBatch()
                    self.episodesToDisplay = true
                }
            } else {
                print("No episodes to display")
                self.episodesToDisplay = false
                self.tableView.isHidden = true
                self.noEpisodesLabel.isHidden = false
                self.loadingView.removeFromSuperview()
                self.navigationItem.title = ""
            }
        }
    }
    
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(noEpisodesLabel)
        noEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false
        noEpisodesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noEpisodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        noEpisodesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white
        
        tableView.addSubview(currentDateLabel)
        currentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentDateLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        currentDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
    }
    
    func transitionAudioPlayerIn() {
        if audioPlayerInPosition == false {
            print("The tab bar height is : \(tabBarController!.tabBar.frame.height)")
            let navBarHeight = view.frame.height - tabBarController!.tabBar.frame.height - 70
            
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                self.audioPlayer.frame = CGRect(x: 0, y: navBarHeight, width: self.view.frame.width, height: 70)
            }) { success in
                if success {
                    self.audioPlayerInPosition = true
                }
            }
        }
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        audioPlayer.playbackDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func checkToLoadFirstBatch() {
        if episodeIDs.count >= firstBatchAmount {
            for each in 0..<firstBatchAmount {
                downloadEpisode(forItemAtIndex: each)
            }
        } else {
            for each in 0..<episodeIDs.count {
                downloadEpisode(forItemAtIndex: each)
                firstBatchAmount = episodeIDs.count
            }
        }
    }
    
    func  getAnotherBatchOrLastWith(row: Int) {
        if episodeIDs.count - downloadedEps.count >= 5  {
            for each in stride(from: row, to: row + 5, by: 1) {
                downloadEpisode(forItemAtIndex: each)
            }
        } else {
            for each in row..<episodeIDs.count {
                downloadEpisode(forItemAtIndex: each)
            }
        }
    }
    
    func downloadEpisode(forItemAtIndex index: Int) {
       
        let epID = self.episodeIDs[index]

        let alreadyDownloaded = self.downloadedEps.contains(where: { $0.ID == epID })
        let startedDownloading = self.downloadedIndexes.contains(where: { $0 == index })
        
        if !alreadyDownloaded && !startedDownloading {
            downloadedIndexes.append(index)
            FireStoreManager.getEpisodeDataWith(ID: epID) { (data) in
                
                let id = data["ID"] as! String
                
                let postedDate = data["postedAt"] as! Timestamp
                let date = postedDate.dateValue()
                let time = date.timeAgoDisplay()
                
                let duration = data["duration"] as! String
                let imageID = data["imageID"] as! String
                let imagePath = data["imagePath"] as! String
                let audioID = data["audioID"] as! String
                let audioPath = data["audioPath"] as! String
                let programName = data["programName"] as! String
                let username = data["username"] as! String
                let caption = data["caption"] as! String
                let likeCount = data["likeCount"] as! Int
                let commentCount = data["commentCount"] as! Int
                let shareCount = data["shareCount"] as! Int
                let listenCount = data["listenCount"] as! Int
                let tags = data["tags"] as! [String]?
                let programID = data["programID"] as! String
                let ownerID = data["ownerID"] as! String
                
                let newEp = Episode(
                    id: id,
                    addedAt: time,
                    duration: duration,
                    imageID: imageID,
                    audioID: audioID,
                    likeCount: likeCount,
                    commentCount: commentCount,
                    shareCount: shareCount,
                    listenCount: listenCount,
                    audioPath: audioPath,
                    imagePath: imagePath,
                    programName: programName,
                    username: username,
                    caption: caption,
                    tags: tags,
                    programID: programID,
                    ownerID: ownerID
                )
                
                self.downloadedEps.append(newEp)
                self.audioPlayer.audioIDs.append(audioID)
                self.audioPlayer.downloadedEps.append(newEp)
                            
                if self.downloadedEps.count >= self.firstBatchAmount {
                    self.tableView.reloadData()
                    self.loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let tempURL = FileManager.getTempDirectory()
        let fileURL = tempURL.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
//            self.downloadedAudioIDs.append(audioID)
            completion(fileURL)
        } else {
            FireStorageManager.downloadEpisodeAudio(audioID: audioID) { url in
//                self.downloadedAudioIDs.append(audioID)
                completion(url)
            }
        }
    }

}

extension MainFeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
//        episodeCell.configureCellWithOptions()
//        episodeCell.row = indexPath.row
        // Set up the cell with the downloaded ep data
        let episode = downloadedEps[indexPath.row]
        episodeCell.episode = episode
        if episode.likeCount >= 10 {
            episodeCell.configureCellWithOptions()
        }
        episodeCell.cellDelegate = self
        episodeCell.normalSetUp(episode: episode)
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
            getAnotherBatchOrLastWith(row: downloadedEps.count)
        }
    }
    
}

extension MainFeedVC: EpisodeCellDelegate {
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
    
   func duration(for resource: String) -> Double {
       let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
       return Double(CMTimeGetSeconds(asset.duration))
   }
   
    func playEpisode(cell: EpisodeCell) {
        activeCell = cell
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
//      audioPlayer.playbackDelegate = cell
        audioPlayer.navHeight = self.tabBarController?.tabBar.frame.height
        
//        if cell.episode.likeCount >= 10 {
//            audioPlayer.animateAudioPlayerWithoutOptions()
//        } else {
//            audioPlayer.animateAudioPlayerWithOptions()
//        }
       
        guard let audioIndex = tableView.indexPath(for: cell)?.row else { return }
        let image = cell.programImageButton.imageView?.image
        let audioID = audioPlayer.audioIDs[audioIndex]
            
        getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
        }
        
        func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
            downloadedEps[indexPath.row] = episode
        }
    }
    
    func showSettings(cell: EpisodeCell) {

        selectedCellRow = episodeIDs.firstIndex(of: cell.episode.ID)

        if cell.usernameLabel.text == "@\(User.username!)" {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
        
    }
    
    func deleteOwnEpisode() {
        guard let row = selectedCellRow else { return }
        
        //Delete own episode
        let episode = self.downloadedEps[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        FireStoreManager.removeEpisodeIDFromProgram(episodeID: episode.ID)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        User.subscriptionIDs!.removeAll { $0 == episode.ID }
        
        let index = IndexPath(item: row, section: 0)
        episodeIDs.remove(at: row)
        downloadedEps.remove(at: row)
        audioPlayer.audioIDs.remove(at: row)
        audioPlayer.downloadedEps.remove(at: row)
        tableView.deleteRows(at: [index], with: .fade)
        
        if episodeIDs.count == 0 {
             resetTableView()
             checkUserHasSubscriptions()
        }
        
        audioPlayer.transitionOutOfView()
        
    }

    
    
    
    func addTappedProgram(programName: String) {
        tappedPrograms.append(programName)
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
        switch setting {
        case "Delete":
            deleteOwnEpisode()
        default:
            break
        }
    }
}

extension MainFeedVC: PlaybackBarDelegate {
   
    func updateProgressBarWith(percentage: CGFloat) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int) {
        let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }
    
    
}
