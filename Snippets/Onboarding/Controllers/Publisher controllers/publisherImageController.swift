//
//  publisherImageController.swift
//  Snippets
//
//  Created by Waylan Sands on 20/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class publisherImageController: UIViewController {
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: uploadImageButton)
        
    }
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func uploadImageButtonPress() {
        if let categoriesController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "categoriesController") as? publisherCategoriesController {
            navigationController?.pushViewController(categoriesController, animated: true)
        }
    }
    
    
}
