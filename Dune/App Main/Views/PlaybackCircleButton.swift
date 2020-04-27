//
//  PlaybackCircleButton.swift
//  Dune
//
//  Created by Waylan Sands on 11/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation


class PlaybackCircleButton: UIView {
    
    let shapeLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

    lazy var viewCenter = CGPoint(x:30, y: 30)
    
    func setupLoadingAnimation() {
        let circularPath = UIBezierPath(arcCenter: viewCenter, radius: 30, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        let underPath = UIBezierPath(arcCenter: viewCenter, radius: 30, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        self.isHidden = true
        
        tracklayer.path = underPath.cgPath
        tracklayer.lineWidth = 4
        tracklayer.lineCap = .round
        tracklayer.fillColor = UIColor.white.withAlphaComponent(0.1).cgColor
        
        self.layer.addSublayer(tracklayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = CustomStyle.primaryRed.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func updateCircleProgressWith(value: CGFloat) {
        self.isHidden = false
        shapeLayer.strokeEnd = value
    }
    
}

