//
//  UIBarButtonItem+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 14/8/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static func itemWith(image: UIImage?, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.addTarget(target, action: action, for: .touchUpInside)

        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}
