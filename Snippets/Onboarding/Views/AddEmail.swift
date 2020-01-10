//
//  CreatePasswordView.swift
//  Snippets
//
//  Created by Waylan Sands on 9/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation


import UIKit

class AddEmail: UIView {
    
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    func setupView() {
        backgroundColor = .blue
        
        let headingLabel = CustomStyle.styleSignupHeading(view: self, title: "Add your email address")
        
        addSubview(headingLabel)
    }
    
    func remove(_: Bool) {
        self.removeFromSuperview()
    }
    
    func transitionIn() {
        UIView.transition(with: self, duration: 0.5, options: [], animations: {self.frame.origin.x = (self.superview?.frame.origin.x)!}, completion: {(value: Bool) in
        })
    }
    
    
}
