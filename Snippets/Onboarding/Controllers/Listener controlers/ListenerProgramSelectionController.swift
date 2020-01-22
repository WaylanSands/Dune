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
    
    var categoriesSelected: [String] = []
        
    let data = [
        CustomCellData(programImage: #imageLiteral(resourceName: "keetIt"), programName: "Keep it", userId: "@keepIt"),
        CustomCellData(programImage: #imageLiteral(resourceName: "weird"), programName: "You made it weird", userId: "@YMIW"),
        CustomCellData(programImage: #imageLiteral(resourceName: "startUp"), programName: "StartUp", userId: "@StartUp"),
        CustomCellData(programImage: #imageLiteral(resourceName: "invisible"), programName: "99% Invisible", userId: "@99Invisible"),
    ]
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: 820.0)
    
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
        backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return backButton
    }()
    
    lazy var confirmButton: UIButton = {
        let confirmButton = UIButton()
        confirmButton.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .bold)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = CustomStyle.onboardingBlack
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.addSubview(topContainerView)
        
        containerView.bringSubviewToFront(topContainerView)
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topContainerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        topContainerView.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 50).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        topContainerView.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 50).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
                
        let headingLabel = CustomStyle.styleSignupHeadingLeftAlign(view: self.view, title: "Select  two programs from each category")
        containerView.addSubview(headingLabel)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40).isActive = true
        headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        headingLabel.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        
        let firstCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(view: self.view, title: categoriesSelected[0])
        containerView.addSubview(firstCategoryLabel)
        firstCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        firstCategoryLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 30).isActive = true
        firstCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firstCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(firstCollectionView)
        firstCollectionView.backgroundColor = CustomStyle.onboardingBlack
        firstCollectionView.topAnchor.constraint(equalTo: firstCategoryLabel.bottomAnchor, constant: 5).isActive = true
        firstCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        firstCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        firstCollectionView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        firstCollectionView.delegate = self
        firstCollectionView.dataSource = self
        
        let secondCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(view: self.view, title: categoriesSelected[1])
        containerView.addSubview(secondCategoryLabel)
        secondCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        secondCategoryLabel.topAnchor.constraint(equalTo: firstCollectionView.bottomAnchor, constant: 10).isActive = true
        secondCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        secondCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        secondCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(secondCollectionView)
        secondCollectionView.backgroundColor = CustomStyle.onboardingBlack
        secondCollectionView.topAnchor.constraint(equalTo: secondCategoryLabel.bottomAnchor, constant: 5).isActive = true
        secondCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        secondCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        secondCollectionView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        secondCollectionView.delegate = self
        secondCollectionView.dataSource = self
        
        let thirdCategoryLabel = CustomStyle.styleSignupSubHeadingLeftAlign(view: self.view, title: categoriesSelected[2])
        containerView.addSubview(thirdCategoryLabel)
        thirdCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        thirdCategoryLabel.topAnchor.constraint(equalTo: secondCollectionView.bottomAnchor, constant: 10).isActive = true
        thirdCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        thirdCategoryLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        thirdCategoryLabel.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        containerView.addSubview(thirdCollectionView)
        thirdCollectionView.backgroundColor = CustomStyle.onboardingBlack
        thirdCollectionView.topAnchor.constraint(equalTo: thirdCategoryLabel.bottomAnchor, constant: 5).isActive = true
        thirdCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        thirdCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        thirdCollectionView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        
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
        return CGSize(width: 100, height: 170.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnboardingProgramCell
        cell.data = self.data[indexPath.row]
        return cell
    }
    
}
