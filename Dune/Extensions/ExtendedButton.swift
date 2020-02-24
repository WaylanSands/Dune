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
    // default value
    // you can change clickable area dynamically by setting this value.
    var padding = CGFloat(0)
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let extendedBounds = bounds.insetBy(dx: -padding, dy: -padding)
        return extendedBounds.contains(point)
    }
}
