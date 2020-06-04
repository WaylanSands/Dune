//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class MainFeedVC: UIViewController {
    
    let tableView = UITableView()
    var audioPlayer = DuneAudioPlayer()
    
    var batchLimit = 10
    var pushingComment = false
    var subscriptionIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var downloadedEpisodes = [Episode]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    
    var activeCell: EpisodeCell?
    var selectedCellRow: Int?
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let loadingView = TVLoadingAnimationView(topHeight: 150)
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
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
        configureDelegates()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscriptionIDs = User.subscriptionIDs!
        setupModalCommentObserver()
        fetchEpisodeIDsForUser()
        pushingComment = false
        configureNavigation()
        selectedCellRow = nil
        setCurrentDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeModalCommentObserver()
        if !pushingComment {
            audioPlayer.finishSession()
        }
        
        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        tableView.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        tableView.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        audioPlayer.audioPlayerDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupModalCommentObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showCommentFromModal), name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
    }
    
    @objc func showCommentFromModal(_ notification: Notification) {
        let episodeID = notification.userInfo?["ID"] as! String
        guard let episode = downloadedEpisodes.first(where: {$0.ID == episodeID}) else { return }
        showCommentsFor(episode: episode)
    }
    
    func removeModalCommentObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
    }
    
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
    
    func resetTableView() {
        addLoadingView()
        navigationItem.title = "Daily Feed"
        noEpisodesLabel.isHidden = true
        batchLimit = 10
        fetchedEpisodeIDs = [String]()
        downloadedEpisodes = [Episode]()
        subscriptionIDs = [String]()
        episodeIDs = [String]()
        batch = [Episode]()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavBarAttributes
        navigationItem.title = "Daily Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
    
    
    func fetchEpisodeIDsForUser() {
        FireStoreManager.fetchEpisodesIDsWith(with: subscriptionIDs) { ids in
            
            if ids.isEmpty {
                print("No episodes to display")
                self.tableView.isHidden = true
                self.noEpisodesLabel.isHidden = false
                self.loadingView.removeFromSuperview()
                self.navigationItem.title = ""
            } else {
                if ids != self.episodeIDs {
                    self.resetTableView()
                    self.episodeIDs = ids
                    self.loadFirstBatch()
                }
            }
        }
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
        let startIndex = episodeIDs.firstIndex(where: { $0 == lastEp })
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
                
                if self.batch.count == self.episodesToFetch.count {
                    
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
                    self.loadingView.removeFromSuperview()
                    self.episodesToFetch.removeAll()
                    self.tableView.reloadData()
                    self.batch.removeAll()
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

extension MainFeedVC: UITableViewDataSource, UITableViewDelegate {
    
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
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
        episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
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
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs.count != episodeIDs.count {
            loadNextBatch()
        }
    }
    
}

extension MainFeedVC: EpisodeCellDelegate {
    
    func tagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
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
        
        audioPlayer.yPosition = view.frame.height - self.tabBarController!.tabBar.frame.height
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
        }
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        downloadedEpisodes[indexPath.row] = episode
    }
    
    func showSettings(cell: EpisodeCell) {
        print("reached")
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
        
        if cell.episode.username == User.username! {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
        
    }
    
    func deleteOwnEpisode() {
        guard let row = selectedCellRow else { return }
        let episode = self.downloadedEpisodes[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        
        if episode.programID == CurrentProgram.ID {
            CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
        }
        
        let index = IndexPath(item: row, section: 0)
        episodeIDs.removeAll(where: { $0 == episode.ID })
        fetchedEpisodeIDs.removeAll(where: { $0 == episode.ID })
        downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        audioPlayer.downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        tableView.deleteRows(at: [index], with: .fade)
        
        if episodeIDs.count == 0 {
            resetTableView()
            fetchEpisodeIDsForUser()
        }
        
        audioPlayer.transitionOutOfView()
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
        switch setting {
        case "Delete":
            deleteOwnEpisode()
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

extension MainFeedVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

extension MainFeedVC: DuneAudioPlayerDelegate {
    
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
        guard let cell = activeCell else { return }
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
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let indexPath = IndexPath(item: atIndex, section: 0)
        if tableView.indexPathsForVisibleRows!.contains(indexPath) {
            let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
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
