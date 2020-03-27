//
//  AddBGMusicVC.swift
//  Dune
//
//  Created by Waylan Sands on 26/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AddBGMusicVC: UIViewController {
    
    lazy var tabBar = navigationController?.tabBarController?.tabBar
    let tableView = UITableView()
    let backgroundMusic = BackgroundMusicOptions.musicOptions
    var cells: [BackgroundMusicCell] = []
    var activeCell: BackgroundMusicCell?
    var selectedCell: BackgroundMusicCell?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onboardingBlack
        setupNavigationBar()
        setTableViewDelegates()
        configureViews()
        tableView.register(BackgroundMusicCell.self, forCellReuseIdentifier: "musicCell")
        tableView.rowHeight = 66
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Add Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tabBarController?.navigationController!.isNavigationBarHidden = true
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.barButtonAttributes
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        for each in cells {
//            if each.isSelectedCell {
//                selectedCell = each
//                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
//                navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
//            }
//        }
//    }
    
    func resetSelectedCell() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetViews()
    }
    
    func resetViews() {
        
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureViews() {
//        view.addSubview(customNav)
//        customNav.pinNavBarTo(view)
        
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = CustomStyle.onboardingBlack
        
//        view.bringSubviewToFront(customNav)
    }
    
    @objc func selectButtonPress() {
        print("Selected pressed")
        
        if activeCell != selectedCell {
            selectedCell?.isDeselected()
        }
        
        selectedCell = activeCell
        selectedCell?.cellSelected()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        Episode.trackOption = selectedCell!.track
    }
    
    @objc func removeButtonPress() {
        selectedCell?.isDeselected()
        selectedCell = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        Episode.trackOption = nil
    }
    
}

extension AddBGMusicVC: UITableViewDelegate, UITableViewDataSource, musicOptionDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = tableView.dequeueReusableCell(withIdentifier: "musicCell") as! BackgroundMusicCell
        let track = backgroundMusic[indexPath.row]
        musicCell.cellContentButton.addTarget(musicCell, action: #selector(BackgroundMusicCell.cellPressed), for: .touchUpInside)
        musicCell.setupCellWith(track)
        musicCell.delegate = self
        
        if musicCell.track == Episode.trackOption {
            musicCell.cellSelected()
            selectedCell = musicCell
            resetSelectedCell()
        }
        
        cells.append(musicCell)
        return musicCell
    }
    
    func activatePressedCell(sender: BackgroundMusicCell) {
        for each in cells {
            if each != selectedCell {
                each.deactivateCell()
            }
        }
        sender.activateCell()
        activeCell = sender
        
        if sender == selectedCell {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        } else {
            print("added")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        }
    }
}

protocol musicOptionDelegate {
    func activatePressedCell(sender: BackgroundMusicCell)
}

