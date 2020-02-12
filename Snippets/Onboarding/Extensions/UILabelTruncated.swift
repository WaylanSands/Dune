//
//  UILabelTruncated.swift
//  Snippets
//
//  Created by Waylan Sands on 11/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    var isTruncated: Bool {

        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: self.intrinsicContentSize.height),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
}

extension String {

func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return boundingBox.height
}
}


