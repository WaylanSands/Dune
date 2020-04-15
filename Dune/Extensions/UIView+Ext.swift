//
//  UIView+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    func pinEdges(to superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
    }
    
    func addTopAndSideAnchors(to superView: UIView, top: CGFloat, leading: CGFloat, trailing: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superView.bottomAnchor,constant: top).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: trailing).isActive = true
    }
    
    func navBarHeight(controller: UIViewController) -> CGFloat {
        return controller.navigationController!.navigationBar.frame.height
    }
    // Transition functions
    
//    lazy var screenWidth = self.frame.width
//    lazy var centerXposition = self.frame.origin.x
    
    func toCenter(view: UIView) {
        view.frame.origin.x = self.self.frame.origin.x
    }
    
    func backOffScreen(view: UIView) {
        view.frame.origin.x -= self.frame.width
    }
    
    func forwardOffScreen(view: UIView) {
        view.frame.origin.x += self.frame.width
    }
    
    func transitionToCenter(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.toCenter(view: view)}, completion: {(value: Bool) in
//            self.currentView = view
        })
    }
    
    func transitionBackwards(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations:  {self.backOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    func transitionForward(view: UIView) {
        UIView.transition(with: view, duration: 0.5, options: .curveEaseInOut, animations: {self.forwardOffScreen(view: view)}, completion: {(value: Bool) in
        })
    }
    
    
}
