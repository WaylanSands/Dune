//
//  UIStackView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 16/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UIStackView {

    public func removeArranged(subview: UIView) {
        removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }

    public func removeAllArrangedSubviews() {
        for subview in arrangedSubviews {
            removeArrangedSubviewCompletely(subview)
        }
    }
}
