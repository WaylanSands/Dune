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
    var tableHeadeTrailingAnchor: NSLayoutConstraint!
    var topSectionHeightMin: CGFloat = UIApplication.shared.statusBarFrame.height
    var topSectionHeightMax: CGFloat = 270
    let tableView = UITableView()
    var programs: [CurrentProgram] = []
    var tappedPrograms: [String] = []
    var userDetailsYPosition: CGFloat = 125
    var statsYPosition: CGFloat = -80.0
    lazy var headerBarButtons: [UIButton] = [savedButton, subscriptionsButton, mentionsButton]
    
    let topSection: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.darkestBlack
        return view
    }()
    
    let topSectionFade: PassThoughView = {
        let view = PassThoughView()
        view.backgroundColor = CustomStyle.darkestBlack
        return view
    }()
    
    let userStackedView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.spacing = 5
        view.axis = .vertical
        return view
    }()
    
    let gestureRec = UITapGestureRecognizer(target: self, action: #selector(presentEditProfile))
    
    lazy var userImage: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRec)
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.frame.size = CGSize(width: 70.0, height: 70.0)
        view.image = UIImage(imageLiteralResourceName: "user-placeholder")
        return view
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.text = "Katyln Donavan"
        return label
    }()
    
    let userHandelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.text = "@KatyDon"
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
        view.backgroundColor = CustomStyle.darkestBlack
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
        label.text = "Saved"
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
        label.text = "Mentions"
        return label
    }()
    
    let savedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Saved", for: .normal)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(headerTabPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let subscriptionsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Subscriptions", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.addTarget(self, action: #selector(headerTabPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let mentionsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitle("Mentions", for: .normal)
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.addTarget(self, action: #selector(headerTabPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let whiteBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // Custom NavBar
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.setImage(#imageLiteral(resourceName: "switch-account-icon"), for: .normal)
        nav.leftButton.addTarget(self, action: #selector(switchAccountPress), for: .touchUpInside)
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
        view.backgroundColor = CustomStyle.darkestBlack
//        programs = fetchData()
        setTableViewDelegates()
        styleForScreens()
        setupTopBar()
        configureViews()
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: Cells.regularCell)
        tableView.backgroundColor = .clear
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
            topSectionFade.alpha = 1.2 - percentage
            headerTopStroke.alpha = percentage
            topSectionHeightConstraint.constant = topSectionHeightMax
        } else if newHeaderViewHeight <= topSectionHeightMin {
            topSectionHeightConstraint.constant = topSectionHeightMin
            tableHeadeTrailingAnchor.constant = -40
            percentage = (currentHeight - y) / headerHeight
            userStackedView.alpha = percentage
            statsStackedView.alpha = percentage
            topSectionFade.alpha = 1.2 - percentage
            headerTopStroke.alpha = percentage
            headerTopStroke.isHidden = true
            customNavBar.leftButton.alpha = 0
        } else {
            percentage = (currentHeight - y) / headerHeight
            topSectionHeightConstraint.constant = newHeaderViewHeight
            tableHeadeTrailingAnchor.constant = 0
            userStackedView.alpha = percentage
            statsStackedView.alpha = percentage
            topSectionFade.alpha = 1.2 - percentage
            headerTopStroke.alpha = percentage
            headerTopStroke.isHidden = false
            customNavBar.leftButton.alpha = percentage
            scrollView.contentOffset.y = 0 // block scroll view
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
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
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupTopBar() {
        self.navigationController!.isNavigationBarHidden = true
    }
    
    
    func configureViews() {
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        
        view.addSubview(topSection)
        topSection.translatesAutoresizingMaskIntoConstraints = false
        topSection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topSection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topSection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topSectionHeightConstraint = topSection.heightAnchor.constraint(equalToConstant: topSectionHeightMax)
        topSectionHeightConstraint.isActive = true
        
        view.addSubview(topSectionFade)
        topSectionFade.translatesAutoresizingMaskIntoConstraints = false
        topSectionFade.topAnchor.constraint(equalTo: topSection.topAnchor).isActive = true
        topSectionFade.leadingAnchor.constraint(equalTo: topSection.leadingAnchor).isActive = true
        topSectionFade.trailingAnchor.constraint(equalTo: topSection.trailingAnchor).isActive = true
        topSectionFade.bottomAnchor.constraint(equalTo: topSection.bottomAnchor).isActive = true
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
        
        userStackedView.addArrangedSubview(userNameLabel)
        userStackedView.addArrangedSubview(userHandelLabel)
        
        // Stats View
        
        topSection.addSubview(statsStackedView)
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
        tableHeader.topAnchor.constraint(equalTo: topSection.bottomAnchor).isActive = true
        tableHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableHeadeTrailingAnchor = tableHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        tableHeadeTrailingAnchor.isActive = true
        tableHeader.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        tableHeader.addSubview(headerTopStroke)
        headerTopStroke.translatesAutoresizingMaskIntoConstraints = false
        headerTopStroke.topAnchor.constraint(equalTo: tableHeader.topAnchor).isActive = true
        headerTopStroke.heightAnchor.constraint(equalToConstant: 1).isActive = true
        headerTopStroke.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerTopStroke.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        
        view.addSubview(whiteBottom)
        whiteBottom.translatesAutoresizingMaskIntoConstraints = false
        whiteBottom.topAnchor.constraint(equalTo: tableView.bottomAnchor,constant: -200).isActive = true
        whiteBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        whiteBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        whiteBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        view.sendSubviewToBack(whiteBottom)
        
        tableHeader.addSubview(headerStackedView)
        headerStackedView.translatesAutoresizingMaskIntoConstraints = false
        headerStackedView.topAnchor.constraint(equalTo: tableHeader.topAnchor).isActive = true
        headerStackedView.leadingAnchor.constraint(equalTo: tableHeader.leadingAnchor).isActive = true
        headerStackedView.trailingAnchor.constraint(equalTo: tableHeader.trailingAnchor).isActive = true
        headerStackedView.bottomAnchor.constraint(equalTo: tableHeader.bottomAnchor).isActive = true
        headerStackedView.backgroundColor = .purple
        
        view.bringSubviewToFront(topSectionFade)
        headerStackedView.addArrangedSubview(savedButton)
        headerStackedView.addArrangedSubview(subscriptionsButton)
        headerStackedView.addArrangedSubview(mentionsButton)
        
        view.bringSubviewToFront(customNavBar)
    }
    
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func switchAccountPress() {
        let programAccount = ProgramAccountVC()
        navigationController?.pushViewController(programAccount, animated: false)
    }
    
    @objc func presentEditProfile() {
        let editProfileVC = EditAccountVC()
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let regularCell = tableView.dequeueReusableCell(withIdentifier: Cells.regularCell) as! EpisodeCell
//        let program = programs[indexPath.row]
//        regularCell.normalSetUp(program: program)
        regularCell.moreButton.addTarget(regularCell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        regularCell.cellDelegate = self
        
//        if tappedPrograms.contains(programs[indexPath.row].name) {
//            regularCell.refreshSetupMoreTapTrue()
//            return regularCell
//        } else {
//            regularCell.refreshSetupMoreTapFalse()
//            return regularCell
//        }
        return regularCell

    }
    
    @objc func headerTabPress(sender: UIButton) {
        sender.setTitleColor(.white, for: .normal)
        let deselecteButtons = headerBarButtons.filter() { $0 != sender }
        for each in deselecteButtons {
            each.setTitleColor(CustomStyle.fifthShade, for: .normal)
        }
    }
}

extension AccountVC: EpisodeCellDelegate {
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

