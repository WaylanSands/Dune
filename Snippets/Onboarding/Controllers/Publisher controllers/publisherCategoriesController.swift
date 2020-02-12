//
//  publisherCategoriesController.swift
//  Snippets
//
//  Created by Waylan Sands on 20/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class publisherCategoriesController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var titleLabelStack: UIStackView!
    @IBOutlet weak var headlingTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var headingTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var continueButtonHeightAnchor: NSLayoutConstraint!
    
    var categories: [String] = []
    var selectedCategory: String?
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.navBarTitleLabel.isHidden = true
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        continueButton.titleLabel!.alpha = 0.7

        styleForScreens()
        setupCategoryButtons()
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headlingTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
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
        for eachCase in Categories.allCases {
            categories.append(eachCase.rawValue)
        }
        
        for eachButton in categoryButtons {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: eachButton)
            eachButton.setTitle(categories[categoryButtons.firstIndex(of: eachButton)!], for: .normal)
        }
    }
    
    @IBAction func categorySelected(_ sender: UIButton) {
        continueButton.titleLabel!.alpha = 1.0

        CustomStyle.categoryButtonSelected(backgroundColor: CustomStyle.white ,textColor: CustomStyle.primaryblack ,button: sender)
        selectedCategory = sender.titleLabel?.text
        
        let deselectButtons = categoryButtons.filter { $0.titleLabel?.text != sender.titleLabel?.text }
        for eachButton in deselectButtons {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: eachButton)
        }
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPress() {
        if selectedCategory != nil {
//            if let summaryController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "summaryController") as? PublisherSummaryController {
//                navigationController?.pushViewController(summaryController, animated: true)
            let summaryController = PublisherAddSummaryController()
            navigationController?.pushViewController(summaryController, animated: true)
            }
        }
    
}
