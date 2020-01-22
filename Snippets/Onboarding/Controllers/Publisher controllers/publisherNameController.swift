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
    @IBOutlet weak var continueButton: UIButton!
    
    var publisherAccountType: publisherAccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextField(textField: nameTextField, placeholder: "")
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)
        setHeadline()
        nameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.nameTextField.becomeFirstResponder()
        })
    }
    
    @objc func keyboardWillChange(notification : Notification) {
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        continueButton.frame.origin.y = view.frame.height - keyboardRect.height - 60
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
    
    @IBAction func continueButtonPress() {
        nameTextField.resignFirstResponder()
        if let ImageController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as? publisherImageController {
            navigationController?.pushViewController(ImageController, animated: true)
        }
    }
    
}