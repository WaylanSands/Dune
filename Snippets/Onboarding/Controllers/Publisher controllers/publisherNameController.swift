//
//  publisherNameController.swift
//  Snippets
//
//  Created by Waylan Sands on 19/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

enum publisherAccountType {
    case channel
    case program
}

class publisherNameController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var maxCharactersLabel: UILabel!
    @IBOutlet weak var headingLabelTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var backButtonTopAnchor: NSLayoutConstraint!
    
    let deviceType = UIDevice.current.deviceType
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.frame = self.view.bounds
        return view
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = CustomStyle.primaryRed
        button.layer.cornerRadius = 20.0
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        button.addTarget(self, action: #selector(continueButtonPress), for: .touchUpInside)
        return button
    }()
    
    var publisherAccountType: publisherAccountType?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleForScreens()
        setupButtonContainer()
        styleTextField(textField: nameTextField, placeholder: "")
        setHeadline()
        nameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.nameTextField.becomeFirstResponder()
        })
    }
    
    func setupButtonContainer() {
        view.addSubview(containerView)
        view.sendSubviewToBack(containerView)
        containerView.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.topAnchor.constraint(equalTo: maxCharactersLabel.bottomAnchor, constant: 20.0).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    func styleForScreens() {
        switch deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            backButtonTopAnchor.constant = 10.0
            headingLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
            headingLabelTopAnchor.constant = 40.0
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
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        continueButton.frame.origin.y = view.frame.height - keyboardRect.height - 50
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func styleTextField(textField: UITextField, placeholder: String) {
        textField.backgroundColor = CustomStyle.sixthShade
        textField.attributedPlaceholder = NSAttributedString(string: "\(placeholder)", attributes: [NSAttributedString.Key.foregroundColor: CustomStyle.fithShade])
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
    
    func setHeadline() {
        switch publisherAccountType {
        case .channel:
            headingLabel.text = """
            What's the name of
            this channel?
            """
        case .program:
            headingLabel.text = """
            What's the name of
            this program?
            """
        default:
            break
        }
    }
    
    @IBAction func backButtonPress(_ sender: Any) {
        nameTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func continueButtonPress() {
        nameTextField.resignFirstResponder()
        if let ImageController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as? publisherImageController {
            navigationController?.pushViewController(ImageController, animated: true)
        }
    }
    
}
