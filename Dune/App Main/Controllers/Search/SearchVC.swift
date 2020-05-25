//
//  SearchVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UIViewController {
    
    enum searchMode {
        case all
        case category
        case episode
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var searchContentWidth: CGFloat = 0
    var pillSpacing: CGFloat = 7
    
    var pillsHeightConstraint: NSLayoutConstraint!
    
    let loadingView = TVLoadingAnimationView(topHeight: 20)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedPrograms = [Program]()
    var filteredPrograms = [Program]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    var currentMode: searchMode = .all
    var categorySelected: String?
    var isGoingForward = false
    
    let subscriptionSettings = SettingsLauncher(options: SettingOptions.subscriptionEpisode, type: .subscriptionEpisode)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?
    
//    lazy var tabButtons = [programButton]
    
    let searchScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let searchButtons: UIView = {
        let view = UIView()
//        view.backgroundColor = .green
        view.isHidden = true
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
    
    lazy var searchContentStackView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = pillSpacing
        return view
    }()
    
    lazy var leftPaddingView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.spacing = pillSpacing
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        view.backgroundColor = CustomStyle.darkestBlack
        createCategoryPills()
        configureDelegates()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchScrollView.setScrollBarToTopLeft()
        tableView.setScrollBarToTopLeft()
        setupSearchController()
        isGoingForward = false
        fetchTopPrograms()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        introPlayer.finishSession()
        if isGoingForward {
            pillsHeightConstraint.constant = 15
        } else {
            pillsHeightConstraint.constant = 0
        }
        searchController.isActive = false
    }
    
    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchTextField.textColor = CustomStyle.primaryBlack
        searchController.searchBar.searchTextField.backgroundColor = .white
//        navigationItem.searchController = searchController
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = CustomStyle.darkestBlack
        navigationController?.navigationBar.tintColor = CustomStyle.primaryBlue
        navigationController?.navigationBar.barStyle = .black
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
    }
    
    func fetchTopPrograms() {
        print("Fetching programs")
        FireStoreManager.fetchProgramsOrderedBySubscriptions(limit: 10) { snapshot in
            
            if self.initialSnapshot != snapshot {
                
                self.resetTableView()
                self.initialSnapshot = snapshot
                self.lastSnapshot = snapshot.last!
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    //                    let documentID = eachDocument.documentID
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
    
    func  fetchAnotherBatch() {
        print("Fetching another batch")
        FireStoreManager.fetchProgramsOrderedBySubscriptionsFrom(lastSnapshot: lastSnapshot!, limit: 10) { snapshots in
            
            if snapshots.count == 0 {
                self.moreToLoad = false
            } else {
                
                self.lastSnapshot = snapshots.last!
                var counter = 0
                
                for eachDocument in snapshots {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let documentID = eachDocument.documentID
                    let imageID = data["imageID"] as? String
                    
                    if User.isPublisher! && documentID == CurrentProgram.ID! {
                        print("Skipping program")
                    } else if imageID != nil {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                    }
                    
                    if counter == snapshots.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func createCategoryPills() {
        for each in Category.allCases {
            let button = categoryPill()
            button.setTitle(each.rawValue, for: .normal)
            button.addTarget(self, action: #selector(categorySelection), for: .touchUpInside)
            searchContentStackView.addArrangedSubview(button)
            searchContentWidth += button.intrinsicContentSize.width
        }
    }
    
    func categoryPill() -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.sixthShade
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 2, right: 10)
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
    
    func configureViews() {
        view.addSubview(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        pillsHeightConstraint = searchScrollView.topAnchor.constraint(equalTo: view.topAnchor)
        pillsHeightConstraint.isActive = true
        searchScrollView.heightAnchor.constraint(equalToConstant:40.0).isActive = true
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
        searchContentStackView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        searchContentStackView.trailingAnchor.constraint(equalTo: searchScrollView.trailingAnchor, constant: -16).isActive = true
        searchContentStackView.widthAnchor.constraint(equalToConstant: searchContentWidth + (pillSpacing * CGFloat(searchContentStackView.arrangedSubviews.count + 14))).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchScrollView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.bringSubviewToFront(searchScrollView)
        
        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
    }
    
    // MARK: Category Selection
    @objc func categorySelection(sender: UIButton) {
        currentMode = .category
        resetTableView()
        let category = sender.titleLabel!.text!
        categorySelected = category
        
        FireStoreManager.fetchProgramsWithinCategory(limit: 10, category: category) { snapshot in
            
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
        print("Fetching another batch for category")
        FireStoreManager.fetchMoreProgramsWithinCategoryFrom(lastSnapshot: lastSnapshot!, limit: 10, category: categorySelected!) { snapshot in
            
            if snapshot.count == 0 {
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
                    
                    if User.isPublisher! && documentID == CurrentProgram.ID! {
                        print("Skipping program")
                    } else if imageID != nil {
                         let program = Program(data: data)
                        if !self.downloadedPrograms.contains(where: { $0.ID == program.ID }) {
                             self.downloadedPrograms.append(program)
                        }
                    }
                    
                    if counter == snapshot.count {
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
            print("The count is \(filteredPrograms.count)")
            return filteredPrograms.count
          }
        return downloadedPrograms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
        programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
        programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
        programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
        
        var program: Program
        if isFiltering {
            program = filteredPrograms[indexPath.row]
        } else {
            program = downloadedPrograms[indexPath.row]
        }
        
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
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 90.0 {
            switch currentMode {
            case .all:
                if moreToLoad == true {
                    fetchAnotherBatch()
                }
            case .category:
                if moreToLoad == true {
                    fetchAnotherBatchOfCategory()
                }
            case .episode:
                break
            }
            
        }
    }
}

extension SearchVC: ProgramCellDelegate {
   
    func tagSelected(tag: String) {
        isGoingForward = true
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
            isGoingForward = true
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
        activeProgramCell = cell

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

extension SearchVC: PlaybackBarDelegate {
   
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType) {
        guard let cell = activeProgramCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        let cell = tableView.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! ProgramCell
        cell.playbackBarView.setupPlaybackBar()
        activeProgramCell = cell
    }
}

extension SearchVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.filterContentForSearchText(searchBar.text!)
        
//        if isFiltering && !isSearchBarEmpty {
//            searchButtons.isHidden = false
//            searchScrollView.isHidden = true
//        }

        FireStoreManager.searchForProgramStartingWith(string: searchBar.text!) { results in

            if results.count != 0 {
                for each in results {
                    let data = each.data()
                    let program = Program(data: data)
                    if !self.downloadedPrograms.contains(where: { $0.ID == program.ID }) {
                         self.downloadedPrograms.append(program)
                    }
                }
            }
        }
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
//                searchScrollView.isHidden = false
//        searchButtons.isHidden = true
//    }
//
 
}
