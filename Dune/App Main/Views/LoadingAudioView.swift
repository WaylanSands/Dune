//
//  LoadingAudioView.swift
//  Dune
//
//  Created by Waylan Sands on 16/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation

class LoadingAudioView: PassThoughView {
    
    let shapeLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

    var viewCenter = CGPoint(x:20, y: 20)
    var lineWidth: CGFloat = 3
    var radius: CGFloat = 20
    
    func configureLargePlayback() {
        viewCenter = CGPoint(x: 28, y: 28)
        lineWidth = 4
        radius = 28
        
    }
    
    func setupLoadingAnimation() {
        let circularPath = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle:0 , endAngle: CGFloat.pi * 2, clockwise: true)
        self.isHidden = false
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.bounds = circularPath.bounds
        shapeLayer.transform = CATransform3DMakeRotation(CGFloat(-90 * Double.pi/180), 0, 0, 1)
        shapeLayer.strokeColor = CustomStyle.white.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.autoreverses = false
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func animate() {
        self.isHidden = false
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        
        basicAnimation.fillMode = .forwards
        basicAnimation.repeatCount = .infinity
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
    }
    
      func terminate() {
        self.layer.removeAllAnimations()
        self.isHidden = true
    }
    
    
}
