//
//  ListenerAccountBottomVC.swift
//  Dune
//
//  Created by Waylan Sands on 29/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ListenerAccountBottomVC: UIViewController {
    
    lazy var activeTV: UITableView = subscriptionTV
    lazy var vFrame = view.frame
    var headerHeight: CGFloat?
    var yOffset: CGFloat?
    var unwrapDifference: CGFloat = 0
    var scrollContentDelegate: updateProgramAccountScrollDelegate!
    
    var programsOwnIDs = [String]()
    
    //Settings
    var selectedEpisodeCellRow: Int?
    var selectedProgramCellRow: Int?
    var selectedEpisodeSetting = false
    var selectedProgramSetting = false
    
    //Subscriptions
    let subscriptionTV = UITableView()
    var currentSubscriptions = [String]()
    var downloadedPrograms = [Program]()
    var fetchedProgramsIDs = [String]()
    var isFetchingPrograms = false
    var subsStartingIndex: Int = 0
    
    //Mentions
    let mentionTV = UITableView()
    var downloadedMentions = [Mention]()
    
    var lastProgress: CGFloat = 0
    var lastPlayedID: String?
    var listenCountUpdated = false
    
    let loadingView = TVLoadingAnimationView(topHeight: 15)
    var pageIndex:Int = 3
    
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
        
    var emptyTableViewTopConstant: CGFloat = 50
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?
    
    let emptyTableView: UIView = {
        let view = UIView()
        return view
    }()
    
    let emptyHeadingLabel: UILabel = {
       let label = UILabel()
        label.text = "Published episodes"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var emptySubLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "Episodes published by @\(CurrentProgram.username!) will appear here."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.subTextColor
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    let emptyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 17
        button.setTitle("Visit Search", for: .normal)
        button.backgroundColor = CustomStyle.onBoardingBlack
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 1, right: 25)
        button.addTarget(self, action: #selector(continueToView), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        programsOwnIDs = CurrentProgram.programsIDs()
        subscriptionTV.setScrollBarToTopLeft()
        mentionTV.setScrollBarToTopLeft()
        emptyTableView.isHidden = true
        updateTableViewWith(title: "Subscriptions")
        mentionTV.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeModalCommentObserver()
        introPlayer.finishSession()
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            emptyTableViewTopConstant = 40
        case .iPhone8:
             emptyTableViewTopConstant = 80
        case .iPhone8Plus:
            emptyTableViewTopConstant = 100
        case .iPhone11:
            emptyTableViewTopConstant = 140
        case .iPhone11Pro:
              emptyTableViewTopConstant = 100
        case .iPhone11ProMax:
             emptyTableViewTopConstant = 80
        case .unknown:
            break
        }
    }
    
    func configureDelegates() {
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        introPlayer.playbackDelegate = self
        subscriptionTV.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        mentionTV.register(MentionCell.self, forCellReuseIdentifier: "mentionCell")
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        subscriptionTV.backgroundColor = .clear
        mentionTV.backgroundColor = .clear
        mentionTV.dataSource = self
        mentionTV.delegate = self
    }
    
    func resetSubscriptionTV() {
        downloadedPrograms = [Program]()
        fetchedProgramsIDs = [String]()
        isFetchingPrograms = false
        subsStartingIndex = 0
    }
    
    func removeModalCommentObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil)
    }
    
    func configureViews() {
        self.view.backgroundColor = CustomStyle.secondShade
      
        view.addSubview(subscriptionTV)
        subscriptionTV.frame = CGRect(x:0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(mentionTV)
        mentionTV.frame = CGRect(x: 0, y: 0, width: vFrame.width, height: vFrame.height)
        
        view.addSubview(emptyTableView)
        emptyTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: emptyTableViewTopConstant).isActive = true
        emptyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emptyTableView.addSubview(emptyHeadingLabel)
        emptyHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyHeadingLabel.topAnchor.constraint(equalTo: emptyTableView.topAnchor).isActive = true
        emptyHeadingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyHeadingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyHeadingLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emptyTableView.addSubview(emptySubLabel)
        emptySubLabel.translatesAutoresizingMaskIntoConstraints = false
        emptySubLabel.topAnchor.constraint(equalTo: emptyHeadingLabel.bottomAnchor).isActive = true
        emptySubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        emptySubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        emptyTableView.addSubview(emptyButton)
        emptyButton.translatesAutoresizingMaskIntoConstraints = false
        emptyButton.topAnchor.constraint(equalTo: emptySubLabel.bottomAnchor, constant: 20).isActive = true
        emptyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: subscriptionTV.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: subscriptionTV.bottomAnchor).isActive = true
        
        navigationController?.visibleViewController?.view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: vFrame.height, width: vFrame.width, height: 64)
        introPlayer.offset = 64
    }
    
    func configureEmptyTableViewFor(tableView: UITableView) {
        switch tableView {
        case subscriptionTV:
            resetSubscriptionTV()
            subscriptionTV.reloadData()
            emptyHeadingLabel.text = "Subscribe to programs"
            emptySubLabel.text = "You will be able to manage your subscriptions here."
            emptyButton.setTitle("Visit Search", for: .normal)
            emptyButton.isHidden = false
            pageIndex = 3
        case mentionTV:
            emptyHeadingLabel.text = "View mentions"
            emptySubLabel.text = "Episodes and comments which you have been tagged in will appear here."
            emptyButton.isHidden = true
        default:
            break
        }
        loadingView.isHidden = true
        emptyTableView.isHidden = false
    }
       
    func fetchProgramsSubscriptions() {
        var subscriptionIDs = CurrentProgram.subscriptionIDs!
        subscriptionIDs.removeAll(where: { programsOwnIDs.contains($0) })
        
        // here
        if subscriptionIDs.count == 0 {
            self.emptyTableView.isHidden = false
        }
        
        if currentSubscriptions != subscriptionIDs {
            resetSubscriptionTV()
        }
        
        currentSubscriptions = subscriptionIDs
        
        if downloadedPrograms.count != subscriptionIDs.count {
            var subsEndIndex = 20
            
            if subscriptionIDs.count - fetchedProgramsIDs.count < subsEndIndex {
                subsEndIndex = subscriptionIDs.count - fetchedProgramsIDs.count
            }
            
            subsEndIndex += subsStartingIndex
            
            let programIDs = Array(subscriptionIDs[subsStartingIndex..<subsEndIndex])
            fetchedProgramsIDs += programIDs
            subsStartingIndex = fetchedProgramsIDs.count
            
            self.isFetchingPrograms = true
            FireStoreManager.fetchProgramsWith(IDs: programIDs) { programs in
                if programs != nil {
                    DispatchQueue.main.async {
                        self.downloadedPrograms = programs!
                        self.subscriptionTV.reloadData()
                        self.loadingView.isHidden = true
                        self.isFetchingPrograms = false
                    }
                }
            }
        }
    }
    
    func fetchProgramsMentions() {
        FireStoreManager.fetchMentionsFor(programID: CurrentProgram.ID!) { mentions in
            DispatchQueue.main.async {
                if mentions != nil {
                    self.downloadedMentions = mentions!
                    self.loadingView.isHidden = true
                    self.mentionTV.reloadData()
                }
            }
        }
    }
    
    func updateTableViewWith(title: String) {
        emptyTableView.isHidden = true
        switch title {
        case "Subscriptions":
            activeTV = subscriptionTV
            mentionTV.isHidden = true
            subscriptionTV.isHidden = false
            mentionTV.setScrollBarToTopLeft()
            if CurrentProgram.subscriptionIDs!.count - programsOwnIDs.count == 0 {
                configureEmptyTableViewFor(tableView: subscriptionTV)
                loadingView.isHidden = true
            } else if downloadedPrograms.count != CurrentProgram.subscriptionIDs!.count - programsOwnIDs.count {
                loadingView.isHidden = false
                fetchProgramsSubscriptions()
            }
        case "Mentions":
            activeTV = mentionTV
            mentionTV.isHidden = false
            subscriptionTV.isHidden = true
            subscriptionTV.setScrollBarToTopLeft()
            if !CurrentProgram.hasMentions! {
                configureEmptyTableViewFor(tableView: mentionTV)
            } else if downloadedMentions.isEmpty {
                loadingView.isHidden = false
                fetchProgramsMentions()
            }
        default:
            break
        }
    }
    
    func activeTableView() -> UIView {
        return activeTV
    }
    
    @objc func continueToView() {
        let tabBar = MainTabController()
        tabBar.selectedIndex = pageIndex
        DuneDelegate.newRootView(tabBar)
    }
}

extension ListenerAccountBottomVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case subscriptionTV:
            return downloadedPrograms.count
        case mentionTV:
            return downloadedMentions.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch tableView {
        case subscriptionTV:
            let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
            programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
            programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
            programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
            programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
            programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
            
            let program = downloadedPrograms[indexPath.row]
            programCell.program = program
            
            programCell.cellDelegate = self
            programCell.normalSetUp(program: program)
            return programCell
        case mentionTV:
            let mentionCell = tableView.dequeueReusableCell(withIdentifier: "mentionCell") as! MentionCell
            mentionCell.actionButton.addTarget(mentionCell, action: #selector(MentionCell.actionButtonPress), for: .touchUpInside)
            mentionCell.profileImageButton.addTarget(mentionCell, action: #selector(MentionCell.visitProfile), for: .touchUpInside)
            mentionCell.usernameButton.addTarget(mentionCell, action: #selector(MentionCell.visitProfile), for: .touchUpInside)
            let mention = downloadedMentions[indexPath.row]
            mentionCell.cellDelegate = self
            mentionCell.cellSetup(mention: mention)
            return mentionCell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return 116
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 116)
        return view
    }
    
}

// MARK: Settings Launcher Delegate
extension ListenerAccountBottomVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
        default:
            break
        }
    }
}

// MARK: ProgramCell Delegate
extension ListenerAccountBottomVC: ProgramCellDelegate, MentionCellDelegate {
   
    func updateRows() {
        //
    }
    
    func showCommentsFor(episode: Episode) {
        //
    }
  
    func programTagSelected(tag: String) {
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
   
    func noIntroAlert() {
        //         view.addSubview(noIntroRecordedAlert)
    }
    
    func unsubscribeFrom(program: Program) {
        guard let index =  downloadedPrograms.firstIndex(where: {$0.ID == program.ID}) else { return }
        downloadedPrograms.remove(at: index)
        subscriptionTV.reloadData()
        
        if downloadedPrograms.count == 0 {
            configureEmptyTableViewFor(tableView: subscriptionTV)
        }
    }
    
    func visitProfile(program: Program) {
        if program.ID == CurrentProgram.ID {
            return
        }
        if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
            let programVC = ProgramProfileVC()
            programVC.program = program
            navigationController?.pushViewController(programVC, animated: true)
        } else {
            let programVC = SingleProgramProfileVC(program: program)
            navigationController?.pushViewController(programVC, animated: true)
        }
    }
    
    //MARK: Play program's cell
    
    func playProgramIntro(cell: ProgramCell) {
        activeProgramCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
        introPlayer.yPosition = UIScreen.main.bounds.height - self.tabBarController!.tabBar.frame.height
        
        let image = cell.programImageButton.imageView!.image!
        let audioID = cell.program.introID
        
        self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
        self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
        
        let program = cell.program!
        program.hasBeenPlayed = true
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == program.ID }) else { return }
        downloadedPrograms[index] = program
    }
    
    func showSettings(cell: ProgramCell) {
        programSettings.showSettings()
        selectedProgramCellRow = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        selectedProgramSetting = true
    }
   
}

// MARK: PlaybackBar Delegate
extension ListenerAccountBottomVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }

    func playedEpisode(episode: Episode) {
        //
    }
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        
        if lastPlayedID != episodeID {
            updatePastEpisodeProgress()
            listenCountUpdated = false
        }
        lastPlayedID = episodeID
        guard let cell = activeProgramCell else { return }
        
        if percentage > 0.0 {
            cell.playbackBarView.progressUpdateWith(percentage: percentage)
            lastProgress = percentage
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let indexPath = IndexPath(item: atIndex, section: 0)
        
        switch forType {
        case .program:
            if subscriptionTV.indexPathsForVisibleRows!.contains(indexPath) {
                let cell = subscriptionTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
                cell.playbackBarView.setupPlaybackBar()
                activeProgramCell = cell
            }
        default:
            break
        }
    }
    
    func updatePastEpisodeProgress() {
        //
    }
    
}

extension ListenerAccountBottomVC: CustomAlertDelegate {
  
    func primaryButtonPress() {
        if selectedEpisodeSetting {
            selectedEpisodeSetting = false
        } else if selectedProgramSetting {
            let program = downloadedPrograms[selectedProgramCellRow!]
            FireStoreManager.reportProgramWith(programID: program.ID)
            selectedProgramSetting = false
        }
    }
    
    func cancelButtonPress() {
        selectedProgramSetting = false
        selectedEpisodeSetting = false
    }
    
}




