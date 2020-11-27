//
//  EpisodeTagLookupVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import AVFoundation

class EpisodeTagLookupVC: UIViewController {
    
    let tableView = UITableView()
    var audioIDs = [String]()
    var downloadedEpisodes = [Episode]()
    var episodeItems = [EpisodeItem]()
    
    var commentVC: CommentThreadVC!

    var activeCell: EpisodeCell?
    var selectedCellRow: Int?

    let loadingView = TVLoadingAnimationView(topHeight: 20)

    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let ownEpisodeSettings = SettingsLauncher(options: SettingOptions.ownEpisode, type: .ownEpisode)
    let reportEpisodeAlert = CustomAlertView(alertType: .reportEpisode)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nav.backgroundColor = CustomStyle.blackNavBar
        return nav
    }()

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
        if dunePlayBar.activeController == .tagLookup && dunePlayBar.activeProfile == tag {
            dunePlayBar.downloadedEpisodes = downloadedEpisodes
            dunePlayBar.itemCount = downloadedEpisodes.count
        }
    }
    
    func configureEpisodeLabelWith(count: Int) {
        var eps = "Episodes"
        if count == 1 {
            eps = "Episode"
        }
         customNavBar.rightButton.setTitle("\(count) \(eps)", for: .normal)
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }

    func configureDelegates() {
        subscriptionSettings.settingsDelegate = self
        ownEpisodeSettings.settingsDelegate = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        reportEpisodeAlert.alertDelegate = self
//        audioPlayer.audioPlayerDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func resetTableView() {
        downloadedEpisodes = [Episode]()
        tableView.isHidden = false
        tableView.reloadData()
    }

    func configureNavigation() {
        navigationItem.title = tag
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: UIDevice.current.navBarHeight()).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.bringSubviewToFront(customNavBar)
    }

    func configureViews() {
        view.backgroundColor = .white

        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableView.safeDunePlayBarHeight, right: 0)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white

        tableView.addSubview(episodeNumberLabel)
        episodeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeNumberLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        episodeNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
}

extension EpisodeTagLookupVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.usernameButton.addTarget(episodeCell, action: #selector(EpisodeCell.visitProfile), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        episodeCell.commentButton.addTarget(episodeCell, action: #selector(EpisodeCell.showComments), for: .touchUpInside)
        episodeCell.shareButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)

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
                
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        dunePlayBar.activeProfile = tag
        dunePlayBar.audioPlayerDelegate = self
        dunePlayBar.activeController = .tagLookup
        dunePlayBar.activeViewController = self
        
        dunePlayBar.downloadedEpisodes = downloadedEpisodes
        dunePlayBar.itemCount = downloadedEpisodes.count


        dunePlayBar.setEpisodeDetailsWith(episode: cell.episode, image: image)
        dunePlayBar.animateToPositionIfNeeded()
        dunePlayBar.playOrPauseEpisodeWith(audioID: audioID)
        
    }

    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        downloadedEpisodes[indexPath.row] = episode
    }

    func showSettingsFor(cell: EpisodeCell) {
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
        dunePlayBar.downloadedEpisodes.removeAll(where: { $0.ID == episode.ID })
        tableView.deleteRows(at: [index], with: .fade)

        if downloadedEpisodes.count == 0 {
             resetTableView()
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
        dunePlayBar.isHidden = true
        commentVC.delegate = self
        navigationController?.pushViewController(commentVC, animated: true)
    }
}

extension EpisodeTagLookupVC: SettingsLauncherDelegate {

    func selectionOf(setting: String) {
        var episode: Episode
        
        if dunePlayBar.activeController != .tagLookup {
             episode = downloadedEpisodes[selectedCellRow!]
        } else {
            episode = dunePlayBar.episode
        }

        switch setting {
        case "Delete":
            deleteOwnEpisode()
        case "Edit":
            let episode = downloadedEpisodes[selectedCellRow!]
            let editEpisodeVC = EditPublishedEpisode(episode: episode)
            editEpisodeVC.delegate = self
            //            editEpisodeVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(editEpisodeVC, animated: true)
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportEpisodeAlert)
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

extension EpisodeTagLookupVC: EpisodeEditorDelegate {

    func updateCell(episode: Episode) {
        let episodeIndex = downloadedEpisodes.firstIndex(where: {$0.ID == episode.ID})
        let indexPath = IndexPath(item: selectedCellRow!, section: 0)

        downloadedEpisodes[episodeIndex!] = episode
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension EpisodeTagLookupVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }

    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
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
    
    func showSettingsFor(episode: Episode) {
        selectedCellRow =  downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID })
                
        if episode.username == User.username! || User.username == "Dune"  {
            ownEpisodeSettings.showSettings()
        } else {
            subscriptionSettings.showSettings()
        }
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

extension EpisodeTagLookupVC: NavBarPlayerDelegate {
    
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

extension EpisodeTagLookupVC: MFMessageComposeViewControllerDelegate {
    
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

