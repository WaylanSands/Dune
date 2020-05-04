//
//  AccountButton.swift
//  Dune
//
//  Created by Waylan Sands on 6/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AccountButton: UIButton {
    
    required init() {
        super.init(frame: .zero)
        self.setTitleColor(CustomStyle.primaryBlack, for: .normal)
        self.setTitleColor(CustomStyle.primaryBlack.withAlphaComponent(0.8), for: .highlighted)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.backgroundColor = CustomStyle.accountButtonGrey
        self.layer.cornerRadius = 6
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet{
            self.imageView?.alpha = isHighlighted ? 0.8 : 1
        }
    }
    
}
