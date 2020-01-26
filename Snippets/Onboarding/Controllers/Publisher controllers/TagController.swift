//
//  TagController.swift
//  Snippets
//
//  Created by Waylan Sands on 22/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class TagController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainAccountTitle: UILabel!
    @IBOutlet weak var mainAccountSummary: UILabel!
    @IBOutlet weak var tagTextView: UITextView!
    
    var accountSummary: String?
    var accountTitle: NSAttributedString?
    
    
    @IBOutlet weak var firstTagButton: UIButton!
    @IBOutlet weak var secondTagButton: UIButton!
    @IBOutlet weak var thirdTagButton: UIButton!
    
    @IBOutlet var tagButtons: [UIButton]!
    
    
    @IBOutlet weak var tagScrollView: UIScrollView!
    @IBOutlet weak var tagScrollSubview: UIView!
    @IBOutlet weak var scrollSubviewWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var floatingDetailsView: UIView!
    @IBOutlet weak var secondaryImageView: UIImageView!
    @IBOutlet weak var secondaryNameLabel: UILabel!
    @IBOutlet weak var secondaryIdLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    let maxCharacters = 30
    var tagsUsed: [String] = []
    var tagsSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagTextView.delegate = self
        mainAccountSummary.text = accountSummary
        mainAccountTitle.attributedText = accountTitle
        tagTextView.textColor = CustomStyle.fourthShade
        styleTags()
    }

    override func viewWillLayoutSubviews() {
        mainAccountSummary.sizeToFit()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tagTextView.textColor == CustomStyle.fourthShade {
            tagTextView.text = nil
            tagTextView.textColor = CustomStyle.primaryblack
        }
    }
    
    func styleTags() {
        for eachTag in tagButtons {
            eachTag.setTitle("", for: .normal)
            eachTag.backgroundColor = CustomStyle.secondShade
            eachTag.layer.cornerRadius = 10.5
            eachTag.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            eachTag.titleLabel?.textColor = CustomStyle.fourthShade
            eachTag.isHidden = true
            eachTag.isUserInteractionEnabled = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        characterCountLabel.text =  String(maxCharacters - mainAccountSummary.text!.count)
        
        tagsUsed = textView.text.split(separator: " ").map { String($0) }
        print(tagsUsed)
        
        switch tagsUsed.count {
        case 0:
            firstTagButton.isHidden = true
        case 1:
            firstTagButton.setTitle(tagsUsed[0], for: .normal)
            firstTagButton.isHidden = false
            secondTagButton.isHidden = true
            thirdTagButton.isHidden = true
            updateWidthWith()
        case 2:
            secondTagButton.setTitle(tagsUsed[1], for: .normal)
            secondTagButton.isHidden = false
            thirdTagButton.isHidden = true
            updateWidthWith()
        case 3:
            thirdTagButton.setTitle(tagsUsed[2], for: .normal)
            thirdTagButton.isHidden = false
            updateWidthWith()
        default:
            return
        }
        
    }
    
    func updateWidthWith() {
        var totalWidth: CGFloat
        let scrollPadding: CGFloat = 18.0

        totalWidth = firstTagButton.frame.width + secondTagButton.frame.width + thirdTagButton.frame.width + scrollPadding
        
//        tagScrollSubview.translatesAutoresizingMaskIntoConstraints = false

        if totalWidth > tagScrollView.frame.width {
            tagScrollSubview.translatesAutoresizingMaskIntoConstraints = false
            tagScrollSubview.widthAnchor.constraint(greaterThanOrEqualTo: tagScrollView.widthAnchor, constant: totalWidth - tagScrollView.frame.width).isActive = true
            scrollSubviewWidthContraint.priority = .defaultLow
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Return true to allow keyboard inputs false to otherwise
        
        print(tagsSelected)
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")

        if (isBackSpace == -92) {
             print("Backspace was pressed")
             return true
        }
        
        let tagCount = textView.text.filter() {$0 == " "}.count
        return tagsUsed.count < 4 && tagCount <= 2
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.deleteBackward()
        if tagTextView.text.isEmpty {
            tagTextView.text = "Write a short summary highlighting what your program iss about."
            tagTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
