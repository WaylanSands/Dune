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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var titleLabelStack: UIStackView!
    @IBOutlet weak var headlingTitleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var categoryStack: UIStackView!
    var categories: [String] = []
    var selectedCategory: String?
    
    let deviceType = UIDevice.current.deviceType

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryButtons()
        styleCategoryButtons()
        styleTitleLabel()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)
    }
    
    func styleTitleLabel() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            break
        case .iPhone8:
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0).isActive = true
            titleLabelStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 90.0).isActive = true
            subtitleLabel.topAnchor.constraint(equalTo: headlingTitleLabel.bottomAnchor, constant: 10.0).isActive = true
            styleCategoryButtons()
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        default:
            return
        }
    }
        func styleCategoryButtons() {
    categoryStack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40.0).isActive = true
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
        continueButton.alpha = 1.0

        CustomStyle.categoryButtonSelected(backgroundColor: CustomStyle.white ,textColor: CustomStyle.primaryblack ,button: sender)
        selectedCategory = sender.titleLabel?.text
        
        let deselectButtons = categoryButtons.filter { $0.titleLabel?.text != sender.titleLabel?.text }
        for eachButton in deselectButtons {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: eachButton)
        }
    }
    
    
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPress() {
        if selectedCategory != nil {
            if let summaryController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "summaryController") as? PublisherSummaryController {
                navigationController?.pushViewController(summaryController, animated: true)
            }
        }
    }
    
    
}