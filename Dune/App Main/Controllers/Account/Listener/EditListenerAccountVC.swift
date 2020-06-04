//
//  EditListenerAccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 12/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class EditListenerAccountVC: UIViewController {
    
    var tagContentWidth: NSLayoutConstraint!
    var tags: [String]?
        
    let headerViewHeight: CGFloat = 300
    lazy var viewHeight = view.frame.height
    lazy var tagScrollViewWidth = tagScrollView.frame.width
    
    let invalidURLAlert = CustomAlertView(alertType: .invalidURL)
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.alpha = 0
        return nav
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
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
        imageView.image = User.image!
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change program image", for: .normal)
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
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Display name"
        return label
    }()
    
    let displayNameTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.addTarget(self, action: #selector(nameFieldChanged), for: UIControl.Event.editingChanged)
        textField.autocorrectionType = .no
        return textField
    }()
    
    let displayNameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let summaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Summary"
        return label
    }()
    
    lazy var summaryTextLabel: UILabel = {
        let label = UILabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateUserDetails))
        label.addGestureRecognizer(tapGesture)
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Optional Link"
        return label
    }()
    
    let websiteTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Interest tags"
        return label
    }()
    
    let tagScrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    let gradientOverlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tagContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let tagContainingStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        return view
    }()
    
    let tagsUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let accountTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Account type"
        return label
    }()
    
    let accountTypeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Listener", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        return button
    }()
    
    let accountTypeUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let topUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let firstCustomCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        cell.frame.size = CGSize(width: 200, height: 100)
        return cell
    }()
    
    let blackBGView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegates()
        configureNavBar()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        scrollView.setScrollBarToTopLeft()
        tagScrollView.setScrollBarToTopLeft()
        summaryTextLabel.text = User.summary
       
        let namePlaceholder = NSAttributedString(string: User.displayName!, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        displayNameTextView.attributedPlaceholder = namePlaceholder;
        
        var weblink: String
        
        if User.webLink == nil ||  User.webLink == "" {
            weblink = "www.example.com"
        } else {
            weblink = User.webLink!
        }
        
        websiteTextView.text = weblink
        websiteTextView.textColor = CustomStyle.fourthShade
        
        createTagButtons()
    }
    
    func configureDelegates() {
        scrollView.delegate = self
    }
    
    func configureNavBar() {
        navigationItem.title = "Edit Account"
        navigationController?.isNavigationBarHidden = false
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBar?.tintColor = .white
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navBar?.backIndicatorImage = imgBackArrow
        navBar?.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addGradient()
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
        scrollContentView.heightAnchor.constraint(equalToConstant: viewHeight + 100).isActive = true
        scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        scrollContentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: scrollContentView.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        headerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor , constant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
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
        
        userFieldsStackedView.addArrangedSubview(displayNameLabel)
        userFieldsStackedView.addArrangedSubview(summaryLabel)
        userFieldsStackedView.addArrangedSubview(websiteLabel)
        userFieldsStackedView.addArrangedSubview(accountTypeLabel)
        userFieldsStackedView.addArrangedSubview(tagsLabel)
        
        // Add user values
        
        scrollContentView.addSubview(displayNameTextView)
        displayNameTextView.translatesAutoresizingMaskIntoConstraints = false
        displayNameTextView.centerYAnchor.constraint(equalTo: displayNameLabel.centerYAnchor).isActive = true
        displayNameTextView.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        displayNameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        displayNameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(displayNameUnderlineView)
        displayNameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        displayNameUnderlineView.topAnchor.constraint(equalTo: displayNameTextView.bottomAnchor, constant: 10).isActive = true
        displayNameUnderlineView.leadingAnchor.constraint(equalTo: displayNameTextView.leadingAnchor).isActive = true
        displayNameUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        displayNameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(summaryTextLabel)
        summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryTextLabel.centerYAnchor.constraint(equalTo: summaryLabel.centerYAnchor).isActive = true
        summaryTextLabel.leadingAnchor.constraint(equalTo: displayNameTextView.leadingAnchor).isActive = true
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
        websiteTextView.leadingAnchor.constraint(equalTo: displayNameTextView.leadingAnchor).isActive = true
        websiteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        websiteTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(websiteUnderlineView)
        websiteUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        websiteUnderlineView.topAnchor.constraint(equalTo: websiteTextView.bottomAnchor, constant: 10).isActive = true
        websiteUnderlineView.leadingAnchor.constraint(equalTo: websiteTextView.leadingAnchor).isActive = true
        websiteUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        websiteUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(tagScrollView)
        tagScrollView.translatesAutoresizingMaskIntoConstraints = false
        tagScrollView.centerYAnchor.constraint(equalTo: tagsLabel.centerYAnchor).isActive = true
        tagScrollView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        tagScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagScrollView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        tagScrollView.addSubview(tagContainingStackView)
        tagContainingStackView.translatesAutoresizingMaskIntoConstraints = false
        tagContainingStackView.topAnchor.constraint(equalTo: tagScrollView.topAnchor).isActive = true
        tagContainingStackView.leadingAnchor.constraint(equalTo: tagScrollView.leadingAnchor).isActive = true
        tagContainingStackView.heightAnchor.constraint(equalTo: tagScrollView.heightAnchor).isActive = true
        tagContainingStackView.trailingAnchor.constraint(equalTo: tagScrollView.trailingAnchor, constant: -20).isActive = true
        
        scrollContentView.addSubview(gradientOverlayView)
        gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
        gradientOverlayView.centerYAnchor.constraint(equalTo: tagScrollView.centerYAnchor).isActive = true
        gradientOverlayView.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        gradientOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        gradientOverlayView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        
        scrollContentView.addSubview(tagsUnderlineView)
        tagsUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        tagsUnderlineView.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        tagsUnderlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tagsUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagsUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(accountTypeButton)
        accountTypeButton.translatesAutoresizingMaskIntoConstraints = false
        accountTypeButton.topAnchor.constraint(equalTo: accountTypeLabel.topAnchor, constant: -5).isActive = true
        accountTypeButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        accountTypeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(accountTypeUnderlineView)
        accountTypeUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        accountTypeUnderlineView.topAnchor.constraint(equalTo: accountTypeButton.bottomAnchor, constant: 10).isActive = true
        accountTypeUnderlineView.leadingAnchor.constraint(equalTo: accountTypeButton.leadingAnchor).isActive = true
        accountTypeUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        accountTypeUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(topUnderlineView)
        topUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnderlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnderlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
         
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviewsCompletely()
        for eachTag in User.tags! {
            let button = tagButton(with: eachTag)
            button.addTarget(self, action: #selector(updateUserDetails), for: .touchUpInside)
            tagContainingStackView.addArrangedSubview(button)
        }
    }
    
    func tagButton(with title: String) -> TagButton {
        let button = TagButton(title: title)
        return button
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
    
    @objc func updateUserDetails() {
        displayNameTextView.resignFirstResponder()
        let listenerDetailsVC = EditListenerDetailsVC()
        navigationController?.pushViewController(listenerDetailsVC, animated: true)
    }
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func nameFieldChanged() {
        if displayNameTextView.text != User.displayName && displayNameTextView.text != "" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            displayNameTextView.textColor = CustomStyle.primaryBlack
        } else {
            displayNameTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    @objc func linkFieldChanged() {
        if  websiteTextView.text != User.webLink {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveChanges))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            websiteTextView.textColor = CustomStyle.primaryBlack
        } else {
             websiteTextView.textColor = CustomStyle.fourthShade
        }
    }
    
    @objc func saveChanges() {
        if displayNameTextView.text != User.displayName && displayNameTextView.text != "" {
            displayNameTextView.textColor = CustomStyle.fourthShade
            User.displayName = displayNameTextView.text
            FireStoreManager.updateUserDisplayName()
        }
        
        if websiteTextView.text != User.webLink && websiteTextView.text != "www.example.com" {
            guard let webLink = websiteTextView.text else { return }
            if webLink.isValidURL || webLink == "" {
                FireStoreManager.updateUsersWeblinkWith(urlString: webLink)
                websiteTextView.textColor = CustomStyle.fourthShade
                User.webLink = webLink
            } else {
                print("Not valid")
                UIApplication.shared.windows.last?.addSubview(invalidURLAlert)
            }
        }
        
        if websiteTextView.text == "" {
            websiteTextView.textColor = CustomStyle.fourthShade
            websiteTextView.text = "www.example.com"
            User.webLink = nil
        }
        displayNameTextView.resignFirstResponder()
        websiteTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
}

// Manage Navbar Opacity while scrolling
extension EditListenerAccountVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        customNavBar.alpha = y / 100
    }
    
}

// Manage primary category selection
extension EditListenerAccountVC: SettingsLauncherDelegate {
 
    func selectionOf(setting: String) {
        accountTypeButton.setTitle(setting, for: .normal)
        FireStoreManager.updatePrimaryCategory()
    }
}

extension EditListenerAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            User.image = selectedImage
            profileImageView.image = selectedImage
            
            FileManager.storeSelectedUserImage(image: selectedImage, imageID: User.imageID)
            dismiss(animated: true, completion: nil)
        }
    }
}

extension EditListenerAccountVC: CustomAlertDelegate {
   
    func primaryButtonPress() {
//        CurrentProgram.hasIntro = false
//
//        FireStoreManager.removeIntroFromProgram()
//        FireStorageManager.deleteIntroAudioFromStorage(audioID: CurrentProgram.introID!)
//        recordIntroButton.titleLabel?.text = "Record"
//        removeIntroButton.removeFromSuperview()
    }
    
    func cancelButtonPress() {
        //
    }
    
}
