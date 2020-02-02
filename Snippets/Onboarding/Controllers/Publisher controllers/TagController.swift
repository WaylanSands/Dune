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
    @IBOutlet weak var gradientOverlayView: UIView!
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var confirmPress = false
    
    let bottomDarkView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryblack
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let floatingDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.primaryblack
        return view
    }()
    
    let secondaryImageView: UIImageView = {
        let ImageView = UIImageView()
        ImageView.image = #imageLiteral(resourceName: "Bitmap")
        return ImageView
    }()
    
    let secondaryNameLabel: UILabel = {
        let label = UILabel()
        label.text = "The Daily"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let secondaryUserNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@TheDaily"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 7.0
        button.layer.borderColor = CustomStyle.white.cgColor
        button.layer.borderWidth = 1
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        return button
    }()
    
    let maxCharacters = 40
    var tagsUsed: [String] = []
    var tagsSelected = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTags()
        addGradient()
        
        view.addSubview(containerView)
         
         view.addSubview(bottomDarkView)
         bottomDarkView.translatesAutoresizingMaskIntoConstraints = false
         bottomDarkView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         bottomDarkView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         bottomDarkView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         bottomDarkView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
         
         view.sendSubviewToBack(containerView)
         containerView.addSubview(floatingDetailsView)
         floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
         floatingDetailsView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -120.0).isActive = true
         floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         floatingDetailsView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
         
         floatingDetailsView.addSubview(secondaryImageView)
         secondaryImageView.translatesAutoresizingMaskIntoConstraints = false
         secondaryImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
         secondaryImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
         secondaryImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
         secondaryImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
         
         floatingDetailsView.addSubview(secondaryNameLabel)
         secondaryNameLabel.translatesAutoresizingMaskIntoConstraints = false
         secondaryNameLabel.topAnchor.constraint(equalTo: floatingDetailsView.topAnchor, constant: 12.0).isActive = true
         secondaryNameLabel.leadingAnchor.constraint(equalTo: secondaryImageView.trailingAnchor, constant: 10.0).isActive = true
         secondaryNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
         
         floatingDetailsView.addSubview(secondaryUserNameLabel)
         secondaryUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
         secondaryUserNameLabel.topAnchor.constraint(equalTo: secondaryNameLabel.bottomAnchor).isActive = true
         secondaryUserNameLabel.leadingAnchor.constraint(equalTo: secondaryImageView.trailingAnchor, constant: 10.0).isActive = true
         secondaryUserNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
         
         floatingDetailsView.addSubview(confirmButton)
         confirmButton.translatesAutoresizingMaskIntoConstraints = false
         confirmButton.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
         confirmButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
         confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        tagTextView.delegate = self
        mainAccountSummary.text = accountSummary
        mainAccountTitle.attributedText = accountTitle
        tagTextView.textColor = CustomStyle.fourthShade

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if confirmPress != true {
            floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height - 65
        } else {
            floatingDetailsView.frame.origin.y = view.frame.height - 120.0
        }
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientOverlayView.bounds
        let whiteColor = UIColor.white
        gradient.colors = [whiteColor.withAlphaComponent(0.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor, whiteColor.withAlphaComponent(1.0).cgColor]
        gradientOverlayView.layer.insertSublayer(gradient, at: 0)
        gradientOverlayView.transform = CGAffineTransform(rotationAngle: (-90.0 * .pi) / 180.0)
        gradientOverlayView.backgroundColor = .clear
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
        updateCharacterCount(textView: textView)
        
        tagsUsed = textView.text.split(separator: " ").map { String($0) }
        print(tagsUsed)
        
        switch tagsUsed.count {
        case 0:
            firstTagButton.isHidden = true
            secondTagButton.isHidden = true
            thirdTagButton.isHidden = true
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
    
    func updateCharacterCount(textView: UITextView) {
        characterCountLabel.text =  String(maxCharacters - textView.text!.count)
        
        if Int(characterCountLabel.text!)! < 0 {
            characterCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            characterCountLabel.textColor = CustomStyle.primaryRed
        } else {
            characterCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            characterCountLabel.textColor = CustomStyle.fourthShade
        }
    }
    
    func updateWidthWith() {
        
        // Need to fix how this minimises when deleteing characters
        var totalWidth: CGFloat
        let scrollPadding: CGFloat = 18.0
        
        totalWidth = firstTagButton.frame.width + secondTagButton.frame.width + thirdTagButton.frame.width + scrollPadding
        
        if totalWidth > tagScrollView.frame.width {
            tagScrollSubview.widthAnchor.constraint(greaterThanOrEqualTo: tagScrollView.widthAnchor, constant: totalWidth - tagScrollView.frame.width).isActive = true
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
        confirmPress = false
        tagTextView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        confirmPress = false
    }
    
    @objc func confirmButtonPress() {
        confirmPress = true
        tagTextView.resignFirstResponder()
    }
}
