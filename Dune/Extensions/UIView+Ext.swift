//
//  UIView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func pinEdges(to superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
    
    func addTopAndSideAnchors(to superView: UIView, top: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.bottomAnchor,constant: top).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailing).isActive = true
    }
    
    
}
