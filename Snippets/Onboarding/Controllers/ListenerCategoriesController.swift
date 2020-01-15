//
//  ListenerCategoriesController.swift
//  Snippets
//
//  Created by Waylan Sands on 15/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ListenerCategoriesController: UIViewController {
    
    @IBOutlet var categoryButtons: [UIButton]!
    @IBOutlet weak var continueButton: UIButton!
    
    let categories = Categories()
    var categorySelection: [String] = []
    let selectionMax = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupCategoryButtons()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)

    }
    
    func setupCategoryButtons() {
        for eachButton in categoryButtons {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: eachButton)
            eachButton.setTitle(categories.availableCategories[categoryButtons.firstIndex(of: eachButton)!], for: .normal)
        }
    }
    
    
    @IBAction func backButtonSelected() {
    navigationController?.popViewController(animated: true)
    }
    
    @IBAction func categorySelected(_ sender: UIButton) {
        if !categorySelection.contains(sender.titleLabel!.text!) && categorySelection.count < selectionMax {
            CustomStyle.categoryButtonSelected(backgroundColor: CustomStyle.white ,textColor: CustomStyle.primaryblack ,button: sender)
            categorySelection.append(sender.titleLabel!.text!)
        } else if categorySelection.contains(sender.titleLabel!.text!) {
            CustomStyle.styleCategoryButtons(color: #colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1), button: sender)
            categorySelection = categorySelection.filter{$0 != sender.titleLabel!.text!}
        }
        
        if categorySelection.count == selectionMax {
            continueButton.alpha = 1.0
        } else {
            continueButton.alpha = 0.7
        }
    }
    
    @IBAction func continueSelected() {
    }
    
}
