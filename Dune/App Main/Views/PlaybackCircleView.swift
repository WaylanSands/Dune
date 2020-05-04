//
//  PlaybackCircleButton.swift
//  Dune
//
//  Created by Waylan Sands on 11/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation


class PlaybackCircleView: UIView {
    
    let shapeLayer = CAShapeLayer()
    let tracklayer = CAShapeLayer()
    let viewCenter = CGPoint(x:20, y: 20)
    
    func setupPlaybackCircle() {
        
        let circularPath = UIBezierPath(arcCenter: viewCenter, radius: 20, startAngle: -CGFloat.pi / 2 , endAngle: CGFloat.pi * 2, clockwise: true)
        
        tracklayer.path = circularPath.cgPath
        tracklayer.strokeColor = UIColor.white.withAlphaComponent(0.2).cgColor
        tracklayer.lineWidth = 2.7
        tracklayer.strokeEnd = 1
        tracklayer.lineCap = .round
        tracklayer.fillColor = UIColor.clear.cgColor
        
        self.layer.addSublayer(tracklayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2.7
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func updateCircleProgressWith(value: CGFloat) {
        shapeLayer.strokeEnd = value
        print("This is the value: \(value)")
    }
    
}

