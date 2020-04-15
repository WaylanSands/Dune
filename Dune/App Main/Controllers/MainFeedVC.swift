//
//  MainFeedVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class MainFeedVC: UIViewController {
    
    struct Cells {
        static let regularCell = "regularCell"
        static let socialCell = "socialCell"
    }
    
    var subscriptionIDs: [String] = []
    let db = Firestore.firestore()
    var episodeIDs: [String] = []
    var episodes: [Episode] = []
    var downloadedEps: [Episode] = [Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"), Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"),Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello"),Episode(id: "hello", image: #imageLiteral(resourceName: "fast-news-business"), programName: "hello", username: "hello", caption: "hello", tags: ["hello"], programID: "hello", ownerID: "hello")]
    
    var tappedPrograms: [String] = []
    var subscriptions: [String] = []
    var programs: [Program] = []
    let tableView = UITableView()
    let loadingView = TVLoadingAnimationView()
    
    let currentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "23 Feb"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let noSubsLabel: UILabel = {
        let label = UILabel()
        label.text = "Subscribe to programs for episodes to show up here"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.textColor = CustomStyle.fourthShade
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        addLoadingView()
        configureViews()
        configureDelegates()
        //      programs = StubbedPrograms.programs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
        //        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavbarAttributes
    }
    
    func configureNavigation() {
        UINavigationBar.appearance().titleTextAttributes = CustomStyle.blackNavbarAttributes
        navigationItem.title = "Daily Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
    }
    
    func getUserData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { (snapshot, error) in
            if error != nil {
                print("There was an error getting users document: \(error!)")
            } else {
                guard let data = snapshot?.data() else { return }
                User.modelUser(data: data)
                print("Model created")
                self.checkUserHasSubscriptions()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func checkUserHasSubscriptions() {
        if User.subscriptionIDs == nil || User.subscriptionIDs?.count == 0 {
            print("User has no subscriptions")
            tableView.isHidden = true
            noSubsLabel.isHidden = false
            navigationItem.title = ""
        } else {
            tableView.isHidden = false
            noSubsLabel.isHidden = true
            navigationItem.title = "Daily Feed"
            FireStoreManager.getEpisodesFromPrograms { (ids) in
                print(ids)
                self.episodeIDs = ids
                self.tableView.reloadData()
            }
        }
    }
    
    func addLoadingView() {
        view.addSubview(loadingView)
        loadingView.pinEdges(to: view)
    }
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(noSubsLabel)
        noSubsLabel.translatesAutoresizingMaskIntoConstraints = false
        noSubsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noSubsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        noSubsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        //  noSubsLabel.heightAnchor.constraint(equalToConstant: 60)
        
        view.addSubview(tableView)
        view.sendSubviewToBack(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = .white
        
        tableView.addSubview(currentDateLabel)
        currentDateLabel.translatesAutoresizingMaskIntoConstraints = false
        currentDateLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -10).isActive = true
        currentDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    func configureDelegates() {
        tableView.prefetchDataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EpisodeFeedCell.self, forCellReuseIdentifier: Cells.regularCell)
    }
    
    func downloadEpisode(forItemAtIndex index: Int) {
        let epID = episodeIDs[index]
         print("here \(epID)")
        FireStoreManager.getEpisodedataWith(ID: epID) { (data) in
                        
            let id = data["ID"] as! String
            let imageURLString = data["imageURL"] as! String
            let url = URL(fileURLWithPath: imageURLString)
            let image = self.downloadImage(from: url)
            let programName = data["programName"] as! String
            let username = data["username"] as! String
            let caption = data["caption"] as! String
            let tags = data["tags"] as! [String]?
            let programID = data["programID"] as! String
            let ownerID = data["ownerID"] as! String
            
            let newEp = Episode(
                id: id,
                image: image,
                programName: programName,
                username: username,
                caption: caption,
                tags: tags,
                programID: programID,
                ownerID: ownerID
            )
            self.downloadedEps.append(newEp)
            print("The number of eps is \(self.downloadedEps.count)")
            print("Downloaded")
        }
    }
    
    
    func downloadImage(from url: URL) -> UIImage {
        print("Download Started")
        var sageImage = UIImage()
        let data = try? Data(contentsOf: url)
        
        if let imageData = data {
            if let image = UIImage(data: imageData) {
                sageImage = image
            }
        }
        return sageImage
    }
}

extension MainFeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("HEEERRREEEE Number of rows is \(downloadedEps.count)")
        return downloadedEps.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("The row is \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = tableView.dequeueReusableCell(withIdentifier: Cells.regularCell) as! EpisodeFeedCell
        let episode = downloadedEps[indexPath.row]
        episodeCell.normalSetUp(episode: episode)
        episodeCell.moreButton.addTarget(episodeCell, action: #selector(EpisodeFeedCell.moreUnwrap), for: .touchUpInside)
        episodeCell.updateRowsDelegate = self
//        print("The row is \(indexPath.row)")
        
        //        if tappedPrograms.contains(programs[indexPath.row].name) {
        //            regularCell.refreshSetupMoreTapTrue()
        //            return regularCell
        //        } else {
        //            regularCell.refreshSetupMoreTapFalse()
        //            return regularCell
        //        }
        return episodeCell
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

extension MainFeedVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("prefetch rows \(indexPaths)")
        for each in indexPaths {
            if each.row < episodeIDs.count {
                print("hit downloading")
                downloadEpisode(forItemAtIndex: each.row)
            }
        }
    }
    
    
}

