//
//  UISearchBar+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 19/10/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


extension UISearchBar {
    func setSearchTextField(height: CGFloat, radius: CGFloat = 8.0) {
        let image = UIImage.getImageWithColor(color: UIColor.clear, size: CGSize(width: 1, height: height))
        setSearchFieldBackgroundImage(image, for: .normal)
        
        for subview in self.subviews {
            for subSubViews in subview.subviews {
                if #available(iOS 13.0, *) {
                    for child in subSubViews.subviews {
                        if let textField = child as? UISearchTextField {
                            textField.layer.cornerRadius = radius
                            textField.clipsToBounds = true
                        }
                    }
                } else {
                    if let textField = subSubViews as? UITextField {
                        textField.layer.cornerRadius = radius
                        textField.clipsToBounds = true
                    }
                }
            }
        }
    }
}
