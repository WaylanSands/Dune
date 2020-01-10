//
//  CustomStyle.swift
//  Snippets
//
//  Created by Waylan Sands on 10/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class CustomStyle {
    
    static let primaryRed = UIColor(#colorLiteral(red: 1, green: 0, blue: 0.6098213792, alpha: 1))
    static let primaryBlue = UIColor(#colorLiteral(red: 0.3184746802, green: 0.5403701067, blue: 1, alpha: 1))
    static let secondShade = UIColor(#colorLiteral(red: 0.9401001334, green: 0.9566956162, blue: 0.9783065915, alpha: 1))
    static let thirdShade = UIColor(#colorLiteral(red: 0.8588235294, green: 0.8823529412, blue: 0.9294117647, alpha: 1))
    static let fourthShade = UIColor(#colorLiteral(red: 0.7054654956, green: 0.7398003936, blue: 0.8311805129, alpha: 1))
    static let fithShade = UIColor(#colorLiteral(red: 0.3058823529, green: 0.3294117647, blue: 0.3803921569, alpha: 1))
    static let sixthShade = UIColor(#colorLiteral(red: 0.1529411765, green: 0.168627451, blue: 0.2, alpha: 1))
    static let seventhShade = UIColor(#colorLiteral(red: 0.1176470588, green: 0.1294117647, blue: 0.1568627451, alpha: 1))
    static let primaryblack = UIColor(#colorLiteral(red: 0.1129432991, green: 0.1129470244, blue: 0.1129450426, alpha: 1))
    
    // MARK: Onbording
    
    static func styleRoundedSignUpButton(color: UIColor, image: UIImage ,button: UIButton) {
        button.backgroundColor = color
        button.layer.cornerRadius = 20.0
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    // Onbording text style
    
    static func styleSignupHeading(view: UIView, title: String) -> UILabel {
        let label = UILabel()
        
        let font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.primaryblack,
        ]
        
        label.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 32)
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return label
    }
    
    static func styleSignupSubheading(view: UIView, title: String) -> UILabel {
        let label = UILabel()
        
        let font = UIFont.systemFont(ofSize: 14, weight: .regular)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: self.fourthShade,
        ]
        
        label.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: 32)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        
        return label
    }
    
}
