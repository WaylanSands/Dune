//
//  UILabel+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 3/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func lineCount() -> Int {
        let myText = self.text! as NSString
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / self.font!.lineHeight))
    }
    
    func addlineSpacing(spacingValue: CGFloat = 2) {

        guard let textString = text else { return }
       
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = spacingValue

        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        attributedText = attributedString
    }
    
      func addCharacterSpacing(kernValue: Double) {
        if let labelText = text, labelText.count > 0 {
          let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
          attributedText = attributedString
        }
      }
    
}
