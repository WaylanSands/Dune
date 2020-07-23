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

class EditAccountVC: UIViewController {
    
    var userFieldshaveUpdated = false
    var activeTextField: String?
    lazy var viewHeight = view.frame.height
    
    let Under18Years = Calendar.current.date(byAdding: .year, value: -18, to: Date())
    
    let headerViewHeight: CGFloat = 300
    let changingDisplayName = CustomAlertView(alertType: .programChangingName)
    let datePicker = CustomDatePicker()
    let db = Firestore.firestore()
    
    // For various screen-sizes
    var imageSize: CGFloat = 90
    var imageViewTopConstant: CGFloat = 120
    var headerViewHeightConstant: CGFloat = 300
    var scrollPadding: CGFloat = 100
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        nav.titleLabel.text = "Edit Account"
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Display Name"
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return textField
    }()
    
    let nameUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Username"
        return label
    }()
    
    let handelAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.text = "@"
        return label
    }()
    
    lazy var usernameTextButton: UIButton = {
        let button = UIButton()
        button.setTitle(User.username!, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.addTarget(self, action: #selector(changeUsernamePress), for: .touchUpInside)
        return button
    }()
    
    let userNameUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Email"
        return label
    }()
    
    lazy var emailLabelButton: UILabel = {
        let label = UILabel()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(changeEmailPress))
        label.addGestureRecognizer(gestureRec)
        label.isUserInteractionEnabled = true
        label.text = User.email
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.textAlignment = .left
        return label
    }()
    
    let emailUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let bdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Birthday"
        return label
    }()
    
    let bdayTextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(CustomStyle.fourthShade, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(changeBirthDate), for: .touchUpInside)
        return button
    }()
    
    let bdayUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Country"
        return label
    }()
    
    let countryTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        let placeholder = NSAttributedString(string: "Australia", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        return textField
    }()
    
    let countryUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.primaryBlack
        label.text = "Password"
        return label
    }()
    
    let passwordButton: UIButton = {
        let button = UIButton()
        button.setTitle("change", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(CustomStyle.buttonBlue, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 2, right: 15)
        button.addTarget(self, action: #selector(changePasswordButtonPress), for: .touchUpInside)
        button.backgroundColor = CustomStyle.secondShade
        button.layer.cornerRadius = 13
        return button
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
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change profile image", for: .normal)
        button.setTitleColor(CustomStyle.buttonBlue, for: .normal)
        button.setTitleColor(CustomStyle.buttonBlue.withAlphaComponent(0.8), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(changeImageButtonPress), for: .touchUpInside)
        return button
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
        styleForScreens()
        configureViews()
        configureDelegates()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextButton.setTitle(User.username, for: .normal)
        bdayTextButton.setTitle(User.birthDate, for: .normal)
        profileImageView.image = CurrentProgram.image
        emailLabelButton.text = User.email

        let placeholder = NSAttributedString(string: CurrentProgram.name!, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        nameTextField.attributedPlaceholder = placeholder

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
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // Save changed fields
    override func viewWillDisappear(_ animated: Bool) {
        
        if nameTextField.text != "" && nameTextField.text != CurrentProgram.name {
            print("Save new name")
            CurrentProgram.name = nameTextField.text
            FireStoreManager.updatePrimaryProgramName()
        }
    }

    
    func configureDelegates() {
        datePicker.delegate = self
        nameTextField.delegate = self
        changingDisplayName.alertDelegate = self
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            imageSize = 80
            headerViewHeightConstant = 260
            imageViewTopConstant = 90
            scrollPadding = 140
        case .iPhone8:
            headerViewHeightConstant = 280
            imageViewTopConstant = 100
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
        changeImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 5).isActive = true
        
        scrollContentView.addSubview(profileInfoView)
        profileInfoView.translatesAutoresizingMaskIntoConstraints = false
        profileInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        profileInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        profileInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        profileInfoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        profileInfoView.addSubview(userFieldsStackedView)
        userFieldsStackedView.translatesAutoresizingMaskIntoConstraints = false
        userFieldsStackedView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 30).isActive = true
        userFieldsStackedView.leadingAnchor.constraint(equalTo: profileInfoView.leadingAnchor).isActive = true
        userFieldsStackedView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        
        // Add user fields
        
        userFieldsStackedView.addArrangedSubview(nameLabel)
        userFieldsStackedView.addArrangedSubview(usernameLabel)
        userFieldsStackedView.addArrangedSubview(emailLabel)
        userFieldsStackedView.addArrangedSubview(bdayLabel)
        userFieldsStackedView.addArrangedSubview(countryLabel)
        userFieldsStackedView.addArrangedSubview(passwordLabel)
        
        // Add user values
        
        scrollContentView.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(nameUnderlineView)
        nameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        nameUnderlineView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        nameUnderlineView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor).isActive = true
        nameUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(handelAtLabel)
        handelAtLabel.translatesAutoresizingMaskIntoConstraints = false
        handelAtLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor).isActive = true
        handelAtLabel.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        
        scrollContentView.addSubview(usernameTextButton)
        usernameTextButton.translatesAutoresizingMaskIntoConstraints = false
        usernameTextButton.topAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -5).isActive = true
        usernameTextButton.leadingAnchor.constraint(equalTo: handelAtLabel.trailingAnchor).isActive = true
        usernameTextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(userNameUnlineView)
        userNameUnlineView.translatesAutoresizingMaskIntoConstraints = false
        userNameUnlineView.topAnchor.constraint(equalTo: usernameTextButton.bottomAnchor, constant: 10).isActive = true
        userNameUnlineView.leadingAnchor.constraint(equalTo: handelAtLabel.leadingAnchor).isActive = true
        userNameUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userNameUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(emailLabelButton)
        emailLabelButton.translatesAutoresizingMaskIntoConstraints = false
        emailLabelButton.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true
        emailLabelButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        emailLabelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailLabelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(emailUnlineView)
        emailUnlineView.translatesAutoresizingMaskIntoConstraints = false
        emailUnlineView.topAnchor.constraint(equalTo: emailLabelButton.bottomAnchor, constant: 10).isActive = true
        emailUnlineView.leadingAnchor.constraint(equalTo: emailLabelButton.leadingAnchor).isActive = true
        emailUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emailUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(bdayTextButton)
        bdayTextButton.translatesAutoresizingMaskIntoConstraints = false
        bdayTextButton.centerYAnchor.constraint(equalTo: bdayLabel.centerYAnchor).isActive = true
        bdayTextButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        bdayTextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(bdayUnlineView)
        bdayUnlineView.translatesAutoresizingMaskIntoConstraints = false
        bdayUnlineView.topAnchor.constraint(equalTo: bdayTextButton.bottomAnchor, constant: 10).isActive = true
        bdayUnlineView.leadingAnchor.constraint(equalTo: bdayTextButton.leadingAnchor).isActive = true
        bdayUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bdayUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(countryTextField)
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        countryTextField.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor).isActive = true
        countryTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        countryTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(countryUnlineView)
        countryUnlineView.translatesAutoresizingMaskIntoConstraints = false
        countryUnlineView.topAnchor.constraint(equalTo: countryTextField.bottomAnchor, constant: 10).isActive = true
        countryUnlineView.leadingAnchor.constraint(equalTo: countryTextField.leadingAnchor).isActive = true
        countryUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(passwordButton)
        passwordButton.translatesAutoresizingMaskIntoConstraints = false
        passwordButton.topAnchor.constraint(equalTo: passwordLabel.topAnchor).isActive = true
        passwordButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        passwordButton.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        scrollContentView.addSubview(topUnderlineView)
        topUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnderlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnderlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        scrollContentView.addSubview(bottomlineView)
        bottomlineView.translatesAutoresizingMaskIntoConstraints = false
        bottomlineView.topAnchor.constraint(equalTo: passwordButton.bottomAnchor, constant: 20).isActive = true
        bottomlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
    
    func updateDateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: datePicker.datePicker.date)
        bdayTextButton.setTitle(date, for: .normal)
        User.birthDate = date
        FireStoreManager.updateUserBirthDate()
    }
    
    @objc func changeBirthDate() {
        nameTextField.resignFirstResponder()
        datePicker.presentDatePicker()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        User.displayName = displayNameTextField.text
    }
    
    @objc func changeUsernamePress() {
        let usernameVC = ChangeUsernameVC()
        navigationController?.pushViewController(usernameVC, animated: true)
    }
    
    @objc func changeEmailPress() {
        let emailVC = ChangeEmailVC()
        navigationController?.pushViewController(emailVC, animated: true)
    }
    
    @objc func changeImageButtonPress() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func changePasswordButtonPress() {
        let changePasswordVC = ChangePasswordVC()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
}

// Resign responder for custom alert
extension EditAccountVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        if activeTextField == "displayName" {
            nameTextField.becomeFirstResponder()
        }
    }
    
    func cancelButtonPress() {
        if activeTextField == "displayName" {
            nameTextField.resignFirstResponder()
        }
    }
}

// Alert user if they are under the age of 18
extension EditAccountVC: CustomDatePickerDelegate {
    
    func confirmDateSelected(date: Date) {
        if date > Under18Years! {
            
            let alert = UIAlertController(title: "Age Restrictions", message: """
                The current date entered indicates you are under 18 years old.

                Is this correct?
                """, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                self.updateDateLabel()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in
                self.datePicker.presentDatePicker()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if date <= Under18Years! {
            self.updateDateLabel()
        }
    }
}


// Alert publishers about changing name
extension EditAccountVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField && User.isPublisher! {
            activeTextField = "displayName"
            DispatchQueue.main.async {
                UIApplication.shared.windows.last?.addSubview(self.changingDisplayName)
            }
        }
    }
}

// Change Account Image
extension EditAccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        // Add selected image
        if let selectedImage = selectedImageFromPicker {
            CurrentProgram.image = selectedImage
            profileImageView.image = selectedImage
            
            // Store selected image to user or Program
            FileManager.storeSelectedProgramImage(image: selectedImage, imageID: CurrentProgram.imageID, programID: CurrentProgram.ID!)
            dismiss(animated: true, completion: nil)
        }
    }
}

