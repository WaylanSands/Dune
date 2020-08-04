//
//  UINavigationController+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 30/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UINavigationController {
    
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
    
}
