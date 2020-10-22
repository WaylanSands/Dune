//
//  PendingRequestsVC.swift
//  Dune
//
//  Created by Waylan Sands on 22/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol RequestsDelegate {
    func updateChannelWith(_ channel: Program)
}

class PendingRequestsVC: UIViewController {
    
    var subChannel: Program?
    var pendingIDs: [String]
    var downloadedChannels = [Program]()
    var requestDelegate: RequestsDelegate!
        
    let tableView = UITableView()
    
    let loadingView = TVLoadingAnimationView(topHeight: UIDevice.current.navBarHeight() + 20)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.backgroundColor = CustomStyle.blackNavBar
        nav.titleLabel.text = "Pending requests"
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let noRequestsView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    let noRequestsLabel: UILabel = {
       let label = UILabel()
        label.text = "No pending requests"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let noRequestsSubLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.text = "The privacy icon on your account screen will highlight when requests are pending."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fifthShade
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    required init(pendingIDs: [String]) {
        self.pendingIDs = pendingIDs
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
        noRequestsView.isHidden = true
        loadingView.isHidden = false
        configureNavigation()
        fetchPendingPrograms()
        print("Will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let channel = subChannel {
            requestDelegate.updateChannelWith(channel)
        }
        resetTableView()
    }
    
    func configureNavigation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Removed", style: .plain, target: self, action: #selector(blockedRequests))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)], for: .normal)
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
        tableView.register(PendingInviteCell.self, forCellReuseIdentifier: "pendingInviteCell")
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
        
        view.addSubview(noRequestsView)
        noRequestsView.translatesAutoresizingMaskIntoConstraints = false
        noRequestsView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noRequestsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noRequestsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noRequestsView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        tableView.backgroundColor = CustomStyle.secondShade
        tableView.tableFooterView = UIView()
        
        noRequestsView.addSubview(noRequestsLabel)
        noRequestsLabel.translatesAutoresizingMaskIntoConstraints = false
        noRequestsLabel.topAnchor.constraint(equalTo: noRequestsView.topAnchor).isActive = true
        noRequestsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        noRequestsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        noRequestsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        noRequestsView.addSubview(noRequestsSubLabel)
        noRequestsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        noRequestsSubLabel.topAnchor.constraint(equalTo: noRequestsLabel.bottomAnchor).isActive = true
        noRequestsSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        noRequestsSubLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
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
        FireStoreManager.fetchPendingInvitesWith(pendingChannelIDs: pendingIDs) { [unowned self] channels in
            if !channels.isEmpty {
                self.downloadedChannels = channels
                self.tableView.reloadData()
                self.loadingView.isHidden = true
            } else {
                self.noRequestsView.isHidden = false
                self.noRequestsView.isHidden = false
                self.loadingView.isHidden = true
            }
        }
    }
    
    @objc func blockedRequests() {
        var blockedRequests: RemovedRequestsVC
        if let IDs = subChannel?.deniedChannels {
            blockedRequests = RemovedRequestsVC(deniedIDs: IDs)
        } else {
            blockedRequests = RemovedRequestsVC(deniedIDs: CurrentProgram.deniedChannels!)
        }
        blockedRequests.requestDelegate = self
        blockedRequests.subChannel = subChannel
        navigationController?.pushViewController(blockedRequests, animated: true)
    }

}

extension PendingRequestsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        downloadedChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = downloadedChannels[indexPath.row]
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "pendingInviteCell") as! PendingInviteCell
        requestCell.removeButton.addTarget(requestCell, action: #selector(PendingInviteCell.removePress), for: .touchUpInside)
        requestCell.allowButton.addTarget(requestCell, action: #selector(PendingInviteCell.allowPress), for: .touchUpInside)
        requestCell.setupCellWith(channel: channel)
        requestCell.inviteCellDelegate = self
        return requestCell
    }
    
}

extension PendingRequestsVC: InviteCellDelegate {
  
    func returnAllowedFor(_ ID: String) {
        pendingIDs.append(ID)
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
        pendingIDs.append(ID)
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
        pendingIDs.removeAll(where: {$0 == ID})
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
        pendingIDs.removeAll(where: {$0 == ID})
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

extension PendingRequestsVC: RequestsDelegate {
    
    func updateChannelWith(_ channel: Program) {
        subChannel = channel
    }

}
