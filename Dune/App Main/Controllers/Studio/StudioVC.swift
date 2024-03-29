
//
//  StudioVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAnalytics
import FirebaseFirestore
import MobileCoreServices

class StudioVC: UIViewController {
   
    var programSelectionView: SettingsLauncher!
    var recordingSession: AVAudioSession!
//    lazy var tabBar = navigationController?.tabBarController?.tabBar
    
    let tableView = UITableView()
    var firstBatchAmount = 10
    var draftEpisodeIDs = [String]()
    var downloadedDrafts = [DraftEpisode]()
    var downloadingIndexes = [Int]()
    var initialLoad: Bool = true
    var selectedProgramName: String?
    var fetchingDraft = false
    
    let publisherNotSetUpAlert = CustomAlertView(alertType: .publisherNotSetUp)
    let notAPublisherAlert = CustomAlertView(alertType: .switchToPublisher)
    
    var customNav: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = CustomStyle.onBoardingBlack.withAlphaComponent(0.8)
        nav.leftButton.setImage(UIImage(named: "upload-icon-white"), for: .normal)
        nav.rightButton.setTitle("Record", for: .normal)
        nav.leftButton.addTarget(self, action: #selector(selectDocument), for: .touchUpInside)
        nav.rightButton.addTarget(self, action: #selector(recordButtonPress), for: .touchUpInside)
        return nav
    }()
    
    let programNameButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12.5
        button.clipsToBounds = true
        button.titleLabel!.lineBreakMode = .byTruncatingTail
        button.addTarget(self, action: #selector(selectProgram), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let studioImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "studio-logo")
        imageView.isHidden = true
        return imageView
    }()
    
    
    let noDraftEpisodesLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Your unpublished episodes will
        display here
        """
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = CustomStyle.subTextColor
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    } 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = CustomStyle.onBoardingBlack
        configureViews()
        configureDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureProgramToggle()
        setupNavigationBar()
        firstBatchAmount = 10
        draftEpisodeIDs = [String]()
        downloadedDrafts = [DraftEpisode]()
        downloadingIndexes = [Int]()
        initialLoad = true
        getDraftEpisodeIDs()
        
        programNameButton.setTitle(CurrentProgram.name, for: .normal)

        navigationController?.isNavigationBarHidden = true
//        tabBar?.isHidden = false
        duneTabBar.isHidden = false
//
//        tabBar!.items?[0].image = UIImage(named: "feed-icon-selected")
//        tabBar!.items?[1].image =  UIImage(named: "trending-icon-selected")
//        tabBar!.items?[3].image =  UIImage(named: "search-icon-selected")
//        tabBar!.items?[4].image =  UIImage(named: "account-icon-selected")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Track.trackOption = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        tabBarController?.tabBar.isHidden = false
//        tabBar?.barStyle = .default
//        tabBar!.backgroundImage = .none
//        tabBar!.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
//        tabBar!.items?[0].image = UIImage(named: "feed-icon")
//        tabBar!.items?[1].image =  UIImage(named: "trending-icon")
//        tabBar!.items?[2].image =  UIImage(named: "studio-icon")
//        tabBar!.items?[3].image =  UIImage(named: "search-icon")
//        tabBar!.items?[4].image =  UIImage(named: "account-icon")
    }

    func setupNavigationBar() {
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configureDelegates() {
        tableView.register(DraftEpisodeCell.self, forCellReuseIdentifier: "draftEpisodeCell")
        publisherNotSetUpAlert.alertDelegate = self
        notAPublisherAlert.alertDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureViews() {
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        view.addSubview(noDraftEpisodesLabel)
        noDraftEpisodesLabel.translatesAutoresizingMaskIntoConstraints = false
        noDraftEpisodesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noDraftEpisodesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        noDraftEpisodesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        
        view.addSubview(studioImage)
        studioImage.translatesAutoresizingMaskIntoConstraints = false
        studioImage.bottomAnchor.constraint(equalTo: noDraftEpisodesLabel.topAnchor, constant: -30).isActive = true
        studioImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(customNav)
        customNav.pinNavBarTo(view)
        
        view.addSubview(programNameButton)
        programNameButton.translatesAutoresizingMaskIntoConstraints = false
        programNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        programNameButton.centerYAnchor.constraint(equalTo: customNav.centerYAnchor, constant: 22).isActive = true
        programNameButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        programNameButton.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
    }
    
    func configureProgramToggle() {
        if !CurrentProgram.programIDs!.isEmpty {
            programNameButton.isHidden = false
            customNav.titleLabel.text = ""
        } else {
            customNav.titleLabel.text = "Studio"
            programNameButton.isHidden = true
        }
    }
    
    func getDraftEpisodeIDs() {
        if User.draftEpisodeIDs != nil && User.draftEpisodeIDs?.count != 0 {
            noDraftEpisodesLabel.isHidden = true
            studioImage.isHidden = true
            tableView.isHidden = false
            FireStoreManager.getDraftEpisodesInOrder { (episodeIDs) in
                if episodeIDs !=  nil {
                    self.draftEpisodeIDs = episodeIDs!
                    self.checkToLoadFirstBatch()
                    print("Returning with ordered drafts")
                }
            }
        } else {
            noDraftEpisodesLabel.isHidden = false
            studioImage.isHidden = false
            tableView.isHidden = true
        }
    }
    
        func checkToLoadFirstBatch() {
            if draftEpisodeIDs.count >= firstBatchAmount {
                for each in 0..<firstBatchAmount {
                    downloadDraft(forItemAtIndex: each)
                }
            } else {
                for each in 0..<draftEpisodeIDs.count {
                    downloadDraft(forItemAtIndex: each)
                    firstBatchAmount = draftEpisodeIDs.count
                }
            }
        }
        
        func  getAnotherBatchOrLastWith(row: Int) {
            if draftEpisodeIDs.count - downloadedDrafts.count >= 5  {
                for each in stride(from: row, to: row + 5, by: 1) {
                    downloadDraft(forItemAtIndex: each)
                }
            } else {
                for each in row..<draftEpisodeIDs.count {
                    downloadDraft(forItemAtIndex: each)
                }
            }
        }
        
        func downloadDraft(forItemAtIndex index: Int) {
            let epID = self.draftEpisodeIDs[index]

            let alreadyDownloaded = self.downloadedDrafts.contains(where: { $0.ID == epID })
            let startedDownloading = self.downloadingIndexes.contains(where: { $0 == index })
            
            if !alreadyDownloaded && !startedDownloading {
                downloadingIndexes.append(index)
                FireStoreManager.getDraftEpisodeDataWith(ID: epID) { (data) in
                    
                    let id = data["ID"] as! String
                    
                    let uploadDate = data["addedAt"] as! Timestamp
                    let date = uploadDate.dateValue()
                    let time = date.timeAgoDisplay()
                    
                    let fileName = data["fileName"]as! String
                    let wasTrimmed = data["wasTrimmed"]as! Bool
                    let startTime = data["startTime"] as! Double
                    let endTime = data["endTime"] as! Double
                    let duration = data["duration"] as! String
                    let programName = data["programName"] as! String
                    let username = data["username"] as! String
                    let caption = data["caption"] as! String
                    let tags = data["tags"] as! [String]?
                    let programID = data["programID"] as! String
                    let ownerID = data["ownerID"] as! String
                    
                    let newEp = DraftEpisode(
                        id: id,
                        addedAt: time,
                        fileName: fileName,
                        wasTrimmed: wasTrimmed,
                        startTime: startTime,
                        endTime: endTime,
                        duration: duration,
                        programName: programName,
                        username: username,
                        caption: caption,
                        tags: tags,
                        programID: programID,
                        ownerID: ownerID
                    )
                    
                    self.downloadedDrafts.append(newEp)
                    if self.downloadedDrafts.count >= self.firstBatchAmount {
                        self.tableView.reloadData()
//                        self.loadingView.removeFromSuperview()
                        self.initialLoad = false
                    }
                }
            }
        }
    
    func visitAppSettings() {
        let url = URL(string:UIApplication.openSettingsURLString)
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:]) {_ in
                print("Did return")
            }
        }
    }
    
    @objc func recordButtonPress() {
        
        if AVCaptureDevice.authorizationStatus(for: .audio) == .denied {
            visitAppSettings()
            return
        }
        
        if CurrentProgram.isPublisher! && User.isSetUp! {
            recordingSession = AVAudioSession.sharedInstance()
            do {
                try recordingSession.setCategory(.playAndRecord, mode: .default)
                try recordingSession.setActive(true)
                recordingSession.requestRecordPermission() { [unowned self] allowed in
                    DispatchQueue.main.async {
                        if allowed {
                            dunePlayBar.finishSession()
                            self.moveToRecordBooth()
                        } else {
                            print("Refused to record")
                        }
                    }
                }
            } catch {
                print("Unable to start recording \(error)")
            }
        } else  if CurrentProgram.isPublisher! && !User.isSetUp! {
            UIApplication.shared.keyWindow!.addSubview(publisherNotSetUpAlert)
        } else if !CurrentProgram.isPublisher! {
            UIApplication.shared.keyWindow!.addSubview(notAPublisherAlert)
        }
    }
    
    func moveToRecordBooth() {
        let recordVC = RecordBoothVC()
        if selectedProgramName != nil && selectedProgramName != CurrentProgram.name {
            recordVC.selectedProgram = CurrentProgram.subPrograms?.first(where: { $0.name == selectedProgramName })
        }
        recordVC.currentScope = .episode
        navigationController?.pushViewController(recordVC, animated: false)
    }
    
    @objc func selectProgram() {
        var options = [Setting]()
        
        for each in CurrentProgram.subPrograms! {
            options.append(Setting(name: each.name, imageName: nil))
        }
        
        options.append(Setting(name:CurrentProgram.name!, imageName: nil))
        
        programSelectionView = SettingsLauncher(options: options, type: .programNames)
        programSelectionView.settingsDelegate = self
        programSelectionView.showSettings()
    }
    
    func editDraftEpisode(for row: Int) {
        let draft = downloadedDrafts[row]
        if !fetchingDraft {
            fetchingDraft = true
            FileManager.getAudioURLFromTempDirectory(fileName: draft.fileName) { url in
                
                let editingVC = EditingBoothVC()
                editingVC.recordingURL = url
                editingVC.fileName = draft.fileName
                editingVC.startTime = draft.startTime
                editingVC.endTime = draft.endTime
                editingVC.wasTrimmed = draft.wasTrimmed
                editingVC.caption = draft.caption
                editingVC.tags = draft.tags
                editingVC.draftID = draft.ID
                editingVC.isDraft = true
                
                if draft.programName != CurrentProgram.name {
                    let program = CurrentProgram.subPrograms?.first(where: {$0.name == draft.programName})
                    editingVC.selectedProgram = program
                }
                self.navigationController?.pushViewController(editingVC, animated: true)
                duneTabBar.isHidden = true
                self.fetchingDraft = false
            }
        }
    }
    
    func editUploadedEpisode(url: URL, fileName: String) {
        
        let editingVC = EditingBoothVC()
        editingVC.recordingURL = url
        editingVC.fileName = fileName
        editingVC.startTime = 0
        editingVC.endTime = 0
        editingVC.wasTrimmed = false
        editingVC.caption = ""
        editingVC.tags = []
        editingVC.isDraft = false
        
        if selectedProgramName != CurrentProgram.name {
            let program = CurrentProgram.subPrograms?.first(where: {$0.name == selectedProgramName})
            editingVC.selectedProgram = program
        }
        
        self.navigationController?.pushViewController(editingVC, animated: true)
    }
}

extension StudioVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return downloadedDrafts.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 90.0 {
            getAnotherBatchOrLastWith(row: downloadedDrafts.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let draftCell = tableView.dequeueReusableCell(withIdentifier: "draftEpisodeCell") as! DraftEpisodeCell
        draftCell.row = indexPath.row
        // Set up the cell with the downloaded ep data
        let draftEpisode = downloadedDrafts[indexPath.row]
//        draftCell.cellDelegate = self
        draftCell.normalSetUp(episode: draftEpisode)
        return draftCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editDraftEpisode(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            draftEpisodeIDs.remove(at: indexPath.row)
            downloadedDrafts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, completionBool) in
            
            //Delete episode
            let draftEpisode = self.downloadedDrafts[indexPath.row]
            FileManager.removeFileFromTempDirectory(fileName: draftEpisode.fileName)
            FireStorageManager.deleteDraftFileFromStorage(fileName: draftEpisode.fileName)
            FireStoreManager.removeDraftIDFromUser(episodeID: draftEpisode.ID)
            FireStoreManager.deleteDraftDocument(ID: draftEpisode.ID)
            User.draftEpisodeIDs!.removeAll { $0 == draftEpisode.ID }
            
            if User.draftEpisodeIDs?.count == 0 {
                self.noDraftEpisodesLabel.isHidden = false
                tableView.isHidden = true
            }
            
            self.draftEpisodeIDs.remove(at: indexPath.row)
            self.downloadedDrafts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
  
        }
        
        contextItem.backgroundColor = CustomStyle.onBoardingBlack
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }

}

extension StudioVC: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
                
        guard let url = urls.first else { return }
        let fileExtension = ".\(url.pathExtension)"
        
        print("The file extension \(fileExtension)")
        
        let fileName = NSUUID().uuidString + fileExtension

            var newURL = FileManager.getTempDirectory()
            newURL.appendPathComponent(fileName)
            do {

                if FileManager.default.fileExists(atPath: newURL.path) {
                    try FileManager.default.removeItem(atPath: newURL.path)
                }
                try FileManager.default.moveItem(atPath: url.path, toPath: newURL.path)
                editUploadedEpisode(url: newURL, fileName: fileName)
            } catch {
                print(error.localizedDescription)
            }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
                dismiss(animated: true, completion: nil)
        }
    
    @objc func selectDocument() {
        if CurrentProgram.isPublisher! && User.isSetUp! {
            let types = [kUTTypeAudio]
            let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
            
            if #available(iOS 11.0, *) {
                importMenu.allowsMultipleSelection = false
            }
            
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .fullScreen
            
            present(importMenu, animated: true)
        } else if CurrentProgram.isPublisher! && !User.isSetUp! {
//            view.addSubview(publisherNotSetUpAlert)
            UIApplication.shared.keyWindow!.addSubview(publisherNotSetUpAlert)
        } else if !CurrentProgram.isPublisher! {
//            view.addSubview(notAPublisherAlert)
            UIApplication.shared.keyWindow!.addSubview(notAPublisherAlert)
        }
    }
}

extension StudioVC: SettingsLauncherDelegate {
   
    func selectionOf(setting: String) {
        programNameButton.setTitle(setting, for: .normal)
        selectedProgramName = setting
    }
    
}

extension StudioVC: CustomAlertDelegate {
   
    func primaryButtonPress() {
        dunePlayBar.finishSession()
        duneTabBar.isHidden = true
        let editProgramVC = EditProgramVC()
        
        if !CurrentProgram.isPublisher! {
            User.isSetUp = false
            CurrentProgram.isPublisher = true
            FireStoreManager.updateUserSetUpTo(false)
            FireStoreManager.updateProgramToPublisher()
            Analytics.setUserProperty("publisher", forName: "publisher_or_listener")
        }
        
        editProgramVC.switchedFromStudio = true
        editProgramVC.highLightNeededFields = true
        navigationController?.pushViewController(editProgramVC, animated: true)
    }
    
    func cancelButtonPress() {
        //
    }
    
    
    
}
