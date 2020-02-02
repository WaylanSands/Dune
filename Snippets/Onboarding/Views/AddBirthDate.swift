//
//  AddBirthDate.swift
//  Snippets
//
//  Created by Waylan Sands on 12/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AddBirthDate: UIView {
    
    var nextButtonDelegate: NextButtonDelegate!
    
    lazy var headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Add your date of birth")
    lazy var subHeadingLabel = CustomStyle.styleSignupSubheading(view: self, title: "This won’t be part of your public profile.")
    lazy var dateTextField = CustomStyle.styleSignUpTextField(color: CustomStyle.secondShade, view: self, placeholder: "")
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    //common func to init our view
    func setupView() {
        addSubview(dateTextField)
        addSubview(headingLabel)
        addSubview(subHeadingLabel)
        
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            headingLabel.centerYAnchor.constraint(equalTo: self.topAnchor, constant:30.0),
            subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10.0),
            subHeadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dateTextField.bottomAnchor.constraint(equalTo:self.bottomAnchor, constant: -10.0),
            dateTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            dateTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0),
            dateTextField.heightAnchor.constraint(equalToConstant: 40),
            ])
        
        dateTextField.delegate = self
    }
}

extension AddBirthDate: UITextFieldDelegate {
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//      return false
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//    }
}
