//
//  EditListenerVC.swift
//  Dune
//
//  Created by Waylan Sands on 29/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class EditListenerVC: UIViewController {
        
    let headerViewHeight: CGFloat = 300
    lazy var viewHeight = view.frame.height
    
    let invalidURLAlert = CustomAlertView(alertType: .invalidURL)
    let settingsLauncher = SettingsLauncher(options: SettingOptions.categories, type: .categories)
    
    // For various screen-sizes
    var imageSize: CGFloat = 90
    var imageViewTopConstant: CGFloat = 120
    var headerViewHeightConstant: CGFloat = 300
    var scrollPadding: CGFloat = 100
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.titleLabel.text = "Edit Profile"
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.keyboardDismissMode = .interactive
        return view
    }()
    
    let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = CurrentProgram.image!
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update Profile image", for: .normal)
        button.setTitleColor(hexStringToUIColor(hex: "#4875FF"), for: .normal)
        button.setTitleColor(hexStringToUIColor(hex: "#4875FF").withAlphaComponent(0.8), for: .highlighted)
        button.addTarget(self, action: #selector(changeImageButtonPress), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return button
    }()
    
    let profileInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileInfoStackedView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    let userFieldsStackedView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
        return stackView
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Display Name"
        return label
    }()
    
    let programNameTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.addTarget(self, action: #selector(nameFieldChanged), for: UIControl.Event.editingChanged)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let programNameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Bio"
        return label
    }()
    
    lazy var summaryTextLabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateListenerBio))
        label.addGestureRecognizer(tapGesture)
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let summaryUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let websiteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Optional Link"
        return label
    }()
    
    let websiteTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.addTarget(self, action: #selector(linkFieldChanged), for: UIControl.Event.editingChanged)
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let websiteUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let topUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let bottomlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let blackBGView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        scrollView.setScrollBarToTopLeft()
        summaryTextLabel.text = CurrentProgram.summary
       
        let namePlaceholder = NSAttributedString(string: CurrentProgram.name!, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        programNameTextView.attributedPlaceholder = namePlaceholder;
        
        var weblink: String
        
        if CurrentProgram.webLink == nil ||  CurrentProgram.webLink == "" {
            weblink = "www.example.com"
        } else {
            weblink = CurrentProgram.webLink!
        }
        
        websiteTextView.text = weblink
        websiteTextView.textColor = CustomStyle.fourthShade
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !User.isSetUp! && CurrentProgram.summary != "" && CurrentProgram.name != "" && CurrentProgram.image != #imageLiteral(resourceName: "missing-image-large") {
            User.isSetUp = true
            FireStoreManager.updateUserSetUpTo(true)
            FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: "accountSetup", rep: 15)
            CurrentProgram.rep! += 15
        }
    }
    
    func configureNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageSize = 80
            headerViewHeightConstant = 260
            imageViewTopConstant = 90
            scrollPadding = 140
        case .iPhone8:
            headerViewHeightConstant = 260
            imageViewTopConstant = 90
        case .iPhone8Plus:
            imageViewTopConstant = 110
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
    
    func configureViews() {
        view.backgroundColor = .white
        
        view.addSubview(blackBGView)
        blackBGView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerViewHeight)
        
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContentView.heightAnchor.constraint(equalToConstant: viewHeight + scrollPadding).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollContentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: headerViewHeightConstant).isActive = true
        
        headerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor , constant: imageViewTopConstant).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        headerView.addSubview(changeImageButton)
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 10).isActive = true
        
        scrollContentView.addSubview(profileInfoView)
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        profileInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        profileInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        profileInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileInfoView.addSubview(userFieldsStackedView)
        userFieldsStackedView.translatesAutoresizingMaskIntoConstraints = false
        userFieldsStackedView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 20).isActive = true
        userFieldsStackedView.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor).isActive = true
        userFieldsStackedView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        // Add user fields
        
        userFieldsStackedView.addArrangedSubview(programNameLabel)
        userFieldsStackedView.addArrangedSubview(summaryLabel)
        userFieldsStackedView.addArrangedSubview(websiteLabel)
        
        // Add user values
        
        scrollContentView.addSubview(programNameTextView)
        programNameTextView.translatesAutoresizingMaskIntoConstraints = false
        programNameTextView.centerYAnchor.constraint(equalTo: programNameLabel.centerYAnchor).isActive = true
        programNameTextView.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        programNameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        programNameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(programNameUnderlineView)
        programNameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        programNameUnderlineView.topAnchor.constraint(equalTo: programNameTextView.bottomAnchor, constant: 10).isActive = true
        programNameUnderlineView.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        programNameUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programNameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(summaryTextLabel)
        summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryTextLabel.centerYAnchor.constraint(equalTo: summaryLabel.centerYAnchor).isActive = true
        summaryTextLabel.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        summaryTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        summaryTextLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(summaryUnderlineView)
        summaryUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        summaryUnderlineView.topAnchor.constraint(equalTo: summaryTextLabel.bottomAnchor, constant: 10).isActive = true
        summaryUnderlineView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        summaryUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(websiteTextView)
        websiteTextView.translatesAutoresizingMaskIntoConstraints = false
        websiteTextView.centerYAnchor.constraint(equalTo: websiteLabel.centerYAnchor).isActive = true
        websiteTextView.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        websiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        websiteTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(websiteUnderlineView)
        websiteUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        websiteUnderlineView.topAnchor.constraint(equalTo: websiteTextView.bottomAnchor, constant: 10).isActive = true
        websiteUnderlineView.leadingAnchor.constraint(equalTo: websiteTextView.leadingAnchor).isActive = true
        websiteUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        websiteUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(topUnderlineView)
        topUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnderlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnderlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func tagButton(with title: String) -> TagButton {
        let button = TagButton(title: title)
        return button
    }
    
    @objc func updateListenerBio() {
        programNameTextView.resignFirstResponder()
        let listenerBioVC = UpdateListenerBioVC()
        navigationController?.pushViewController(listenerBioVC, animated: true)
    }
    
    @objc func selectGenrePress() {
        settingsLauncher.showSettings()
        programNameTextView.resignFirstResponder()
    }
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func nameFieldChanged() {
        if programNameTextView.text != CurrentProgram.name && programNameTextView.text != "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            programNameTextView.textColor = CustomStyle.primaryBlack
        } else {
            programNameTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    @objc func linkFieldChanged() {
        if  websiteTextView.text != CurrentProgram.webLink {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            websiteTextView.textColor = CustomStyle.primaryBlack
        } else {
             websiteTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    
    @objc func saveChanges() {
        if programNameTextView.text != CurrentProgram.name && programNameTextView.text != "" {
            programNameTextView.textColor = CustomStyle.fourthShade
            CurrentProgram.name = programNameTextView.text?.trimmingTrailingSpaces
            FireStoreManager.updatePrimaryProgramName()
        }
        
        if websiteTextView.text != CurrentProgram.webLink && websiteTextView.text != "www.example.com" {
            guard let webLink = websiteTextView.text else { return }
            if webLink.isValidURL || webLink == "" {
                FireStoreManager.updateProgramsWeblinkWith(urlString: webLink, programID: CurrentProgram.ID!)
                websiteTextView.textColor = CustomStyle.fourthShade
                CurrentProgram.webLink = webLink
            } else {
                print("Not valid")
                UIApplication.shared.windows.last?.addSubview(invalidURLAlert)
            }
        }
        
        if websiteTextView.text == "" {
            websiteTextView.textColor = CustomStyle.fourthShade
            websiteTextView.text = "www.example.com"
            CurrentProgram.webLink = nil
        }
        programNameTextView.resignFirstResponder()
        websiteTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

extension EditListenerVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            CurrentProgram.image = selectedImage
            profileImageView.image = selectedImage
            
            FileManager.storeSelectedProgramImage(image: selectedImage, imageID: CurrentProgram.imageID, programID: CurrentProgram.ID!)
            dismiss(animated: true, completion: nil)
        }
    }
}
