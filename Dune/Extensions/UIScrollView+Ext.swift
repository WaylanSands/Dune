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
    
    func setScrollBarToBottom() {
        if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
        self.setContentOffset(bottomOffset, animated: true)
    }
    
    func setScrollViewToTop() {
        let bottomOffset = CGPoint(x: 0, y: -UIDevice.current.navBarHeight())
        self.setContentOffset(bottomOffset, animated: true)
    }
    
    func setScrollBarToTopLeftAnimated() {
        
        var offset = CGPoint(
            x: -self.contentInset.left,
            y: -self.contentInset.top)
        
        if #available(iOS 11.0, *) {
            offset = CGPoint(
                x: -self.adjustedContentInset.left,
                y: -self.adjustedContentInset.top)
        }
        
        self.setContentOffset(offset, animated: true)
    }
}
