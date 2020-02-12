//
//  ListenerNameController.swift
//  Snippets
//
//  Created by Waylan Sands on 20/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class ListenerNameController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var headingTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var maxCharactersLabel: UILabel!
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryBlue
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        return button
    }()
    
    let customNavBar = CustomNavBar()
    let device = UIDevice()
    lazy var deviceType = device.deviceType
    lazy var dynamicNavbarHeight = device.navBarHeight()
    lazy var dynamicNavbarButtonHeight = device.navBarButtonTopAnchor()
    
    var homeIndicatorHeight:CGFloat = 34.0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        
        customNavBar.skipButton.isHidden = true
        customNavBar.backButton.addTarget(self, action: #selector(backButtonPress), for: .touchUpInside)
        
        view.addSubview(customNavBar)
        customNavBar.bringSubviewToFront(customNavBar)
        customNavBar.translatesAutoresizingMaskIntoConstraints = false
        customNavBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        customNavBar.heightAnchor.constraint(equalToConstant: dynamicNavbarHeight).isActive = true
        
        view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        containerView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -homeIndicatorHeight).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        styleTextField(textField: usernameTextField, placeholder: "John Dow")
        usernameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.usernameTextField.becomeFirstResponder()
        })
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingTopAnchor.constant = 40.0
            homeIndicatorHeight = 0.0
        case .iPhone8:
            homeIndicatorHeight = 0.0
        case .iPhone8Plus:
            homeIndicatorHeight = 0.0
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
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        continueButton.frame.origin.y = view.frame.height - keyboardRect.height - 45
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func styleTextField(textField: UITextField, placeholder: String) {
        textField.backgroundColor = CustomStyle.sixthShade
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: CustomStyle.fithShade])
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = UITextField.BorderStyle.none
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.layer.cornerRadius = 6.0
        textField.layer.masksToBounds = true
        textField.setLeftPadding(20)
    }
    
    @objc func continueButtonPress() {
        usernameTextField.resignFirstResponder()
        
        DispatchQueue.main.async {
            self.continueButton.frame.origin.y = self.view.frame.height - (self.continueButton.frame.height + self.homeIndicatorHeight)
        }
        if let categoryController = UIStoryboard(name: "OnboardingListener", bundle: nil).instantiateViewController(withIdentifier: "categoryController") as? ListenerCategoriesController {
            navigationController?.pushViewController(categoryController, animated: true)
        }
    }
    
    @IBAction func backButtonPress(_ sender: Any) {
        usernameTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
}




