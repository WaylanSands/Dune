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

class ProgramTagLookupVC: UIViewController {
    
    var pushedForward = false

    let tableView = UITableView()
    var introPlayer = DuneIntroPlayer()
    var audioPlayerInPosition = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    var audioIDs = [String]()
    var downloadedPrograms = [Program]()

    var commentVC: CommentThreadVC!
    var activeCell: ProgramCell?
    var activeProgram: Program?
    var selectedCellRow: Int?
    var lastPlayedID: String?
    var lastProgress: CGFloat = 0

    let loadingView = TVLoadingAnimationView(topHeight: 20)
    
    var selectedProgramCellRow: Int?
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    let noIntroRecordedAlert = CustomAlertView(alertType: .noIntroRecorded)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nav.backgroundColor = CustomStyle.blackNavBar
        return nav
    }()

    let programNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    var tag: String!
    
    required init(tag: String) {
        super.init(nibName: nil, bundle: nil)
        self.tag = tag
        FireStoreManager.getProgramsWith(tag: tag) { programs in
            self.configureProgramLabelWith(count: programs.count)
            self.loadingView.removeFromSuperview()
            self.downloadedPrograms = programs
            self.tableView.reloadData()
        }
    }
    
    func configureProgramLabelWith(count: Int) {
        var programs = "Channels"
        
        if count == 1 {
            programs = "Channel"
        }
        
        customNavBar.rightButton.setTitle("\(count) \(programs)", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDelegates()
        configureViews()
        addLoadingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        selectedCellRow = nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        introPlayer.finishSession()

        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }

    func configureDelegates() {
        tableView.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        introPlayer.playbackDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func resetTableView() {
        downloadedPrograms = [Program]()
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
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white

        tableView.addSubview(programNumberLabel)
        programNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        programNumberLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        programNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 64)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }

    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {

        let tempURL = FileManager.getTempDirectory()
        let fileURL = tempURL.appendingPathComponent(audioID)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            FireStorageManager.downloadIntroAudio(audioID: audioID) { url in
                completion(url)
            }
        }
    }
}

extension ProgramTagLookupVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedPrograms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
        let program = downloadedPrograms[indexPath.row]
       
        programCell.program = program
        programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.programNameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
//        programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
        programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
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

extension ProgramTagLookupVC: ProgramCellDelegate {
    
    func noIntroAlert() {
         UIApplication.shared.windows.last?.addSubview(noIntroRecordedAlert)
    }
    
    func unsubscribeFrom(program: Program) {
        //
    }
   
    func programTagSelected(tag: String) {
        pushedForward = true
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
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
    
    func playProgramIntro(cell: ProgramCell) {
              activeProgram = cell.program
              
              cell.program.hasBeenPlayed = true
              guard let index = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID }) else { return }
              downloadedPrograms[index] = cell.program
              
              if cell.program.ID != lastPlayedID {
                  updatePastProgress()
              }
              
              if !cell.playbackBarView.playbackBarIsSetup {
                  cell.playbackBarView.setupPlaybackBar()
              }
                          
              let image = cell.programImageButton.imageView!.image!
              let audioID = cell.program.introID
        
              self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
              self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
    }
    
    func updatePastProgress() {
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
        let program = downloadedPrograms[index]
        program.playBackProgress = lastProgress
        downloadedPrograms[index] = program
    }
    
    func showSettings(cell: ProgramCell) {
        selectedProgramCellRow = downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        programSettings.showSettings()
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
}

extension ProgramTagLookupVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }
    
   
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        if lastPlayedID != episodeID {
            updatePastProgress()
        }
        
        lastPlayedID = episodeID
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == episodeID }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        if tableView.indexPathsForVisibleRows!.contains(indexPath) {
            let cell = tableView.cellForRow(at: indexPath) as! ProgramCell
            if percentage > 0.01 {
                cell.playbackBarView.progressUpdateWith(percentage: percentage)
                lastProgress = percentage
            }
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        // No implementation needed
    }
    
    func showSettingsFor(episode: Episode) {
        // No implementation needed
    }
    
}

extension ProgramTagLookupVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Report":
              UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
        default:
            break
        }
    }
    
    
}

extension ProgramTagLookupVC: CustomAlertDelegate {
   
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


