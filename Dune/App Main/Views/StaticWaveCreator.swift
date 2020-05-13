//
//  StaticWaveCreator.swift
//  Dune
//
//  Created by Waylan Sands on 23/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class StaticWaveCreator: UIView {
    
//    var playbackCoverLeading: NSLayoutConstraint!
//    var trailingPlayAnchor: NSLayoutConstraint!
    
//    lazy var presetWaves = [primaryPlayBackBars, trimPlayBackBars]
    
//    let primaryPlayBackBars: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = .clear
//        return view
//    }()
    
    let trimPlayBackBars: StaticAudioWave = {
        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 100)
        view.backgroundColor = .clear
        return view
    }()
    
    let playbackCover: UIView = {
        let view = UIView()
        view.backgroundColor = CurrentProgram.image?.averageColor?.withAlphaComponent(0.4)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureViews() {
//        self.addSubview(primaryPlayBackBars)
//        primaryPlayBackBars.translatesAutoresizingMaskIntoConstraints = false
//        primaryPlayBackBars.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        primaryPlayBackBars.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        primaryPlayBackBars.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        primaryPlayBackBars.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
        self.addSubview(trimPlayBackBars)
        trimPlayBackBars.translatesAutoresizingMaskIntoConstraints = false
        trimPlayBackBars.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trimPlayBackBars.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        trimPlayBackBars.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        trimPlayBackBars.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        self.addSubview(playbackCover)
        playbackCover.translatesAutoresizingMaskIntoConstraints = false
        playbackCover.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       
//        playbackCoverLeading = playbackCover.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
//        playbackCoverLeading.isActive = true
//        
//        trailingPlayAnchor = playbackCover.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
//        trailingPlayAnchor.priority = UILayoutPriority(rawValue: 750)
//        trailingPlayAnchor.isActive = true
        
        playbackCover.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupPlaybackBars(url: URL, snapshot: Double) {
        
//        primaryPlayBackBars.timeInSeconds = snapshot
        trimPlayBackBars.timeInSeconds = snapshot

//        primaryPlayBackBars.reDrawBars(url : url, color: CustomStyle.primaryBlue, height: 400.0)
        trimPlayBackBars.reDrawBars(url : url, color: .white, height: 100.0)
        
//        primaryPlayBackBars.setNeedsDisplay()
        trimPlayBackBars.setNeedsDisplay()
    }
    
    func showTrimWave() {
        trimPlayBackBars.isHidden = false
//        primaryPlayBackBars.isHidden = true
    }
//    
//    func resetPrimaryWave() {
//        trimPlayBackBars.isHidden = true
////        primaryPlayBackBars.isHidden = false
//    }
    
}
