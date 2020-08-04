//
//  InterestsVC.swift
//  Dune
//
//  Created by Waylan Sands on 29/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class InterestsVC: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var titleLabelStack: UIStackView!
    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var headingTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonHeightAnchor: NSLayoutConstraint!
    
    var categories = [String]()
    var selectedCategories = [String]()
//    var selectedCategory: String?
    lazy var deviceType = UIDevice.current.deviceType
    
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.titleLabel.text = ""
//        navBar.rightButton.setTitle("Skip", for: .normal)
        navBar.leftButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        return navBar
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        setupCategoryButtons()
        continueButton.isEnabled = false
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        continueButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingTopAnchor.constant = 40.0
            continueButtonHeightAnchor.constant = 45.0
            shrinkButtons()
            continueButton.titleEdgeInsets = .zero
        case .iPhone8:
            headingTopAnchor.constant = 70.0
            continueButtonHeightAnchor.constant = 45.0
            continueButton.titleEdgeInsets = .zero
        case .iPhone8Plus:
            continueButtonHeightAnchor.constant = 45.0
            continueButton.titleEdgeInsets = .zero
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
    
    func shrinkButtons() {
        for each in categoryButtons {
            each.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
    }
    
    func setupCategoryButtons() {
        for eachCase in Category.allCases {
            categories.append(eachCase.rawValue)
        }
        
        for eachButton in categoryButtons {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: eachButton)
            eachButton.setTitle(categories[categoryButtons.firstIndex(of: eachButton)!], for: .normal)
        }
    }
    
    @IBAction func categorySelected(_ sender: UIButton) {
        
        if selectedCategories.contains(sender.titleLabel!.text!) {
            selectedCategories.removeAll(where: {$0 == sender.titleLabel!.text!})
            CustomStyle.categoryButtonSelected(backgroundColor: CustomStyle.seventhShade ,textColor: CustomStyle.fifthShade ,button: sender)
        } else {
            selectedCategories.append(sender.titleLabel!.text!)
            CustomStyle.categoryButtonSelected(backgroundColor: CustomStyle.white ,textColor: CustomStyle.primaryBlack ,button: sender)
        }
        
        if selectedCategories.count > 0 {
            continueButton.isEnabled = true
            continueButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            continueButton.isEnabled = false
            continueButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        }

    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPress() {
        
//        CurrentProgram.primaryCategory = selectedCategory
//
//        let db = Firestore.firestore()
//        let programRef = db.collection("programs").document(CurrentProgram.ID!)
//
//        programRef.updateData([
//            "primaryCategory" : CurrentProgram.primaryCategory!
//        ]) { (error) in
//            if let error = error {
//                print("Error adding primaryCategory: \(error.localizedDescription)")
//            } else {
//                print("Successfully added primary category")
//                self.presentNextVC()
//            }
//        }
        
        User.interests = selectedCategories
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "interests" :  User.interests!,
        ]) { (error) in
            if let error = error {
                print("Error adding interests: \(error.localizedDescription)")
            } else {
                print("Successfully added interests")
                self.presentNextVC()
            }
        }

    }
    
    func presentNextVC() {
            let listenerBioVC = ListenerAddBioVC()
            navigationController?.pushViewController(listenerBioVC, animated: true)
    }
}
