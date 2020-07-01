//
//  SubscribersVC.swift
//  Dune
//
//  Created by Waylan Sands on 8/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SubscribersVC: UIViewController {
  
    var programID: String!
    var programName: String!
    var programIDs: [String]!
    var subscriberIDs: [String]!
    
    var currentlyFetching = false
    var fetchedIDs = [String]()
    var startingIndex: Int = 0
    var endIndex: Int = 20

    var downloadedPrograms = [Program]()
    var activeProgramCell: ProgramCell?
    var listenCountUpdated = false
    var lastProgress: CGFloat = 0
    var activeProgram: Program?
    var lastPlayedID: String?
    
    var selectedProgramCellRow: Int?
    
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    let noIntroRecordedAlert = CustomAlertView(alertType: .noIntroRecorded)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
   
    let loadingView = TVLoadingAnimationView(topHeight: UIDevice.current.navBarHeight() + 20)
    
    let tableView = UITableView()
    let introPlayer = DuneIntroPlayer()
    var introYConstant: CGFloat = 60
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.9
        return nav
    }()
    
    let emptyTableView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let noSubscribersLabel: UILabel = {
       let label = UILabel()
        label.text = "Nothing to see here - yet."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var noSubscribersSubLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "At this current moment \(programName!) does not have any subscribers"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fifthShade
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    lazy var subscribeButton: UIButton = {
       let button = UIButton()
        button.setTitle("Subscribe to \(programName!)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.addTarget(self, action: #selector(subscribePress), for: .touchUpInside)
        button.backgroundColor = CustomStyle.onBoardingBlack
        button.layer.cornerRadius = 13
        return button
    }()
 
    init(programName: String, programID: String, programIDs: [String], subscriberIDs: [String]) {
        super.init(nibName: nil, bundle: nil)
        self.programID = programID
        self.programName = programName
        self.programIDs = programIDs
        self.subscriberIDs = subscriberIDs
        self.title = "Subscribers"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        configureDelegates()
        sizeForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureSubscribeButton()
        fetchSubscribers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        introPlayer.finishSession()
    }
    
    func configureDelegates() {
        tableView.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        introPlayer.playbackDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureSubscribeButton() {
        if !CurrentProgram.subscriptionIDs!.contains(programID) {
            subscribeButton.isHidden = false
        } else {
            subscribeButton.isHidden = true
        }
    }
    
    func sizeForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            introYConstant = 0
        case .iPhone8:
            introYConstant = 0
        case .iPhone8Plus:
            introYConstant = 0
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        view.backgroundColor = CustomStyle.secondShade
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
        
        view.addSubview(emptyTableView)
        emptyTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emptyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emptyTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emptyTableView.addSubview(noSubscribersLabel)
        noSubscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        noSubscribersLabel.topAnchor.constraint(equalTo: emptyTableView.topAnchor).isActive = true
        noSubscribersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noSubscribersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noSubscribersLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emptyTableView.addSubview(noSubscribersSubLabel)
        noSubscribersSubLabel.translatesAutoresizingMaskIntoConstraints = false
        noSubscribersSubLabel.topAnchor.constraint(equalTo: noSubscribersLabel.bottomAnchor).isActive = true
        noSubscribersSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        noSubscribersSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        emptyTableView.addSubview(subscribeButton)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.topAnchor.constraint(equalTo: noSubscribersSubLabel.bottomAnchor, constant: 20).isActive = true
        subscribeButton.widthAnchor.constraint(equalToConstant: subscribeButton.intrinsicContentSize.width).isActive = true
        subscribeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subscribeButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        introPlayer.addBottomSection()
        
        if !CurrentProgram.programsIDs().contains(programID) {
            view.addSubview(customNavBar)
            customNavBar.pinNavBarTo(view)
        }
    }
    
    func fetchSubscribers() {
        if subscriberIDs.count == 0 {
            emptyTableView.isHidden = false
            loadingView.isHidden = true
            tableView.isHidden = true
        } else if downloadedPrograms.count != subscriberIDs.count {
            loadingView.isHidden = false
            tableView.isHidden = false
            fetchPrograms()
        }
    }
    
    func fetchPrograms() {
        endIndex = 20
        
        if subscriberIDs.count - fetchedIDs.count < endIndex {
            endIndex = subscriberIDs.count - fetchedIDs.count
        }
        
        endIndex += startingIndex
        
        let subscribers = Array(subscriberIDs[startingIndex..<endIndex])
        fetchedIDs += subscribers
        startingIndex = fetchedIDs.count
        fetchSubscribersWith(subscribers: subscribers)
    }
    
    func fetchSubscribersWith(subscribers: [String]) {
        FireStoreManager.fetchProgramsSubscribersWith(subscriberIDs: subscribers) { programs in
            if programs != nil {
                DispatchQueue.main.async {
                    self.downloadedPrograms = programs!
                    self.loadingView.isHidden = true
                    self.tableView.isHidden = false
                    self.currentlyFetching = false
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func subscribePress() {
        subscribeButton.isHidden = true
        emptyTableView.isHidden = true
        loadingView.isHidden = false
        tableView.isHidden = false
        CurrentProgram.subscriptionIDs!.append(programID)
        FireStoreManager.addSubscriptionToProgramWith(programID: programID) { success in
            if success {
                self.subscriberIDs.append(CurrentProgram.ID!)
                self.fetchSubscribers()
            }
        }
        FireStoreManager.subscribeToProgramWith(programID:  programID)
    }

}

extension SubscribersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        downloadedPrograms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
        let program = downloadedPrograms[indexPath.row]

        programCell.program = program
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
        programCell.playProgramButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
        programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
        programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
        programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.normalSetUp(program: program)
        programCell.cellDelegate = self
        
        if lastPlayedID == program.ID {
            activeProgram = program
        }
        
        if program.ID == lastPlayedID {
            programCell.playbackBarView.setProgressWith(percentage: lastProgress)
        }

        return programCell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 90.0 && !currentlyFetching {
           fetchSubscribers()
        }
    }
    
}

extension SubscribersVC: DuneAudioPlayerDelegate {
   
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        if lastPlayedID != episodeID {
            updatePastEpisodeProgress()
            listenCountUpdated = false
        }
        
        lastPlayedID = episodeID
        
        guard let cell = activeProgramCell else { return }
        if percentage > 0.01 {
            cell.playbackBarView.progressUpdateWith(percentage: percentage)
            lastProgress = percentage
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        //
    }
    
    func showCommentsFor(episode: Episode) {
        //
    }
    
    func playedEpisode(episode: Episode) {
        //
    }
    
    
}

extension SubscribersVC: ProgramCellDelegate {
   
    func noIntroAlert() {
         view.addSubview(noIntroRecordedAlert)
    }
   
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func playProgramIntro(cell: ProgramCell) {
        introPlayer.isProgramPageIntro = false
        activeProgram = cell.program
        
        cell.program.hasBeenPlayed = true
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID }) else { return }
        downloadedPrograms[index] = cell.program
        
        if cell.program.ID != lastPlayedID {
            updatePastEpisodeProgress()
        }
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        
        introPlayer.yPosition = view.frame.height - introPlayer.frame.height - introYConstant
     
        let image = cell.programImageButton.imageView!.image!
        let audioID = cell.program.introID
        
        self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
        self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
    }
    
    func updatePastEpisodeProgress() {
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
        let program = downloadedPrograms[index]
        program.playBackProgress = lastProgress
        downloadedPrograms[index] = program
    }
    
    func unsubscribeFrom(program: Program) {
        //
    }
    
    func showSettings(cell: ProgramCell) {
        selectedProgramCellRow = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        programSettings.showSettings()
    }
    
    func visitProfile(program: Program) {
        if User.isPublisher! && CurrentProgram.programsIDs().contains(program.ID) {
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
    
    func programTagSelected(tag: String) {
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
}

extension SubscribersVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Report":
            view.addSubview(reportProgramAlert)
        default:
            break
        }
    }
    
    
}

extension SubscribersVC: CustomAlertDelegate {
    func primaryButtonPress() {
        if let row = selectedProgramCellRow {
            let program = downloadedPrograms[row]
            FireStoreManager.reportProgramWith(programID: program.ID)
        }
    }
    
    func cancelButtonPress() {
        //
    }
    
}

