//
//  PlaybackBarView.swift
//  Dune
//
//  Created by Waylan Sands on 11/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Foundation

enum PlayBackType {
    case episode
    case program
}

class PlaybackBarView: UIView {
    
    var playbackBarIsSetup = false
    
    let trackView = UIView()
    let progressView = UIView()
    let startSize = CGRect(x: 0, y: 0, width: 0, height: 4)
    lazy var endSize = CGRect(x: 0, y: 0, width: width(), height: 4)
    var animator: UIViewPropertyAnimator!
    
    func setupPlaybackBar() {
        playbackBarIsSetup = true
        trackView.frame = endSize
        trackView.layer.cornerRadius = 2
        trackView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.addSubview(trackView)
        
        progressView.frame = startSize
        progressView.layer.cornerRadius = 2
        progressView.backgroundColor = CustomStyle.primaryBlue
        self.addSubview(progressView)
    }
    
    func progressUpdateWith(percentage: CGFloat) {
        let dynamicWidth = width()
        let percent = percentage * 100
        let width = (dynamicWidth * percent) / 100
        self.progressView.frame = CGRect(x: 0, y: 0, width: width, height: 4)
    }
    
    func setProgressWith(percentage: CGFloat) {
        let dynamicWidth = width()
        let percent = percentage * 100
        let width = (dynamicWidth * percent) / 100
        self.progressView.frame = CGRect(x: 0, y: 0, width: width, height: 4)
    }
    
    func resetPlaybackBar() {
        trackView.backgroundColor = .clear
        progressView.backgroundColor = .clear
        progressView.frame = startSize
        playbackBarIsSetup = false
    }
    
    func width() -> CGFloat {
        if UIDevice.current.deviceType == .iPhoneSE {
            return 40
        } else {
            return 50
        }
    }
    

}

