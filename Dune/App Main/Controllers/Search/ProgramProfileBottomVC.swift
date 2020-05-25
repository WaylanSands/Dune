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
    var scrollContentDelegate: updateProgramAccountScrollDelegate!
    
    let episodeTV = UITableView()
    let program: Program!
    
    var batchLimit = 10
    var programIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    var selectedCellRow: Int?
    
    let episodeLoadingView = TVLoadingAnimationView(topHeight: 15)
    var downloadedEpisodes = [Episode]()
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    
    let introPlayer = DuneIntroPlayer()
    
    let audioPlayer = DuneAudioPlayer()
    var activeCell: EpisodeCell?
    
    required init(program: Program) {
        self.program = program
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
        addEpisodeLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        episodeTV.setScrollBarToTopLeft()
        programIDs = programsIDs()
        fetchEpisodeIDsForUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.finishSession()
    }
    
    func configureDelegates() {
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        episodeTV.register(EpisodeCellRegLink.self, forCellReuseIdentifier: "episodeCellRegLink")
        episodeTV.register(EpisodeCellSmlLink.self, forCellReuseIdentifier: "EpisodeCellSmlLink")
        subscriptionSettings.settingsDelegate = self
        episodeTV.dataSource = self
        episodeTV.delegate = self
        audioPlayer.playbackDelegate = self
    }
    
    func configureViews() {
        view.addSubview(episodeTV)
        episodeTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 70)
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 70)
    }
    
    func programsIDs() -> [String] {
        if program.hasMultiplePrograms! {
            var ids = program.programIDs!
            ids.append(program.ID)
            return ids
        } else {
            return [program.ID]
        }
    }
    
    func resetTableView() {
        navigationItem.title = "Daily Feed"
        downloadedEpisodes = [Episode]()
        fetchedEpisodeIDs = [String]()
        episodeTV.isHidden = false
        addEpisodeLoadingView()
        episodeIDs = [String]()
        batch = [Episode]()
        batchLimit = 10
        episodeTV.reloadData()
    }
    
    func addEpisodeLoadingView() {
        view.addSubview(episodeLoadingView)
        episodeLoadingView.translatesAutoresizingMaskIntoConstraints = false
        episodeLoadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        episodeLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        episodeLoadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(audioPlayer)
        view.bringSubviewToFront(introPlayer)
    }
    
    // MARK: Fetch Episode IDs
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
                        self.audioPlayer.audioIDs.append(each.audioID)
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
    
    // MARK: Play Program's Intro
    @objc func playIntro() {
        introPlayer.isProgramPageIntro = true
        if !audioPlayer.isOutOfPosition {
            audioPlayer.finishSession()
        }
        
        introPlayer.getAudioWith(audioID: program.introID!) { url in
            self.introPlayer.playOrPauseWith(url: url, name: self.program.name, image: self.program.image!)
        }
        print("Play intro")
    }
}


// MARK: Settings Launcher
extension ProgramProfileBottomVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
        episodeCell.episode = episode
        
        if episode.likeCount >= 10 {
            episodeCell.configureCellWithOptions()
        }
        episodeCell.cellDelegate = self
        episodeCell.normalSetUp(episode: episode)
        return episodeCell
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
        
        if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs != episodeIDs {
            print("loading more episodes")
            loadNextBatch()
        }
    }
}

// MARK: Settings Launcher Delegate
extension ProgramProfileBottomVC: SettingsLauncherDelegate {
    func selectionOf(setting: String) {
        switch setting {
        case "Delete":
            break
        default:
            break
        }
    }
}

// MARK: Episode Editor Delegate
extension ProgramProfileBottomVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        episodeTV.reloadRows(at: [indexPath], with: .fade)
    }
}

// MARK: PlaybackBar Delegate
extension ProgramProfileBottomVC: PlaybackBarDelegate {
   
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }
}

// MARK: EpisodeCell Delegate
extension ProgramProfileBottomVC :EpisodeCellDelegate {
    
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
        
        activeCell = cell
        
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
        subscriptionSettings.showSettings()
    }
    
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
}

extension ProgramProfileBottomVC: ProgramCellDelegate {
    
    func visitProfile(program: Program) {
        //
    }
    
    func showSettings(cell: ProgramCell) {
        //
    }
    
    func playProgramIntro(cell: ProgramCell) {
        //
    }
    
}


