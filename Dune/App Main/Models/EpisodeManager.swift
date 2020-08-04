//
//  DuneAudioPlayer.swift
//  Dune
//
//  Created by Waylan Sands on 21/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

struct EpisodeManager {
    
    static var currentState: playerStatus = .ready
    static var downloadedEpisodes = [Episode]()
    static var currentEpisode: Episode!
    static var currentAudioID: String?
    static var loadingAudioID: String?
    static var itemCount = 0
    static var index = 0
    static var yPosition: CGFloat = 0
    
    static var isOutOfPosition = true
    
    static var likedEpisode = false
    static var episodeIndex: Int!
    static var episodeID: String!
    static var image: UIImage!
    
    static var scrubbedTime: Double = 0
    static var sliderStatus: sliderStatus = .unchanged
    
}
