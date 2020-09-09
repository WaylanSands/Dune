//
//  ListenerAccount.swift
//  Dune
//
//  Created by Waylan Sands on 29/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//


import UIKit
import Firebase

class ListenerAccountVC : UIViewController {
        
    let minHeight = UIDevice.current.navBarHeight() + 40
    let navHeight = UIDevice.current.navBarHeight()

    var imageSize: CGFloat = 60.0
    let maxPrograms = 10
    
    var unwrapped = false
    var unwrapDifference: CGFloat = 0
    
    let viewFrame = UIScreen.main.bounds
    var headerHeight: ClosedRange<CGFloat>!
    var tableViews: [Int: UIView] = [:]
    var currentIndex: Int = 0
    
    let accountBottomVC = ListenerAccountBottomVC()
   
    let settingsLauncher = SettingsLauncher(options: SettingOptions.sharing, type: .sharing)
    let switchToPublisherAlert = CustomAlertView(alertType: .switchToPublisher)
    let nonPublisherAlert = CustomAlertView(alertType: .publisherNotSetUp)
    
    lazy var headerBarButtons: [UIButton] = [subscriptionsButton, mentionsButton]
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.backgroundColor = .white
        nav.alpha = 0.9
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.frame = UIScreen.main.bounds
        view.scrollsToTop = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.doNotAdjustContentInset()
        return view
    }()
    
    let overlayScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        view.showsVerticalScrollIndicator = false
        view.doNotAdjustContentInset()
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    let topDetailsView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mainImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = imageSize / 2
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(changeImageButtonPress), for: .touchUpInside)
        return button
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
    
    let websiteLinkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "website-link"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(CustomStyle.primaryBlue, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(websiteButtonPress), for: .touchUpInside)
        return button
    }()
    
    let linkAndStatsStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .leading
        return view
    }()
    
    let statsView: UIView = {
        let view = UIView()
        return view
    }()
    
    let subscriptionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        return label
    }()
    
    let subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var repCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.sixthShade
        label.text = "\(CurrentProgram.rep!)"
        return label
    }()
    
    let repLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = CustomStyle.fourthShade
        label.text = "Cred"
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
        button.setTitle("Edit Profile", for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(editProgramButtonPress), for: .touchUpInside)
        return button
    }()
    
    let becomePublisherButton: AccountButton = {
        let button = AccountButton()
        button.setImage(UIImage(named: "switch-account-icon"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(becomePublisherPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.setTitle("Publish Content", for: .normal)
        return button
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

    
    let mentionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mentions", for: .normal)
        button.setTitleColor(CustomStyle.thirdShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    let subscriptionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscriptions", for: .normal)
        button.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        button.addTarget(self, action: #selector(tableViewTabButtonPress(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nonPublisherAlert.alertDelegate = self
        switchToPublisherAlert.alertDelegate = self
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        overlayScrollView.setScrollBarToTopLeft()
        configurePrivacyState()
        setupNavigationBar()
        addWebLink()

        nameLabel.text = CurrentProgram.name
        mainImageButton.setBackgroundImage(CurrentProgram.image!, for: .normal)
        usernameLabel.text = "@\(User.username!)"
        repCountLabel.text = String(CurrentProgram.rep!)
        subscriptionCountLabel.text = (CurrentProgram.subscriptionIDs!.count - 1).roundedWithAbbreviations
        
        configureSummary()
        configureSubscriptionLabel()

        if unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
            unwrapped = false
        }
    }
    
    func  configurePrivacyState() {
        switch CurrentProgram.privacyStatus {
        case .madePrivate:
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: privacyImage(), style: .plain, target: self, action: #selector(viewPendingRequests))
            navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        case .madePublic:
            navigationItem.leftBarButtonItem = nil
        default:
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    func privacyImage() -> UIImage {
        if CurrentProgram.pendingChannels!.isEmpty {
            return UIImage(named: "no-requests-pending")!
        } else {
           return UIImage(named: "requests-pending")!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        headerHeight = (minHeight)...headerHeightCalculated()
        prepareSetup()
        updateScrollContent()
        DispatchQueue.main.async {
            if self.summaryTextView.lineCount() > 3 {
                self.addMoreButton()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        tableViewTabButtonPress(sender: subscriptionsButton)
        websiteLinkButton.removeConstraints(websiteLinkButton.constraints)
        websiteLinkButton.removeFromSuperview()
    }
    
    func setupNavigationBar() {
//        tabBarController?.tabBar.backgroundImage = UIImage()
//        tabBarController?.tabBar.backgroundColor = hexStringToUIColor(hex: "F4F7FB")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: CustomStyle.primaryBlack]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.tintColor = CustomStyle.primaryBlack
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "white-settings-icon"), style: .plain, target: self, action: #selector(settingsButtonPress))
    }
    
    func configureSubscriptionLabel() {
        let subscriptions = CurrentProgram.subscriptionIDs!.count - 1

        if subscriptions == 1 {
            subscriptionsLabel.text = "subscription"
        } else {
            subscriptionsLabel.text = "subscriptions"
        }
    }
    
    func configureSummary() {
        if CurrentProgram.summary != "" {
           summaryTextView.text = CurrentProgram.summary
        } else {
            summaryTextView.text = "Share a little information about yourself."
        }
    }
    
    func prepareSetup() {
        headerView.frame = CGRect(x: viewFrame.minX, y: CGFloat(0), width: viewFrame.width, height: CGFloat(headerHeight.upperBound))
        scrollView.contentSize = CGSize.init(width: viewFrame.width, height: viewFrame.height + CGFloat(headerHeight.upperBound))
       
        overlayScrollView.frame = CGRect(x: viewFrame.minX, y: viewFrame.minY, width: viewFrame.width, height: viewFrame.height)
        overlayScrollView.contentSize = self.scrollView.contentSize
        overlayScrollView.layer.zPosition = 999
        overlayScrollView.delegate = self
        
        self.add(accountBottomVC, to: scrollView, frame:  CGRect(x: viewFrame.minX, y: headerHeight.upperBound, width: viewFrame.width, height: viewFrame.height))

        self.tableViews[currentIndex] = accountBottomVC.activeTableView()
        if let scrollView = self.tableViews[currentIndex] as? UIScrollView {
            scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
            scrollView.doNotAdjustContentInset()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UIScrollView, let scroll = self.tableViews[currentIndex] as? UIScrollView {
            if obj == scroll && keyPath == #keyPath(UIScrollView.contentSize) {
                self.overlayScrollView.contentSize = getContentSize(for: scroll)
            }
        }
    }

    func headerHeightCalculated() -> CGFloat {
        var height: CGFloat = 73 + navHeight
        
        for each in headerView.subviews {
            height += each.frame.height
        }
        
        if headerView.subviews.contains(moreButton) {
            height -= moreButton.frame.height
        }
            
        accountBottomVC.headerHeight = height
        return height
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            imageSize = 60
            editProgramButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            becomePublisherButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
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
    
    func configureViews() {
        view.addSubview(overlayScrollView)
        view.addSubview(scrollView)
        scrollView.addSubview(headerView)
        scrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        
        headerView.addSubview(topDetailsView)
        topDetailsView.translatesAutoresizingMaskIntoConstraints = false
        topDetailsView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: navHeight).isActive = true
        topDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        topDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        topDetailsView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
//        topDetailsView.backgroundColor = .brown
        
        topDetailsView.addSubview(mainImageButton)
        mainImageButton.translatesAutoresizingMaskIntoConstraints = false
        mainImageButton.topAnchor.constraint(equalTo:topDetailsView.topAnchor, constant: 0).isActive = true
        mainImageButton.leadingAnchor.constraint(equalTo:topDetailsView.leadingAnchor).isActive = true
        mainImageButton.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        mainImageButton.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        topDetailsView.addSubview(topMiddleStackedView)
        topMiddleStackedView.translatesAutoresizingMaskIntoConstraints = false
        topMiddleStackedView.centerYAnchor.constraint(equalTo: mainImageButton.centerYAnchor).isActive = true
        topMiddleStackedView.leadingAnchor.constraint(equalTo: mainImageButton.trailingAnchor, constant: 10).isActive = true
        topMiddleStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16).isActive = true
        topMiddleStackedView.addArrangedSubview(nameLabel)
        topMiddleStackedView.addArrangedSubview(usernameLabel)
        
        headerView.addSubview(summaryTextView)
        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
        summaryTextView.topAnchor.constraint(equalTo: topDetailsView.bottomAnchor, constant: 20).isActive = true
        summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        headerView.addSubview(linkAndStatsStackedView)
        linkAndStatsStackedView.translatesAutoresizingMaskIntoConstraints = false
        linkAndStatsStackedView.topAnchor.constraint(equalTo: summaryTextView.bottomAnchor, constant: 15).isActive = true
        linkAndStatsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        linkAndStatsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        linkAndStatsStackedView.addArrangedSubview(statsView)
        statsView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        statsView.widthAnchor.constraint(equalTo: linkAndStatsStackedView.widthAnchor).isActive = true
        
        statsView.addSubview(subscriptionCountLabel)
        subscriptionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptionCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        
        statsView.addSubview(subscriptionsLabel)
        subscriptionsLabel.translatesAutoresizingMaskIntoConstraints = false
        subscriptionsLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        subscriptionsLabel.leadingAnchor.constraint(equalTo: subscriptionCountLabel.trailingAnchor, constant: 5).isActive = true
        subscriptionsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        statsView.addSubview(repCountLabel)
        repCountLabel.translatesAutoresizingMaskIntoConstraints = false
        repCountLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        repCountLabel.leadingAnchor.constraint(equalTo: subscriptionsLabel.trailingAnchor, constant: 15).isActive = true
        
        statsView.addSubview(repLabel)
        repLabel.translatesAutoresizingMaskIntoConstraints = false
        repLabel.centerYAnchor.constraint(equalTo: statsView.centerYAnchor).isActive = true
        repLabel.leadingAnchor.constraint(equalTo: repCountLabel.trailingAnchor, constant: 5).isActive = true
        
        headerView.addSubview(buttonsStackedView)
        buttonsStackedView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackedView.topAnchor.constraint(equalTo: linkAndStatsStackedView.bottomAnchor, constant: 20).isActive = true
        buttonsStackedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        buttonsStackedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        buttonsStackedView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        buttonsStackedView.addArrangedSubview(editProgramButton)
        buttonsStackedView.addArrangedSubview(becomePublisherButton)
        
        headerView.addSubview(tableViewButtons)
        tableViewButtons.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtons.topAnchor.constraint(equalTo: editProgramButton.bottomAnchor, constant: 20).isActive = true
        tableViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtons.heightAnchor.constraint(equalToConstant: 40).isActive = true
          
        tableViewButtons.addSubview(subscriptionsButton)
        subscriptionsButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: -4).isActive = true
        subscriptionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        tableViewButtons.addSubview(mentionsButton)
        mentionsButton.translatesAutoresizingMaskIntoConstraints = false
        mentionsButton.centerYAnchor.constraint(equalTo: tableViewButtons.centerYAnchor, constant: -4).isActive = true
        mentionsButton.leadingAnchor.constraint(equalTo: subscriptionsButton.trailingAnchor, constant: 20).isActive = true
        
        tableViewButtons.addSubview(tableViewButtonsLine)
        tableViewButtonsLine.translatesAutoresizingMaskIntoConstraints = false
        tableViewButtonsLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableViewButtonsLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableViewButtonsLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableViewButtonsLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
                
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func addWebLink() {
        if CurrentProgram.webLink != nil && CurrentProgram.webLink != "" {
        linkAndStatsStackedView.insertArrangedSubview(websiteLinkButton, at: 0)
        websiteLinkButton.setTitle(CurrentProgram.webLink?.lowercased(), for: .normal)
        websiteLinkButton.widthAnchor.constraint(equalToConstant: websiteLinkButton.intrinsicContentSize.width + 15).isActive = true
        websiteLinkButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        }
    }
    
    func addMoreButton() {
        DispatchQueue.main.async {
            self.headerView.addSubview(self.moreButton)
            self.moreButton.translatesAutoresizingMaskIntoConstraints = false
            self.moreButton.bottomAnchor.constraint(equalTo: self.summaryTextView.bottomAnchor).isActive = true
            self.moreButton.trailingAnchor.constraint(equalTo: self.summaryTextView.trailingAnchor).isActive = true
            self.moreButton.heightAnchor.constraint(equalToConstant: self.summaryTextView.font!.lineHeight).isActive = true
            
            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width - 10, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 10, height: self.summaryTextView.font!.lineHeight)
            let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
    }

    
    // MARK: Table View Tab Button
    @objc func tableViewTabButtonPress(sender: UIButton) {
        sender.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        let nonSelectedButtons = headerBarButtons.filter() { $0 != sender }
        for each in nonSelectedButtons {
            each.setTitleColor(CustomStyle.thirdShade, for: .normal)
        }

         let title = sender.titleLabel!.text!
         accountBottomVC.updateTableViewWith(title: title)
        
        switch title {
        case "Subscriptions":
            currentIndex = 0
        case "Mentions":
            currentIndex = 1
        default:
            break
        }
         updateScrollContent()
    }
    
    @objc func websiteButtonPress() {
        let link = linkWithPrefix(urlString: CurrentProgram.webLink!)
    
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    func linkWithPrefix(urlString: String) -> String {
        if !urlString.starts(with: "http://") && !urlString.starts(with: "https://") {
            print("Added https")
            return "https://\(urlString)"
        } else if urlString.hasPrefix("http://") {
            let url = urlString.dropFirst("http://".count)
            print("switched to https")
            return "https://" + url
        } else {
            return urlString
        }
    }
    
    func updateScrollContent() {
        let vc = accountBottomVC
        if self.tableViews[currentIndex] == nil{
            self.tableViews[currentIndex] = vc.activeTableView()
            if let scrollView = self.tableViews[currentIndex] as? UIScrollView{
                scrollView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
                scrollView.doNotAdjustContentInset()
            }
        }
        
        if let scrollView = self.tableViews[currentIndex] as? UIScrollView{
            self.overlayScrollView.contentSize = getContentSize(for: scrollView)
            scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: .new, context: nil)
        }else if let bottomView = self.tableViews[currentIndex]{
            self.overlayScrollView.contentSize = getContentSize(for: bottomView)
        }
    }
    
    func getContentSize(for bottomView: UIView) -> CGSize {
        if let scroll = bottomView as? UIScrollView {
            let bottomHeight = max(scroll.contentSize.height, self.view.frame.height - CGFloat(headerHeight.lowerBound))
            return CGSize.init(width: scroll.contentSize.width, height: bottomHeight + CGFloat(headerHeight.upperBound))
        } else {
            let bottomHeight = self.view.frame.height - CGFloat(headerHeight.lowerBound)
            return CGSize.init(width: bottomView.frame.width, height: bottomHeight + CGFloat(headerHeight.upperBound))
        }
    }
 
    @objc func settingsButtonPress() {
        let settingsVC = AccountSettingsVC()
//        settingsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc func moreUnwrap() {
        let heightBefore = summaryTextView.frame.height
        unwrapped = true
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryTextView.text = "\(CurrentProgram.summary!) "
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
        
        if UIDevice.current.deviceType == .iPhoneSE {
        }
        summaryTextView.layoutIfNeeded()
        view.layoutIfNeeded()
        
        let heighAfter = summaryTextView.frame.height
        unwrapDifference = heighAfter - heightBefore
        accountBottomVC.unwrapDifference = unwrapDifference
        updateHeaderHeight()
    }
    
    func updateHeaderHeight() {
        headerHeight = (minHeight)...headerHeightCalculated()
        prepareSetup()
        updateScrollContent()
    }
    
    @objc func editProgramButtonPress() {
        let editListenerVC = EditListenerVC()
//        editListenerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editListenerVC, animated: true)
    }
    
    @objc func becomePublisherPress() {
        UIApplication.shared.keyWindow!.addSubview(switchToPublisherAlert)
    }
    
    @objc func pushSubscribersVC() {
        let subscribersVC = SubscribersVC(programName: CurrentProgram.name!, programID: CurrentProgram.ID!, programIDs: CurrentProgram.programsIDs(), subscriberIDs: CurrentProgram.subscriberIDs!)
//        subscribersVC.hidesBottomBarWhenPushed = true
        subscribersVC.isPublic = CurrentProgram.isPrivate!
        navigationController?.pushViewController(subscribersVC, animated: true)
    }
    
    @objc func viewPendingRequests() {
        let requests = PendingRequestsVC(pendingIDs: CurrentProgram.pendingChannels!)
        navigationController?.pushViewController(requests, animated: true)
    }
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ListenerAccountVC: UIScrollViewDelegate {
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        let topHeight = CGFloat(headerHeight.upperBound) - CGFloat(headerHeight.lowerBound)
        
        if scrollView.contentOffset.y < topHeight {
            self.scrollView.contentOffset.y = scrollView.contentOffset.y
            accountBottomVC.activeTV.contentOffset.y = 0
        } else {
            self.scrollView.contentOffset.y = CGFloat(headerHeight.upperBound) - CGFloat(headerHeight.lowerBound)
             (self.tableViews[currentIndex] as? UIScrollView)?.contentOffset.y = scrollView.contentOffset.y - self.scrollView.contentOffset.y
        }

        if scrollView.contentOffset.y < 0{
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: min(topHeight, scrollView.contentOffset.y),
                                      width: headerView.frame.width,
                                      height: max(CGFloat(headerHeight.lowerBound), CGFloat(headerHeight.upperBound) + -scrollView.contentOffset.y))

        } else {
            headerView.frame = CGRect(x: headerView.frame.minX,
                                      y: 0,
                                      width: headerView.frame.width,
                                      height: CGFloat(headerHeight.upperBound))
        }

        let progress = self.scrollView.contentOffset.y / topHeight
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade
        
        if progress > 0.2 {
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = User.username
        } else {
            navigationItem.title = ""
        }
        
        if progress > 0.97 {
            customNavBar.alpha = 1
        } else {
            customNavBar.alpha = 0.9
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= 90.0 {
            switch accountBottomVC.activeTV {
            case accountBottomVC.mentionTV:
                print("mentionTV")
            case accountBottomVC.subscriptionTV:
                print("subscriptionTV")
            default:
                break
            }
        }
    }
}

extension ListenerAccountVC: CustomAlertDelegate {
   
    func primaryButtonPress() {
        User.isSetUp = false
        CurrentProgram.isPublisher = true
        let editProgramVC = EditProgramVC()
        editProgramVC.switchedAccount = true
        FireStoreManager.updateProgramToPublisher()
        FireStoreManager.updateUserSetUpTo(false)
//        editProgramVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editProgramVC, animated: true)
    }
    
    func cancelButtonPress() {
        //
    }
}

extension ListenerAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            CurrentProgram.image = selectedImage
            mainImageButton.setBackgroundImage(selectedImage, for: .normal)
            
            FileManager.storeSelectedProgramImage(image: selectedImage, imageID: CurrentProgram.imageID, programID: CurrentProgram.ID!)
            dismiss(animated: true, completion: nil)
        }
    }
}




