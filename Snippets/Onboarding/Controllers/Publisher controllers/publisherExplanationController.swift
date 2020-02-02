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
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelDescription: UILabel!
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var programDescription: UILabel!
    @IBOutlet weak var containerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topContainerHeight: NSLayoutConstraint!
    
    let deviceType = UIDevice.current.deviceType
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1), image: nil, button: createChannel)
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 0.3184746802, green: 0.5403701067, blue: 1, alpha: 1), image: nil, button: createProgram)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            backButtonTopAnchor.constant = 30.0
            headingLabelTopAnchor.constant = 60.0
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            topContainerHeight.constant = 60.0
            containerViewHeight.constant = 1600.0
        case .iPhone8, .iPhone8Plus:
            backButtonTopAnchor.constant = 40.0
            topContainerHeight.constant = 80.0
            containerViewHeight.constant = 1490.0
        case .iPhone11, .iPhone11Pro, .iPhone11ProMax:
            containerViewHeight.constant = 1500.0
        case .unknown:
            break
        }
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
