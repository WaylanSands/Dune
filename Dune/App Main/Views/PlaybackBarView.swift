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

protocol PlaybackBarDelegate {
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType)
    func updateActiveCell(atIndex: Int, forType: PlayBackType)
}

class PlaybackBarView: UIView {
    
    var playbackBarIsSetup = false
    
    let trackView = UIView()
    let progressView = UIView()
    let startSize = CGRect(x: 0, y: 0, width: 0, height: 4)
    let endSize = CGRect(x: 0, y: 0, width: 50, height: 4)
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
        let percent = percentage * 100
        let width = (50 * percent) / 100
        self.progressView.frame = CGRect(x: 0, y: 0, width: width, height: 4)
    }

}

