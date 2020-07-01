//
//  EpisodeTagLookupVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class EpisodeTagLookupVC: UIViewController {
    
    var pushedForward = false

    let tableView = UITableView()
    var audioPlayer = DuneAudioPlayer()
   
    var pushingComment = false
    var audioIDs = [String]()
    var downloadedEpisodes = [Episode]()
    var episodeItems = [EpisodeItem]()

    var activeCell: EpisodeCell?
    var selectedCellRow: Int?

    let loadingView = TVLoadingAnimationView(topHeight: 150)

    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let reportEpisodeAlert = CustomAlertView(alertType: .reportEpisode)

    let episodeNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    var tag: String!
    
    required init(tag: String) {
        super.init(nibName: nil, bundle: nil)
        self.tag = tag
        FireStoreManager.getEpisodesWith(tag: tag) { episodes in
            self.configureEpisodeLabelWith(count: episodes.count)
            self.loadingView.removeFromSuperview()
            self.downloadedEpisodes = episodes
            self.addEpisodesToAudioPlayer()
            self.tableView.reloadData()
        }
    }
    
    func addEpisodesToAudioPlayer() {
        audioPlayer.downloadedEpisodes = downloadedEpisodes
    }
    
    func configureEpisodeLabelWith(count: Int) {
        var eps = "Episodes"
        
        if count == 1 {
            eps = "Episode"
        }
        
       episodeNumberLabel.text = "\(count) \(eps)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureViews()
        configureDelegates()
        addLoadingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        selectedCellRow = nil
        pushingComment = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        if !pushingComment {
            audioPlayer.finishSession()
        }
        
//        if pushedForward == false {
//            navigationController?.popToRootViewController(animated: true)
//        }

        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }

    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        reportEpisodeAlert.alertDelegate = self
        audioPlayer.audioPlayerDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func resetTableView() {
        downloadedEpisodes = [Episode]()
        tableView.isHidden = false
        tableView.reloadData()
    }

    func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavBarAttributes
        navigationItem.title = tag
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = .black

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

        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white

        tableView.addSubview(episodeNumberLabel)
        episodeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeNumberLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        episodeNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
    }
    
}

extension EpisodeTagLookupVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.playEpisodeButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)

        let episode = downloadedEpisodes[indexPath.row]
        episodeCell.episode = episode
        
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
        //
    }

}

extension EpisodeTagLookupVC: EpisodeCellDelegate {
    
    func episodeTagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        pushedForward = true
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }


    func visitProfile(program: Program) {
            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                let programVC = ProgramProfileVC()
                programVC.program = program
                navigationController?.pushViewController(programVC, animated: true)
            } else {
                let programVC = SingleProgramProfileVC(program: program)
                navigationController?.pushViewController(programVC, animated: true)
            }
    }

   func duration(for resource: String) -> Double {
       let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
       return Double(CMTimeGetSeconds(asset.duration))
   }

    // MARK: Play Episode

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

    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        downloadedEpisodes[indexPath.row] = episode
    }

    func showSettings(cell: EpisodeCell) {
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
        guard let item = episodeItems.first(where: { $0.id == episode.ID }) else { return }
        FireStoreManager.removeEpisodeIDFromProgram(programID: episode.programID, episodeID: episode.ID, time: episode.timeStamp, category: item.category)
        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: episode.ID, rep: -7)
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

extension EpisodeTagLookupVC: SettingsLauncherDelegate {

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
            UIApplication.shared.windows.last?.addSubview(reportEpisodeAlert)
        default:
            break
        }
    }
}

extension EpisodeTagLookupVC: EpisodeEditorDelegate {

    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)

        downloadedEpisodes[episodeIndex!] = episode
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension EpisodeTagLookupVC: DuneAudioPlayerDelegate {
    
    func showCommentsFor(episode: Episode) {
        pushingComment = true
        if audioPlayer.audioPlayer != nil {
            audioPlayer.pauseSession()
        }
        let commentVC = CommentThreadVC(episode: episode)
        commentVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(commentVC, animated: true)
    }
   
    func playedEpisode(episode: Episode) {
        //
    }

    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }

    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
        cell.playEpisodeButton.setImage(nil, for: .normal)
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }

}

extension EpisodeTagLookupVC: CustomAlertDelegate {
    
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

