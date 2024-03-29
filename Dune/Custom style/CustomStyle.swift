//
//  CustomStyle.swift
//  Snippets
//
//  Created by Waylan Sands on 10/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CustomStyle {
    
    static let blackNavBar = UIColor.black.withAlphaComponent(0.9)
    static let subTextColor = hexStringToUIColor(hex: "8188A0")
    static let primaryBlue = UIColor(#colorLiteral(red: 0.1098039216, green: 0, blue: 1, alpha: 1))
    static let linkBlue = UIColor(#colorLiteral(red: 0.2235294118, green: 0.368627451, blue: 0.8, alpha: 1))
    static let buttonBlue = UIColor(#colorLiteral(red: 0.2823529412, green: 0.4588235294, blue: 1, alpha: 1))
    static let primaryYellow = UIColor(#colorLiteral(red: 0.9960784314, green: 1, blue: 0, alpha: 1))
    static let primaryRed = UIColor(#colorLiteral(red: 1, green: 0, blue: 0.2862745098, alpha: 1))
    static let warningRed = UIColor(#colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1))
    static let accountButtonGrey = UIColor(#colorLiteral(red: 0.9294117647, green: 0.937254902, blue: 0.9764705882, alpha: 1))
    static let white = UIColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let whiteCg = CGColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    static let secondShade = UIColor(#colorLiteral(red: 0.9401001334, green: 0.9566956162, blue: 0.9783065915, alpha: 1))
    static let thirdShade = UIColor(#colorLiteral(red: 0.8588235294, green: 0.8823529412, blue: 0.9294117647, alpha: 1))
    static let fourthShade = UIColor(#colorLiteral(red: 0.7054654956, green: 0.7398003936, blue: 0.8311805129, alpha: 1))
    static let fifthShade = UIColor(#colorLiteral(red: 0.3058823529, green: 0.3294117647, blue: 0.3803921569, alpha: 1))
    static let sixthShade = UIColor(#colorLiteral(red: 0.1529411765, green: 0.168627451, blue: 0.2, alpha: 1))
    static let seventhShade = UIColor(#colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1))
    static let primaryBlack = UIColor(#colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1))
    static let onBoardingBlack = UIColor(#colorLiteral(red: 0.09019607843, green: 0.09803921569, blue: 0.1098039216, alpha: 1))
    static let darkestBlack = UIColor(#colorLiteral(red: 0.06274509804, green: 0.07058823529, blue: 0.07843137255, alpha: 1))
    static let snapColor = UIColor(#colorLiteral(red: 1, green: 0.9882352941, blue: 0, alpha: 1))

    
    // Onboarding
    
    static func styleRoundedSignUpButton(color: UIColor, image: UIImage? ,button: UIButton) {
        button.backgroundColor = color
        button.layer.cornerRadius = 20.0
        if image != nil {
            button.setImage(image, for: .normal)
            button.imageView?.image?.withRenderingMode(.alwaysOriginal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
    }
    
    static func styleRoundedPublishserpButton(borderColor: CGColor, backgroundColor: UIColor, image: UIImage? ,button: UIButton) {
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor
        button.layer.cornerRadius = 20.0
        button.layer.borderWidth = 1
        if image != nil {
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
    }
    
    static func styleCategoryButtons(color: UIColor ,button: UIButton) {
        button.backgroundColor = color
        button.layer.cornerRadius = 20.0
        button.setTitleColor(CustomStyle.fifthShade, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
     }
    
    static func categoryButtonSelected(backgroundColor: UIColor ,textColor: UIColor ,button: UIButton) {
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 20.0
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        button.setTitleColor(textColor, for: .normal)
     }
    
    static func styleRoundedTagLabel(label: UILabel) -> UILabel {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = CustomStyle.secondShade
        label.layer.cornerRadius = 10.5
        label.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        return label
    }
    
    // Onboarding text style
    
    static func styleSignupHeading(view: UIView, title: String) -> UILabel {
        let label = UILabel()
        
        let font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.primaryBlack,
        ]
        
        label.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return label
    }
    
    static func styleSignupHeadingLeftAlign(view: UIView, title: String) -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 26.0, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.white,
        ]
        label.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 70)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return label
    }
    
    static func styleSignupSubHeadingLeftAlign(size: CGFloat, view: UIView, title: String) -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: size, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.white,
        ]
        label.frame = CGRect(x: 16, y: 0, width: view.frame.width - 32, height: 35)
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return label
    }
    
    static func styleSignupSubheading(view: UIView) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = self.fourthShade
//        let attributes: [NSAttributedString.Key: Any] = [
//            .font: font,
//            .foregroundColor: self.fourthShade,
//        ]
//
//        label.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 32)
//        label.textAlignment = .center
//        label.numberOfLines = 0
//        label.attributedText = NSAttributedString(string: title, attributes: attributes)
//
        return label
    }
    
    static func styleProgramName() -> UILabel {
        let label = UILabel()
        
        let font = UIFont.systemFont(ofSize: 24, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.fourthShade,
        ]
        label.textAlignment = .left
        label.numberOfLines = 1
        label.attributedText = NSAttributedString(string: "", attributes: attributes)

        return label
    }
    
    static func styleSignUpTextField(color: UIColor, view: UIView, placeholder: String) -> UITextField {
        let textField =  UITextField(frame: CGRect(x: 0, y: 30, width: view.frame.width, height: 40))
        textField.placeholder = placeholder
        textField.backgroundColor = color
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
        return textField
    }
    
    // App Flow
    
    static func styleFloatingButton(button: UIButton) {
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.layer.cornerRadius = 7.0
        button.layer.borderWidth = 1.0
        button.layer.backgroundColor = .none
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    // NavBar
    
    static let barButtonItemFont  = UIFont.systemFont(ofSize: 16, weight: .semibold)
    static let navbarFont  = UIFont.systemFont(ofSize: 16, weight: .semibold)

    static let barButtonAttributes: [NSAttributedString.Key: AnyObject] = [
         NSAttributedString.Key.font: barButtonItemFont,
         NSAttributedString.Key.foregroundColor: UIColor.white
         ]
    
    static let whiteNavbarAttributes: [NSAttributedString.Key: AnyObject] = [
         NSAttributedString.Key.font: navbarFont,
         NSAttributedString.Key.foregroundColor: UIColor.white
         ]
    
    static let blackNavBarAttributes: [NSAttributedString.Key: AnyObject] = [
         NSAttributedString.Key.font: navbarFont,
         NSAttributedString.Key.foregroundColor: CustomStyle.primaryBlack
         ]
    
    // Caption text
    static let captionFont  = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let captionDraftFont  = UIFont.systemFont(ofSize: 15, weight: .regular)

    
    static func createCaptionWith(text: String, textView: UITextView) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes = [
            NSAttributedString.Key.paragraphStyle : style,
            NSAttributedString.Key.font: captionFont,
            NSAttributedString.Key.foregroundColor: CustomStyle.sixthShade
        ]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    static func createDraftCaptionWith(text: String, textView: UITextView) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        let attributes = [
            NSAttributedString.Key.paragraphStyle : style,
            NSAttributedString.Key.font: captionDraftFont,
            NSAttributedString.Key.foregroundColor: CustomStyle.white
        ]
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
}
