//
//  ProgramAccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ProgramAccountVC: UIViewController {
    
    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 74.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var unwrapped = false
    
    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)

    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let topView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "hollywood")
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
        label.textColor = CustomStyle.primaryblack
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
    
    let playIntroButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryYellow
        button.layer.cornerRadius = 13
        button.setTitle("Play Intro", for: .normal)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        button.addTarget(self, action: #selector(introPress), for: .touchUpInside)
        button.setImage(UIImage(named: "small-play-icon"), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 15)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
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
    
    let statsStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let subscribersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        label.text = "23K Subscribers"
        return label
    }()
    
    let episodesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        label.text = "114 Episodes"
        return label
    }()
    
    let buttonsStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        view.spacing = 10.0
        return view
    }()
    
    let editProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "edit-account-icon"), for: .normal)
        button.setTitle("Edit Program", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(editProgramButtonPress), for: .touchUpInside)
        return button
    }()
    
    let shareProgramButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "share-account-icon"), for: .normal)
        button.addTarget(self, action: #selector(shareButtonPress), for: .touchUpInside)
        button.setTitle("Share Program", for: .normal)
        return button
    }()
    
    let multiplePorgramsLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryblack
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Multiple programs"
        return label
    }()
    
    let multiplePorgramsSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryblack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Create multiple programs for your channel"
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
    
    let addIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "add-program-icon")
        return view
    }()
    
    let createLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryblack
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Create"
        label.textAlignment = .center
        return label
    }()
    
//    let customNavBar: CustomNavBar = {
//        let nav = CustomNavBar()
//        nav.leftButton.setImage(#imageLiteral(resourceName: "back-button-blk"), for: .normal)
//        nav.backgroundColor = .clear
//        nav.rightButton.setImage(#imageLiteral(resourceName: "white-settings-icon"), for: .normal)
//        //        nav.rightButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
//        return nav
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = false
        styleForScreens()
        configureViews()
        addIntroButton()
        scrollView.delegate = self
    }
    
//    @objc func introPress() {
//        print("ran")
//        print(navigationController?.navigationBar.barStyle.rawValue)
//        navigationController?.navigationBar.barStyle = .default
//    }
//
    func setupTopBar() {
        print("ran")
        let navBar = navigationController?.navigationBar
        navigationController?.isNavigationBarHidden = false
        navBar?.setBackgroundImage(nil, for: .default)
        navBar?.barStyle = .default
        navBar?.shadowImage = UIImage()
        navBar?.tintColor = .black
        
        navBar?.titleTextAttributes = CustomStyle.blackNavbarAttributes
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        programsScrollView.setScrollBarToTopLeft()
        scrollView.setScrollBarToTopLeft()
        setProgramImage()
        setupTopBar()
        
        nameLabel.text = Program.name
        usernameLabel.text = "@\(User.username!)"
        categoryLabel.text = Program.primaryCategory
        summaryTextView.text = Program.summary
        
        if  unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
//            summaryViewHeight = summaryTextView.heightAnchor.constraint(lessThanOrEqualToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
//            summaryViewHeight.isActive = true
            unwrapped = false
        }
         print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        if summaryTextView.lineCount() > 3 {
            addMoreButton()
//            summaryViewHeight = summaryTextView.heightAnchor.constraint(equalToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
        }
//            summaryViewHeight.isActive = true
//        } else {
//            summaryViewHeight = summaryTextView.heightAnchor.constraint(lessThanOrEqualToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
//            summaryViewHeight.isActive = true
//        }
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
    
    func setProgramImage() {
        if Program.image != nil {
            mainImage.image = Program.image
        } else {
            mainImage.image = #imageLiteral(resourceName: "missing-image-large")
        }
    }
    
    func addIntroButton() {
        if Program.hasIntro == true {
            playIntroButton.setTitle("Play Intro", for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryBlue
            playIntroButton.setImage(nil, for: .normal)
            playIntroButton.setImage(UIImage(named: "small-play-icon"), for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryYellow
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 15)
            playIntroButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        } else {
            playIntroButton.setTitle("Record Intro", for: .normal)
            playIntroButton.backgroundColor = CustomStyle.primaryBlue
            playIntroButton.setTitleColor(.white, for: .normal)
            playIntroButton.setImage(nil, for: .normal)
            playIntroButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            playIntroButton.addTarget(self, action: #selector(recordIntro), for: .touchUpInside)
        }
    }
    
    func configureViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        scrollContentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollContentView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant:20).isActive = true
        topView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
        topView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 74).isActive = true
        
        topView.addSubview(mainImage)
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        mainImage.topAnchor.constraint(equalTo:topView.topAnchor, constant: 0).isActive = true
        mainImage.leadingAnchor.constraint(equalTo:topView.leadingAnchor).isActive = true
        mainImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        mainImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
        
        topView.addSubview(topMiddleStackedView)
        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
        topMiddleStackedView.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
        topMiddleStackedView.addArrangedSubview(nameLabel)
        topMiddleStackedView.addArrangedSubview(usernameLabel)
        topMiddleStackedView.addArrangedSubview(categoryLabel)
        
        topView.addSubview(playIntroButton)
        playIntroButton.translatesAutoresizingMaskIntoConstraints = false
        playIntroButton.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
        playIntroButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playIntroButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        scrollContentView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        summaryViewHeight = summaryTextView.heightAnchor.constraint(lessThanOrEqualToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
//        summaryViewHeight.isActive = true
//
        scrollContentView.addSubview(statsStackedView)
        statsStackedView.translatesAutoresizingMaskIntoConstraints = false
        statsStackedView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        statsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        statsStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20).isActive = true
        
        statsStackedView.addArrangedSubview(subscribersLabel)
        subscribersLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribersLabel.widthAnchor.constraint(equalToConstant: subscribersLabel.intrinsicContentSize.width).isActive = true
        subscribersLabel.leadingAnchor.constraint(equalTo: statsStackedView.leadingAnchor).isActive = true
        
        statsStackedView.addArrangedSubview(episodesLabel)
        episodesLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesLabel.widthAnchor.constraint(equalToConstant: episodesLabel.intrinsicContentSize.width).isActive = true
        
        scrollContentView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: statsStackedView.bottomAnchor, constant: 20.0).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16.0).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(editProgramButton)
        buttonsStackedView.addArrangedSubview(shareProgramButton)
        
        scrollContentView.addSubview(multiplePorgramsLabel)
        multiplePorgramsLabel.translatesAutoresizingMaskIntoConstraints = false
        multiplePorgramsLabel.topAnchor.constraint(equalTo: buttonsStackedView.bottomAnchor, constant: 20).isActive = true
        multiplePorgramsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        scrollContentView.addSubview(multiplePorgramsSubLabel)
        multiplePorgramsSubLabel.translatesAutoresizingMaskIntoConstraints = false
        multiplePorgramsSubLabel.topAnchor.constraint(equalTo: multiplePorgramsLabel.bottomAnchor, constant: 5).isActive = true
        multiplePorgramsSubLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true

        scrollContentView.addSubview(programsScrollView)
        programsScrollView.translatesAutoresizingMaskIntoConstraints = false
        programsScrollView.topAnchor.constraint(equalTo: multiplePorgramsSubLabel.bottomAnchor, constant: 10).isActive = true
        programsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        programsScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programsScrollView.heightAnchor.constraint(equalToConstant: 85).isActive = true

        programsScrollView.addSubview(programsStackView)
        programsStackView.translatesAutoresizingMaskIntoConstraints = false
        programsStackView.topAnchor.constraint(equalTo: programsScrollView.topAnchor).isActive = true
        programsStackView.bottomAnchor.constraint(equalTo: programsScrollView.bottomAnchor).isActive = true
        programsStackView.leadingAnchor.constraint(equalTo: programsScrollView.leadingAnchor, constant: 16).isActive = true
        programsStackView.trailingAnchor.constraint(equalTo: programsScrollView.trailingAnchor).isActive = true
        programsStackView.widthAnchor.constraint(equalToConstant: programsStackView.intrinsicContentSize.width).isActive = true
        
        createProgramViews()
        
        let firstView = programsStackView.arrangedSubviews[0]
        firstView.addSubview(addIconView)
        addIconView.translatesAutoresizingMaskIntoConstraints = false
        addIconView.centerYAnchor.constraint(equalTo: firstView.centerYAnchor).isActive = true
        addIconView.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        
        programsScrollView.addSubview(createLabel)
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        createLabel.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 5).isActive = true
        createLabel.centerXAnchor.constraint(equalTo: firstView.centerXAnchor).isActive = true
        createLabel.widthAnchor.constraint(equalTo: firstView.widthAnchor).isActive = true
    }
    
    @objc func recordIntro() {
        
    }

    func createProgramViews() {
        for _ in 1...6 {
            let view = program()
            programsStackView.addArrangedSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 64).isActive = true
            view.widthAnchor.constraint(equalToConstant: 64).isActive = true

        }
    }
    
    func program() -> UIView {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }

    
    func addMoreButton() {
        DispatchQueue.main.async {
            self.scrollContentView.addSubview(self.moreButton)
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
                   
            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
                   let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
    }
    
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func moreUnwrap() {
        unwrapped = true
//        summaryHeightClosed = summaryTextView.frame.height
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(Program.summary!) "
//        summaryViewHeight.constant = summaryTextView.intrinsicContentSize.height
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
            
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        summaryTextView.layoutIfNeeded()
        scrollContentView.layoutIfNeeded()
    }
    
    @objc func editProgramButtonPress() {
        let editProgramVC = EditProgramVC()
        editProgramVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProgramVC, animated: true)
    }
    
    @objc func shareButtonPress() {
        settingsLauncher.showSettings()
    }
    
}

extension ProgramAccountVC: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade

        
        if scrollView.contentOffset.y >= -45.5 {
             navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = User.username
        } else {
            navigationItem.title = ""
        }
        
    }
    
}
