//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class MainFeedVC: UIViewController {
   
    let tableView = UITableView()
    var audioPlayer = DuneAudioPlayer()
    
    var firstBatchAmount = 10
    var episodeIDs = [String]()
    var tappedPrograms = [String]()
    var downloadedEps = [Episode]()
    var audioUrls = [String]()
    var downloadedIndexes = [Int]()
    var episodesToDisplay = true
    var selectedCellRow: Int?
    
    var audioIDs = [String]()
    var downloadedAudioIDs = [String]()

    let loadingView = TVLoadingAnimationView()
    
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
        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }
    
    @objc func appMovedToBackground() {
        tableView.setScrollBarToTopLeft()
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
        loadingView.pinEdges(to: view)
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
    }
    
    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
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
                let tags = data["tags"] as! [String]?
                let programID = data["programID"] as! String
                let ownerID = data["ownerID"] as! String
                                
                let newEp = Episode(
                    id: id,
                    addedAt: time,
                    duration: duration,
                    imageID: imageID,
                    audioID: audioID,
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
                self.audioIDs.append(audioID)
                            
                if self.downloadedEps.count >= self.firstBatchAmount {
                    self.tableView.reloadData()
                    self.loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let documentsURL = FileManager.getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            self.downloadedAudioIDs.append(audioID)
            completion(fileURL)
        } else {
            FireStorageManager.downloadEpisodeAudio(audioID: audioID) { url in
                self.downloadedAudioIDs.append(audioID)
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
//        episodeCell.row = indexPath.row
        // Set up the cell with the downloaded ep data
        let episode = downloadedEps[indexPath.row]
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
   
    func playEpisode(cell: EpisodeCell) {
        guard let audioIndex = tableView.indexPath(for: cell)?.row else { return }
        let image = cell.programImageButton.imageView?.image
        let programName = cell.programNameLabel.text
        let username = cell.usernameLabel.text
        let caption = cell.captionTextView.text
        
        let audioID = audioIDs[audioIndex]
            
        getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPauseEpisode(url: url, image: image!, programName: programName!, username: username!, caption: caption!)
        }
    }
    
    func showSettings(cell: EpisodeCell) {

        selectedCellRow = episodeIDs.firstIndex(of: cell.episodeID!)

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
        tableView.deleteRows(at: [index], with: .fade)
        
        if episodeIDs.count == 0 {
             resetTableView()
             checkUserHasSubscriptions()
        }
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
