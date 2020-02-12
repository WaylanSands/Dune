//
//  PublisherTagController.swift
//  Snippets
//
//  Created by Waylan Sands on 11/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PublisherTagController: UIViewController, UITextViewDelegate  {
    
        var navbarHeight: CGFloat = 90.0
        lazy var screenHeight: CGFloat = view.frame.height
        var largeImageSize: CGFloat = 74.0
        var confirmPress = false
        var fontNameSize: CGFloat = 16
        var fontIDSize: CGFloat = 14
        
//        //  Resizng screen variables
//        var maxCharacters = 200
//        var maxSummaryLines = 7
//        var summaryTextViewThreshold: CGFloat = 80.0
//        var summaryLabelThreshold: CGFloat = 68.0
//        var lastTextViewHeight: CGFloat = 0.0
//        var lastLableHeight: CGFloat = 0.0
//        var summaryBarPadding: CGFloat  = 45
//        var textPlacement = true
    
    var summaryBarPadding: CGFloat  = 45
    var accountSummary: String?
    let maxCharacters = 40
    var tagsUsed: [String] = []
    var tagsSelected = false
    var textPlacement = true
    var isTruncated = false
    var completeSummary = ""
    var summaryHeightClosed: CGFloat = 0
        
        let customNavBar = CustomNavBar()
        
        // Styling device to device
        let device = UIDevice()
        lazy var deviceType = device.deviceType
        lazy var dynamicNavbarHeight = device.navBarHeight()
        lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
        
        lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        var scrollHeight: NSLayoutConstraint!
        var summaryBarYAnchor: NSLayoutConstraint!

        
        let topStackView: UIStackView = {
            let view = UIStackView()
            view.spacing = 10.0
            return view
        }()
        
        let largeUserImage: UIImageView = {
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "missing-image-large")
            imageView.layer.cornerRadius = 7
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let topRightStackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.spacing = 10.0
            view.distribution = .fill
            return view
        }()
        
        let accountLabel: UILabel = {
            let label = UILabel()
            label.text = "The Daily"
            return label
        }()
        
        let summaryLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.isUserInteractionEnabled = true
            return label
        }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("more", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(moreUnwrap), for: .touchUpInside)
        return button
    }()
        
        let summaryView: UIView = {
            let view = UIView()
            return view
        }()
        
        let summaryBar: UIView = {
            let view = UIView()
            view.backgroundColor = CustomStyle.secondShade
            return view
        }()
        
        let summaryBarLabel: UILabel = {
            let label = UILabel()
            label.text = "Seperate tags by a space"
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = CustomStyle.fithShade
            return label
        }()
        
        lazy var summaryBarCounter: UILabel = {
            let label = UILabel()
            label.text = String(maxCharacters)
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = CustomStyle.fourthShade
            return label
        }()
        
        let summaryTextView: UITextView = {
            let textView = UITextView()
            textView.text = "Write a short summary highlighting what your program iss about."
            textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            textView.textColor = CustomStyle.fourthShade
            textView.isScrollEnabled = false
            return textView
        }()
        
        let floatingDetailsView: UIView = {
            let view = UIView()
            view.backgroundColor = CustomStyle.primaryblack
            return view
        }()
        
        let secondaryImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = #imageLiteral(resourceName: "missing-imag-small")
            imageView.layer.cornerRadius = 7
            imageView.clipsToBounds = true
            return imageView
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
            button.alpha = 0.2
            button.layer.cornerRadius = 7.0
            button.layer.borderColor = CustomStyle.white.cgColor
            button.layer.borderWidth = 1
            button.setTitle("Confirm", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
            return button
        }()
        
        let bottomFill: UIView = {
            let view = UIView()
            view.backgroundColor = CustomStyle.primaryblack
            return view
        }()

        override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            completeSummary = summaryLabel.text!
            view.backgroundColor = .white
            customNavBar.navBarTitleLabel.text = "Custom tags"
            customNavBar.skipButton.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
            customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
            styleForScreens()
            setupViews()
            setupAccountLabel()
            summaryTextView.delegate = self
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.summaryTextView.becomeFirstResponder()
            })
            
            let newPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
            summaryBarCounter.text = String(maxCharacters)
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            })
        }
    
    override func viewDidAppear(_ animated: Bool) {
        summaryHeightClosed = summaryLabel.frame.height
        
        if isTruncated {
            addMoreButton()
        }
    }
        
        func styleForScreens() {
            switch deviceType {
            case .iPhone4S:
                break
            case .iPhoneSE:
                largeImageSize = 60
                fontNameSize = 14
                fontIDSize = 12
            case .iPhone8:
                addFloatingView()
            case .iPhone8Plus:
                addFloatingView()
            case .iPhone11:
                addFloatingView()
                 callBottomFill()
            case .iPhone11Pro:
                addFloatingView()
                callBottomFill()
            case .iPhone11ProMax:
                addFloatingView()
                callBottomFill()
            case .unknown:
                addFloatingView()
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        
        
        @objc func keyboardWillChange(notification : Notification) {
            guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  floatingDetailsView.frame.height
        }
        
        func setupViews() {
            view.addSubview(topStackView)
            topStackView.translatesAutoresizingMaskIntoConstraints = false
            topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: dynamicNavbarHeight + 15.0 ).isActive = true
            topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            topStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            
            topStackView.addArrangedSubview(largeUserImage)
            largeUserImage.translatesAutoresizingMaskIntoConstraints = false
            largeUserImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
            largeUserImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
            
            topStackView.addArrangedSubview(topRightStackView)
            
            topRightStackView.addArrangedSubview(accountLabel)
            accountLabel.translatesAutoresizingMaskIntoConstraints = false
            accountLabel.topAnchor.constraint(equalTo: topRightStackView.topAnchor).isActive = true
            accountLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
            accountLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            
            topRightStackView.addArrangedSubview(summaryView)
            summaryView.translatesAutoresizingMaskIntoConstraints = false
            
            summaryView.addSubview(summaryLabel)
            summaryLabel.translatesAutoresizingMaskIntoConstraints = false
            summaryLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor).isActive = true
            summaryLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
            summaryLabel.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor, constant: -20.0).isActive = true
            summaryLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 185.0) .isActive = true
            
            view.addSubview(summaryBar)
            summaryBar.translatesAutoresizingMaskIntoConstraints = false
            summaryBarYAnchor = summaryBar.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: summaryBarPadding)
            summaryBarYAnchor.isActive = true
            summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            summaryBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            
            summaryBar.addSubview(summaryBarLabel)
            summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
            summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
            summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
            
            summaryBar.addSubview(summaryBarCounter)
            summaryBarCounter.translatesAutoresizingMaskIntoConstraints = false
            summaryBarCounter.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
            summaryBarCounter.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
            
            view.addSubview(summaryTextView)
            summaryTextView.translatesAutoresizingMaskIntoConstraints = false
            summaryTextView.topAnchor.constraint(equalTo: summaryBarCounter.bottomAnchor, constant: 15.0).isActive = true
            summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
            summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
            
            view.addSubview(customNavBar)
            customNavBar.bringSubviewToFront(customNavBar)
            customNavBar.translatesAutoresizingMaskIntoConstraints = false
            customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
       
            if view.subviews.contains(passThoughView) {
                view.bringSubviewToFront(passThoughView)
            }
        }
        
        func addFloatingView() {
            view.addSubview(passThoughView)
            
            passThoughView.addSubview(floatingDetailsView)
            floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
            floatingDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            floatingDetailsView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
            
            floatingDetailsView.addSubview(secondaryImageView)
            secondaryImageView.translatesAutoresizingMaskIntoConstraints = false
            secondaryImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
            secondaryImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
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
            secondaryUserNameLabel.leadingAnchor.constraint(equalTo: secondaryNameLabel.leadingAnchor).isActive = true
            secondaryUserNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
            
            floatingDetailsView.addSubview(confirmButton)
            confirmButton.translatesAutoresizingMaskIntoConstraints = false
            confirmButton.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
            confirmButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
            confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        }
    
    func addMoreButton() {
        
//        let manager = summaryLabel
        
//        var truncatedText = summaryLabel.text!
//        let summarySize: CGSize = summaryLabel.text!.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
//        let linesActual: CGFloat = summarySize.width / summaryLabel.frame.width
//        let linesOver: CGFloat = linesActual - CGFloat(summaryLabel.numberOfLines)
//        let percentageOver: CGFloat = (linesOver / linesActual) * 100
//        var totalCharactersOver: CGFloat = (CGFloat(summaryLabel.text!.count) * percentageOver) / 100
//        totalCharactersOver = totalCharactersOver.rounded(.up)
//
//        truncatedText.removeLast(Int(totalCharactersOver) + 10)
//        if truncatedText.last == " " {
//            truncatedText.removeLast()
//        }
//
//        truncatedText = truncatedText + "..."
//        summaryLabel.text = truncatedText
        

//        summaryLabel.addSubview(moreButton)
//        moreButton.translatesAutoresizingMaskIntoConstraints = false
//        moreButton.bottomAnchor.constraint(equalTo: summaryLabel.bottomAnchor).isActive = true
//        moreButton.trailingAnchor.constraint(equalTo: summaryLabel.trailingAnchor).isActive = true
//        moreButton.heightAnchor.constraint(equalToConstant: summaryLabel.font.lineHeight).isActive = true
    }
        
        func callBottomFill() {
            view.addSubview(bottomFill)
            view.sendSubviewToBack(bottomFill)
            bottomFill.translatesAutoresizingMaskIntoConstraints = false
            bottomFill.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            bottomFill.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            bottomFill.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bottomFill.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
        }
    
    override func viewWillLayoutSubviews() {
        summaryLabel.sizeToFit()
    }
        
        func setupAccountLabel() {
            let programName = "The Daily "
            let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .bold)
            let programNameAttributedString = NSMutableAttributedString(string: programName)
            let programNameAttributes: [NSAttributedString.Key: Any] = [
                .font: programNameFont,
                .foregroundColor: CustomStyle.sixthShade
                
            ]
            programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
            
            let userId = " @TheDaily"
            let userIdFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
            let userIdAttributedString = NSMutableAttributedString(string: userId)
            let userIdeAttributes: [NSAttributedString.Key: Any] = [
                .font: userIdFont,
                .foregroundColor: CustomStyle.fourthShade
            ]
            userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
            programNameAttributedString.append(userIdAttributedString)
            accountLabel.attributedText = programNameAttributedString
        }
        
        func textViewDidChange(_ textView: UITextView) {
            summaryLabel.text = summaryTextView.text
            summaryBarCounter.text =  String(maxCharacters - summaryLabel.text!.count)
            
            if Int(summaryBarCounter.text!)! < 0 {
                summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .bold)
                summaryBarCounter.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .regular)
                summaryBarCounter.textColor = CustomStyle.fourthShade
            }
            
            if summaryTextView.text.count > 3 && deviceType == .iPhoneSE {
                customNavBar.skipButton.setTitle("Continue", for: .normal)
                customNavBar.skipButton.removeTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
                customNavBar.skipButton.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
            } else {
                customNavBar.skipButton.setTitle("Skip", for: .normal)
                customNavBar.skipButton.removeTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
                customNavBar.skipButton.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
            }
            
            if summaryTextView.text.count > 3 && deviceType != .iPhoneSE {
                UIView.animate(withDuration: 1, animations: { self.confirmButton.alpha = 1} )
                confirmButton.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
            } else {
                confirmButton.alpha = 0.2
                confirmButton.removeTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
            }
            
            if summaryTextView.text.isEmpty {
                returnScreenToSize()
            }
        }
    
    func returnScreenToSize() {
            self.summaryTextView.text = "Write a short summary highlighting what your program iss about."
            self.summaryTextView.textColor = CustomStyle.fourthShade
            
            let newPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
            self.textPlacement = true
    }
        
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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
    
    @objc func moreUnwrap() {
        moreButton.isHidden = true
        summaryLabel.text = completeSummary
        summaryLabel.numberOfLines = 0
        let positionDifference = summaryLabel.intrinsicContentSize.height - summaryHeightClosed
        summaryBarYAnchor.constant = positionDifference + summaryBarPadding
        summaryBar.layoutIfNeeded()
    }
        
        @objc func skipButtonPress() {
            print("Skip")
        }
        
       @objc func backButtonPress() {
            navigationController?.popViewController(animated: true)
        }
        
        @objc func confirmButtonPress() {
            confirmPress = true
            summaryTextView.resignFirstResponder()
            
            let tagController = PublisherTagController()
            navigationController?.pushViewController(tagController, animated: true)
            
        }
    }

