//
//  SearchVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var searchContenWidth: CGFloat = 0
    var pillSpacing: CGFloat = 7
    
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
        configureViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createCategoryPills() {
        for each in Categories.allCases {
            let button = categoryPill()
            button.setTitle(each.rawValue, for: .normal)
            searchContentStackView.addArrangedSubview(button)
            searchContenWidth += button.intrinsicContentSize.width
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
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchTextField.textColor = CustomStyle.primaryblack
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
        tableView.rowHeight = 100
        
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
        searchContentStackView.widthAnchor.constraint(equalToConstant: searchContenWidth + (pillSpacing * CGFloat(searchContentStackView.arrangedSubviews.count + 14))).isActive = true

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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var view = UIView()
//        view = searchController.searchBar
//        view.backgroundColor = .red
//        return view
//    }
    

}
