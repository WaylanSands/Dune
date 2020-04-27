//
//  AudioPresetButton.swift
//  Dune
//
//  Created by Waylan Sands on 23/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class AudioPresetButton: UIButton {
    
    var activeBGColor: UIColor

    required init(backgroundColor: UIColor, title: String) {
        self.activeBGColor = backgroundColor
        super.init(frame: .zero)
        self.backgroundColor = CustomStyle.sixthShade
        self.setTitle(title, for: .normal)
        self.setTitleColor(CustomStyle.fifthShade, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonIsActive() {
        self.backgroundColor = activeBGColor
        self.setTitleColor(.white, for: .normal)
    }
    
    func buttonIsInactive() {
        self.backgroundColor = CustomStyle.sixthShade
        self.setTitleColor(CustomStyle.fifthShade, for: .normal)
    }    

}
