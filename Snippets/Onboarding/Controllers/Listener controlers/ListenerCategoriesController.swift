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
    @IBOutlet weak var continueButtonBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var categoryStack: UIStackView!
    @IBOutlet weak var titleLabelStack: UIStackView!
    @IBOutlet weak var titleLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    let deviceType = UIDevice.current.deviceType
    
    var categories: [String] = []
    var categorySelection: [String] = []
    let selectionMax = 3
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryButtons()
        styleForScreens()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            backButtonTopAnchor.constant = 10.0
            mainTitleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            titleLabelTopAnchor.constant = 40.0
            continueButtonBottomAnchor.constant = 25.0
            shrinkButtons()
        case .iPhone8:
            titleLabelTopAnchor.constant = 70.0
            continueButtonBottomAnchor.constant = 50.0
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

    @IBAction func backButtonPress() {
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
        let programSelector = ListenerProgramSelectionController()
        programSelector.categoriesSelected = categorySelection
        navigationController?.pushViewController(programSelector, animated: true)
    }
    
}
