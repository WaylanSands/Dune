//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


class MainFeedVC: UIViewController {
    
    struct Cells {
        static let regularCell = "regularCell"
        static let socialCell = "socialCell"
    }
    
    var tappedPrograms: [String] = []
    var programs: [Program] = []
    let tableView = UITableView()
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "23 Feb"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programs = StubbedPrograms.programs
        setTableViewDelegates()
        configureViews()
        setupTopBar()
        tableView.register(RegularFeedCell.self, forCellReuseIdentifier: Cells.regularCell)
    }
    
    func setupTopBar() {
        navigationItem.title = "Daily Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationController!.isNavigationBarHidden = true
        
        tableView.addSubview(currentDateLabel)
        currentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentDateLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        currentDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureViews() {
        view.addSubview(tableView)
        tableView.pinEdges(to: view)

    }
}

extension MainFeedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regularCell = tableView.dequeueReusableCell(withIdentifier: Cells.regularCell) as! RegularFeedCell
        let program = programs[indexPath.row]
        regularCell.normalSetUp(program: program)
        regularCell.moreButton.addTarget(regularCell, action: #selector(RegularFeedCell.moreUnwrap), for: .touchUpInside)
        regularCell.updateRowsDelegate = self
                
        if tappedPrograms.contains(programs[indexPath.row].name) {
            regularCell.refreshSetupMoreTapTrue()
            return regularCell
        } else {
            regularCell.refreshSetupMoreTapFalse()
            return regularCell
        }
    }
    
//    func configurePlayBar() {
//        let playbar = PlayBar(episode: )
//
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
}

extension MainFeedVC: UpdateRowsDelegate {
    
    func addtappedProgram(programName: String) {
        tappedPrograms.append(programName)
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            print("ROWS UPDATED")
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}

