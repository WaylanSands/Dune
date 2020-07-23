//
//  BlockedRequestsVC.swift
//  Dune
//
//  Created by Waylan Sands on 22/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class RemovedRequestsVC: UIViewController {
    
    var subChannel: Program?
    var removedIDs: [String]
    var downloadedChannels = [Program]()
    var requestDelegate: RequestsDelegate!
    
    let tableView = UITableView()
    
    let loadingView = TVLoadingAnimationView(topHeight: UIDevice.current.navBarHeight() + 20)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Removed requests"
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let noneRemovedView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let noneRemovedLabel: UILabel = {
        let label = UILabel()
        label.text = "No removed requests"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let noneRemovedSubLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Requests you remove from pending invites will appear here. If you change your mind."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fifthShade
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    required init(deniedIDs: [String]) {
        self.removedIDs = deniedIDs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noneRemovedView.isHidden = true
        loadingView.isHidden = false
        configureNavigation()
        fetchPendingPrograms()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let channel = subChannel {
            requestDelegate.updateChannelWith(channel)
        }
        resetTableView()
    }
    
    func configureNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureDelegates() {
        tableView.register(RemovedInviteCell.self, forCellReuseIdentifier: "removeInviteCell")
        tableView.rowHeight = 70.0
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.addTopBounceAreaView()
        tableView.tableFooterView = UIView()
        
        view.addSubview(noneRemovedView)
        noneRemovedView.translatesAutoresizingMaskIntoConstraints = false
        noneRemovedView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noneRemovedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noneRemovedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noneRemovedView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.tableFooterView = UIView()
        
        noneRemovedView.addSubview(noneRemovedLabel)
        noneRemovedLabel.translatesAutoresizingMaskIntoConstraints = false
        noneRemovedLabel.topAnchor.constraint(equalTo: noneRemovedView.topAnchor).isActive = true
        noneRemovedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noneRemovedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noneRemovedLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        noneRemovedView.addSubview(noneRemovedSubLabel)
        noneRemovedSubLabel.translatesAutoresizingMaskIntoConstraints = false
        noneRemovedSubLabel.topAnchor.constraint(equalTo: noneRemovedLabel.bottomAnchor).isActive = true
        noneRemovedSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        noneRemovedSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        view.addSubview(loadingView)
        loadingView.pinEdges(to: view)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func resetTableView() {
        downloadedChannels = []
        tableView.reloadData()
    }
    
    func fetchPendingPrograms() {
        FireStoreManager.fetchRemovedInvitesWith(channelIDs: removedIDs)
        { [unowned self] channels in
            print("Returned with removed: \(channels)")
            if !channels.isEmpty {
                self.downloadedChannels = channels
                self.tableView.reloadData()
                self.loadingView.isHidden = true
            } else {
                self.noneRemovedView.isHidden = false
                self.loadingView.isHidden = true
            }
        }
    }
    
}

extension RemovedRequestsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        downloadedChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = downloadedChannels[indexPath.row]
        let deniedCell = tableView.dequeueReusableCell(withIdentifier: "removeInviteCell") as! RemovedInviteCell
        deniedCell.allowButton.addTarget(deniedCell, action: #selector(RemovedInviteCell.allowPress), for: .touchUpInside)
        deniedCell.setupCellWith(channel: channel)
        deniedCell.inviteCellDelegate = self
        return deniedCell
    }
    
}

extension RemovedRequestsVC: InviteCellDelegate {
    
    func returnAllowedFor(_ ID: String) {
        removedIDs.append(ID)
        if subChannel != nil {
            subChannel!.subscriberIDs.removeAll(where: { $0 == ID })
            subChannel!.deniedChannels.removeAll(where: { $0 == ID })
            FireStoreManager.returnAllowedFor(ID, for: subChannel!)
            subChannel!.pendingChannels.append(ID)
            subChannel!.subscriberCount -= 1
        } else {
            FireStoreManager.returnAllowedFor(ID)
        }
    }
    
    func returnRemovedFor(_ ID: String) {
        removedIDs.append(ID)
        if subChannel != nil {
            subChannel!.pendingChannels.removeAll(where: { $0 == ID })
            subChannel!.subscriberIDs.removeAll(where: { $0 == ID })
            FireStoreManager.returnRemovedFor(ID, for: subChannel!)
            subChannel!.deniedChannels.append(ID)
        } else {
            FireStoreManager.returnRemovedFor(ID)
        }
    }
    
    
    func approveRequestFor(_ ID: String) {
        removedIDs.removeAll(where: {$0 == ID})
        if subChannel != nil {
            subChannel!.deniedChannels.removeAll(where: { $0 == ID })
            subChannel!.pendingChannels.removeAll(where: { $0 == ID })
            FireStoreManager.approveRequestFor(ID, for: subChannel!)
            subChannel!.subscriberIDs.append(ID)
            subChannel!.subscriberCount += 1
        } else {
            FireStoreManager.approveRequestFor(ID)
        }
    }
    
    func denyRequestFor(_ ID: String) {
        removedIDs.removeAll(where: {$0 == ID})
        if subChannel != nil {
            subChannel!.subscriberIDs.removeAll(where: { $0 == ID })
            subChannel!.pendingChannels.removeAll(where: { $0 == ID })
            FireStoreManager.denyRequestFor(ID, for: subChannel!)
            subChannel!.deniedChannels.append(ID)
        } else {
            FireStoreManager.denyRequestFor(ID)
        }
    }
    
}
