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

    var audioIDs = [String]()
    var downloadedPrograms = [Program]()

    var activeCell: ProgramCell?
    var selectedCellRow: Int?

    let loadingView = TVLoadingAnimationView(topHeight: UIDevice.current.navBarHeight() + 20)

    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.9
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
        var programs = "Programs"
        
        if count == 1 {
            programs = "Program"
        }
        
       programNumberLabel.text = "\(count) \(programs)"
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
        introPlayer.finishSession()
        
        if pushedForward == false {
            navigationController?.popToRootViewController(animated: true)
        }

        FileManager.removeAudioFilesFromDocumentsDirectory() {
            print("Audio removed")
        }
    }

    func configureDelegates() {
//        programSettings.settingsDelegate = self
        tableView.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
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
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavBarAttributes
        navigationItem.title = tag
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.shadowImage = UIImage()
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
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white

        tableView.addSubview(programNumberLabel)
        programNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        programNumberLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        programNumberLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        
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
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
        programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
        programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
        programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        let program = downloadedPrograms[indexPath.row]
        
        programCell.program = program
        programCell.cellDelegate = self
        programCell.normalSetUp(program: program)
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
   
    func tagSelected(tag: String) {
        pushedForward = true
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func visitProfile(program: Program) {
        
        if User.isPublisher! && CurrentProgram.programsIDs().contains(program.ID) {
            let tabBar = MainTabController()
            tabBar.selectedIndex = 4
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = tabBar
        } else {
            if program.isPrimaryProgram && program.hasMultiplePrograms!  {
                let programVC = TProgramProfileVC()
                programVC.program = program
                navigationController?.pushViewController(programVC, animated: true)
            } else {
                let programVC = SubProgramProfileVC(program: program)
                navigationController?.present(programVC, animated: true, completion: nil)
            }
        }
    }
    
    func playProgramIntro(cell: ProgramCell) {
        introPlayer.isProgramPageIntro = false
        activeCell = cell

        let programIntro = cell.program.introID!
        let programImage = cell.program.image!
        let programName = cell.program.name
                
        print("NAV height \(self.tabBarController!.tabBar.frame.height)")
        print("Screen height \(view.frame.height)")
        
        introPlayer.yPosition = view.frame.height - tabBarController!.tabBar.frame.height - introPlayer.frame.height
        
        introPlayer.getAudioWith(audioID: programIntro) { url in
            self.introPlayer.playOrPauseWith(url: url, name: programName, image: programImage)
        }
        print("Play intro")
    }
    
    func showSettings(cell: ProgramCell) {
        programSettings.showSettings()
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func addTappedProgram(programName: String) {
        //
    }
}

extension ProgramTagLookupVC: PlaybackBarDelegate {
   
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }
}


