//
//  TagController.swift
//  Snippets
//
//  Created by Waylan Sands on 22/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class TagController: UIViewController {

    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainAccountTitle: UILabel!
    @IBOutlet weak var mainAccountSummary: UILabel!
    
    var accountSummary: String?
    var accountTitle: NSAttributedString?

    @IBOutlet weak var firstTagLabel: UILabel!
    @IBOutlet weak var secondTagLabel: UILabel!
    @IBOutlet var thirdTagLabel: UIView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var floatingDetailsView: UIView!
    @IBOutlet weak var secondaryImageView: UIImageView!
    @IBOutlet weak var secondaryNameLabel: UILabel!
    @IBOutlet weak var secondaryIdLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        mainAccountSummary.text = accountSummary
        mainAccountTitle.attributedText = accountTitle
    }
}
