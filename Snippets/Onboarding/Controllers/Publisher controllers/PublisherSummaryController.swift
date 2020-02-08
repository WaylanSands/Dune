//
//  PublisherSummaryController.swift
//  Snippets
//
//  Created by Waylan Sands on 21/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PublisherSummaryController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var navBatView: UIView!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var mainAccountTitle: UILabel!
    @IBOutlet weak var mainAccountSummary: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var textSummaryView: UITextView!
    @IBOutlet weak var navBarHeight: NSLayoutConstraint!
    @IBOutlet weak var summayBarTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var mainSummaryHeigh: NSLayoutConstraint!
    @IBOutlet weak var placeholderTopLine: UIView!
    @IBOutlet weak var placeholderBottomLine: UIView!
    
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var mainImageHeight: NSLayoutConstraint!
    @IBOutlet weak var mainImageWidth: NSLayoutConstraint!
    @IBOutlet weak var mainStackViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var textViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    
    lazy var leadConstraints = view.constraintWith(identifier: "leadAnchor")
    lazy var trailingConstraints = view.constraintWith(identifier: "trailingAnchor")
    let maxCharacters = 150
    var confirmPress = false
    
    var mainNameSize: CGFloat = 18
    var mainIdSize: CGFloat = 14
    
    
    let deviceType = UIDevice.current.deviceType
    
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        setupMainTitle()
//        textSummaryView.backgroundColor = .blue
        textSummaryView.textColor = CustomStyle.fourthShade
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        })
        textSummaryView.delegate = self
        characterCountLabel.text = String(maxCharacters)
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            backButtonTopAnchor.constant = 10.0
            mainStackViewTopAnchor.constant = 10.0
            navBarHeight.constant = 90.0
            mainImageHeight.constant = 60.0
            mainImageWidth.constant = 60.0
            mainAccountSummary.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            mainStackView.spacing = 10.0
            mainNameSize = 16
            mainIdSize = 12
            textViewTopAnchor.constant = 5.0
            textViewHeight.constant = 90.0
            updateEdgeConstraints()
        case .iPhone8:
            mainStackViewTopAnchor.constant = 15.0
            textViewTopAnchor.constant = 5.0
            textViewHeight.constant = 85.0
            addBottomSection()
        case .iPhone8Plus:
            addBottomSection()
        case .iPhone11:
            addBottomSection()
        case .iPhone11Pro:
            addBottomSection()
        case .iPhone11ProMax:
            addBottomSection()
        case .unknown:
            break
        }
    }
    
    func  updateEdgeConstraints() {
        for each in leadConstraints {
            each.constant = 12.0
        }
        
        for each in trailingConstraints {
            each.constant = 12.0
        }
    }
    
    func addBottomSection() {
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
    }
    
    override func viewWillLayoutSubviews() {
        mainAccountSummary.sizeToFit()
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textSummaryView.textColor == CustomStyle.fourthShade {
            textSummaryView.text = nil
            textSummaryView.textColor = CustomStyle.primaryblack
            placeholderTopLine.isHidden = true
            placeholderBottomLine.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textSummaryView.text.isEmpty {
            textSummaryView.text = "Write a short summary highlighting what your program iss about."
            textSummaryView.textColor = CustomStyle.fourthShade
            placeholderTopLine.isHidden = false
            placeholderBottomLine.isHidden = false
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        mainAccountSummary.text = textSummaryView.text
        characterCountLabel.text =  String(maxCharacters - mainAccountSummary.text!.count)
        
        if Int(characterCountLabel.text!)! < 0 {
            characterCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            characterCountLabel.textColor = CustomStyle.primaryRed
        } else {
            characterCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            characterCountLabel.textColor = CustomStyle.fourthShade
        }
    }
    
    func setupMainTitle() {
        let programName = "The Daily "
        let programNameFont = UIFont.systemFont(ofSize: mainNameSize, weight: .bold)
        let programNameAttributedString = NSMutableAttributedString(string: programName)
        let programNameAttributes: [NSAttributedString.Key: Any] = [
            .font: programNameFont,
            .foregroundColor: CustomStyle.sixthShade
            
        ]
        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
        
        let userId = "@TheDaily"
        let userIdFont = UIFont.systemFont(ofSize: mainIdSize, weight: .medium)
        let userIdAttributedString = NSMutableAttributedString(string: userId)
        let userIdeAttributes: [NSAttributedString.Key: Any] = [
            .font: userIdFont,
            .foregroundColor: CustomStyle.fourthShade
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
    
    override func viewWillDisappear(_ animated: Bool) {
        confirmPress = false
    }
    
    @objc func confirmButtonPress() {
        confirmPress = true
        textSummaryView.resignFirstResponder()
        
        if let tagController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "tagController") as? TagController {
            tagController.accountSummary = self.mainAccountSummary.text!
            tagController.accountTitle = self.mainAccountTitle.attributedText!
            navigationController?.pushViewController(tagController, animated: true)
            
        }
    }
}
