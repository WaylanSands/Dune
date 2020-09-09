//
//  UITableView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 29/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


extension UITableView {

    func addTopBounceAreaView(color: UIColor = .white) {
        var frame = UIScreen.main.bounds
        frame.origin.y = -frame.size.height

        let view = UIView(frame: frame)
        view.backgroundColor = color

        self.addSubview(view)
    }
    
    var safeDunePlayBarHeight: CGFloat {
        return 64 + duneTabBar.frame.height - UIDevice.safeBottomHeight
    }
}
