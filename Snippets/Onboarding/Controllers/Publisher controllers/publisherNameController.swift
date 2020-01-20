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

class publisherNameController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    
    var publisherAccountType: publisherAccountType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTextField(textField: nameTextField, placeholder: "")
        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: nil, button: continueButton)
        setHeadline()
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
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPress() {
        if let ImageController = UIStoryboard(name: "OnboardingPublisher", bundle: nil).instantiateViewController(withIdentifier: "ImageController") as? publisherImageController {
            navigationController?.pushViewController(ImageController, animated: true)
        }
    }
    
}
