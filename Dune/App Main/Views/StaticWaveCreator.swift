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
    
    var playbackCoverLeading: NSLayoutConstraint!
    var trailingPlayAnchor: NSLayoutConstraint!
    
    lazy var presetWaves = [primaryPlayBackBars, trimPlayBackBars]
    
    let primaryPlayBackBars: StaticAudioWave = {
        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
    let trimPlayBackBars: StaticAudioWave = {
        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 100)
        view.backgroundColor = CustomStyle.onBoardingBlack
        return view
    }()
    
//    let playBackBarsOne: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
//    let playBackBarsTwo: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
//    let playBackBarsThree: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
//    let playBackBarsFour: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
//    let playBackBarsFive: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
//    let playBackBarsSix: StaticAudioWave = {
//        let view = StaticAudioWave(color: CustomStyle.primaryBlue, height: 400)
//        view.backgroundColor = CustomStyle.onboardingBlack
//        return view
//    }()
//
    
    let playbackCover: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.onBoardingBlack.withAlphaComponent(0.45)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CustomStyle.onBoardingBlack
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureViews() {
        self.addSubview(primaryPlayBackBars)
        primaryPlayBackBars.translatesAutoresizingMaskIntoConstraints = false
        primaryPlayBackBars.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        primaryPlayBackBars.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        primaryPlayBackBars.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        primaryPlayBackBars.heightAnchor.constraint(equalToConstant: 200).isActive = true
     
        self.addSubview(trimPlayBackBars)
        trimPlayBackBars.translatesAutoresizingMaskIntoConstraints = false
        trimPlayBackBars.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trimPlayBackBars.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        trimPlayBackBars.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        trimPlayBackBars.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
//        self.addSubview(playBackBarsOne)
//        playBackBarsOne.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsOne.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsOne.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsOne.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsOne.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        self.addSubview(playBackBarsTwo)
//        playBackBarsTwo.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsTwo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsTwo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsTwo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsTwo.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        self.addSubview(playBackBarsThree)
//        playBackBarsThree.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsThree.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsThree.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsThree.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsThree.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        self.addSubview(playBackBarsFour)
//        playBackBarsFour.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsFour.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsFour.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsFour.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsFour.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        self.addSubview(playBackBarsFive)
//        playBackBarsFive.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsFive.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsFive.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsFive.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsFive.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//        self.addSubview(playBackBarsSix)
//        playBackBarsSix.translatesAutoresizingMaskIntoConstraints = false
//        playBackBarsSix.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        playBackBarsSix.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        playBackBarsSix.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        playBackBarsSix.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
        self.addSubview(playbackCover)
        playbackCover.translatesAutoresizingMaskIntoConstraints = false
        playbackCover.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
       
        playbackCoverLeading = playbackCover.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
        playbackCoverLeading.isActive = true
        
        trailingPlayAnchor = playbackCover.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        trailingPlayAnchor.priority = UILayoutPriority(rawValue: 750)
        trailingPlayAnchor.isActive = true
        
        playbackCover.heightAnchor.constraint(equalToConstant: 200).isActive = true

    }
    
    func setupPlaybackBars(url: URL, snapshot: Double) {
        
        print("Setting up playback bars with \(url)")
        primaryPlayBackBars.timeInSeconds = snapshot
        trimPlayBackBars.timeInSeconds = snapshot
//        playBackBarsOne.timeInSeconds = snapshot
//        playBackBarsThree.timeInSeconds = snapshot
//        playBackBarsFour.timeInSeconds = snapshot
//        playBackBarsFive.timeInSeconds = snapshot
//        playBackBarsSix.timeInSeconds = snapshot
//        playBackBarsTwo.timeInSeconds = snapshot
//
        primaryPlayBackBars.reDrawBars(url : url, color: CustomStyle.primaryBlue, height: 400.0)
        trimPlayBackBars.reDrawBars(url : url, color: .white, height: 100.0)
//        playBackBarsOne.reDrawBars(url : url, color: hexStringToUIColor(hex: "#27A6E0"), height: 400.0)
//        playBackBarsTwo.reDrawBars(url : url, color: hexStringToUIColor(hex: "#AACC55"), height: 400.0)
//        playBackBarsThree.reDrawBars(url : url, color: hexStringToUIColor(hex: "#FF6D6D"), height: 400.0)
//        playBackBarsFour.reDrawBars(url : url, color: hexStringToUIColor(hex: "#FFBA3F"), height: 400.0)
//        playBackBarsFive.reDrawBars(url : url, color: hexStringToUIColor(hex: "#8067FF"), height: 400.0)
//        playBackBarsSix.reDrawBars(url : url, color: hexStringToUIColor(hex: "#35C396"), height: 400.0)
        
        primaryPlayBackBars.setNeedsDisplay()
        trimPlayBackBars.setNeedsDisplay()
//        playBackBarsOne.setNeedsDisplay()
//        playBackBarsTwo.setNeedsDisplay()
//        playBackBarsThree.setNeedsDisplay()
//        playBackBarsFour.setNeedsDisplay()
//        playBackBarsFive.setNeedsDisplay()
//        playBackBarsSix.setNeedsDisplay()
    }
    
    func showTrimWave() {
        trimPlayBackBars.isHidden = false
        primaryPlayBackBars.isHidden = true
//        playBackBarsOne.isHidden = true
//        playBackBarsThree.isHidden = true
//        playBackBarsFour.isHidden = true
//        playBackBarsFive.isHidden = true
//        playBackBarsSix.isHidden = true
//        playBackBarsTwo.isHidden = true
    }
    
    func resetPrimaryWave() {
        trimPlayBackBars.isHidden = true
        primaryPlayBackBars.isHidden = false
//        playBackBarsOne.isHidden = true
//        playBackBarsThree.isHidden = true
//        playBackBarsFour.isHidden = true
//        playBackBarsFive.isHidden = true
//        playBackBarsSix.isHidden = true
//        playBackBarsTwo.isHidden = true
    }
    
}
