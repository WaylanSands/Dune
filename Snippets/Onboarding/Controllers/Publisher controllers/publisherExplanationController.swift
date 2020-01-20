//
//  publisherExplanationController.swift
//  Snippets
//
//  Created by Waylan Sands on 18/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class publisherExplanationController: UIViewController {
    
    @IBOutlet weak var createChannel: UIButton!
    @IBOutlet weak var createProgram: UIButton!
    
    let nameController = publisherNameController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1), image: nil, button: createChannel)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.3184746802, green: 0.5403701067, blue: 1, alpha: 1), image: nil, button: createProgram)
    }
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createChannelPress(_ sender: Any) {
        if let nameController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "nameController") as? publisherNameController {
            nameController.publisherAccountType = .channel
            navigationController?.pushViewController(nameController, animated: true)
        }
    }
    
    @IBAction func createProgramPress(_ sender: Any) {
        if let nameController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "nameController") as? publisherNameController {
            nameController.publisherAccountType = .program
            navigationController?.pushViewController(nameController, animated: true)
        }
    }
    
}
