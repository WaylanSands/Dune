//
//  SearchVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SearchVC: UIViewController {
    
    enum searchMode {
        case all
        case category
        case episode
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var searchContentWidth: CGFloat = 0
    var pillsHeightConstraint: NSLayoutConstraint!
    
    let loadingView = TVLoadingAnimationView(topHeight: 20)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedPrograms = [Program]()
    var filteredPrograms = [Program]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    var currentMode: searchMode = .all
    var selectedCategory: String?
    var isGoingForward = false
    var isFetching = false
        
    var categoryButtons = [UIButton]()
    var categories = [String]()
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    let noIntroRecordedAlert = CustomAlertView(alertType: .noIntroRecorded)
    let reportProgramAlert = CustomAlertView(alertType: .reportProgram)
    
    let introPlayer = DuneIntroPlayer()
    var activeProgram: Program?
    var lastPlayedID: String?
    var lastProgress: CGFloat = 0
    var selectedCellRow: Int?
    
    // For various screens
    var searchBarPadding = 10
    
    // Deep link navigation
    var programToPush: Program?
    
    var  adjustmentHeight: CGFloat = 15.0
    
    let customNavBar: CustomNavBar = {
        let view = CustomNavBar()
        view.backgroundColor = CustomStyle.blackNavBar
        view.leftButton.isHidden = true
        return view
    }()
    
    let searchScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.backgroundColor = CustomStyle.blackNavBar
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let searchButtons: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    lazy var searchContentStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = 7
        return view
    }()
    
    let programButton: UIButton = {
        let button = UIButton()
        button.setTitle("Program names", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let programNamesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Programs tags", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let episodesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Episodes", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var emptyTableViewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        return label
    }()
    
    func emptyLabelText(searchText: String) -> String {
     return """
     Sorry but "\(searchText)" is
     coming up empty.
     """
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        view.backgroundColor = CustomStyle.darkestBlack
        createCategoryPills()
        configureDelegates()
        styleForScreens()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchScrollView.setScrollBarToTopLeft()
        setupSearchController()
        isGoingForwardHeight()
        if isGoingForward {
            isGoingForward = false
        } else {
            fetchTopPrograms()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkToPushLinkedProgram()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        introPlayer.finishSession()
        if isGoingForward {
//            pillsHeightConstraint.constant = adjustmentHeight
        } else {
//            pillsHeightConstraint.constant = 0
            resetAllSelection()
            resetTableView()
        }
        searchController.isActive = false
    }
    
    func checkToPushLinkedProgram() {
        if programToPush != nil {
            isGoingForward = true
            visitProfile(program: programToPush!)
            programToPush = nil
        }
    }
    
    func isGoingForwardHeight() {
        if #available(iOS 13.0, *) {
            adjustmentHeight = 0
        } else {
            adjustmentHeight = 15
        }
    }
    

    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search channels by name"
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            searchController.searchBar.searchTextField.textColor = CustomStyle.primaryBlack
            searchController.searchBar.searchTextField.backgroundColor = .white
        } else {
            // Fallback on earlier versions
            let searchTextField : UITextField?
            searchTextField = searchController.searchBar.value(forKey: "_searchField") as? UITextField
            searchTextField?.backgroundColor = .white
        }
        
        searchController.searchBar.barStyle = .black
        searchController.searchBar.keyboardAppearance = .light

        navigationItem.titleView = searchController.searchBar
//        navigationItem.searchController = searchController
    
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = false
//        navigationController?.navigationBar.barTintColor = CustomStyle.darkestBlack
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let searchBarTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchBarTextField?.textColor = CustomStyle.sixthShade
        searchBarTextField?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let placeholder = searchBarTextField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = CustomStyle.fourthShade
        placeholder?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        searchController.searchBar.setImage(#imageLiteral(resourceName: "searchBar-icon"), for: .search, state: .normal)
        let offset = UIOffset(horizontal: 10, vertical: 0)
        searchController.searchBar.setPositionAdjustment(offset, for: .search)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configureDelegates() {
        tableView.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        programSettings.settingsDelegate = self
        reportProgramAlert.alertDelegate = self
        introPlayer.playbackDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    func filterContentForSearchText(_ searchText: String) {
     filteredPrograms = downloadedPrograms.filter { program -> Bool in
        return program.name.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedPrograms = []
        filteredPrograms = []
        initialSnapshot = []
        lastSnapshot = nil
        moreToLoad = true
        tableView.reloadData()
    }
    
    func fetchTopPrograms() {
        isFetching = true
        FireStoreManager.fetchProgramsOrderedBySubscriptions(limit: 10) { [weak self] snapshot in
            guard let self = self else { return }
            self.isFetching = false
            if self.initialSnapshot != snapshot {
                self.resetTableView()
                self.initialSnapshot = snapshot
                self.lastSnapshot = snapshot.last!
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let imageID = data["imageID"] as? String
                    let isPublisher = data["isPublisher"] as? Bool
                    
                    if imageID != nil && isPublisher == true {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                    }
                    
                    if counter == snapshot.count {
                        self.tableView.reloadData()
                        self.loadingView.removeFromSuperview()
                    }
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    func  fetchAnotherBatch() {
        addBottomLoadingSpinner()
        isFetching = true
        FireStoreManager.fetchProgramsOrderedBySubscriptionsFrom(lastSnapshot: lastSnapshot!, limit: 10) { snapshots in
            self.isFetching = false
            if snapshots.count == 0 {
                self.tableView.tableFooterView = nil
                self.moreToLoad = false
            } else {
                self.lastSnapshot = snapshots.last!
                var counter = 0
                
                for eachDocument in snapshots {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let imageID = data["imageID"] as? String
                    let isPublisher = data["isPublisher"] as? Bool
                    
                                        
                    if data["isGlobal"] != nil {
                        FireStoreManager.change(ID: data["ID"] as! String)
                    }
                    
                    if imageID != nil && isPublisher == true {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                    }
                    
                    if counter == snapshots.count {
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func createCategoryPills() {
        FireStoreManager.usedCategories() { categories in
            self.categories = categories
            let allProgramsButton = self.allPrograms()
            self.searchContentStackView.addArrangedSubview(allProgramsButton)
            self.categoryButtons.append(allProgramsButton)
            
            if let interests = User.interests {
               for each in interests {
                if !categories.contains(each) {
                    continue
                }
                   let button = self.categoryPill()
                   button.setTitle(each, for: .normal)
                   button.addTarget(self, action: #selector(self.categorySelection), for: .touchUpInside)
                   self.searchContentStackView.addArrangedSubview(button)
                   self.categoryButtons.append(button)
               }
            }
            
            for each in categories {
                if let interests = User.interests {
                    if interests.contains(each) {
                        continue
                    }
                }
                let button = self.categoryPill()
                button.setTitle(each, for: .normal)
                button.addTarget(self, action: #selector(self.categorySelection), for: .touchUpInside)
                self.searchContentStackView.addArrangedSubview(button)
                self.categoryButtons.append(button)
            }
            
            self.categories.append("All")
        }
    }
    
    func allPrograms() -> UIButton {
        let button = categoryPill()
        button.setTitle("All", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.addTarget(self, action: #selector(showAllPrograms), for: .touchUpInside)
        return button
    }
    
    func categoryPill() -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.sixthShade
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        return button
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func styleForScreens() {
//        switch UIDevice.current.deviceType {
//        case .iPhone4S, .iPhoneSE:
//            searchBarPadding = 7
//        case .iPhone8:
//            searchBarPadding = 7
//        case .iPhone8Plus:
//            searchBarPadding = 7
//        case .iPhone11:
//            searchBarPadding = 10
//        case .iPhone11Pro:
//            break
//        case .iPhone11ProMax:
//            break
//        case .unknown:
//            break
//        }
    }
    
    func configureViews() {
        view.addSubview(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        if #available(iOS 14.0, *) {
            searchController.searchBar.setSearchTextField(height: 32)
            customNavBar.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight() + 20).isActive = true
        } else {
            searchController.searchBar.setSearchTextField(height: 38)
            customNavBar.heightAnchor.constraint(equalToConstant: UIDevice.current.navBarHeight() + 15).isActive = true
        }
        
        view.backgroundColor = CustomStyle.secondShade
        view.addSubview(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor).isActive = true
        searchScrollView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
//        view.addSubview(searchButtons)
//        searchButtons.translatesAutoresizingMaskIntoConstraints = false
//        pillsHeightConstraint = searchButtons.topAnchor.constraint(equalTo: view.topAnchor)
//        pillsHeightConstraint.isActive = true
//        searchButtons.heightAnchor.constraint(equalToConstant:40.0).isActive = true
//        searchButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        searchButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        searchButtons.addSubview(programButton)
//        programButton.translatesAutoresizingMaskIntoConstraints = false
//        programButton.leadingAnchor.constraint(equalTo: searchButtons.leadingAnchor, constant: 16).isActive = true
//        programButton.topAnchor.constraint(equalTo: searchButtons.topAnchor, constant: 5).isActive = true
//
//        searchButtons.addSubview(programNamesButton)
//        programNamesButton.translatesAutoresizingMaskIntoConstraints = false
//        programNamesButton.leadingAnchor.constraint(equalTo: programButton.trailingAnchor, constant: 17).isActive = true
//        programNamesButton.topAnchor.constraint(equalTo: searchButtons.topAnchor, constant: 5).isActive = true
//
//        searchButtons.addSubview(episodesButton)
//        episodesButton.translatesAutoresizingMaskIntoConstraints = false
//        episodesButton.leadingAnchor.constraint(equalTo: programNamesButton.trailingAnchor, constant: 17).isActive = true
//        episodesButton.topAnchor.constraint(equalTo: searchButtons.topAnchor, constant: 5).isActive = true

        searchScrollView.addSubview(searchContentStackView)
        searchContentStackView.translatesAutoresizingMaskIntoConstraints = false
        searchContentStackView.topAnchor.constraint(equalTo: searchScrollView.topAnchor).isActive = true
        searchContentStackView.leadingAnchor.constraint(equalTo: searchScrollView.leadingAnchor, constant: 16).isActive = true
        searchContentStackView.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        searchContentStackView.trailingAnchor.constraint(equalTo: searchScrollView.trailingAnchor, constant: -16).isActive = true
        
        view.addSubview(emptyTableViewLabel)
        emptyTableViewLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyTableViewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90).isActive = true
        emptyTableViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emptyTableViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: tableView.safeDunePlayBarHeight, right: 0.0)
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.addTopBounceAreaView()
                
        view.bringSubviewToFront(searchScrollView)
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 64)
    }
    
    func addBottomLoadingSpinner() {
        var spinner: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = CustomStyle.fifthShade
        } else {
            spinner = UIActivityIndicatorView(style: .gray)
        }
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 60.0)
        
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
    // MARK: Category Selection
    @objc func categorySelection(sender: UIButton) {
        
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.text?.removeAll()

        let category = sender.titleLabel!.text!
        selectedCategory = category
        currentMode = .category
        resetTableView()
              
        for eachCategory in categories {
            let pill = categoryButtons.first(where: { $0.titleLabel?.text ==  eachCategory })
            if eachCategory != selectedCategory {
                pill?.backgroundColor = CustomStyle.sixthShade
                pill?.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
            } else {
                pill?.backgroundColor = CustomStyle.white
                pill?.setTitleColor(CustomStyle.primaryBlack, for: .normal)
            }
        }
        
        isFetching = true
        FireStoreManager.fetchProgramsWithinCategory(limit: 10, category: category) { snapshot in
            self.isFetching = false
            if self.initialSnapshot != snapshot {
                
                self.initialSnapshot = snapshot
                self.lastSnapshot = snapshot.last!
                var counter = 0
                
                if snapshot.count < 10 {
                    self.moreToLoad = false
                }
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let imageID = data["imageID"] as? String
                    
                    if imageID != nil {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                    }
                    
                    if counter == snapshot.count {
                        self.tableView.reloadData()
                        self.loadingView.removeFromSuperview()
                    }
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    func  fetchAnotherBatchOfCategory() {
        addBottomLoadingSpinner()
        isFetching = true
        FireStoreManager.fetchMoreProgramsWithinCategoryFrom(lastSnapshot: lastSnapshot!, limit: 10, category: selectedCategory!) { snapshot in
            self.isFetching = false
            if snapshot.count == 0 {
                print("Remove spinner")
                self.tableView.tableFooterView = nil
                self.moreToLoad = false
            } else {
                
                if snapshot.count < 10 {
                    self.moreToLoad = false
                }
                
                self.lastSnapshot = snapshot.last!
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let documentID = eachDocument.documentID
                    let imageID = data["imageID"] as? String
                    
                    if CurrentProgram.isPublisher! && documentID == CurrentProgram.ID! {
                    } else if imageID != nil {
                         let program = Program(data: data)
                        if !self.downloadedPrograms.contains(where: { $0.ID == program.ID }) {
                             self.downloadedPrograms.append(program)
                        }
                    }
                    
                    if counter == snapshot.count {
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if filteredPrograms.count == 0 {
                tableView.isHidden = true
            }
            return filteredPrograms.count
        } else {
            tableView.isHidden = false
            return downloadedPrograms.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
        
        var program: Program
        if isFiltering {
            program = filteredPrograms[indexPath.row]
        } else {
            program = downloadedPrograms[indexPath.row]
        }
        
        programCell.program = program
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.programNameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
        programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        programCell.programImageButton.setImage(program.image ?? nil, for: .normal)
        
        if programCell.program.image != program.image {
            programCell.programImageButton.setImage(nil, for: .normal)
        }
        
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
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 90.0 {
            switch currentMode {
            case .all:
                if moreToLoad == true && !isFetching {
                    fetchAnotherBatch()
                }
            case .category:
                if moreToLoad == true && !isFetching {
                    fetchAnotherBatchOfCategory()
                }
            case .episode:
                break
            }
            
        }
    }
}

extension SearchVC: ProgramCellDelegate {
    
    func unsubscribeFrom(program: Program) {
        //
    }
   
    func programTagSelected(tag: String) {
        isGoingForward = true
        let tagSelectedVC = ProgramTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func visitProfile(program: Program) {
        if CurrentProgram.programsIDs().contains(program.ID) {
             duneTabBar.visit(screen: .account)
        } else if program.isPublisher {
            isGoingForward = true
            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                let programVC = ProgramProfileVC()
                programVC.program = program
                navigationController?.pushViewController(programVC, animated: true)
            } else {
                let programVC = SingleProgramProfileVC(program: program)
                navigationController?.pushViewController(programVC, animated: true)
            }
        } else {
            isGoingForward = true
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
            updatePastEpisodeProgress()
        }
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
              
        let image = cell.programImageButton.imageView!.image!
        let audioID = cell.program.introID
  
        self.introPlayer.setProgramDetailsWith(program: cell.program, image: image)
        self.introPlayer.playOrPauseIntroWith(audioID: audioID!)
    }
    
    func showSettings(cell: ProgramCell) {
        selectedCellRow =  downloadedPrograms.firstIndex(where: { $0.ID == cell.program.ID })
        programSettings.showSettings()
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
    
    func noIntroAlert() {
        UIApplication.shared.keyWindow!.addSubview(noIntroRecordedAlert)
    }

}

extension SearchVC: DuneAudioPlayerDelegate {
    
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        if lastPlayedID != episodeID {
            updatePastEpisodeProgress()
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
    
    func updatePastEpisodeProgress() {
        guard let index = downloadedPrograms.firstIndex(where: { $0.ID == lastPlayedID }) else { return }
        let program = downloadedPrograms[index]
        program.playBackProgress = lastProgress
        downloadedPrograms[index] = program
    }
    
    @objc func showAllPrograms() {
        resetTableView()
        resetCategoryButtons()
        updateSearchResults(for: self.searchController)
        categoryButtons[0].backgroundColor = CustomStyle.white
        categoryButtons[0].setTitleColor(CustomStyle.primaryBlack, for: .normal)
        currentMode = .all
        fetchTopPrograms()
    }
    
    @objc func resetAllSelection() {
        resetCategoryButtons()
        if categoryButtons.count > 0  {
            categoryButtons[0].backgroundColor = CustomStyle.white
            categoryButtons[0].setTitleColor(CustomStyle.primaryBlack, for: .normal)
        }
        currentMode = .all
    }
    
    func resetCategoryButtons() {
        for each in categoryButtons {
            each.backgroundColor = CustomStyle.sixthShade
            each.setTitleColor(CustomStyle.fourthShade.withAlphaComponent(0.8), for: .normal)
        }
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        // No implementation needed
    }
    
    func showSettingsFor(episode: Episode) {
        // No implementation needed
    }
    
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)
        emptyTableViewLabel.text = emptyLabelText(searchText: searchBar.text!)
        
        if filteredPrograms.count > 0 {
            tableView.isHidden = false
        }
        
        if searchController.searchBar.text != "" {
            FireStoreManager.searchForProgramStartingWith(string: searchBar.text!) { results in
                for each in results {
                    let data = each.data()
                    let imageID = data["imageID"] as? String
                    let program = Program(data: data)
                    
                    if !self.downloadedPrograms.contains(where: { $0.ID == program.ID }) && imageID != nil {
                        self.downloadedPrograms.append(program)
                    }
                }
            }
        }
    }
}

extension SearchVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Report":
            UIApplication.shared.windows.last?.addSubview(reportProgramAlert)
        default:
            break
        }
    }
}

extension SearchVC: CustomAlertDelegate {
    func primaryButtonPress() {
        let program = downloadedPrograms[selectedCellRow!]
        FireStoreManager.reportProgramWith(programID: program.ID)
    }
    
    func cancelButtonPress() {
        //
    }
    

}


extension SearchVC: UISearchBarDelegate {
    
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//
//        searchScrollView.isHidden = true
//        searchButtons.isHidden = false
//        return true
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchScrollView.isHidden = false
//        searchButtons.isHidden = true
//    }
//

}
