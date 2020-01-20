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
    var categories: [String] = []
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCategoryButtons()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)
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
    }
    
    
}
