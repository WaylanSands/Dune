//
//  AccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    
    struct Cells {
        static let regularCell = "regularCell"
        static let socialCell = "socialCell"
    }
    
    var topSectionHeightConstraint: NSLayoutConstraint!
    var tableHeaderTrailingAnchor: NSLayoutConstraint!
    
    var likedTVBottomConstraint: NSLayoutConstraint!
    var sharedTVBottomConstraint: NSLayoutConstraint!
    var subscriptionTVBottomConstraint: NSLayoutConstraint!
    
    var topSectionHeightMin: CGFloat = UIApplication.shared.statusBarFrame.height
    var topSectionHeightMax: CGFloat = 270
    let tableView = UITableView()
//    var programs: [CurrentProgram] = []
    var tappedPrograms: [String] = []
    var userDetailsYPosition: CGFloat = 125
    var statsYPosition: CGFloat = -80.0
    lazy var headerBarButtons: [UIButton] = [subscriptionsButton, savedButton, mentionsButton]
    
    var subscriptionIDs = [String]()
    var programIDs = [String]()
    
    let introPlayer = DuneIntroPlayer()
    var activeProgramCell: ProgramCell?
    
    let audioPlayer = DuneAudioPlayer()
    
    var likedEpisodes = [Episode]()
    let likedEpisodeTV = UITableView()

    var sharedEpisodes = [Episode]()
    let sharedEpisodeTV = UITableView()
    
    var subscriptions = [Program]()
    let subscriptionTV = UITableView()
    
    let likedTVLoadingView = TVLoadingAnimationView(topHeight: 15)
    let sharedTVLoadingView = TVLoadingAnimationView(topHeight: 15)
    let subscriptionTVLoadingView = TVLoadingAnimationView(topHeight: 15)
    
    let flexView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let topSectionFade: PassThoughView = {
        let view = PassThoughView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let userStackedView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let userImage: UIImageView = {
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(presentEditProfile))
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRec)
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.frame.size = CGSize(width: 70.0, height: 70.0)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.alpha = 0.3
        return label
    }()
    
    let headerTopStroke: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: view.frame.width, height: 5)
        view.backgroundColor = CustomStyle.sixthShade
        return view
    }()
    
    let tableHeader: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let headerStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        return view
    }()
    
    let statsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        return view
    }()
    
    let subscriptionStackedView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        return view
    }()
    
    let likedStackedView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        return view
    }()
    
    let mentionedStackedView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        return view
    }()
    
    let savedStat: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.text = "12"
        return label
    }()
    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.text = "Liked"
        return label
    }()
    
    let subscriptionsStat: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.text = "22"
        return label
    }()
    
    let subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.text = "Subscriptions"
        return label
    }()
    
    let mentionsStat: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.text = "2"
        return label
    }()
    
    let mentionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.text = "Shared"
        return label
    }()
    
    let subscriptionsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Subscriptions", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let savedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Comments", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let mentionsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Liked", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let whiteBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Custom NavBar
    
    lazy var customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .clear
        nav.rightButton.setImage(#imageLiteral(resourceName: "white-settings-icon"), for: .normal)
        nav.rightButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        return nav
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onBoardingBlack
        configureDelegates()
        styleForScreens()
        configureViews()
        addSubscriptionLoadingView()
        setupTopBar()

         if User.subscriptionIDs!.count > 0 {
              fetchSubscriptions()
         }
        
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: Cells.regularCell)
        tableView.backgroundColor = .clear
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userImage.image = User.image
        nameLabel.text = User.displayName
        usernameLabel.text = "@\(User.username!)"
        
        if User.subscriptionIDs!.count > 0 && subscriptions.count != User.subscriptionIDs!.count {
             fetchSubscriptions()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tableViewTabButtonPress(sender: subscriptionsButton)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = topSectionHeightConstraint.constant - y
        var percentage: CGFloat = 100
        let headerHeight : CGFloat = topSectionHeightMax / 200
        let currentHeight : CGFloat = newHeaderViewHeight / 200
        
        if newHeaderViewHeight > topSectionHeightMax {
            percentage = (currentHeight - y) / headerHeight
            userStackedView.alpha = percentage
            statsStackedView.alpha = percentage
            topSectionFade.alpha = 1 - percentage
            headerTopStroke.alpha = percentage
            topSectionHeightConstraint.constant = topSectionHeightMax
        } else if newHeaderViewHeight <= topSectionHeightMin {
            topSectionHeightConstraint.constant = topSectionHeightMin
            tableHeaderTrailingAnchor.constant = -40
            percentage = (currentHeight - y) / headerHeight
            userStackedView.alpha = percentage
            statsStackedView.alpha = percentage
            topSectionFade.alpha = 1 - percentage
            headerTopStroke.alpha = percentage
            headerTopStroke.isHidden = true
            customNavBar.leftButton.alpha = 0
        } else {
            percentage = (currentHeight - y) / headerHeight
            topSectionHeightConstraint.constant = newHeaderViewHeight
            tableHeaderTrailingAnchor.constant = 0
            userStackedView.alpha = percentage
            statsStackedView.alpha = percentage
            topSectionFade.alpha = 1 - percentage
            headerTopStroke.alpha = percentage
            headerTopStroke.isHidden = false
            customNavBar.leftButton.alpha = percentage
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhoneSE:
            userDetailsYPosition = 60
            statsYPosition = -60
            topSectionHeightMax = 240
        case .iPhone8:
            userDetailsYPosition = 60
            statsYPosition = -70
            topSectionHeightMax = 260
        case .iPhone8Plus:
            userDetailsYPosition = 60
            statsYPosition = -70
            topSectionHeightMax = 260
        case .iPhone11:
            userDetailsYPosition = 100
            statsYPosition = -80
            topSectionHeightMax = 320
        case .iPhone11Pro:
            userDetailsYPosition = 100
            statsYPosition = -80
            topSectionHeightMax = 320
        case .iPhone11ProMax:
            userDetailsYPosition = 100
            statsYPosition = -80
            topSectionHeightMax = 320
        default:
            break
        }
    }
    
    func configureDelegates() {
        likedEpisodeTV.delegate = self
        likedEpisodeTV.dataSource = self
        likedEpisodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        
        sharedEpisodeTV.delegate = self
        sharedEpisodeTV.dataSource = self
        likedEpisodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        
        subscriptionTV.delegate = self
        subscriptionTV.dataSource = self
        subscriptionTV.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
    }
    
    func setupTopBar() {
        self.navigationController!.isNavigationBarHidden = true
    }
    
    func configureViews() {
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        
        view.addSubview(flexView)
        flexView.translatesAutoresizingMaskIntoConstraints = false
        flexView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        flexView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        flexView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topSectionHeightConstraint = flexView.heightAnchor.constraint(equalToConstant: topSectionHeightMax)
        topSectionHeightConstraint.isActive = true
        
        view.addSubview(topSectionFade)
        topSectionFade.translatesAutoresizingMaskIntoConstraints = false
        topSectionFade.topAnchor.constraint(equalTo: flexView.topAnchor).isActive = true
        topSectionFade.leadingAnchor.constraint(equalTo: flexView.leadingAnchor).isActive = true
        topSectionFade.trailingAnchor.constraint(equalTo: flexView.trailingAnchor).isActive = true
        topSectionFade.bottomAnchor.constraint(equalTo: flexView.bottomAnchor).isActive = true
        topSectionFade.alpha = 0
        
        // User details
        
        view.addSubview(userStackedView)
        userStackedView.translatesAutoresizingMaskIntoConstraints = false
        userStackedView.topAnchor.constraint(equalTo: view.topAnchor, constant: userDetailsYPosition).isActive = true
        userStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        userStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        userStackedView.addArrangedSubview(userImage)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.widthAnchor.constraint(equalToConstant: 70) .isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        userStackedView.addArrangedSubview(nameLabel)
        userStackedView.addArrangedSubview(usernameLabel)
        
        // Stats View
        
        flexView.addSubview(statsStackedView)
        statsStackedView.translatesAutoresizingMaskIntoConstraints = false
        statsStackedView.topAnchor.constraint(equalTo: userStackedView.bottomAnchor, constant: 30 ).isActive = true
        statsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        statsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        statsStackedView.addArrangedSubview(subscriptionStackedView)
        subscriptionStackedView.addArrangedSubview(savedStat)
        subscriptionStackedView.addArrangedSubview(savedLabel)
        
        statsStackedView.addArrangedSubview(likedStackedView)
        likedStackedView.addArrangedSubview(subscriptionsStat)
        likedStackedView.addArrangedSubview(subscriptionsLabel)
        
        statsStackedView.addArrangedSubview(mentionedStackedView)
        mentionedStackedView.addArrangedSubview(mentionsStat)
        mentionedStackedView.addArrangedSubview(mentionsLabel)
        
        view.addSubview(tableHeader)
        tableHeader.translatesAutoresizingMaskIntoConstraints = false
        tableHeader.topAnchor.constraint(equalTo: flexView.bottomAnchor).isActive = true
        tableHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableHeaderTrailingAnchor = tableHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        tableHeaderTrailingAnchor.isActive = true
        tableHeader.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        tableHeader.addSubview(headerTopStroke)
        headerTopStroke.translatesAutoresizingMaskIntoConstraints = false
        headerTopStroke.topAnchor.constraint(equalTo: tableHeader.topAnchor).isActive = true
        headerTopStroke.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headerTopStroke.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerTopStroke.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // Table Views
        
        view.addSubview(sharedEpisodeTV)
        sharedEpisodeTV.translatesAutoresizingMaskIntoConstraints = false
        sharedEpisodeTV.topAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        sharedEpisodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sharedEpisodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sharedTVBottomConstraint = sharedEpisodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        sharedTVBottomConstraint.isActive = true
        sharedEpisodeTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        view.addSubview(likedEpisodeTV)
        likedEpisodeTV.translatesAutoresizingMaskIntoConstraints = false
        likedEpisodeTV.topAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        likedEpisodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        likedEpisodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        likedTVBottomConstraint = likedEpisodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        likedTVBottomConstraint.isActive = true
        likedEpisodeTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        view.addSubview(subscriptionTV)
        subscriptionTV.translatesAutoresizingMaskIntoConstraints = false
        subscriptionTV.topAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        subscriptionTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subscriptionTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subscriptionTVBottomConstraint = subscriptionTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        subscriptionTVBottomConstraint.isActive = true
        subscriptionTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        view.addSubview(whiteBottom)
        whiteBottom.translatesAutoresizingMaskIntoConstraints = false
        whiteBottom.topAnchor.constraint(equalTo: view.bottomAnchor,constant: -200).isActive = true
        whiteBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        whiteBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        whiteBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.sendSubviewToBack(whiteBottom)
        
        tableHeader.addSubview(headerStackedView)
        headerStackedView.translatesAutoresizingMaskIntoConstraints = false
        headerStackedView.topAnchor.constraint(equalTo: tableHeader.topAnchor).isActive = true
        headerStackedView.leadingAnchor.constraint(equalTo: tableHeader.leadingAnchor, constant: 16).isActive = true
        headerStackedView.trailingAnchor.constraint(equalTo: tableHeader.trailingAnchor, constant: -16).isActive = true
        headerStackedView.bottomAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        headerStackedView.backgroundColor = .purple
        
        view.bringSubviewToFront(topSectionFade)
        headerStackedView.addArrangedSubview(subscriptionsButton)
        headerStackedView.addArrangedSubview(savedButton)
        headerStackedView.addArrangedSubview(mentionsButton)
        
        view.bringSubviewToFront(customNavBar)
    }
    
    func addLikeLoadingView() {
        view.addSubview(likedTVLoadingView)
        likedTVLoadingView.translatesAutoresizingMaskIntoConstraints = false
        likedTVLoadingView.topAnchor.constraint(equalTo: likedEpisodeTV.topAnchor).isActive = true
        likedTVLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        likedTVLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        likedTVLoadingView.bottomAnchor.constraint(equalTo: likedEpisodeTV.bottomAnchor).isActive = true
    }
    
    func addSubscriptionLoadingView() {
        view.addSubview(subscriptionTVLoadingView)
        subscriptionTVLoadingView.translatesAutoresizingMaskIntoConstraints = false
        subscriptionTVLoadingView.topAnchor.constraint(equalTo: subscriptionTV.topAnchor).isActive = true
        subscriptionTVLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        subscriptionTVLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        subscriptionTVLoadingView.bottomAnchor.constraint(equalTo: subscriptionTV.bottomAnchor).isActive = true
    }
    
    func addSharedLoadingView() {
        view.addSubview(sharedTVLoadingView)
        sharedTVLoadingView.translatesAutoresizingMaskIntoConstraints = false
        sharedTVLoadingView.topAnchor.constraint(equalTo: sharedEpisodeTV.topAnchor).isActive = true
        sharedTVLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sharedTVLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        sharedTVLoadingView.bottomAnchor.constraint(equalTo: sharedEpisodeTV.bottomAnchor).isActive = true
    }
    
    // MARK: Fetching Data
    
    func fetchLikedEpisodes() {
        FireStoreManager.fetchLikedEpisodes(UserID: User.ID!) { episodes in
            self.likedEpisodes = episodes
            self.likedEpisodeTV.reloadData()
            self.likedTVLoadingView.removeFromSuperview()
        }
    }
    
    func fetchSubscriptions() {
        print("Fetching subs")
        FireStoreManager.fetchListenersSubscriptions { programs in
            self.subscriptions = programs
            self.subscriptionTV.reloadData()
            self.subscriptionTVLoadingView.removeFromSuperview()
        }
    }
    
    func fetchSharedEpisodes() {
        
    }
    
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func switchAccountPress() {
        let programAccount = TProgramAccountVC()
        navigationController?.pushViewController(programAccount, animated: false)
    }
    
    @objc func presentEditProfile() {
        let editProfileVC = EditAccountVC()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case likedEpisodeTV:
            return likedEpisodes.count
        case subscriptionTV:
            return subscriptions.count
        case sharedEpisodeTV:
            return sharedEpisodes.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case likedEpisodeTV:
            let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
            cell.moreButton.addTarget(cell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
            cell.programImageButton.addTarget(cell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
            cell.episodeSettingsButton.addTarget(cell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
            cell.likeButton.addTarget(cell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
            
            let episode = likedEpisodes[indexPath.row]
            cell.episode = episode
            if episode.likeCount >= 10 {
                cell.configureCellWithOptions()
            }
            cell.cellDelegate = self
            cell.normalSetUp(episode: episode)
            return cell
        case subscriptionTV:
            let programCell = tableView.dequeueReusableCell(withIdentifier: "programCell") as! ProgramCell
            programCell.moreButton.addTarget(programCell, action: #selector(ProgramCell.moreUnwrap), for: .touchUpInside)
            programCell.programImageButton.addTarget(programCell, action: #selector(ProgramCell.playProgramIntro), for: .touchUpInside)
            programCell.programSettingsButton.addTarget(programCell, action: #selector(ProgramCell.showSettings), for: .touchUpInside)
            programCell.usernameButton.addTarget(programCell, action: #selector(ProgramCell.visitProfile), for: .touchUpInside)
            programCell.subscribeButton.addTarget(programCell, action: #selector(ProgramCell.subscribeButtonPress), for: .touchUpInside)
            
            let program = subscriptions[indexPath.row]
            programCell.program = program
            
//            programCell.cellDelegate = self
            programCell.normalSetUp(program: program)
            return programCell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: Table View Switch
    
    @objc func tableViewTabButtonPress(sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        let deselectedButtons = headerBarButtons.filter() { $0 != sender }
        for each in deselectedButtons {
            each.setTitleColor(CustomStyle.fifthShade, for: .normal)
        }
        
        switch sender.titleLabel?.text {
        case "Liked":
            likedEpisodeTV.isHidden = false
            subscriptionTV.isHidden = true
            sharedEpisodeTV.isHidden = true
           
            likedTVBottomConstraint.isActive = true
            subscriptionTVBottomConstraint.isActive = false
            sharedTVBottomConstraint.isActive = false
            
            likedTVLoadingView.isHidden = false
            subscriptionTVLoadingView.isHidden = true
            sharedTVLoadingView.isHidden = true


            if User.likedEpisodesIDs != nil && User.likedEpisodesIDs!.count > 0 && likedEpisodes.count == 0 {
                addLikeLoadingView()
                fetchLikedEpisodes()
            }
            
        case "Subscriptions":
            likedEpisodeTV.isHidden = true
            subscriptionTV.isHidden = false
            sharedEpisodeTV.isHidden = true
            
            likedTVBottomConstraint.isActive = false
            subscriptionTVBottomConstraint.isActive = true
            sharedTVBottomConstraint.isActive = false
            
            likedTVLoadingView.isHidden = true
            subscriptionTVLoadingView.isHidden = false
            sharedTVLoadingView.isHidden = true
            
        case "Shared":
            likedEpisodeTV.isHidden = true
            subscriptionTV.isHidden = true
            sharedEpisodeTV.isHidden = false

            likedTVBottomConstraint.isActive = false
            subscriptionTVBottomConstraint.isActive = false
            sharedTVBottomConstraint.isActive = true
            
            likedTVLoadingView.isHidden = true
            subscriptionTVLoadingView.isHidden = true
            sharedTVLoadingView.isHidden = false
            

        default:
            break
        }
        
    }
}

extension AccountVC: EpisodeCellDelegate {
    
    func tagSelected(tag: String) {
        let tagSelectedVC = EpisodeTagLookupVC(tag: tag)
        navigationController?.pushViewController(tagSelectedVC, animated: true)
    }
    
    func visitProfile(program: Program) {
        //
    }
    
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

