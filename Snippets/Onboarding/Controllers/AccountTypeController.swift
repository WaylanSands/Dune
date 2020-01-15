//
//  AccountTypeController.swift
//  Snippets
//
//  Created by Waylan Sands on 13/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AccountTypeController: UIViewController {

    @IBOutlet weak var listenerButton: UIButton!
    @IBOutlet weak var publisherButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomStyle.styleRoundedSignUpButton(color: #colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1), image: #imageLiteral(resourceName: "headphones-icon") , button: listenerButton)
        CustomStyle.styleRoundedPublishserpButton(borderColor: CustomStyle.whiteCg, backgroundColor: #colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 0), image: #imageLiteral(resourceName: "publisher-icon"), button: publisherButton)
    }

}
