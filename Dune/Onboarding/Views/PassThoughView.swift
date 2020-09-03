//
//  PassThoughView.swift
//  Snippets
//
//  Created by Waylan Sands on 5/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class PassThoughView: UIView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


