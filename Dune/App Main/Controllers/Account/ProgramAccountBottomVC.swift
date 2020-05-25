//
//  BottomViewController.swift
//  profileScroll
//
//  Created by Waylan Sands on 21/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ProgramAccountBottomVC: UIViewController {
    
    lazy var activeTV: UITableView = episodeTV
    lazy var vFrame = view.frame
    var headerHeight: CGFloat?
    var yOffset: CGFloat?
    var unwrapDifference: CGFloat = 0
    var scrollContentDelegate: updateProgramAccountScrollDelegate!

    let episodeTV = UITableView()
    let subscriptionTV = ProgramSubscriptionTV()
        
    var batchLimit = 10
    var programIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    var selectedCellRow: Int?
    
    let episodeLoadingView = TVLoadingAnimationView(topHeight: 15)
    let programLoadingView = TVLoadingAnimationView(topHeight: 15)
    var downloadedEpisodes = [Episode]()
    
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    
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
        
        subscriptionTV.isHidden = true
        programIDs = programsIDs()
        fetchEpisodeIDsForUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        subscriptionTV.downloadedPrograms.removeAll()
        audioPlayer.finishSession()
        introPlayer.finishSession()
    }
    
    func configureDelegates() {
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        ownEpisodeSettings.settingsDelegate = self
        episodeTV.dataSource = self
        episodeTV.delegate = self
        audioPlayer.playbackDelegate = self
        introPlayer.playbackDelegate = self
        subscriptionTV.registerCustomCell()
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
    
    func programsIDs() -> [String] {
        if CurrentProgram.hasMultiplePrograms! {
            var ids = CurrentProgram.programIDs!
            ids.append(CurrentProgram.ID!)
            return ids
        } else {
            return [CurrentProgram.ID!]
        }
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
         if User.subscriptionIDs?.count != subscriptionTV.downloadedPrograms.count - programsIDs().count {
         subscriptionTV.fetchProgramsSubscriptions()
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
        
        introPlayer.isProgramPageIntro = true
        if !audioPlayer.isOutOfPosition {
            audioPlayer.finishSession()
        }
        
        introPlayer.getAudioWith(audioID: CurrentProgram.introID!) { url in
            self.introPlayer.playOrPauseWith(url: url, name: CurrentProgram.name!, image: CurrentProgram.image!)
        }
        print("Play intro")
    }
}


// MARK: Settings Launcher
extension ProgramAccountBottomVC: UITableViewDelegate, UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
            cell.moreButton.addTarget(cell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
            cell.programImageButton.addTarget(cell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
            cell.episodeSettingsButton.addTarget(cell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
            cell.likeButton.addTarget(cell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
            
            let episode = downloadedEpisodes[indexPath.row]
            cell.episode = episode
            if episode.likeCount >= 10 {
                cell.configureCellWithOptions()
            }
            cell.cellDelegate = self
            cell.normalSetUp(episode: episode)
            return cell
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
extension ProgramAccountBottomVC: SettingsLauncherDelegate {
    
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
    
    func deleteOwnEpisode() {
        guard let row = self.selectedCellRow else { return }
        print("Downloaded eps before \(downloadedEpisodes.count)")
        let episode = downloadedEpisodes[row]
        FireStorageManager.deletePublishedAudioFromStorage(audioID: episode.audioID)
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp)
        FireStoreManager.deleteEpisodeDocument(ID: episode.ID)
        CurrentProgram.episodeIDs!.removeAll { $0["ID"] as! String == episode.ID }
        
        let index = IndexPath(item: row, section: 0)
        downloadedEpisodes.remove(at: row)
        print("Downloaded eps after \(downloadedEpisodes.count)")
        
        episodeTV.deleteRows(at: [index], with: .fade)
        
        if downloadedEpisodes.count == 0 {
            resetTableView()
        }
        
        audioPlayer.transitionOutOfView()
        
    }
}

// MARK: Episode Editor Delegate
extension ProgramAccountBottomVC: EpisodeEditorDelegate {
    
    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)
        
        downloadedEpisodes[episodeIndex!] = episode
        episodeTV.reloadRows(at: [indexPath], with: .fade)
    }
    
}

// MARK: PlaybackBar Delegate
extension ProgramAccountBottomVC: PlaybackBarDelegate {
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType) {
        switch forType {
        case .episode:
            guard let cell = activeEpisodeCell else { return }
            cell.playbackBarView.progressUpdateWith(percentage: percentage)
        case .program:
            guard let cell = activeProgramCell else { return }
            cell.playbackBarView.progressUpdateWith(percentage: percentage)
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        switch forType {
        case .episode:
            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
            cell.playbackBarView.setupPlaybackBar()
            activeEpisodeCell = cell
        case .program:
            let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
            cell.playbackBarView.setupPlaybackBar()
            activeProgramCell = cell
        }
    }
    
}

// MARK: ProgramCell Delegate
extension ProgramAccountBottomVC: ProgramCellDelegate {
    
    func visitProfile(program: Program) {
        print("This was hit")
        if program.isPrimaryProgram && program.hasMultiplePrograms!  {
            let programVC = TProgramProfileVC()
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
extension ProgramAccountBottomVC :EpisodeCellDelegate {
    
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

