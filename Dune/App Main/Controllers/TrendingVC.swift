//
//  PlaylistVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class TrendingVC: UIViewController {
    
    let loadingView = TVLoadingAnimationView(topHeight: 150)
    var initialSnapshot = [QueryDocumentSnapshot]()
    var downloadedEpisodes = [Episode]()
    var lastSnapshot: DocumentSnapshot?
    var moreToLoad = true
    
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
        configureDelegates()
        configureViews()
        addLoadingView()
        setupTopBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.setScrollBarToTopLeft()
        fetchTrendingEpisodes()
    }
    
    func setupTopBar() {
        navigationItem.title = "Trending"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.addSubview(currentDateLabel)
        currentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentDateLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        currentDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
    func configureDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
    }
    
    func configureViews() {
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func resetTableView() {
        addLoadingView()
        downloadedEpisodes = []
        initialSnapshot = []
        lastSnapshot = nil
        moreToLoad = true
    }
    
    func fetchTrendingEpisodes() {
        print("Fetching trending episodes")
        FireStoreManager.fetchTrendingEpisodesWith(limit: 10) { snapshot in
            
            if snapshot.count == 0 {
                self.moreToLoad = false
            } else if self.initialSnapshot != snapshot {
                            
                self.resetTableView()
                self.initialSnapshot = snapshot
                self.lastSnapshot = snapshot.last!
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let episode = Episode(data: data)
                    
                    self.downloadedEpisodes.append(episode)
                    
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
        FireStoreManager.fetchTrendingEpisodesFrom(lastSnapshot: lastSnapshot!, limit: 10) { snapshots in
            
            if snapshots.count == 0 {
                self.moreToLoad = false
            } else {
                
                self.lastSnapshot = snapshots.last!
                var counter = 0
                
                for eachDocument in snapshots {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let episode = Episode(data: data)
                    
                    self.downloadedEpisodes.append(episode)
                    
                    if counter == snapshots.count {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    
}

extension TrendingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        episodeCell.programImageButton.addTarget(episodeCell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        episodeCell.episodeSettingsButton.addTarget(episodeCell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        episodeCell.likeButton.addTarget(episodeCell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)

        let episode = downloadedEpisodes[indexPath.row]
        episodeCell.episode = episode
        if episode.likeCount >= 10 {
            episodeCell.configureCellWithOptions()
        }
        episodeCell.cellDelegate = self
        episodeCell.normalSetUp(episode: episode)
        return episodeCell
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

extension TrendingVC: EpisodeCellDelegate {
    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }
    
    func playEpisode(cell: EpisodeCell) {
        let index = tableView.indexPath(for: cell)
        print(index!)
    }
    
    func showSettings(cell: EpisodeCell) {
        let index = tableView.indexPath(for: cell)
        print(index!)
    }
    
    
    func addTappedProgram(programName: String) {
        //        tappedPrograms.append(programName)
    }
    
    func updateRows() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }
}



