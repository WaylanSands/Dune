//
//  ListenerProgramSelectionController.swift
//  Snippets
//
//  Created by Waylan Sands on 16/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

struct CustomCellData {
    var programImage: UIImage
    var programName: String
    var userId: String
}

class ListenerProgramSelectionController: UIViewController {
    
    var backButtonTopAnchor: CGFloat = 65.0
    var headingLabelTopAnchor: CGFloat = 70.0
    var topContainerHeight: CGFloat = 90.0
    var subheadingSize: CGFloat = 22.0
    
    var categoriesSelected: [String] = []
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
        
    let data = [
        CustomCellData(programImage: #imageLiteral(resourceName: "keetIt"), programName: "Keep it", userId: "@keepIt"),
        CustomCellData(programImage: #imageLiteral(resourceName: "weird"), programName: "You made it weird", userId: "@YMIW"),
        CustomCellData(programImage: #imageLiteral(resourceName: "startUp"), programName: "StartUp", userId: "@StartUp"),
        CustomCellData(programImage: #imageLiteral(resourceName: "invisible"), programName: "99% Invisible", userId: "@99Invisible"),
    ]
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 790.0)
    
    lazy var scrollView: UIView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = self.view.bounds
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.frame.size = contentViewSize
        return containerView
    }()
    
    lazy var topContainerView: UIView = {
        let topContainerView = UIView()
        topContainerView.backgroundColor = CustomStyle.onboardingBlack
        return topContainerView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.frame = CGRect(x: 16.0, y: 45.0, width: 30.0, height: 30.0)
        backButton.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15.0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return backButton
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.textAlignment = .right
        confirmButton.tintColor = .white
        confirmButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -20.0)
        return confirmButton
    }()
        
    fileprivate let firstCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingProgramCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    fileprivate let secondCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingProgramCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    fileprivate let thirdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingProgramCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = CustomStyle.onboardingBlack
        
        customNavBar.skipButton.setTitle("Continue", for: .normal)
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
       
        styleForScreens()
        setupSubviews()
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            subheadingSize = 20.0
            backButtonTopAnchor = 30.0
            headingLabelTopAnchor = 60.0
            topContainerHeight = 60.0
        case .iPhone8, .iPhone8Plus:
            backButtonTopAnchor = 45.0
        case .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            headingLabelTopAnchor = 80.0
        case .unknown:
            break
        }
    }
    
    func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
                
        let headingLabel = CustomStyle.styleSignupHeadingLeftAlign(view: self.view, title: "Select  two programs from each category")
        containerView.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: headingLabelTopAnchor).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        headingLabel.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        let firstCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(size: subheadingSize, view: self.view, title: categoriesSelected[0])
        containerView.addSubview(firstCategoryLabel)
        firstCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        firstCategoryLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).isActive = true
        firstCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firstCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(firstCollectionView)
        firstCollectionView.translatesAutoresizingMaskIntoConstraints = false
        firstCollectionView.backgroundColor = CustomStyle.onboardingBlack
        firstCollectionView.topAnchor.constraint(equalTo: firstCategoryLabel.bottomAnchor, constant: 5).isActive = true
        firstCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firstCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstCollectionView.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        
        let secondCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(size: subheadingSize, view: self.view, title: categoriesSelected[1])
        containerView.addSubview(secondCategoryLabel)
        secondCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondCategoryLabel.topAnchor.constraint(equalTo: firstCollectionView.bottomAnchor, constant: 10).isActive = true
        secondCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        secondCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        secondCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(secondCollectionView)
        secondCollectionView.translatesAutoresizingMaskIntoConstraints = false
        secondCollectionView.backgroundColor = CustomStyle.onboardingBlack
        secondCollectionView.topAnchor.constraint(equalTo: secondCategoryLabel.bottomAnchor, constant: 5).isActive = true
        secondCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        secondCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        secondCollectionView.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
        
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        
        let thirdCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(size: subheadingSize, view: self.view, title: categoriesSelected[2])
        containerView.addSubview(thirdCategoryLabel)
        thirdCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdCategoryLabel.topAnchor.constraint(equalTo: secondCollectionView.bottomAnchor, constant: 10).isActive = true
        thirdCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        thirdCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        thirdCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(thirdCollectionView)
        thirdCollectionView.translatesAutoresizingMaskIntoConstraints = false
        thirdCollectionView.backgroundColor = CustomStyle.onboardingBlack
        thirdCollectionView.topAnchor.constraint(equalTo: thirdCategoryLabel.bottomAnchor, constant: 5).isActive = true
        thirdCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        thirdCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        thirdCollectionView.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
        
        thirdCollectionView.delegate = self
        thirdCollectionView.dataSource = self
    }

    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addTapped() {
        
    }
}

extension ListenerProgramSelectionController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 95.0, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingProgramCell
        cell.data = self.data[indexPath.row]
        
        cell.programImageButton.tag = indexPath.row
        cell.programImageButton.addTarget(cell, action: #selector(OnboardingProgramCell.programButtonPress(sender:)), for: .touchUpInside)

        return cell
    }
    
}
