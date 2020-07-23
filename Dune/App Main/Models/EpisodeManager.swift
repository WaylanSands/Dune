////
////  DuneAudioPlayer.swift
////  Dune
////
////  Created by Waylan Sands on 21/7/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class EpisodeManager {
//    
//    var downloadedEpisodes: [Episode] = [] {
//        willSet {
//            index = downloadedEpisodes.count
//        }
//        didSet {
//            if currentState == .fetching {
//                currentState = .ready
//                episode = downloadedEpisodes[index]
//                playOrPauseEpisodeWith(audioID: episode.audioID)
//            }
//        }
//    }
//    
//    func playAudioFrom(url: URL) {
//        animateToPositionIfNeeded()
//        playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
//        playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
//        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        audioPlayer = try! AVAudioPlayer(contentsOf: url)
//        playPauseButton.backgroundColor = .white
//        audioPlayer.delegate = self
//        audioPlayer.volume = 1.0
//        currentState = .playing
//        trackEpisodePlayback()
//        prefetchNextEpisode()
//        audioPlayer.play()
//        setupNowPlaying()
//    }
// 
//}
