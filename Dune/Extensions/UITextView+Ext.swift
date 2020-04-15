//
//  UITextView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    func lineCount() -> Int {
        let myText = self.text! as NSString
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / self.font!.lineHeight))
    }
    
    func actualHeight() -> CGFloat {
        return self.font!.lineHeight * CGFloat(self.lineCount())
    }
    
//    func getStringWidth( ) -> CGFloat {
//
//        var fontWeight: UIFont.Weight
//
//        switch self.font?.fontName {
//        case ".SFUI-Black": fontWeight = UIFont.Weight.black
//        case ".SFUI-Bold": fontWeight = UIFont.Weight.bold
//        case ".SFUI-Heavy": fontWeight = UIFont.Weight.heavy
//        case ".SFUI-Light": fontWeight = UIFont.Weight.light
//        case ".SFUI-Medium": fontWeight = UIFont.Weight.medium
//        case ".SFUI-Regular": fontWeight = UIFont.Weight.regular
//        case ".SFUI-Semibold": fontWeight = UIFont.Weight.semibold
//        case ".SFUI-Thin": fontWeight = UIFont.Weight.thin
//        case ".SFUI-UltraLight": fontWeight = UIFont.Weight.ultraLight
//        default: fatalError("Font weight of \(String(describing: self.font?.familyName)) is unknown")
//        }
//
//        let labelSize: CGSize = self.text!.size(withAttributes: [.font: UIFont.systemFont(ofSize: self.font!.pointSize, weight: fontWeight)])
//        return labelSize.width
//    }
    
}
