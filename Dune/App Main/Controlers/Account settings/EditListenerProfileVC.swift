//
//  editListenerProfileVC.swift
//  Dune
//
//  Created by Waylan Sands on 12/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class EditListenerProfileVC: UIViewController {
    
    let customNavBar: CustomNavBar = {
        let nav = CustomNavBar()
        nav.leftButton.isHidden = true
        return nav
    }()
    
    let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "profile-image-two")
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
    
//    let userValuesStackedView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.spacing = 30
//        return stackView
//    }()
    
    let displayNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryblack
        label.text = "Display Name"
        return label
    }()
    
    let displayNameTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "Monica", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryblack
        return textField
    }()
    
    let displayNameUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryblack
        label.text = "Username"
        return label
    }()
    
    let handelAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.fourthShade
        label.text = "@"
        return label
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "Monica", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryblack
        return textField
    }()
    
    let userNameUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryblack
        label.text = "Email"
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "Monica", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryblack
        return textField
    }()
    
    let emailUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let bdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryblack
        label.text = "Birthday"
        return label
    }()
    
    let bdayTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "Monica", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryblack
        return textField
    }()
    
    let bdayUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = CustomStyle.primaryblack
        label.text = "Country"
        return label
    }()
    
    let countryTextField: UITextField = {
        let textField = UITextField()
        let placeholder = NSAttributedString(string: "Monica", attributes: [NSAttributedString.Key.foregroundColor : CustomStyle.fourthShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.attributedPlaceholder = placeholder;
        textField.textColor = CustomStyle.primaryblack
        return textField
    }()
    
    let countryUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    let topUnlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        return view
    }()
    
    
    let changeImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change profile photo", for: .normal)
        button.setTitleColor(CustomStyle.linkBlue, for: .normal)
        button.setTitleColor(CustomStyle.linkBlue.withAlphaComponent(0.8), for: .highlighted)
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
        configiureViews()
        self.title = "Edit Profile"
    }
    
    func configiureViews() {
        view.backgroundColor = .white
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        headerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor , constant: 140).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        headerView.addSubview(changeImageButton)
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changeImageButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor , constant: 5).isActive = true
        
        view.addSubview(profileInfoView)
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
        userFieldsStackedView.addArrangedSubview(usernameLabel)
        userFieldsStackedView.addArrangedSubview(emailLabel)
        userFieldsStackedView.addArrangedSubview(bdayLabel)
        userFieldsStackedView.addArrangedSubview(countryLabel)
        
        // Add user values
        
        view.addSubview(displayNameTextField)
        displayNameTextField.translatesAutoresizingMaskIntoConstraints = false
        displayNameTextField.topAnchor.constraint(equalTo: displayNameLabel.topAnchor).isActive = true
        displayNameTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        displayNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        displayNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(displayNameUnlineView)
        displayNameUnlineView.translatesAutoresizingMaskIntoConstraints = false
        displayNameUnlineView.topAnchor.constraint(equalTo: displayNameTextField.bottomAnchor, constant: 10).isActive = true
        displayNameUnlineView.leadingAnchor.constraint(equalTo: displayNameTextField.leadingAnchor).isActive = true
        displayNameUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        displayNameUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(handelAtLabel)
        handelAtLabel.translatesAutoresizingMaskIntoConstraints = false
        handelAtLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor).isActive = true
        handelAtLabel.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        
        view.addSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.topAnchor.constraint(equalTo: usernameLabel.topAnchor, constant: -5).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: handelAtLabel.trailingAnchor).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        usernameTextField.setLeftPadding(2)
        
        view.addSubview(userNameUnlineView)
        userNameUnlineView.translatesAutoresizingMaskIntoConstraints = false
        userNameUnlineView.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10).isActive = true
        userNameUnlineView.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true
        userNameUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        userNameUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: emailLabel.topAnchor).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(emailUnlineView)
        emailUnlineView.translatesAutoresizingMaskIntoConstraints = false
        emailUnlineView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        emailUnlineView.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor).isActive = true
        emailUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        emailUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(bdayTextField)
        bdayTextField.translatesAutoresizingMaskIntoConstraints = false
        bdayTextField.topAnchor.constraint(equalTo: bdayLabel.topAnchor).isActive = true
        bdayTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        bdayTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        bdayTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(bdayUnlineView)
        bdayUnlineView.translatesAutoresizingMaskIntoConstraints = false
        bdayUnlineView.topAnchor.constraint(equalTo: bdayTextField.bottomAnchor, constant: 10).isActive = true
        bdayUnlineView.leadingAnchor.constraint(equalTo: bdayTextField.leadingAnchor).isActive = true
        bdayUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bdayUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(countryTextField)
        countryTextField.translatesAutoresizingMaskIntoConstraints = false
        countryTextField.topAnchor.constraint(equalTo: countryLabel.topAnchor).isActive = true
        countryTextField.leadingAnchor.constraint(equalTo: userFieldsStackedView.trailingAnchor).isActive = true
        countryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        countryTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.addSubview(countryUnlineView)
        countryUnlineView.translatesAutoresizingMaskIntoConstraints = false
        countryUnlineView.topAnchor.constraint(equalTo: countryTextField.bottomAnchor, constant: 10).isActive = true
        countryUnlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        countryUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        countryUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(topUnlineView)
        topUnlineView.translatesAutoresizingMaskIntoConstraints = false
        topUnlineView.topAnchor.constraint(equalTo: profileInfoView.topAnchor, constant: 0).isActive = true
        topUnlineView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topUnlineView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topUnlineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
    }
}

