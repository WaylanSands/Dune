//
//  ExtendedButton.swift
//  Dune
//
//  Created by Waylan Sands on 20/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class ExtendedButton: UIButton {
   
    var padding = CGFloat(0)
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
}

extension UIButton{
    
    func roundCorners(corners: UIRectCorner, radius: Int) {
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: corners,
                                     cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
