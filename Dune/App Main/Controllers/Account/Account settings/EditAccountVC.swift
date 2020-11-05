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

import MapKit
import CoreLocation

class EditAccountVC: UIViewController {
    
    var userFieldshaveUpdated = false
    var activeTextField: String?
    lazy var viewHeight = view.frame.height
    
    let Under18Years = Calendar.current.date(byAdding: .year, value: -18, to: Date())
    
    let headerViewHeight: CGFloat = 300
    
    let locationSettingsAlert = CustomAlertView(alertType: .didNotAllowLocationServices)
    var resetLocationSettingsTriggered = false
    let changingDisplayName = CustomAlertView(alertType: .programChangingName)
    var changeDisplayNameTriggered = false
    let db = Firestore.firestore()
    
    // For various screen-sizes
    var imageSize: CGFloat = 90
    var imageViewTopConstant: CGFloat = 120
    var headerViewHeightConstant: CGFloat = 300
    var scrollPadding: CGFloat = 100
    
    // Location
    let locationManager = CLLocationManager()
    
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
    
    lazy var profileImageView: UIImageView = {
        var radius: CGFloat
        if CurrentProgram.isPublisher! {
            radius = 7
        } else {
            radius = imageSize / 2
        }
        let imageView = UIImageView()
        imageView.layer.cornerRadius = radius
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
    
    var nameFieldPlaceholder: NSAttributedString {
        return NSAttributedString(string: CurrentProgram.name!, attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryBlack
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .done
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
    
    let userNameUnderlineView: UIView = {
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
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if let date = User.birthDate {
            picker.date = Date.stringToDate(dateString: User.birthDate!)
        }
        picker.addTarget(self, action: #selector(updateDateLabel), for: .editingDidEnd)
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .compact
        }
        return picker
    }()
    
    let bdayTextField: UITextField = {
        let field = UITextField()
        field.tintColor = .clear
        field.textAlignment = .right
        field.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        field.textColor = CustomStyle.fourthShade
        return field
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
    
    lazy var countryButton: UILabel = {
        let label = UILabel()
        let gestureRec = UITapGestureRecognizer(target: self, action: #selector(updateCountry))
        label.addGestureRecognizer(gestureRec)
        label.isUserInteractionEnabled = true
        label.text = User.country ?? "Needed"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.textAlignment = .left
        return label
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
        createDatePicker()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.attributedPlaceholder = nameFieldPlaceholder
        usernameTextButton.setTitle(User.username, for: .normal)
        
        profileImageView.image = CurrentProgram.image
        bdayTextField.text = User.birthDate ?? "Needed"
        emailLabelButton.text = User.email

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
            CurrentProgram.name = nameTextField.text
            FireStoreManager.updatePrimaryProgramName()
        }
    }

    
    func configureDelegates() {
//        datePicker.delegate = self
        locationSettingsAlert.alertDelegate = self
        changingDisplayName.alertDelegate = self
        nameTextField.delegate = self
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
        userFieldsStackedView.addArrangedSubview(countryLabel)
        userFieldsStackedView.addArrangedSubview(bdayLabel)
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
        
        scrollContentView.addSubview(userNameUnderlineView)
        userNameUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        userNameUnderlineView.topAnchor.constraint(equalTo: usernameTextButton.bottomAnchor, constant: 10).isActive = true
        userNameUnderlineView.leadingAnchor.constraint(equalTo: handelAtLabel.leadingAnchor).isActive = true
        userNameUnderlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userNameUnderlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
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
        
        if #available(iOS 13.4, *) {
            scrollContentView.addSubview(datePicker)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            datePicker.centerYAnchor.constraint(equalTo: bdayLabel.centerYAnchor).isActive = true
            datePicker.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor, constant: -10).isActive = true
            datePicker.heightAnchor.constraint(equalToConstant: 30).isActive = true
            datePicker.subviews[0].subviews[0].backgroundColor = nil
            
            scrollContentView.addSubview(bdayUnlineView)
            bdayUnlineView.translatesAutoresizingMaskIntoConstraints = false
            bdayUnlineView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10).isActive = true
            bdayUnlineView.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor, constant: 10).isActive = true
            bdayUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bdayUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        } else {
            scrollContentView.addSubview(bdayTextField)
            bdayTextField.translatesAutoresizingMaskIntoConstraints = false
            bdayTextField.centerYAnchor.constraint(equalTo: bdayLabel.centerYAnchor).isActive = true
            bdayTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
            bdayTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            scrollContentView.addSubview(bdayUnlineView)
            bdayUnlineView.translatesAutoresizingMaskIntoConstraints = false
            bdayUnlineView.topAnchor.constraint(equalTo: bdayTextField.bottomAnchor, constant: 10).isActive = true
            bdayUnlineView.leadingAnchor.constraint(equalTo: bdayTextField.leadingAnchor).isActive = true
            bdayUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            bdayUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
        scrollContentView.addSubview(countryButton)
        countryButton.translatesAutoresizingMaskIntoConstraints = false
        countryButton.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor).isActive = true
        countryButton.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        countryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        countryButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollContentView.addSubview(countryUnlineView)
        countryUnlineView.translatesAutoresizingMaskIntoConstraints = false
        countryUnlineView.topAnchor.constraint(equalTo: countryButton.bottomAnchor, constant: 10).isActive = true
        countryUnlineView.leadingAnchor.constraint(equalTo: countryButton.leadingAnchor).isActive = true
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
    
    
    @objc func updateDateLabel() {
        print("updateDateLabel")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let date = dateFormatter.string(from: datePicker.date)
        bdayTextField.text = date
        User.birthDate = date
        datePicker.subviews[0].subviews[0].backgroundColor = nil
        FireStoreManager.updateUserBirthDate()
        bdayTextField.resignFirstResponder()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(updateDateLabel))
        toolbar.items = [doneButton]
        toolbar.sizeToFit()
        
        bdayTextField.inputAccessoryView = toolbar
        bdayTextField.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
//    @objc func confirmDateSelected(date: Date) {
//        if date > Under18Years! {
//
//            let alert = UIAlertController(title: "Age Restrictions", message: """
//                The current date entered indicates you are under 18 years old.
//
//                Is this correct?
//                """, preferredStyle: .alert)
//
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//                self.updateDateLabel()
//            }))
//
//            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.cancel, handler: {(alert: UIAlertAction!) in
//                self.bdayTextField.becomeFirstResponder()
//            }))
//
//            self.present(alert, animated: true, completion: nil)
//
//        } else if date <= Under18Years! {
//            self.updateDateLabel()
//        }
//    }
    
    @objc func changeBirthDate() {
        nameTextField.resignFirstResponder()
//        datePicker.presentDatePicker()
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
    
    //MARK: - Get Country data
    
    @objc func updateCountry() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
             case .restricted, .denied:
                print("No access")
                UIApplication.shared.windows.last?.addSubview(self.locationSettingsAlert)
                resetLocationSettingsTriggered = true
            case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                locationManager.delegate = self
                print("Access")
            default:
                break
             }
        } else {
            // Device location settings is turned off
            print("Fire")
        }
    }
    
}

extension EditAccountVC: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let location: CLLocation = manager.location else { return }
        
        fetchCityAndCountry(from: location) { [weak self] city, country, error in
            guard let country = country, error == nil else { return }
            self?.countryButton.text = country
            FireStoreManager.updateUserLocationWith(country: country, lat: locValue.latitude, lon: locValue.longitude)
        }
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
}

// Resign responder for custom alert
extension EditAccountVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        
        if changeDisplayNameTriggered {
            nameTextField.becomeFirstResponder()
            changeDisplayNameTriggered = false
        } else if resetLocationSettingsTriggered {
            resetLocationSettingsTriggered = false
            let url = URL(string:UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url!) {
                UIApplication.shared.open(url!, options: [:]) {_ in
                    print("Did return")
                }
            }
        }

    }
    
    func cancelButtonPress() {
        
        if changeDisplayNameTriggered {
            nameTextField.resignFirstResponder()
        }
        
        resetLocationSettingsTriggered = false
        changeDisplayNameTriggered = false
    }
}


// Alert publishers about changing name
extension EditAccountVC: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
//        changeDisplayNameTriggered = false
//    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTextField.textColor = CustomStyle.primaryBlack
        if textField == nameTextField && CurrentProgram.isPublisher! {
            DispatchQueue.main.async {
                UIApplication.shared.windows.last?.addSubview(self.changingDisplayName)
                self.changeDisplayNameTriggered = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" && nameTextField.text != CurrentProgram.name {
            CurrentProgram.name = nameTextField.text
            FireStoreManager.updatePrimaryProgramName()
            nameTextField.attributedPlaceholder = nameFieldPlaceholder
            nameTextField.textColor = CustomStyle.fourthShade
            nameTextField.resignFirstResponder()
        }
        return true
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

