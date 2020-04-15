//
//  UIScrollView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 5/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    
    func setScrollBarToTopLeft() {
        
        var offset = CGPoint(
            x: -self.contentInset.left,
            y: -self.contentInset.top)
        
        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -self.adjustedContentInset.left,
                y: -self.adjustedContentInset.top)
        }
        
        self.setContentOffset(offset, animated: false)
    }
}
