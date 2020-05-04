//
//  AudioTrimmerView.swift
//  Dune
//
//  Created by Waylan Sands on 21/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import MultiSlider
import UIKit

protocol TrimmerDelegate {
     func trimmerChangedValue()
}

class AudioTrimmerView: UIView {
    
    var trimmerLeftConstraint: NSLayoutConstraint!
    var trimmerRightConstraint: NSLayoutConstraint!
    var maxValue: Float = Float(UIScreen.main.bounds.width) - Float(60)
    var trimmerDelegate: TrimmerDelegate!

    
    lazy var doubleSlider: MultiSlider = {
        let slider = MultiSlider()
        let max = CGFloat(maxValue)
        slider.minimumValue = 0.0
        slider.maximumValue = max
        slider.value = [0.0, max]
        slider.tintColor = .clear
        slider.trackWidth = 32
        slider.hasRoundTrackEnds = true
        slider.outerTrackColor = .clear
        slider.orientation  = .horizontal
        slider.thumbImage = UIImage(named: "empty-thumb-image")
        slider.addTarget(self, action: #selector(trimmerChangedValue), for: .valueChanged) // continuous
        return slider
    }()
    
    let trimmer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        view.layer.borderColor = UIColor.white.cgColor
//        view.layer.borderWidth = 2
//        view.layer.cornerRadius = 10
//        view.clipsToBounds = true
        return view
    }()
    
    
    let leftHandleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        return view
    }()
    
    let rightHandleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage()
        return view
    }()
    
    let leftWaveCoverView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    let rightWaveCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    let leftHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let rightHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        
        self.addSubview(trimmer)
        trimmer.translatesAutoresizingMaskIntoConstraints = false
        trimmer.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        trimmerLeftConstraint = trimmer.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        trimmerRightConstraint = trimmer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        trimmer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        trimmerLeftConstraint.isActive = true
        trimmerRightConstraint.isActive = true
        
        self.addSubview(doubleSlider)
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        doubleSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        doubleSlider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        doubleSlider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(leftHandleView)
        leftHandleView.translatesAutoresizingMaskIntoConstraints = false
        leftHandleView.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor).isActive = true
        leftHandleView.centerXAnchor.constraint(equalTo: trimmer.leadingAnchor, constant: 9).isActive = true
        
        self.addSubview(rightHandleView)
        rightHandleView.translatesAutoresizingMaskIntoConstraints = false
        rightHandleView.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor).isActive = true
        rightHandleView.centerXAnchor.constraint(equalTo: trimmer.trailingAnchor, constant: -9).isActive = true
        
        self.addSubview(leftWaveCoverView)
        leftWaveCoverView.translatesAutoresizingMaskIntoConstraints = false
        leftWaveCoverView.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor).isActive = true
        leftWaveCoverView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        leftWaveCoverView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftWaveCoverView.trailingAnchor.constraint(equalTo: trimmer.leadingAnchor).isActive = true
        
        self.addSubview(rightWaveCoverView)
        rightWaveCoverView.translatesAutoresizingMaskIntoConstraints = false
        rightWaveCoverView.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor).isActive = true
        rightWaveCoverView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        rightWaveCoverView.leadingAnchor.constraint(equalTo: trimmer.trailingAnchor).isActive = true
        rightWaveCoverView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.addSubview(leftHandLabel)
        leftHandLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHandLabel.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor, constant: 50).isActive = true
        leftHandLabel.centerXAnchor.constraint(equalTo: trimmer.leadingAnchor, constant: 9).isActive = true
        
        self.addSubview(rightHandLabel)
        rightHandLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHandLabel.centerYAnchor.constraint(equalTo: doubleSlider.centerYAnchor, constant: 50).isActive = true
        rightHandLabel.centerXAnchor.constraint(equalTo: trimmer.trailingAnchor, constant: -9).isActive = true
    }
    
   @objc func trimmerChangedValue() {
    trimmerLeftConstraint.constant =  doubleSlider.value.first!
    trimmerRightConstraint.constant = doubleSlider.value.last! - CGFloat(maxValue)
    trimmerDelegate.trimmerChangedValue()
    }
    
    func resetTrimmer() {
        doubleSlider.value = [0.0,CGFloat(maxValue)]
        trimmerLeftConstraint.constant =  0
        trimmerRightConstraint.constant =  0
    }
    
}
