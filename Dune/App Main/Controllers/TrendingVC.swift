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
    
    let loadingView = TVLoadingAnimationView(topHeight: 150)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedEpisodes = [Episode]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    
    var audioPlayer = DuneAudioPlayer()
    
    var activeCell: EpisodeCell?
    var selectedCellRow: Int?
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    
    let tableView = UITableView()
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTrendingEpisodes()
        configureNavigation()
        setCurrentDate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.finishSession()
        
        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavBarAttributes
        navigationItem.title = "Trending"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        audioPlayer.audioPlayerDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        tableView.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        tableView.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
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
    
    func configureViews() {
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
        
        tableView.addSubview(currentDateLabel)
        currentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentDateLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        currentDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedEpisodes = []
        initialSnapshot = []
        lastSnapshot = nil
        moreToLoad = true
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
//                    self.audioPlayer.audioIDs.append(episode.audioID)
                    
                    if counter == snapshot.count {
                        self.tableView.reloadData()
                        self.loadingView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func  fetchAnotherBatch() {
        print("Fetching another batch")
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
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
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
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 90.0 {
            if moreToLoad == true {
                fetchAnotherBatch()
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
            navigationController?.present(editEpisodeVC, animated: true, completion: nil)
        default:
            break
        }
    }
}
    

extension TrendingVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
//        let episodeIndex = downloadedEps.firstIndex(where: {$0.ID == episode.ID})
//        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
//
//        downloadedEps[episodeIndex!] = episode
//        tableView.reloadRows(at: [indexPath], with: .fade)
    }
 
}

extension TrendingVC: EpisodeCellDelegate {
    
    func showCommentsFor(episode: Episode) {
        let commentVC = CommentThreadVC(episode: episode)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func pushCommentsFor(episode: Episode) {
        let commentVC = CommentThreadVC(episode: episode)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
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
             
         getAudioWith(audioID: audioID) { url in
             self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
         }
    }
    
    func deleteOwnEpisode() {
        guard let row = selectedCellRow else { return }
        let episode = self.downloadedEpisodes[row]
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp)
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
        print("reached")
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



