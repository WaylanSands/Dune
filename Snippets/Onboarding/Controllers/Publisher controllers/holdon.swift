//
////
////  PublisherAddSummaryController.swift
////  Snippets
////
////  Created by Waylan Sands on 4/2/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//import Foundation
//import UIKit
//
//class PublisherAddSummaryController: UIViewController, UITextViewDelegate {
//
//    var navbarHeight: CGFloat = 90.0
//    lazy var screenHeight: CGFloat = view.frame.height
//    var largeImageSize: CGFloat = 74.0
//    var confirmPress = false
//    var fontNameSize: CGFloat = 16
//    var fontIDSize: CGFloat = 14
//
//    //  Resizng screen variables
//    var maxCharacters = 200
//    var maxSummaryLines = 7
//    var scrollThreshold: CGFloat = 80.0
//    var summaryBarThreshold: CGFloat = 50.0
//    var nextHeightChange: CGFloat = 0.0
//    var lastRecordedHeight: CGFloat = 0.0
//    var heightDifference: CGFloat = 0.0
//    var summaryHeight: CGFloat = 0.0
//    var summaryBarPadding: CGFloat  = 45
//    lazy var lineheight = summaryLabel.font.lineHeight
//    var textPlacement = true
//
//    // test
//    var heightCount: CGFloat = 0.0
//
//    // Styling device to device
//    let device = UIDevice()
//    lazy var deviceType = device.deviceType
//    lazy var dynamicNavbarHeight = device.navBarHeight()
//    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
//
//    lazy var passThoughView = PassThoughView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//
//    var scrollHeight: NSLayoutConstraint!
//    var summaryBarYAnchor: NSLayoutConstraint!
//
//    lazy var scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isScrollEnabled = true
//        view.contentInsetAdjustmentBehavior = .never
//        return view
//    }()
//
//    lazy var scrollContentView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let topStackView: UIStackView = {
//        let view = UIStackView()
//        view.spacing = 10.0
//        return view
//    }()
//
//    let largeUserImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "Bitmap")
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    let topRightStackView: UIStackView = {
//        let view = UIStackView()
//        view.axis = .vertical
//        view.spacing = 10.0
//        view.distribution = .fill
//        return view
//    }()
//
//    let accountLabel: UILabel = {
//        let label = UILabel()
//        label.text = "The Daily"
//        return label
//    }()
//
//    let summaryLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 7
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.backgroundColor = .blue
//        return label
//    }()
//
//    let summaryView: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    let summaryBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomStyle.secondShade
//        return view
//    }()
//
//    let summaryBarLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Program summary"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
//        label.textColor = CustomStyle.fithShade
//        return label
//    }()
//
//    lazy var summaryBarCounter: UILabel = {
//        let label = UILabel()
//        label.text = String(maxCharacters)
//        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        label.textColor = CustomStyle.fourthShade
//        return label
//    }()
//
//    let summaryTextView: UITextView = {
//        let textView = UITextView()
//        textView.text = "Write a short summary highlighting what your program iss about."
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        textView.textColor = CustomStyle.fourthShade
//        textView.isScrollEnabled = false
//        textView.backgroundColor = .red
//        return textView
//    }()
//
//    let floatingDetailsView: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomStyle.primaryblack
//        return view
//    }()
//
//    let secondaryImageView: UIImageView = {
//        let ImageView = UIImageView()
//        ImageView.image = #imageLiteral(resourceName: "Bitmap")
//        return ImageView
//    }()
//
//    let secondaryNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "The Daily"
//        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
//        label.textColor = .white
//        return label
//    }()
//
//    let secondaryUserNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "@TheDaily"
//        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
//        label.textColor = .white
//        return label
//    }()
//
//    let confirmButton: UIButton = {
//        let button = UIButton()
//        button.layer.cornerRadius = 7.0
//        button.layer.borderColor = CustomStyle.white.cgColor
//        button.layer.borderWidth = 1
//        button.setTitle("Confirm", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
//        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
//        return button
//    }()
//
//    let navBar: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.alpha = 0.9
//        return view
//    }()
//
//    lazy var backButton: UIButton = {
//        let button = UIButton()
//        button.frame = CGRect(x: 16.0, y: 45.0, width: 30.0, height: 30.0)
//        button.setImage(#imageLiteral(resourceName: "back-button-white"), for: .normal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15.0, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
//        return button
//    }()
//
//    let navBarTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Summary"
//        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
//        label.textColor = .white
//        return label
//    }()
//
//    lazy var skipButton: UIButton = {
//        let button = UIButton()
//        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        button.setTitle("Skip", for: .normal)
//        button.titleLabel?.textAlignment = .right
//        button.tintColor = .white
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
//        button.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//        return button
//    }()
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        styleForScreens()
//        setupViews()
//        setupAccountLabel()
//        summaryTextView.delegate = self
//        summaryTextView.becomeFirstResponder()
//        let newPosition = self.summaryTextView.beginningOfDocument
//        self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
//        summaryBarCounter.text = String(maxCharacters)
//
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//        })
//    }
//
//    func styleForScreens() {
//        switch deviceType {
//        case .iPhone4S:
//            break
//        case .iPhoneSE:
//            scrollThreshold = 60
//            summaryBarThreshold = 84.0
//            largeImageSize = 60
//            fontNameSize = 14
//            fontIDSize = 12
//        case .iPhone8:
//            addFloatingView()
//        case .iPhone8Plus:
//            addFloatingView()
//        case .iPhone11:
//            addFloatingView()
//        case .iPhone11Pro:
//            addFloatingView()
//        case .iPhone11ProMax:
//            addFloatingView()
//        case .unknown:
//            addFloatingView()
//        }
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//
//    @objc func keyboardWillChange(notification : Notification) {
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        //        if confirmPress != true {
//        //            floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height - 65
//        //        } else {
//        //            floatingDetailsView.frame.origin.y = view.frame.height - 120.0
//        //        }
//
//        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height - 65
//
//    }
//
//    func setupViews() {
//
//        view.addSubview(scrollView)
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//        scrollView.addSubview(scrollContentView)
//        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
//        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        scrollHeight = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight)
//        scrollHeight.isActive = true
//
//        scrollView.addSubview(topStackView)
//        topStackView.translatesAutoresizingMaskIntoConstraints = false
//        topStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: dynamicNavbarHeight + 15.0 ).isActive = true
//        topStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
//        topStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16).isActive = true
//
//        topStackView.addArrangedSubview(largeUserImage)
//        largeUserImage.translatesAutoresizingMaskIntoConstraints = false
//        largeUserImage.widthAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//        largeUserImage.heightAnchor.constraint(equalToConstant: largeImageSize).isActive = true
//
//        topStackView.addArrangedSubview(topRightStackView)
//
//        topRightStackView.addArrangedSubview(accountLabel)
//        accountLabel.translatesAutoresizingMaskIntoConstraints = false
//        accountLabel.topAnchor.constraint(equalTo: topRightStackView.topAnchor).isActive = true
//        accountLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
//        accountLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//
//        topRightStackView.addArrangedSubview(summaryView)
//        summaryView.translatesAutoresizingMaskIntoConstraints = false
//
//        summaryView.addSubview(summaryLabel)
//        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
//        summaryLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor).isActive = true
//        summaryLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
//        summaryLabel.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor, constant: -20.0).isActive = true
//        summaryLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 185.0) .isActive = true
//
//        scrollView.addSubview(summaryBar)
//        summaryBar.translatesAutoresizingMaskIntoConstraints = false
//        summaryBarYAnchor = summaryBar.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: 45.0)
//        summaryBarYAnchor.isActive = true
//        summaryBar.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        summaryBar.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        summaryBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
//
//        summaryBar.addSubview(summaryBarLabel)
//        summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
//        summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
//        summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
//
//        summaryBar.addSubview(summaryBarCounter)
//        summaryBarCounter.translatesAutoresizingMaskIntoConstraints = false
//        summaryBarCounter.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
//        summaryBarCounter.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
//
//        scrollContentView.addSubview(summaryTextView)
//        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
//        summaryTextView.topAnchor.constraint(equalTo: summaryBarCounter.bottomAnchor, constant: 15.0).isActive = true
//        summaryTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0).isActive = true
//        summaryTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0).isActive = true
//
//        view.addSubview(navBar)
//        view.bringSubviewToFront(navBar)
//        navBar.translatesAutoresizingMaskIntoConstraints = false
//        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        navBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
//
//        navBar.addSubview(backButton)
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        backButton.topAnchor.constraint(equalTo: navBar.topAnchor, constant: dynamicNavbarButtonHeight).isActive = true
//        backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        navBar.addSubview(navBarTitleLabel)
//        navBarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        navBarTitleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
//        navBarTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//        navBar.addSubview(skipButton)
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor).isActive = true
//        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//
//        if view.subviews.contains(passThoughView) {
//            view.bringSubviewToFront(passThoughView)
//        }
//    }
//
//    func addFloatingView() {
//        view.addSubview(passThoughView)
//
//        passThoughView.addSubview(floatingDetailsView)
//        floatingDetailsView.translatesAutoresizingMaskIntoConstraints = false
//        floatingDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        floatingDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        floatingDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        floatingDetailsView.heightAnchor.constraint(equalToConstant: 65.0).isActive = true
//
//        floatingDetailsView.addSubview(secondaryImageView)
//        secondaryImageView.translatesAutoresizingMaskIntoConstraints = false
//        secondaryImageView.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
//        secondaryImageView.leadingAnchor.constraint(equalTo: floatingDetailsView.leadingAnchor, constant: 16.0).isActive = true
//        secondaryImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
//        secondaryImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
//
//        floatingDetailsView.addSubview(secondaryNameLabel)
//        secondaryNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        secondaryNameLabel.topAnchor.constraint(equalTo: floatingDetailsView.topAnchor, constant: 12.0).isActive = true
//        secondaryNameLabel.leadingAnchor.constraint(equalTo: secondaryImageView.trailingAnchor, constant: 10.0).isActive = true
//        secondaryNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//
//        floatingDetailsView.addSubview(secondaryUserNameLabel)
//        secondaryUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        secondaryUserNameLabel.topAnchor.constraint(equalTo: secondaryNameLabel.bottomAnchor).isActive = true
//        secondaryUserNameLabel.leadingAnchor.constraint(equalTo: secondaryNameLabel.leadingAnchor).isActive = true
//        secondaryUserNameLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//
//        floatingDetailsView.addSubview(confirmButton)
//        confirmButton.translatesAutoresizingMaskIntoConstraints = false
//        confirmButton.centerYAnchor.constraint(equalTo: floatingDetailsView.centerYAnchor).isActive = true
//        confirmButton.trailingAnchor.constraint(equalTo: floatingDetailsView.trailingAnchor, constant: -16.0).isActive = true
//        confirmButton.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
//    }
//
//    override func viewWillLayoutSubviews() {
//        summaryLabel.sizeToFit()
//    }
//
//    func setupAccountLabel() {
//        let programName = "The Daily "
//        let programNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .bold)
//        let programNameAttributedString = NSMutableAttributedString(string: programName)
//        let programNameAttributes: [NSAttributedString.Key: Any] = [
//            .font: programNameFont,
//            .foregroundColor: CustomStyle.sixthShade
//
//        ]
//        programNameAttributedString.addAttributes(programNameAttributes, range: NSRange(location: 0, length: programName.count))
//
//        let userId = " @TheDaily"
//        let userIdFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
//        let userIdAttributedString = NSMutableAttributedString(string: userId)
//        let userIdeAttributes: [NSAttributedString.Key: Any] = [
//            .font: userIdFont,
//            .foregroundColor: CustomStyle.fourthShade
//        ]
//        userIdAttributedString.addAttributes(userIdeAttributes, range: NSRange(location: 0, length: userId.count))
//        programNameAttributedString.append(userIdAttributedString)
//        accountLabel.attributedText = programNameAttributedString
//    }
//
//    func textViewDidChange(_ textView: UITextView) {
//        summaryLabel.text = summaryTextView.text
//        summaryBarCounter.text =  String(maxCharacters - summaryLabel.text!.count)
//
//        if Int(summaryBarCounter.text!)! < 0 {
//            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//            summaryBarCounter.textColor = CustomStyle.primaryRed
//        } else {
//            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//            summaryBarCounter.textColor = CustomStyle.fourthShade
//        }
//
//        if summaryTextView.text.count > 3 && deviceType == .iPhoneSE {
//            skipButton.setTitle("Continue", for: .normal)
//            skipButton.removeTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//            skipButton.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//            skipButton.sizeToFit()
//        } else {
//            skipButton.setTitle("Skip", for: .normal)
//            skipButton.removeTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//            skipButton.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//            skipButton.sizeToFit()
//        }
//
//        print("HEIGHT COUNT: \(heightCount)")
//
//        if summaryTextView.text.isEmpty {
//            returnScreenToSize()
//        }
//
//        summaryHeight = summaryLabel.frame.height
//
//        if summaryHeight > scrollThreshold {
//            heightCount =  (summaryTextView.frame.height + scrollThreshold) - screenHeight
//            if summaryHeight > nextHeightChange {
//                scaleUpScreen()
//            }  else if summaryHeight < nextHeightChange {
//                scaleDownScreen()
//            }
//        } else if summaryHeight < scrollThreshold {
//            summaryBarCheck()
//        }
//        let roundedLineHight = CGFloat(round(10*lineheight)/10)
//        let roundedSummaryHight = CGFloat(round(10*(summaryLabel.frame.height / 7))/10)
//
//        if roundedSummaryHight == roundedLineHight  {
//
//            DispatchQueue.main.async {
//                if self.summaryTextView.frame.height > self.lastRecordedHeight {
//                    self.lastRecordedHeight = self.summaryTextView.frame.height
//                    let textViewLineHeight = self.summaryTextView.font?.lineHeight
//                    self.scrollHeight.constant += textViewLineHeight!
//                } else if self.summaryTextView.frame.height < self.lastRecordedHeight {
//                    self.lastRecordedHeight = self.summaryTextView.frame.height
//                    let textViewLineHeight = self.summaryTextView.font?.lineHeight
//                    self.scrollHeight.constant -= textViewLineHeight!
//                }
//                self.scrollContentView.layoutIfNeeded()
//            }
//        }
//    }
//
//    func scaleUpScreen() {
//        DispatchQueue.main.async {
//            print("scaleUpScreen")
//            self.nextHeightChange = self.summaryLabel.frame.height
//
//            self.scrollHeight.constant += (self.lineheight * 2)
//            self.summaryBarYAnchor.constant += self.lineheight
//
//            print("here")
//            let point = CGPoint(x: 0, y: self.summaryTextView.frame.origin.y)
//            self.scrollView.contentOffset = point
//
//            self.scrollContentView.layoutIfNeeded()
//            self.summaryBar.layoutIfNeeded()
//        }
//    }
//
//    func scaleDownScreen() {
//        DispatchQueue.main.async {
//            print("scaleDownScreen")
//            self.nextHeightChange = self.summaryLabel.frame.height
//
//            self.scrollHeight.constant -= (self.lineheight * 2)
//            self.summaryBarYAnchor.constant  -= self.lineheight
//
//            let point = CGPoint(x: 0, y: self.summaryTextView.frame.origin.y)
//            self.scrollView.contentOffset = point
//
//            self.scrollContentView.layoutIfNeeded()
//            self.summaryBar.layoutIfNeeded()
//        }
//    }
//
//    func summaryBarCheck() {
//        DispatchQueue.main.async {
//
//            let heightChange =  self.summaryLabel.frame.height - self.summaryBarThreshold
//            self.nextHeightChange = self.summaryLabel.frame.height
//            self.scrollHeight.constant = self.view.frame.height
//
//            print("\(self.nextHeightChange) VS \(self.summaryBarThreshold)")
//
//            if self.nextHeightChange > self.summaryBarThreshold {
//                self.summaryBarYAnchor.constant =  heightChange + self.summaryBarPadding
//            } else {
//                self.summaryBarYAnchor.constant = self.summaryBarPadding
//            }
//
//            self.scrollContentView.layoutIfNeeded()
//            self.summaryBar.layoutIfNeeded()
//        }
//    }
//
//    func returnScreenToSize() {
//        DispatchQueue.main.async {
//            self.nextHeightChange = self.summaryLabel.frame.height
//            self.scrollHeight.constant = self.view.frame.height
//            self.summaryBarYAnchor.constant =  self.summaryBarPadding
//            self.scrollContentView.layoutIfNeeded()
//            self.summaryBar.layoutIfNeeded()
//
//            self.summaryTextView.text = "Write a short summary highlighting what your program iss about."
//            self.summaryTextView.textColor = CustomStyle.fourthShade
//            let newPosition = self.summaryTextView.beginningOfDocument
//            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
//            self.textPlacement = true
//        }
//    }
//
//    func allowContinueButton() {
//        skipButton.titleLabel?.text = "Continue"
//        skipButton.removeTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//        skipButton.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        print("Summary label height: \(summaryLabel.frame.height), Next height change: \(nextHeightChange)")
//
//        if textPlacement == true {
//            summaryTextView.text.removeAll()
//            self.summaryTextView.textColor = CustomStyle.fithShade
//            textPlacement = false
//            return true
//        }
//        return true
//    }
//
//    @objc func skipButtonPress() {
//        print("Skip")
//    }
//
//    @objc func backButtonPress() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    @objc func confirmButtonPress() {
//        confirmPress = true
//        summaryTextView.resignFirstResponder()
//
//        let tagController = TagController()
//        navigationController?.pushViewController(tagController, animated: true)
//
//    }
//}
