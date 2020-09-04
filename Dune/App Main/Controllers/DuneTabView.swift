//
//  DuneTabView.swift
//  Dune
//
//  Created by Waylan Sands on 4/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class DuneTabView: UIView {
    
    let firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("FIRST", for: .normal)
//        button.addTarget(self, action:#selector(visitFirst), for: .touchUpInside)
        return button
    }()
    
    let secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Second", for: .normal)
//        button.addTarget(self, action:#selector(visitSecond), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
        
        self.addSubview(firstButton)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        firstButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        firstButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.addSubview(secondButton)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        secondButton.leadingAnchor.constraint(equalTo: firstButton.trailingAnchor, constant: 25).isActive = true
        secondButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    


}
