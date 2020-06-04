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
    
}
