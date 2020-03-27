////
////  AddEpisodeDetails.swift
////  Dune
////
////  Created by Waylan Sands on 27/3/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//
//class AddEpisodeDetails: UIViewController {
//
//    let scrollView: UIScrollView = {
//        let view = UIScrollView()
//        view.isScrollEnabled = true
//        view.contentInsetAdjustmentBehavior = .never
//        return view
//    }()
//
//    let scrollContentView: UIView = {
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
//        imageView.image = #imageLiteral(resourceName: "missing-image-large")
//        imageView.layer.cornerRadius = 7
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
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
//    let channelNameStackedView: UIStackView = {
//        let view = UIStackView()
//        view.spacing = 5
//        return view
//    }()
//
//    let channelNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = Channel.name
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        return label
//    }()
//
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "@\(User.username!)"
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        label.textColor = CustomStyle.linkBlue
//        return label
//    }()
//
//    let summaryLabel: UILabel = {
//        let label = UILabel()
//        label.numberOfLines = 7
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
//
//    let summaryTextView: UITextView = {
//        let textView = UITextView()
//        textView.text = "Write a short summary highlighting what your program iss about."
//        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        textView.isScrollEnabled = false
//        textView.textColor = CustomStyle.fourthShade
//        textView.keyboardType = .twitter
//        return textView
//    }()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//
//    }
//
//
//    func setupViews() {
//        view.backgroundColor = .white
//        view.addSubview(scrollView)
//        scrollView.pinEdges(to: view)
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
//    }
//}
//
//
//
////
//
//
//    let floatingDetailsView: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomStyle.primaryblack
//        return view
//    }()
//
//    let secondaryImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "missing-imag-small")
//        imageView.layer.cornerRadius = 7
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//
//    let secondaryNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = Channel.name
//        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
//        label.textColor = .white
//        return label
//    }()
//
//    let secondaryUserNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "@\(User.username!)"
//        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
//        label.textColor = .white
//        return label
//    }()
//
//    let confirmButton: UIButton = {
//        let button = UIButton()
//        button.alpha = 0.2
//        button.layer.cornerRadius = 7.0
//        button.layer.borderColor = CustomStyle.white.cgColor
//        button.layer.borderWidth = 1
//        button.setTitle("Confirm", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
//        button.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
//        button.isEnabled = false
//        return button
//    }()
//
//    let bottomFill: UIView = {
//        let view = UIView()
//        view.backgroundColor = CustomStyle.primaryblack
//        return view
//    }()
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        largeUserImage.setImage(from: Channel.downloadURL!)
//        secondaryImageView.setImage(from: Channel.downloadURL!)
//        styleForScreens()
//        setupViews()
////        setupAccountLabel()
//        summaryTextView.delegate = self
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            self.summaryTextView.becomeFirstResponder()
//        })
//
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//    override func viewWillLayoutSubviews() {
//        summaryLabel.sizeToFit()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.floatingDetailsView.frame.origin.y =  self.view.frame.height - ( self.floatingDetailsView.frame.height +  self.homeIndicatorHeight)
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
//
//    @objc func keyboardWillChange(notification : Notification) {
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
//            return
//        }
//        floatingDetailsView.frame.origin.y = view.frame.height - keyboardRect.height -  floatingDetailsView.frame.height
//    }
//
//    func styleForScreens() {
//        switch deviceType {
//        case .iPhone4S:
//            break
//        case .iPhoneSE:
//            summaryTextViewThreshold = 57.0
//            largeImageSize = 60
//            fontNameSize = 14
//            fontIDSize = 12
//        case .iPhone8:
//            addFloatingView()
//            summaryTextViewThreshold = 57.0
//        case .iPhone8Plus:
//            addFloatingView()
//            summaryTextViewThreshold = 95.0
//        case .iPhone11:
//            addFloatingView()
//            summaryTextViewThreshold = 133.0
//            callBottomFill()
//        case .iPhone11Pro:
//            summaryTextViewThreshold = 95.0
//            addFloatingView()
//            callBottomFill()
//        case .iPhone11ProMax:
//            summaryTextViewThreshold = 133.0
//            addFloatingView()
//            callBottomFill()
//        case .unknown:
//            addFloatingView()
//        }
//    }
//
//    func setupViews() {
//        view.backgroundColor = .white
//        view.addSubview(scrollView)
//        scrollView.pinEdges(to: view)
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
//        topStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIDevice.current.navBarHeight() + 15.0 ).isActive = true
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
//        topRightStackView.addArrangedSubview(channelNameStackedView)
//        channelNameStackedView.translatesAutoresizingMaskIntoConstraints = false
//        channelNameStackedView.leadingAnchor.constraint(lessThanOrEqualTo: topRightStackView.leadingAnchor, constant: 5).isActive = true
//        channelNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20).isActive = true
//        channelNameStackedView.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        channelNameStackedView.addArrangedSubview(channelNameLabel)
//        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        channelNameLabel.widthAnchor.constraint(equalToConstant: channelNameLabel.intrinsicContentSize.width).isActive = true
//
//        channelNameStackedView.addArrangedSubview(usernameLabel)
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        usernameLabel.widthAnchor.constraint(equalToConstant: channelNameLabel.intrinsicContentSize.width).isActive = true
//
//        topRightStackView.addArrangedSubview(summaryView)
//        summaryView.translatesAutoresizingMaskIntoConstraints = false
//
//        summaryView.addSubview(summaryLabel)
//        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
//        summaryLabel.topAnchor.constraint(equalTo: channelNameLabel.bottomAnchor).isActive = true
//        summaryLabel.leadingAnchor.constraint(equalTo: topRightStackView.leadingAnchor).isActive = true
//        summaryLabel.trailingAnchor.constraint(equalTo: topRightStackView.trailingAnchor, constant: -4.0).isActive = true
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
//        summaryBarCounter.text = String(maxCharacters)
//
//        scrollContentView.addSubview(summaryTextView)
//        summaryTextView.translatesAutoresizingMaskIntoConstraints = false
//        summaryTextView.topAnchor.constraint(equalTo: summaryBarCounter.bottomAnchor, constant: 15.0).isActive = true
//        summaryTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0).isActive = true
//        summaryTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0).isActive = true
//        let newPosition = self.summaryTextView.beginningOfDocument
//        self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
//
//        view.addSubview(customNavBar)
//        customNavBar.bringSubviewToFront(customNavBar)
//        customNavBar.pinNavBarTo(view)
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
//        floatingDetailsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
//    func callBottomFill() {
//        view.addSubview(bottomFill)
//        view.sendSubviewToBack(bottomFill)
//        bottomFill.translatesAutoresizingMaskIntoConstraints = false
//        bottomFill.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        bottomFill.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        bottomFill.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        bottomFill.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
//    }
//
////    func setupAccountLabel() {
////        guard let channelName = Channel.name else { return }
////        let channelNameFont = UIFont.systemFont(ofSize: fontNameSize, weight: .bold)
////        let channelNameAttributedString = NSMutableAttributedString(string: channelName)
////        let channelNameAttributes: [NSAttributedString.Key: Any] = [
////            .font: channelNameFont,
////            .foregroundColor: CustomStyle.sixthShade
////        ]
////        channelNameAttributedString.addAttributes(channelNameAttributes, range: NSRange(location: 0, length: channelName.count))
////
////        guard let id = Channel.channelID else { return }
////        let channelID = "@\(id)"
////        let channelIDFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
////        let channelIDAttributedString = NSMutableAttributedString(string: channelID)
////        let channelIDAttributes: [NSAttributedString.Key: Any] = [
////            .font: channelIDFont,
////            .foregroundColor: CustomStyle.fourthShade
////        ]
////        channelIDAttributedString.addAttributes(channelIDAttributes, range: NSRange(location: 0, length: channelID.count))
////        channelNameAttributedString.append(channelIDAttributedString)
////        accountLabel.attributedText = channelNameAttributedString
////    }
//
//    func updatePageHeight(with difference: CGFloat) {
//        if summaryTextView.frame.height != lastTextViewHeight {
//            lastTextViewHeight = summaryTextView.frame.height
//
//            scrollHeight.constant = screenHeight + (difference + 17)
//
//            let point = CGPoint(x: 0, y: self.summaryTextView.frame.origin.y)
//            scrollView.contentOffset = point
//
//            scrollContentView.layoutIfNeeded()
//        }
//    }
//
//    func updateSummaryBar(with difference: CGFloat) {
//        if summaryLabel.frame.height != lastLableHeight {
//            lastLableHeight = summaryLabel.frame.height
//
//            summaryBarYAnchor.constant = difference + summaryBarPadding
//            summaryBar.layoutIfNeeded()
//
//        } else if summaryLabel.frame.height == lastLableHeight {
//            summaryBarYAnchor.constant = difference + summaryBarPadding
//            summaryBar.layoutIfNeeded()
//        }
//    }
//
//    func returnScreenToSize() {
//        DispatchQueue.main.async {
//            self.lastLableHeight = self.summaryLabel.frame.height
//            self.lastTextViewHeight = self.summaryTextView.frame.height
//
//            self.scrollHeight.constant = self.screenHeight
//            self.summaryBarYAnchor.constant = self.summaryBarPadding
//            self.scrollContentView.layoutIfNeeded()
//            self.summaryBar.layoutIfNeeded()
//
//            self.summaryTextView.text = "Write a short summary highlighting what your program iss about."
//            self.summaryTextView.textColor = CustomStyle.fourthShade
//
//            let newPosition = self.summaryTextView.beginningOfDocument
//            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: newPosition, to: newPosition)
//            self.textPlacement = true
//        }
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
//        Channel.summary = summaryTextView.text
//        summaryTextView.resignFirstResponder()
//
//        DispatchQueue.main.async {
//            self.floatingDetailsView.frame.origin.y =  self.view.frame.height - ( self.floatingDetailsView.frame.height +  self.homeIndicatorHeight)
//        }
//
//        let tagController = PublisherTagVC()
//        tagController.summaryTextView.text = summaryLabel.text
//        navigationController?.pushViewController(tagController, animated: true)
//
//    }
//}
//
//extension PublisherAddSummaryVC: UITextViewDelegate {
//
//    func textViewDidChange(_ textView: UITextView) {
//        summaryLabel.text = summaryTextView.text
//        summaryBarCounter.text =  String(maxCharacters - summaryLabel.text!.count)
//
//        if Int(summaryBarCounter.text!)! < 0 {
//            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//            summaryBarCounter.textColor = CustomStyle.warningRed
//        } else {
//            summaryBarCounter.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//            summaryBarCounter.textColor = CustomStyle.fourthShade
//        }
//
//        if summaryTextView.text.count > 3 && deviceType == .iPhoneSE {
//            customNavBar.rightButton.setTitle("Continue", for: .normal)
//            customNavBar.rightButton.removeTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//            customNavBar.rightButton.addTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//        } else {
//            customNavBar.rightButton.setTitle("Skip", for: .normal)
//            customNavBar.rightButton.removeTarget(self, action: #selector(confirmButtonPress), for: .touchUpInside)
//            customNavBar.rightButton.addTarget(self, action: #selector(skipButtonPress), for: .touchUpInside)
//        }
//
//        if summaryTextView.text.count > 3 && deviceType != .iPhoneSE {
//            UIView.animate(withDuration: 1, animations: { self.confirmButton.alpha = 1} )
//            confirmButton.isEnabled = true
//        } else {
//            confirmButton.alpha = 0.2
//            confirmButton.isEnabled = false
//        }
//
//        if summaryTextView.text.isEmpty {
//            returnScreenToSize()
//        }
//
//        DispatchQueue.main.async {
//            if self.summaryTextView.frame.height >= self.summaryTextViewThreshold {
//                let heightDifference =  self.summaryTextView.frame.height - self.summaryTextViewThreshold
//                self.updatePageHeight(with: heightDifference)
//            }
//        }
//
//        if summaryLabel.frame.height >= summaryLabelThreshold {
//            let heightDifference =  summaryLabel.frame.height - summaryLabelThreshold
//            updateSummaryBar(with: heightDifference)
//        }
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        if textPlacement == true {
//            summaryTextView.text.removeAll()
//            self.summaryTextView.textColor = CustomStyle.fithShade
//            textPlacement = false
//            return true
//        }
//        return true
//    }
//}
