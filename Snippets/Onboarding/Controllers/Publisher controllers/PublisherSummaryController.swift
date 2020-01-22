//
//  PublisherSummaryController.swift
//  Snippets
//
//  Created by Waylan Sands on 21/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PublisherSummaryController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainAccountTitle: UILabel!
    @IBOutlet weak var mainAccountSummary: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var textSummaryView: UITextView!
    @IBOutlet weak var floatingDetailsView: UIView!
    @IBOutlet weak var secondaryImageView: UIImageView!
    @IBOutlet weak var secondaryNameLabel: UILabel!
    @IBOutlet weak var secondaryIdLabel: UILabel!

    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var placeholderLine: UIView!
    @IBOutlet weak var placeholderBottomLine: UIView!
        
    let maxCharacters = 87
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTitle()
        textSummaryView.textColor = CustomStyle.fourthShade
        CustomStyle.styleFloatingButton(button: confirmButton)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        })
        textSummaryView.delegate = self
        characterCountLabel.text = String(maxCharacters)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        let userInfo = notification.userInfo!
        let beginFrameValue = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)!
        let beginFrame = beginFrameValue.cgRectValue
        let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!
        let endFrame = endFrameValue.cgRectValue
        
        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        floatingDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -endFrame.height).isActive = true
        
        if beginFrame.equalTo(endFrame) {
            return
        }
        
        floatingDetailsView.frame.origin.y = view.frame.height - endFrame.height - floatingDetailsView.frame.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textSummaryView.textColor == CustomStyle.fourthShade {
            textSummaryView.text = nil
            textSummaryView.textColor = CustomStyle.primaryblack
            placeholderLine.isHidden = true
            placeholderBottomLine.isHidden = true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        mainAccountSummary.text = textSummaryView.text
        characterCountLabel.text =  String(maxCharacters - mainAccountSummary.text!.count)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textSummaryView.text.isEmpty {
                   textSummaryView.text = "Write a short summary highlighting what your program iss about."
                   textSummaryView.textColor = CustomStyle.fourthShade
            placeholderLine.isHidden = false
            placeholderBottomLine.isHidden = false
               }
    }

    func setupMainTitle() {
        let programName = "The Daily "
        let programNameFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let programNameAttributedString = NSMutableAttributedString(string: programName)
        let programNameAttributes: [NSAttributedString.Key: Any] = [
            .font: programNameFont,
        ]
        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))

        let userId = "@TheDaily"
        let userIdFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        let userIdAttributedString = NSMutableAttributedString(string: userId)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
        ]
        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))

        programNameAttributedString.append(userIdAttributedString)

        mainAccountTitle.attributedText = programNameAttributedString
    }


    @IBAction func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func skipButtonPress() {
    }

    @IBAction func confirmButtonPress(_ sender: Any) {
        if let tagController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "tagController") as? TagController {
            tagController.accountSummary = self.mainAccountSummary.text!
            tagController.accountTitle = self.mainAccountTitle.attributedText!
                       navigationController?.pushViewController(tagController, animated: true)
                   }
    }
    

}
