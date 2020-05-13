//
//  ProgramProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class ProgramProfileVC: UIViewController {

    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var tableViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 80.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var unwrapped = false
    
    var selectedCellRow: Int?
    var program: Program!
    
    var contentViewHeight: NSLayoutConstraint!
    var flexHeightConstraint: NSLayoutConstraint!
        
     var tableViewBottomConstraint: NSLayoutConstraint!
     var subscriptionBottomConstraint: NSLayoutConstraint!
    
    var topSectionHeightMin: CGFloat = UIDevice.current.navBarHeight() + 40
    var topSectionHeightMax: CGFloat = 0
    
    // Episode Table view
    var batchLimit = 10
    var programIDs = [String]()
    var fetchedEpisodeIDs = [String]()
    var episodesToFetch = [String]()
    var episodeIDs = [String]()
    
    let episodeLoadingView = TVLoadingAnimationView(topHeight: 15)
    
    var downloadedEpisodes = [Episode]()
    var moreEpisodesToLoad = false
    
    var activeCell: EpisodeCell?
    var subAccounts = [Program]()
    let maxPrograms = 10

    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let programSettings = SettingsLauncher(options: SettingOptions.programSettings, type: .program)

    let introPlayer = DuneIntroPlayer()
    let audioPlayer = DuneAudioPlayer()

    let episodeTV = UITableView()
  
    let flexView: UIView = {
        let view = UIView()
        return view
    }()

    let contentView: UIView = {
         let view = UIView()
         return view
     }()
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.8
        return nav
    }()

    let topDetailsView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.frame.size = CGSize(width: 74, height: 74)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let topMiddleStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 3
        return view
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryBlack
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlue
        return label
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        return label
    }()

    // Intro button
    let playIntroButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return button
    }()

    let summaryTextView: UITextView = {
        let view = UITextView()
        view.isScrollEnabled = false
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.textContainer.maximumNumberOfLines = 3
        view.isUserInteractionEnabled = false
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.textColor = CustomStyle.sixthShade
        view.backgroundColor = .clear
        return view
    }()

    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        return button
    }()

    let statsView: UIView = {
        let view = UIView()
        return view
    }()

    let subscriberCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()

    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()

    let episodeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()

    let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()

    let buttonsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 10.0
        return view
    }()

    let subscribeButton: AccountButton = {
        let button = AccountButton()
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(subscribeButtonPress), for: .touchUpInside)
        return button
    }()

    let shareProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.setTitle("Share Program", for: .normal)
        return button
    }()

    let multipleProgramsLabelView: UIView = {
        let view = UIView()
        return view
    }()

    let multipleProgramsLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Sub-programs"
        return label
    }()

    // Maybe remove
    let multipleProgramsSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()

    let programsScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    let programsStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()

    let tableViewButtons: UIView = {
        let view = UIView()
        return view
    }()
    
    let tableViewButtonsLine: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()

    let episodesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Episodes", for: .normal)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        episodeTV.isHidden = true
        configureDelegates()
        styleForScreens()
        configureViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        episodeTV.setScrollBarToTopLeft()
        configureSubscribeButton()
        configureProgramStats()
        configureSubAccounts()
        configureIntroButton()
        setupTopBar()

        mainImage.image = program.image!
        nameLabel.text = program.name
        usernameLabel.text = "@\(program.username)"
        categoryLabel.text = program.primaryCategory
        summaryTextView.text = program.summary
        
        multipleProgramsSubLabel.text = "Programs brought to you by @\(program.username)"


        programIDs = programsIDs()
        fetchEpisodeIDsForUser()

        if  unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
        }
    }
    
    func configureProgramStats() {
        subscriberCountLabel.text = "\(program.subscriberCount.roundedWithAbbreviations)"
        episodeCountLabel.text = "\(program.episodeIDs.count)"
        
        let episodes = program.episodeIDs
        let subscribers = program.subscriberCount

        if episodes.count == 1 {
            episodesLabel.text = "Episode"
        } else {
            episodesLabel.text = "Episodes"
        }

        if subscribers == 1 {
            subscribersLabel.text = "Subscriber"
        } else {
             subscribersLabel.text = "Subscribers"
        }
    }
    
    func programsIDs() -> [String] {
        if program.hasMultiplePrograms! {
            var ids = program.programIDs!
            ids.append(program.ID)
            return ids
        } else {
            return [program.ID]
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        setupHeightForViews()
        if summaryTextView.lineCount() > 3 {
            addMoreButton()
        }
    }
    
    func setupHeightForViews() {
        var height: CGFloat = 140 + UIDevice.current.navBarHeight()
        
        for each in contentView.subviews {
            height += each.frame.height
        }
        
        if contentView.subviews.contains(moreButton) {
            height -= 16
        }
        
        topSectionHeightMax = height
        flexHeightConstraint.constant = topSectionHeightMax
        contentViewHeight.constant = topSectionHeightMax
        episodeTV.isHidden = false
        episodeLoadingView.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer.finishSession()
        introPlayer.finishSession()
        moreEpisodesToLoad = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        for each in programsScrollView.subviews {
            if each is UILabel {
                each.removeFromSuperview()
            }
        }

        let buttons = programsStackView.subviews as! [UIButton]
            for each in buttons {
                each.setImage(UIImage(), for: .normal)
                each.removeTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
                each.removeTarget(self, action: #selector(createProgram), for: .touchUpInside)
            }
    }

    func configureDelegates() {
        episodeTV.register(EpisodeCell.self, forCellReuseIdentifier: "episodeCell")
        audioPlayer.playbackDelegate = self
        episodeTV.dataSource = self
        episodeTV.delegate = self
    }
    
    func setupTopBar() {
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.barStyle = .default
        navBar?.shadowImage = UIImage()
//        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .black
                
        navBar?.titleTextAttributes = CustomStyle.blackNavBarAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))

        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            largeImageSize = 60
            fontNameSize = 14
            fontIDSize = 12
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }

    func configureIntroButton() {
        if CurrentProgram.hasIntro == true {
            playIntroButton.setTitle("Play Intro", for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryYellow
            playIntroButton.setTitleColor(CustomStyle.darkestBlack, for: .normal)
            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 15)
            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            playIntroButton.removeTarget(self, action:  #selector(recordIntro), for: .touchUpInside)
            playIntroButton.addTarget(self, action: #selector(playIntro), for: .touchUpInside)
        } else {
            playIntroButton.isHidden = true
//            playIntroButton.setImage(nil, for: .normal)
//            playIntroButton.setTitle("Add Intro", for: .normal)
//            playIntroButton.setTitleColor(.white, for: .normal)
//            playIntroButton.backgroundColor = CustomStyle.primaryBlue
//            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//            playIntroButton.removeTarget(self, action: #selector(playIntro), for: .touchUpInside)
//            playIntroButton.addTarget(self, action: #selector(recordIntro), for: .touchUpInside)
        }
    }

    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(flexView)
        flexView.translatesAutoresizingMaskIntoConstraints = false
        flexView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        flexView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        flexView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        flexHeightConstraint = flexView.heightAnchor.constraint(equalToConstant: topSectionHeightMax)
        flexHeightConstraint.isActive = true
        
        view.addSubview(episodeTV)
        episodeTV.translatesAutoresizingMaskIntoConstraints = false
        episodeTV.topAnchor.constraint(equalTo: flexView.bottomAnchor).isActive = true
        episodeTV.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeTV.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewBottomConstraint = episodeTV.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomConstraint.isActive = true
        episodeTV.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)

        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.bottomAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeight.isActive = true
        
        contentView.addSubview(tableViewButtons)
        tableViewButtons.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtons.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        tableViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        tableViewButtons.addSubview(tableViewButtonsLine)
        tableViewButtonsLine.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtonsLine.bottomAnchor.constraint(equalTo: tableViewButtons.bottomAnchor).isActive = true
        tableViewButtonsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtonsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtonsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        tableViewButtons.addSubview(episodesButton)
        episodesButton.translatesAutoresizingMaskIntoConstraints = false
        episodesButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor).isActive = true
        episodesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        if program.isPrimaryProgram && program.hasMultiplePrograms! {
        
        contentView.addSubview(programsScrollView)
        programsScrollView.translatesAutoresizingMaskIntoConstraints = false
        programsScrollView.bottomAnchor.constraint(equalTo: tableViewButtons.topAnchor, constant: -20).isActive = true
        programsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        programsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programsScrollView.heightAnchor.constraint(equalToConstant: 85).isActive = true

        programsScrollView.addSubview(programsStackView)
        programsStackView.translatesAutoresizingMaskIntoConstraints = false
        programsStackView.topAnchor.constraint(equalTo: programsScrollView.topAnchor).isActive = true
        programsStackView.bottomAnchor.constraint(equalTo: programsScrollView.bottomAnchor).isActive = true
        programsStackView.leadingAnchor.constraint(equalTo: programsScrollView.leadingAnchor, constant: 16).isActive = true
        programsStackView.trailingAnchor.constraint(equalTo: programsScrollView.trailingAnchor, constant: -16).isActive = true

        createProgramButtons()
        
        contentView.addSubview(multipleProgramsLabelView)
        multipleProgramsLabelView.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsLabelView.bottomAnchor.constraint(equalTo: programsScrollView.topAnchor, constant: -20).isActive = true
        multipleProgramsLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        multipleProgramsLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        multipleProgramsLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        multipleProgramsLabelView.addSubview(multipleProgramsLabel)
        multipleProgramsLabel.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsLabel.topAnchor.constraint(equalTo: multipleProgramsLabelView.topAnchor, constant: 5).isActive = true
        multipleProgramsLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true

        multipleProgramsLabelView.addSubview(multipleProgramsSubLabel)
        multipleProgramsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        multipleProgramsSubLabel.topAnchor.constraint(equalTo: multipleProgramsLabel.bottomAnchor, constant: 5).isActive = true
        multipleProgramsSubLabel.leadingAnchor.constraint(equalTo: multipleProgramsLabelView.leadingAnchor).isActive = true
        }
        
        contentView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        
        if program.isPrimaryProgram && program.hasMultiplePrograms! {
            buttonsStackedView.bottomAnchor.constraint(equalTo: multipleProgramsLabelView.topAnchor, constant: -20).isActive = true
        } else {
             buttonsStackedView.bottomAnchor.constraint(equalTo: episodesButton.topAnchor, constant: -20).isActive = true
        }
        
        buttonsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true

        buttonsStackedView.addArrangedSubview(subscribeButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        contentView.addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        statsView.bottomAnchor.constraint(equalTo: buttonsStackedView.topAnchor, constant: -20).isActive = true
        statsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        statsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        statsView.addSubview(subscriberCountLabel)
        subscriberCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriberCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscriberCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        statsView.addSubview(subscribersLabel)
        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribersLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscribersLabel.leadingAnchor.constraint(equalTo: subscriberCountLabel.trailingAnchor, constant: 5).isActive = true

        statsView.addSubview(episodeCountLabel)
        episodeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        episodeCountLabel.leadingAnchor.constraint(equalTo: subscribersLabel.trailingAnchor, constant: 15).isActive = true

        statsView.addSubview(episodesLabel)
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        episodesLabel.leadingAnchor.constraint(equalTo: episodeCountLabel.trailingAnchor, constant: 5).isActive = true
        
        contentView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.bottomAnchor.constraint(equalTo: subscriberCountLabel.topAnchor, constant: -20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        contentView.addSubview(topDetailsView)
        topDetailsView.translatesAutoresizingMaskIntoConstraints = false
        topDetailsView.bottomAnchor.constraint(equalTo: summaryTextView.topAnchor, constant: -20).isActive = true
        topDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        topDetailsView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        topDetailsView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo:topDetailsView.topAnchor, constant: 0).isActive = true
        mainImage.leadingAnchor.constraint(equalTo:topDetailsView.leadingAnchor).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true

        topDetailsView.addSubview(playIntroButton)
        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
        playIntroButton.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true

        topDetailsView.addSubview(topMiddleStackedView)
        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
        topMiddleStackedView.topAnchor.constraint(equalTo: topDetailsView.topAnchor).isActive = true
        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: playIntroButton.leadingAnchor, constant: -20).isActive = true
        topMiddleStackedView.addArrangedSubview(nameLabel)
        topMiddleStackedView.addArrangedSubview(usernameLabel)
        topMiddleStackedView.addArrangedSubview(categoryLabel)

        view.addSubview(introPlayer)
        introPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        
        view.addSubview(audioPlayer)
        audioPlayer.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 70)
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addLoadingView() {
        view.addSubview(episodeLoadingView)
        episodeLoadingView.translatesAutoresizingMaskIntoConstraints = false
        episodeLoadingView.topAnchor.constraint(equalTo: episodeTV.topAnchor).isActive = true
        episodeLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        episodeLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        episodeLoadingView.bottomAnchor.constraint(equalTo: episodeTV.bottomAnchor).isActive = true
        episodeLoadingView.isHidden = true
    }
    
    func resetTableView() {
        addLoadingView()
        navigationItem.title = ""
        fetchedEpisodeIDs = [String]()
        downloadedEpisodes = [Episode]()
        episodeIDs = [String]()
        episodeTV.reloadData()
    }
    
    // MARK: Fetch batch of episode IDs
    func fetchEpisodeIDsForUser() {
        print("Fetching")
        FireStoreManager.fetchEpisodesIDsWith(with: programIDs) { ids in
            
            if ids.isEmpty {
                print("No episodes to display")
            } else {
                 if ids.count != self.episodeIDs.count {
                    self.resetTableView()
                    self.episodeIDs = ids
                    self.loadFirstBatch()
                 } else {
                    self.episodeLoadingView.removeFromSuperview()
                }
            }
        }
    }

    func loadFirstBatch() {
         var endIndex = batchLimit
        
         if episodeIDs.count < batchLimit {
             endIndex = episodeIDs.count
         }
         
         episodesToFetch = Array(episodeIDs[0..<endIndex])
        
        for eachID in episodesToFetch {
             downloadEpisodeWith(ID: eachID)
        }
    }
    
    func  loadNextBatch() {
        var endIndex = batchLimit
        
        if (episodeIDs.count - fetchedEpisodeIDs.count) < batchLimit {
             endIndex = episodeIDs.count - fetchedEpisodeIDs.count
         }

        let lastEp = fetchedEpisodeIDs.last!
        let startIndex = episodeIDs.firstIndex(of: lastEp)
        endIndex += startIndex!
        
        episodesToFetch = Array(episodeIDs[startIndex!..<endIndex])
        
        for eachID in episodesToFetch {
             downloadEpisodeWith(ID: eachID)
        }
    }
    
    // MARK: Download episodes
    var batch = [Episode]()
    
    func downloadEpisodeWith(ID: String) {
                        
        let alreadyDownloaded = self.fetchedEpisodeIDs.contains(where: { $0 == ID })
               
        if !alreadyDownloaded {
            FireStoreManager.getEpisodeDataWith(ID: ID) { (data) in
                
                let episode = Episode(data: data)
                self.batch.append(episode)
                
                print("Batch count \(self.batch.count) eps to fetch count \(self.episodesToFetch.count)")
                if self.batch.count == self.episodesToFetch.count{
                   
                    let orderedBatch = self.batch.sorted { (epA , epB) -> Bool in
                        let dateA = epA.timeStamp.dateValue()
                        let dateB = epB.timeStamp.dateValue()
                        return dateA > dateB
                    }
                    
                    for each in orderedBatch {
                        self.downloadedEpisodes.append(each)
                        self.audioPlayer.downloadedEps.append(each)
                        self.audioPlayer.audioIDs.append(each.audioID)
                    }
                    
                    print("Im here")
                    self.fetchedEpisodeIDs += self.episodesToFetch
                    self.episodeLoadingView.removeFromSuperview()
                    self.episodesToFetch.removeAll()
                    self.episodeTV.reloadData()
                    self.batch.removeAll()
                }
            }
        }
    }


    func configureSubAccounts() {
        let buttons = programsStackView.subviews as! [UIButton]
        
            for (index, item) in program.subPrograms!.enumerated() {
                if item.image == nil {
                    FileManager.getImageWith(imageID: item.imageID!) { image in
                        DispatchQueue.main.async {
                            buttons[index].setImage(image, for: .normal)
                        }
                    }
                } else {
                    buttons[index].setImage(item.image, for: .normal)
                }
                buttons[index].addTarget(self, action: #selector(programSelection(sender:)), for: .touchUpInside)
            }
            createProgramLabels()
    }

    @objc func programSelection(sender: UIButton) {
        let buttons = programsStackView.subviews as! [UIButton]
        let index = buttons.firstIndex(of: sender)
        let programs = program.subPrograms!
        let program = programs[index!]

        let subProgramVC = SubProgramProfileVC(program: program)
        navigationController?.present(subProgramVC, animated: true, completion: nil)
    }

    func createProgramButtons() {
        for _ in 1...maxPrograms {
            let button = subProgramButton()
            programsStackView.addArrangedSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 64).isActive = true
            button.widthAnchor.constraint(equalToConstant: 64).isActive = true
        }
    }
    
    func createProgramLabels() {
        for (index, item) in program.subPrograms!.enumerated() {
            let label = programLabel()
            label.text = item.name
            
            let button = programsStackView.arrangedSubviews[index]
            addConstraintsToProgram(label: label, with: button)
        }
    }

    func addConstraintsToProgram(label: UILabel, with button: UIView) {
        programsScrollView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5).isActive = true
        label.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: button.widthAnchor).isActive = true
    }

    @objc func createProgram() {
//        let createProgramVC = CreateProgramVC()
//        navigationController?.pushViewController(createProgramVC, animated: true)
    }

    func subProgramButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }

    func programLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = CustomStyle.fifthShade
        label.textAlignment = .center
        return label
    }

    @objc func playIntro() {
        
        if !audioPlayer.playerIsOutOfPosition {
            audioPlayer.finishSession()
        }
        
        introPlayer.navHeight = self.tabBarController?.tabBar.frame.height
        introPlayer.getAudioWith(audioID: program.introID!) { url in
            self.introPlayer.playOrPauseWith(url: url, name: self.program.name, image: self.program.image!)
             print("Play intro")
        }
    }

    @objc func recordIntro() {
        let recordBoothVC = RecordBoothVC()
        recordBoothVC.currentScope = .intro
        navigationController?.pushViewController(recordBoothVC, animated: true)
    }


    func addMoreButton() {
        DispatchQueue.main.async {
            self.contentView.addSubview(self.moreButton)
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true

            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
                   let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
        
    }
    
    // MARK: Select TV tab button
    @objc func tableViewTabButtonPress(sender: UIButton) {
        tableViewBottomConstraint.isActive = true
        episodeLoadingView.isHidden = false
        episodeTV.isHidden = false
    }

    @objc func settingsButtonPress() {
        programSettings.showSettings()
    }

    @objc func moreUnwrap() {
        let heightBefore = summaryTextView.frame.height
        print("Height before : \(heightBefore)")
        unwrapped = true
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(CurrentProgram.summary!) "
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()

        if UIDevice.current.deviceType == .iPhoneSE {
        }
        summaryTextView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        
        let heighAfter = summaryTextView.frame.height
        print("Height after : \(heighAfter)")
        
        let difference =  heighAfter - heightBefore
        
         topSectionHeightMax += difference
         contentViewHeight.constant = topSectionHeightMax
         flexHeightConstraint.constant = topSectionHeightMax
         contentViewHeight.constant = topSectionHeightMax
    }
    
    func configureSubscribeButton() {
        if !User.subscriptionIDs!.contains(program.ID) {
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
        } else {
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
        }
    }

    // MARK: Subscribe button press
    @objc func subscribeButtonPress() {
        if User.subscriptionIDs!.contains(program.ID) {
            FireStoreManager.unsubscribeFromProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithUnSubscribe(programID: program.ID)
            User.subscriptionIDs!.removeAll(where: {$0 == program.ID})
            program.subscriberCount -= 1
            subscribeButton.setTitle("Subscribe", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribe-icon"), for: .normal)
            configureProgramStats()
        } else {
            FireStoreManager.subscribeUserToProgramWith(programID: program.ID)
            FireStoreManager.updateProgramWithSubscription(programID: program.ID)
            User.subscriptionIDs!.append(program.ID)
            program.subscriberCount += 1
            subscribeButton.setTitle("Subscribed", for: .normal)
            subscribeButton.setImage(UIImage(named: "subscribed-icon"), for: .normal)
            configureProgramStats()
        }
    }

    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }

}

extension ProgramProfileVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell") as! EpisodeCell
        cell.moreButton.addTarget(cell, action: #selector(EpisodeCell.moreUnwrap), for: .touchUpInside)
        cell.programImageButton.addTarget(cell, action: #selector(EpisodeCell.playEpisode), for: .touchUpInside)
        cell.episodeSettingsButton.addTarget(cell, action: #selector(EpisodeCell.showSettings), for: .touchUpInside)
        cell.likeButton.addTarget(cell, action: #selector(EpisodeCell.likeButtonPress), for: .touchUpInside)
        
        let episode = downloadedEpisodes[indexPath.row]
        cell.episode = episode
        if episode.likeCount >= 10 {
            cell.configureCellWithOptions()
        }
        cell.cellDelegate = self
        cell.normalSetUp(episode: episode)
        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
            if maximumOffset - currentOffset <= 90.0 && fetchedEpisodeIDs != episodeIDs {
                print("loading more episodes")
                loadNextBatch()
            }
    }

}

extension ProgramProfileVC :EpisodeCellDelegate {
    
    func updateRows() {
        //
    }

    func addTappedProgram(programName: String) {
        //
    }

    func playEpisode(cell: EpisodeCell) {
        
        if !introPlayer.playerIsOutOfPosition {
            introPlayer.finishSession()
        }
        
        activeCell = cell
        
        if !cell.playbackBarView.playbackBarIsSetup {
            cell.playbackBarView.setupPlaybackBar()
        }
        audioPlayer.navHeight = self.tabBarController?.tabBar.frame.height
        
        let image = cell.programImageButton.imageView?.image
        let audioID = cell.episode.audioID
        
        audioPlayer.getAudioWith(audioID: audioID) { url in
            self.audioPlayer.playOrPause(episode: cell.episode, with: url, image: image!)
        }
    }

    func showSettings(cell: EpisodeCell) {
        selectedCellRow = downloadedEpisodes.firstIndex(where: { $0.ID == cell.episode.ID })
    }

    func updateLikeCountFor(episode: Episode, at indexPath: IndexPath) {
        //
    }

}

extension ProgramProfileVC: SettingsLauncherDelegate {
    
    func selectionOf(setting: String) {
        switch setting {
        case "Delete":
           break
        default:
            break
        }
    }
}

extension ProgramProfileVC: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        let screenHeight = UIScreen.main.bounds.height

        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade
        
        if flexView.frame.height != 0 && flexView.frame.height <= topSectionHeightMax - 100 {
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = User.username
//            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        } else {
            navigationItem.title = ""
        }
        
//        print("HERE \(flexView.frame.height)")
//        if flexView.frame.height != 0 {
//            let percent = flexView.frame.height / topSectionHeightMax
//            coverView.alpha = 1 - percent
//        }
        
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = flexHeightConstraint.constant - y
        if newHeaderViewHeight > topSectionHeightMax {
            flexHeightConstraint.constant = topSectionHeightMax
        } else if newHeaderViewHeight <= topSectionHeightMin {
            flexHeightConstraint.constant = topSectionHeightMin
        } else {
            flexHeightConstraint.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
}

extension ProgramProfileVC: PlaybackBarDelegate {
   
    func updateProgressBarWith(percentage: CGFloat) {
        guard let cell = activeCell else { return }
        cell.playbackBarView.progressUpdateWith(percentage: percentage)
    }
    
    func updateActiveCell(atIndex: Int) {
        let cell = episodeTV.cellForRow(at: IndexPath(item: atIndex, section: 0)) as! EpisodeCell
        cell.playbackBarView.setupPlaybackBar()
        activeCell = cell
    }

}

extension ProgramProfileVC: ProgramCellDelegate {
  
    func visitProfile(program: Program) {
//        let programVC = ProgramProfileVC()
//        programVC.program = program
//        navigationController?.pushViewController(programVC, animated: true)
    }
    
    func showSettings(cell: ProgramCell) {
        //
    }
   
    func playProgramIntro(cell: ProgramCell) {
        //
    }
 
}




