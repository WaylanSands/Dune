//
//  LoadingCircleView.swift
//  Dune
//
//  Created by Waylan Sands on 11/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation


class LoadingCircleView: UIView {
    
    let shapeLayer = CAShapeLayer()
    lazy var viewCenter = CGPoint(x:15, y: 15)
    
    func setupLoadingAnimation() {
        let circularPath = UIBezierPath(arcCenter: viewCenter, radius: 8, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = CustomStyle.primaryblack.cgColor
        shapeLayer.lineWidth = 2.5
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        //        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //        basicAnimation.toValue = 1
        //
        //        basicAnimation.fillMode = .forwards
        //        basicAnimation.isRemovedOnCompletion = false
        
        //        shapeLayer.add(basicAnimation, forKey: "basic")
    }
}
