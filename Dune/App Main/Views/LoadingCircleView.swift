//
//  LoadingCircleView.swift
//  Dune
//
//  Created by Waylan Sands on 11/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation


class LoadingCircleView: PassThoughView {
    
    let shapeLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

    lazy var viewCenter = CGPoint(x:35, y: 35)
    
    
    func setupLoadingAnimation() {
        let circularPath = UIBezierPath(arcCenter: viewCenter, radius: 35, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        let underPath = UIBezierPath(arcCenter: viewCenter, radius: 38, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        self.isHidden = true
        
        tracklayer.path = underPath.cgPath
        tracklayer.lineWidth = 6
//        tracklayer.strokeEnd = 0
        tracklayer.lineCap = .round
        tracklayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        self.layer.addSublayer(tracklayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = CustomStyle.white.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func animate() {
        self.isHidden = false
        basicAnimation.toValue = 1
        basicAnimation.duration = 60
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
      func terminate() {
        self.layer.removeAllAnimations()
        self.isHidden = true
    }
    
    
}
