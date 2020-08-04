//
//  UpdateListenerBioVC.swift
//  Dune
//
//  Created by Waylan Sands on 31/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class UpdateListenerBioVC: UIViewController {
    
    let maxCaptionCharacters = 240
    let summaryPlaceholder = "Include a short bio, what makes you unique?"
    
    var scrollContentHeightConstraint: NSLayoutConstraint!
    
    var homeIndicatorHeight:CGFloat = 34.0
    var summaryPlaceholderIsActive = false
        
    lazy var screenHeight = view.frame.height
        
    // For screen-size adjustment
    var imageViewSize:CGFloat = 55.0
    var floatingBarHeight:CGFloat = 65.0
    var imageBarViewSize:CGFloat = 45.0
    var scrollPadding: CGFloat = 0
        
    let customNavBar: CustomNavBar = {
        let navBar = CustomNavBar()
        navBar.leftButton.isHidden = true
        return navBar
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let programNameStackedView: UIStackView = {
        let view = UIStackView()
        view.spacing = 5
        return view
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.text = CurrentProgram.name
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(User.username!)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.linkBlue
        return label
    }()
    
    let summaryLabel: UITextView = {
        let label = UITextView()
        label.text = ""
        label.textContainer.maximumNumberOfLines = 7
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = CustomStyle.sixthShade
        label.textContainerInset = .zero
        label.textContainer.lineFragmentPadding = 0
        label.isScrollEnabled = false
        label.isEditable = false
        return label
    }()
    
    let summaryBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    
    let summaryBarLabel: UILabel = {
        let label = UILabel()
        label.text = "Include a bio"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = CustomStyle.fifthShade
        return label
    }()
    
    lazy var summaryCounterLabel: UILabel = {
        let label = UILabel()
        label.text = String(maxCaptionCharacters)
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = CustomStyle.fourthShade
        return label
    }()
    
    lazy var summaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = summaryPlaceholder
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textContainer.maximumNumberOfLines = 12
        textView.isScrollEnabled = false
        textView.textColor = CustomStyle.fourthShade
        textView.keyboardType = .twitter
        textView.textAlignment = .left
        return textView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        summaryTextView.delegate = self
        configureNavBar()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.setScrollBarToTopLeft()
        configureSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        summaryTextView.resignFirstResponder()
    }
    
    func configureSummary() {
        
        mainImage.image = CurrentProgram.image
        usernameLabel.text = "@\(User.username!)"
        summaryLabel.text = CurrentProgram.summary
        summaryTextView.text = CurrentProgram.summary
        programNameLabel.text = CurrentProgram.name

        if summaryLabel.text == "" {
            summaryPlaceholderIsActive = true
            summaryTextView.text = summaryPlaceholder
            summaryTextView.textColor = CustomStyle.fourthShade
        }
        
    }

    func configureNavBar() {
        navigationItem.title = "Biography"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-button-white"), style: .plain, target: self, action: #selector(popVC))
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageViewSize = 50
        case .iPhone8:
            break
        case .iPhone8Plus:
            break
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
   func setupViews() {
           view.backgroundColor = .white
           
           view.addSubview(scrollView)
           scrollView.pinEdges(to: view)
           
           scrollView.addSubview(scrollContentView)
           scrollContentView.translatesAutoresizingMaskIntoConstraints = false
           scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
           scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
           scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
           scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
           scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
           scrollContentHeightConstraint = scrollContentView.heightAnchor.constraint(equalToConstant: screenHeight + scrollPadding)
           scrollContentHeightConstraint.isActive = true
           
           scrollContentView.addSubview(mainImage)
           mainImage.translatesAutoresizingMaskIntoConstraints = false
           mainImage.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIDevice.current.navBarHeight() + 10).isActive = true
           mainImage.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 16).isActive = true
           mainImage.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
           mainImage.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
           
           scrollContentView.addSubview(programNameStackedView)
           programNameStackedView.translatesAutoresizingMaskIntoConstraints = false
           programNameStackedView.topAnchor.constraint(equalTo: mainImage.topAnchor).isActive = true
           programNameStackedView.leadingAnchor.constraint(equalTo: mainImage.trailingAnchor, constant: 10).isActive = true
           programNameStackedView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: 20).isActive = true
           
           programNameStackedView.addArrangedSubview(programNameLabel)
           programNameLabel.translatesAutoresizingMaskIntoConstraints = false
           programNameLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
           programNameLabel.widthAnchor.constraint(equalToConstant: programNameLabel.intrinsicContentSize.width).isActive = true
           
           programNameStackedView.addArrangedSubview(usernameLabel)
           usernameLabel.translatesAutoresizingMaskIntoConstraints = false
           usernameLabel.widthAnchor.constraint(equalToConstant: usernameLabel.intrinsicContentSize.width).isActive = true
           
           scrollContentView.addSubview(summaryLabel)
           summaryLabel.translatesAutoresizingMaskIntoConstraints = false
           summaryLabel.topAnchor.constraint(equalTo: programNameStackedView.bottomAnchor, constant: 2).isActive = true
           summaryLabel.leadingAnchor.constraint(equalTo: programNameStackedView.leadingAnchor).isActive = true
           summaryLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -16.0).isActive = true
           summaryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
           
           scrollContentView.addSubview(summaryBar)
           summaryBar.translatesAutoresizingMaskIntoConstraints = false
           summaryBar.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 40).isActive = true
           summaryBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
           summaryBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
           summaryBar.heightAnchor.constraint(equalToConstant: 37.0).isActive = true
           
           summaryBar.addSubview(summaryBarLabel)
           summaryBarLabel.translatesAutoresizingMaskIntoConstraints = false
           summaryBarLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
           summaryBarLabel.leadingAnchor.constraint(equalTo: summaryBar.leadingAnchor, constant: 16).isActive = true
           
           summaryBar.addSubview(summaryCounterLabel)
           summaryCounterLabel.translatesAutoresizingMaskIntoConstraints = false
           summaryCounterLabel.centerYAnchor.constraint(equalTo: summaryBar.centerYAnchor).isActive = true
           summaryCounterLabel.trailingAnchor.constraint(equalTo: summaryBar.trailingAnchor, constant: -16).isActive = true
           
           scrollContentView.addSubview(summaryTextView)
           summaryTextView.translatesAutoresizingMaskIntoConstraints = false
           summaryTextView.topAnchor.constraint(equalTo: summaryBarLabel.bottomAnchor, constant: 20).isActive = true
           summaryTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13).isActive = true
           summaryTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13).isActive = true
           summaryTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
           
           view.addSubview(customNavBar)
           customNavBar.pinNavBarTo(view)
       }
    
    func updateCharacterCount(textView: UITextView) {
        if !summaryPlaceholderIsActive {
            summaryCounterLabel.text =  String(maxCaptionCharacters - summaryTextView.text!.count)
        } else {
           summaryCounterLabel.text =  String(maxCaptionCharacters)
        }
        
        if Int(summaryCounterLabel.text!)! < 0 {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            summaryCounterLabel.textColor = CustomStyle.warningRed
        } else {
            summaryCounterLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            summaryCounterLabel.textColor = CustomStyle.fourthShade
        }
    }
    
    func addCaptionPlaceholderText() {
        DispatchQueue.main.async {
            self.summaryTextView.text = self.summaryPlaceholder
            let startPosition: UITextPosition = self.summaryTextView.beginningOfDocument
            self.summaryTextView.selectedTextRange = self.summaryTextView.textRange(from: startPosition, to: startPosition)
            self.summaryTextView.textColor = CustomStyle.fourthShade
            self.summaryPlaceholderIsActive = true
            self.checkIfAbleToSave()
        }
    }
    
    func checkIfAbleToSave() {
        if summaryPlaceholderIsActive == false {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
    
    // Save details to Firebase
    @objc func saveButtonPress() {
        CurrentProgram.summary = summaryTextView.text
        FireStoreManager.updateProgram(summary: summaryTextView.text, tags: CurrentProgram.tags!, for: CurrentProgram.ID!)
        navigationController?.popViewController(animated: true)
    }
    
}

extension UpdateListenerBioVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount(textView: textView)
        if summaryTextView.text.isEmpty {
            addCaptionPlaceholderText()
            scrollContentHeightConstraint.constant = scrollView.frame.height + scrollPadding
        } else {
            scrollContentHeightConstraint.constant = scrollView.frame.height + summaryTextView.frame.height + scrollPadding
            summaryLabel.textColor = CustomStyle.sixthShade
            summaryLabel.text = summaryTextView.text
        }
        checkIfAbleToSave()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if summaryPlaceholderIsActive == true {
            summaryTextView.text.removeAll()
            summaryTextView.textColor = CustomStyle.fifthShade
            summaryPlaceholderIsActive = false
        } else {
            summaryTextView.textColor = CustomStyle.sixthShade
            summaryLabel.textColor = CustomStyle.sixthShade
        }
        return true
    }
}

