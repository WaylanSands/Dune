//
//  ProgramAccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 4/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ProgramAccountVC: UIViewController {
    
    //    lazy var tagscrollViewWidth = tagScrollView.frame.width
    var summaryHeightClosed: CGFloat = 0
    var tagContentWidth: NSLayoutConstraint!
    var summaryViewHeight: NSLayoutConstraint!
    var largeImageSize: CGFloat = 74.0
    var fontNameSize: CGFloat = 16
    var fontIDSize: CGFloat = 14
    var unwrapped = false
    //    lazy var tagButtons: [UIButton] = [firstTagButton, secondTagButton, thirdTagButton]
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
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
        label.text = "Hollywood"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = CustomStyle.primaryblack
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@PlanetHollywood"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.primaryBlue
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    let playIntroButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryYellow
        button.layer.cornerRadius = 15
        button.setTitle("Play Intro", for: .normal)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
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
        view.text = "The Daily is a daily news podcast and radio show by the American newspaper The New York Times and all the other things that go in here and make lines wrap. I hope you join me and enjoy the show."
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
    
    let promotionsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Promotions", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.backgroundColor = CustomStyle.accountButtonGrey
        button.setImage(UIImage(named: "promotions-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        button.layer.cornerRadius = 6
        return button
    }()
    
    let insightsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Insights", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(CustomStyle.primaryblack, for: .normal)
        button.backgroundColor = CustomStyle.accountButtonGrey
        button.setImage(UIImage(named: "promotions-icon"), for: .normal)
        button.layer.cornerRadius = 6
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
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
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.setImage(#imageLiteral(resourceName: "back-button-blk"), for: .normal)
        nav.backgroundColor = .clear
        nav.rightButton.setImage(#imageLiteral(resourceName: "white-settings-icon"), for: .normal)
        //        nav.rightButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        configureViews()
        addMoreButton()
        setupTopBar()
        scrollView.delegate = self
    }
    
    func setupTopBar() {
        let navBar = navigationController!.navigationBar
        navigationController?.isNavigationBarHidden = false
        navBar.shadowImage = UIImage()
        navBar.tintColor = .black
        
        let userIdFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
            .foregroundColor: CustomStyle.primaryblack
        ]
        
        navBar.titleTextAttributes = userIdeAttributes
    }
    
    func setupNavBar() {
        self.title = "Settings"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  unwrapped {
            summaryTextView.textContainer.maximumNumberOfLines = 3
//            summaryTextView.backgroundColor = .red
            summaryHeightClosed = 0
            summaryViewHeight = summaryTextView.heightAnchor.constraint(equalToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
            summaryViewHeight.isActive = true
            addMoreButton()
            unwrapped = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {

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
        summaryViewHeight = summaryTextView.heightAnchor.constraint(equalToConstant: (summaryTextView.font!.lineHeight * 3) + 1)
        summaryViewHeight.isActive = true
        
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
        
        buttonsStackedView.addArrangedSubview(promotionsButton)
        buttonsStackedView.addArrangedSubview(insightsButton)
        
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

        

        print(programsStackView.arrangedSubviews.count)
        
//        view.addSubview(customNavBar)
//        customNavBar.pinNavBarTo(view)
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
                   
            let rect = CGRect(x: self.summaryTextView.frame.width - self.moreButton.intrinsicContentSize.width, y: self.summaryTextView.font!.lineHeight * 2, width: self.moreButton.intrinsicContentSize.width + 4, height: self.summaryTextView.font!.lineHeight)
                   let path = UIBezierPath(rect: rect)
            self.summaryTextView.textContainer.exclusionPaths = [path]
        }
    }
    
    @objc func moreUnwrap() {
        unwrapped = true
        summaryHeightClosed = summaryTextView.frame.height
        summaryTextView.textContainer.maximumNumberOfLines = 0
        summaryViewHeight.constant = summaryTextView.intrinsicContentSize.height
        moreButton.removeFromSuperview()
        summaryTextView.textContainer.exclusionPaths.removeAll()
        
        _ = summaryTextView.intrinsicContentSize.height - summaryHeightClosed
        
        if UIDevice.current.deviceType == .iPhoneSE {
            //            scrollHeight.constant = screenHeight + positionDifference
        }
        
        //        summaryBarYPosition.constant = positionDifference + summaryBarPadding
        summaryTextView.layoutIfNeeded()
        scrollContentView.layoutIfNeeded()
        //        summaryBar.layoutIfNeeded()
    }
    
    
    //    func setupAccountLabel() {
    //        let programName = "The Daily "
    //        let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .heavy)
    //        let programNameAttributedString = NSMutableAttributedString(string: programName)
    //        let programNameAttributes: [NSAttributedString.Key: Any] = [
    //            .font: programNameFont,
    //            .foregroundColor: CustomStyle.white
    //
    //        ]
    //        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
    //
    //        let userId = " @TheDaily"
    //        let userIdFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
    //        let userIdAttributedString = NSMutableAttributedString(string: userId)
    //        let userIdeAttributes: [NSAttributedString.Key: Any] = [
    //            .font: userIdFont,
    //            .foregroundColor: CustomStyle.fithShade
    //        ]
    //        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
    //        programNameAttributedString.append(userIdAttributedString)
    //        nameLabel.attributedText = programNameAttributedString
    //    }
    
}

extension ProgramAccountVC: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.5
        fadeTextAnimation.type = CATransitionType.fade

        
        if scrollView.contentOffset.y >= -45.5 {
             navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            self.title = "@PlanetHollywood"
        } else {
            self.title = ""
        }
        
    }
    
}
