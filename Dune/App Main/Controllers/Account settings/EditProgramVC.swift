//
//  editListenerProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 12/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class EditProgramVC: UIViewController {
    
    var tagContentWidth: NSLayoutConstraint!
    var tags: [String]?
    
    lazy var viewHeight = view.frame.height
    lazy var tagscrollViewWidth = tagScrollView.frame.width
    
    let settingsLauncher = SettingsLauncher(options: SettingOptions.categories, type: .categories)
    let db = Firestore.firestore()
    
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
        return view
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.seventhShade
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "momentum")
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        return imageView
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
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Program Name"
        return label
    }()
    
    let programNameTextView: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: User.username!, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        //        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return textField
    }()
    
    let programNameUnlineView: UIView = {
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(updateProgramDetails))
        label.addGestureRecognizer(tapGesture)
        label.textColor = CustomStyle.fourthShade
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let summaryUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let tagsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Tags"
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
    
    let tagsUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let primaryGenreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Primary Genre"
        return label
    }()
    
    let primaryGenreButton: UIButton = {
        let button = UIButton()
        button.setTitle(CurrentProgram.primaryCategory, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.addTarget(self, action: #selector(selectGenrePress), for: .touchUpInside)
        return button
    }()
    
    let primaryGenreUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let programIntroLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Program Intro"
        return label
    }()
    
    let countryUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let programIntroButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.backgroundColor = CustomStyle.seventhShade
        button.layer.cornerRadius = 4
        return button
    }()
    
    let topUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let bottomlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
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
    
    let firstCustomCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.backgroundColor = .red
        cell.frame.size = CGSize(width: 200, height: 100)
        return cell
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfPrimaryProgram()
        configiureViews()
        configureNavBar()
        scrollView.delegate = self
        settingsLauncher.settingsDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
        scrollView.setScrollBarToTopLeft()
        tagScrollView.setScrollBarToTopLeft()
        summaryTextLabel.text = CurrentProgram.summary
        programNameTextView.text = ""
        programNameTextView.placeholder = CurrentProgram.name
        createTagButtons()
        setProgramImage()
    }
    
    // Save changed program name
    override func viewWillDisappear(_ animated: Bool) {
        
        if programNameTextView.text != CurrentProgram.name && programNameTextView.text != "" {
            print("Save New Name")
            CurrentProgram.name = programNameTextView.text
            
            if CurrentProgram.isPrimaryProgram! {
                FireStoreManager.updatePrimaryProgramName()
            } else {
                FireStoreManager.updateSecondaryProgramName()
            }
        }
    }
    
    func checkIfPrimaryProgram() {
        guard let isPrimaryProgram = CurrentProgram.isPrimaryProgram else { return }
      
        if isPrimaryProgram {
            primaryGenreButton.isEnabled = true
        } else {
             primaryGenreButton.isEnabled = false
        }
    }
    
    func configureNavBar() {
        navigationItem.title = "Edit Program"
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
    
    
    func setProgramImage() {
        if CurrentProgram.image != nil {
            profileImageView.image = CurrentProgram.image
        } else {
            profileImageView.image = #imageLiteral(resourceName: "missing-image-large")
        }
    }
    
    func configiureViews() {
        view.backgroundColor = .white
        
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
        
        userFieldsStackedView.addArrangedSubview(programNameLabel)
        userFieldsStackedView.addArrangedSubview(summaryLabel)
        userFieldsStackedView.addArrangedSubview(tagsLabel)
        userFieldsStackedView.addArrangedSubview(primaryGenreLabel)
        userFieldsStackedView.addArrangedSubview(programIntroLabel)
        
        // Add user values
        
        scrollContentView.addSubview(programNameTextView)
        programNameTextView.translatesAutoresizingMaskIntoConstraints = false
        programNameTextView.centerYAnchor.constraint(equalTo: programNameLabel.centerYAnchor).isActive = true
        programNameTextView.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        programNameTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        programNameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(programNameUnlineView)
        programNameUnlineView.translatesAutoresizingMaskIntoConstraints = false
        programNameUnlineView.topAnchor.constraint(equalTo: programNameTextView.bottomAnchor, constant: 10).isActive = true
        programNameUnlineView.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        programNameUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        programNameUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(summaryTextLabel)
        summaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        summaryTextLabel.centerYAnchor.constraint(equalTo: summaryLabel.centerYAnchor).isActive = true
        summaryTextLabel.leadingAnchor.constraint(equalTo: programNameTextView.leadingAnchor).isActive = true
        summaryTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        summaryTextLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(summaryUnlineView)
        summaryUnlineView.translatesAutoresizingMaskIntoConstraints = false
        summaryUnlineView.topAnchor.constraint(equalTo: summaryTextLabel.bottomAnchor, constant: 10).isActive = true
        summaryUnlineView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        summaryUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        summaryUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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
        
        scrollContentView.addSubview(tagsUnlineView)
        tagsUnlineView.translatesAutoresizingMaskIntoConstraints = false
        tagsUnlineView.topAnchor.constraint(equalTo: tagScrollView.bottomAnchor, constant: 20).isActive = true
        tagsUnlineView.leadingAnchor.constraint(equalTo: summaryTextLabel.leadingAnchor).isActive = true
        tagsUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tagsUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(primaryGenreButton)
        primaryGenreButton.translatesAutoresizingMaskIntoConstraints = false
        primaryGenreButton.topAnchor.constraint(equalTo: primaryGenreLabel.topAnchor, constant: -5).isActive = true
        primaryGenreButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        primaryGenreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(primaryGenreUnlineView)
        primaryGenreUnlineView.translatesAutoresizingMaskIntoConstraints = false
        primaryGenreUnlineView.topAnchor.constraint(equalTo: primaryGenreButton.bottomAnchor, constant: 10).isActive = true
        primaryGenreUnlineView.leadingAnchor.constraint(equalTo: primaryGenreButton.leadingAnchor).isActive = true
        primaryGenreUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        primaryGenreUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(programIntroButton)
        programIntroButton.translatesAutoresizingMaskIntoConstraints = false
        programIntroButton.topAnchor.constraint(equalTo: programIntroLabel.topAnchor).isActive = true
        programIntroButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        programIntroButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(topUnlineView)
        topUnlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(bottomlineView)
        bottomlineView.translatesAutoresizingMaskIntoConstraints = false
        bottomlineView.topAnchor.constraint(equalTo: programIntroButton.bottomAnchor, constant: 20).isActive = true
        bottomlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    @objc func selectGenrePress() {
        programNameTextView.resignFirstResponder()
        settingsLauncher.showSettings()
    }
    
    @objc func updateProgramDetails() {
        programNameTextView.resignFirstResponder()
        let programDetailsVC = UpdateProgramDetails()
        navigationController?.pushViewController(programDetailsVC, animated: true)
    }
    
    // Program tag creation
    func createTagButtons() {
        tagContainingStackView.removeAllArrangedSubviewsCompletely()
        for eachTag in CurrentProgram.tags! {
            let button = tagButton(with: eachTag!)
            button.addTarget(self, action: #selector(updateProgramDetails), for: .touchUpInside)
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
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

// Manage Navbar Opacity while scrolling
extension EditProgramVC: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        customNavBar.alpha = y / 100
    }
    
}

// Manage primary category selection
extension EditProgramVC: SettingsLauncherDelegate {
 
    func selectionOf(setting: String) {
        // do things
    }
    
    
    func selectionOf() {
        programNameTextView.resignFirstResponder()
        primaryGenreButton.setTitle(CurrentProgram.primaryCategory, for: .normal)
        FireStoreManager.updatePrimaryCategory()
    }
}

extension EditProgramVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            
            FileManager.storeSelectedProgramImage(image: selectedImage)
            
//            FireStorageManager.deleteProgramImageFileFromStorage(imageID: Program.imageID!) {                    FileManager.removeFilesIn(folder: .programImage) {
//                FileManager.storeSelectedProgram(image: selectedImage) {
//                    FireStorageManager.storeProgram(image: selectedImage)
//                }
//                }
//            }
            dismiss(animated: true, completion: nil)
        }
    }
}
