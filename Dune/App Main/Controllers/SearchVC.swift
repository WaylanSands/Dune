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
    
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var searchContentWidth: CGFloat = 0
    var pillSpacing: CGFloat = 7
   
    let loadingView = TVLoadingAnimationView(topHeight: 20)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedPrograms = [Program]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    
    let searchScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
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
        view.backgroundColor = CustomStyle.darkestBlack
        setupSearchController()
        createCategoryPills()
        configureDelegates()
        configureViews()
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchScrollView.setScrollBarToTopLeft()
        fetchTopPrograms()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        resetTableView()
    }
    
    func configureDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedPrograms = []
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
                    let documentID = eachDocument.documentID
                    
                    if User.isPublisher! && documentID == CurrentProgram.ID! {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                    } else {
                        let program = Program(data: data)
                        self.downloadedPrograms.append(program)
                        print(program.name)
                    }
                    
                    if counter == snapshot.count {
                        self.tableView.reloadData()
                        self.loadingView.removeFromSuperview()
                    }
                }
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
                
                if User.isPublisher! && documentID != CurrentProgram.ID! {
                    let program = Program(data: data)
                    self.downloadedPrograms.append(program)
                } else {
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
        for each in Categories.allCases {
            let button = categoryPill()
            button.setTitle(each.rawValue, for: .normal)
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
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchTextField.textColor = CustomStyle.primaryBlack
        searchController.searchBar.searchTextField.backgroundColor = .white
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.isTranslucent = false
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
    }
    
    func configureViews() {
        view.addSubview(searchScrollView)
        searchScrollView.translatesAutoresizingMaskIntoConstraints = false
        searchScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchScrollView.heightAnchor.constraint(equalToConstant:40.0).isActive = true
        searchScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
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
    }
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //TO DO
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedPrograms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
        programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
        programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playEpisode), for: .touchUpInside)
        programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
        
        let program = downloadedPrograms[indexPath.row]
        programCell.program = program
        
        //        program.cellDelegate = self
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
            if moreToLoad == true {
            fetchAnotherBatch()
            }
        }
    }
    
    
}
