//
//  TagButton.swift
//  Dune
//
//  Created by Waylan Sands on 8/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class TagButton: UIButton {

    required init(title: String) {
         super.init(frame: .zero)
            self.setTitle(title, for: .normal)
            self.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            self.setTitleColor(CustomStyle.fourthShade, for: .normal)
            self.backgroundColor = CustomStyle.secondShade
            self.layer.cornerRadius = 12
        }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
