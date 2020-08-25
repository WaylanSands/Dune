//
//  DuneAudioPlayer.swift
//  Dune
//
//  Created by Waylan Sands on 21/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

struct AudioManager {
    
    static var audioSession = AVAudioSession.sharedInstance()
    static var commandCenter = MPRemoteCommandCenter.shared()
    static var audioPlayer: AVAudioPlayer!
    
    static var filteredEpisodeItems = [EpisodeItem]()
    static var activeEpisodeItems = [EpisodeItem]()
    static var episodeItems = [EpisodeItem]()
    static var startingIndex: Int = 0
    static var itemCount = 0
    static var index = 0
    
    static var activeEpisodes = [Episode]()
    static var activeEpisode: Episode!
    static var currentAudioID: String!
    static var loadingAudioID: String!
    
    static var yPosition: CGFloat = 0
    static var activeImage: UIImage!
    static var timeIn: Double = 0
    
    static var isFetching = false
    
    static var episodes: [Episode] = [] {
        willSet { index = episodes.count }
        didSet {
            if currentState == .fetching {
                currentState = .ready
                activeEpisode = episodes[index]
                playOrPauseEpisodeWith(audioID: activeEpisode.audioID)
            }
        }
    }
    
    static var currentState: playerStatus = .ready {
        didSet { if currentState == .ready { deactivateAudioSession() }
        else { configureAudioSession() }
        }
    }
    
    static func deactivateAudioSession() {
        do { try audioSession.setActive(false) }
        catch {
            print("error.")
        }
    }
    
    static func configureAudioSession() {
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setActive(true)
        } catch {
            print("error.")
        }
    }
    
    
    static func fetchItemsWith(with: [String], completion: @escaping (_ noItems: Bool, _ itemsAreNew: Bool) -> ()) {
        AudioDownloadManager.fetchEpisodesItemsWith(with: with) { items in
            
            if items.isEmpty {
                print("Empty")
                completion(true, false)
            } else if items != self.episodeItems {
                itemCount = items.count
                episodeItems = items
                completion(false, true)
            } else {
                completion(false, false)
            }
        }
    }
    
    static func updateActiveAudio() {
        activeEpisodeItems = episodeItems
        activeEpisodes = episodes
    }
    
    static func setActiveAudio() {
        if activeEpisodeItems.count == 0 {
            activeEpisodeItems = episodeItems
            activeEpisodes = episodes
        }
    }
    
    static func fetchEpisodes(completion: @escaping (_ areAvailable: Bool) ->()) {
        if episodes.count != episodeItems.count {
            var endIndex = 10
            if episodeItems.count - episodes.count < endIndex {
                endIndex = episodeItems.count - episodes.count
            }
            endIndex += startingIndex
            var items = Array(episodeItems[startingIndex..<endIndex])
            
            for each in items {
                if episodes.contains(where: {$0.ID == each.id}) {
                    items.removeAll(where: {$0 == each})
                }
            }
            
            startingIndex = episodes.count + items.count
            
            if items.count == 0 {
                return
            }
            
            isFetching = true
            
            AudioDownloadManager.fetchEpisodesWith(episodeItems: items) { episodes in
                if !episodes.isEmpty {
                    self.episodes += episodes
                    self.episodes = self.episodes.sorted(by: >)
                    self.setActiveAudio()
                    isFetching = false
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func fetchFilteredEpisodes() {
        if episodes.count != filteredEpisodeItems.count {
            var endIndex = 10
            
            if filteredEpisodeItems.count - episodes.count < endIndex {
                endIndex = filteredEpisodeItems.count - episodes.count
            }
            endIndex += startingIndex
            
            let items = Array(filteredEpisodeItems[startingIndex..<endIndex])
            startingIndex = episodes.count + items.count
            
            var itemsNeeded = [EpisodeItem]()
            
            for eachItem in items  {
                if let episode = episodes.first(where: {$0.ID == eachItem.id}) {
                    episodes.append(episode)
                } else {
                    itemsNeeded.append(eachItem)
                }
            }
            
            if itemsNeeded.count == 0 {
                episodes = episodes.sorted(by: >)
//                loadingView.isHidden = true
//                tableView.reloadData()
            } else {
                fetchEpisodesWith(items: itemsNeeded)
            }
        }
    }
    
    static func fetchEpisodesWith(items: [EpisodeItem] ) {
        isFetching = true
        FireStoreManager.fetchEpisodesWith(episodeItems: items) { episodes in
            DispatchQueue.main.async {
                if !episodes.isEmpty {
                    self.episodes += episodes
                    self.episodes = self.episodes.sorted(by: >)
                }
            }
        }
    }
    
    static func trackProgress() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "trackProgress"), object: nil, userInfo: nil)
    }
    
    static func pauseDisplayLink() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pauseDisplayLink"), object: nil, userInfo: nil)
    }
    
    static func setupEpisode() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setUpEpisode"), object: nil, userInfo: nil)
    }
    
    
    static func playOrPauseEpisodeWith(audioID: String) {
        
        switch currentState {
        case .ready:
            getAudioWith(audioID: audioID) { url in
                self.playAudioFrom(url: url)
            }
        case .playing:
            if currentAudioID != audioID {
                audioPlayer.pause()
                pauseDisplayLink()
                currentState = .paused
                getAudioWith(audioID: audioID) { url in
                    self.playAudioFrom(url: url)
                }
            } else {
                //                playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
                //                playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
                //                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
                audioPlayer.pause()
                pauseDisplayLink()
                currentState = .paused
            }
        case .paused:
            if currentAudioID == audioID {
                //                playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
                //                playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
                //                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                currentState = .playing
                trackProgress()
                audioPlayer.play()
            } else {
                getAudioWith(audioID: audioID) { url in
                    self.playAudioFrom(url: url)
                }
            }
        case .loading:
            if audioID == loadingAudioID {
                break
            } else {
                AudioDownloadManager.cancelCurrentDownload()
                getAudioWith(audioID: audioID) { url in
                    self.playAudioFrom(url: url)
                }
            }
        case .fetching:
            currentState = .ready
            getAudioWith(audioID: audioID) { url in
                self.playAudioFrom(url: url)
            }
        }
    }
    
    static func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        let documentsURL = FileManager.getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(audioID)
        FireStoreManager.updateListenCountFor(episode: activeEpisode.ID)
        currentAudioID = audioID
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            AudioDownloadManager.downloadEpisodeAudio(audioID: audioID) { url in
                //                self.playPauseButton.backgroundColor = .white
                completion(url)
            }
        }
    }
    
    
    static func playAudioFrom(url: URL) {
        //        animateToPositionIfNeeded()
        //        playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
        //        playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
        //        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        //        playPauseButton.backgroundColor = .white
        //        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        currentState = .playing
        trackProgress()
        prefetchNextEpisode()
        audioPlayer.play()
        setupNowPlaying()
    }
    
    static func prefetchNextEpisode() {
        guard let index = activeEpisodes.firstIndex(where: { $0.ID == activeEpisode.ID }) else { return }
        if (activeEpisodes.count - 1) > index {
            let documentsURL = FileManager.getDocumentsDirectory()
            let episode = activeEpisodes[index + 1]
            let fileURL = documentsURL.appendingPathComponent(episode.audioID)
            if FileManager.default.fileExists(atPath: fileURL.path) {
            } else {
                AudioDownloadManager.preDownloadEpisodeAudio(audioID: episode.audioID)
            }
        }
    }
    
    static func checkAndFetchNextEpisode() {
        if currentState == .loading {
            AudioDownloadManager.cancelCurrentDownload()
        } else if currentState == .fetching {
            return
        }
        if currentState == .playing {
            audioPlayer.pause()
            currentState = .ready
            pauseDisplayLink()
            //            leftHandLabel.text = timeString(time: 0.0)
            //            rightHandLabel.text = timeString(time: 0.0)
            //            playBackSlider.setValue(0, animated: true)
        }
        
        //        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        //        playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        //        playbackCircleView.setupPlaybackCircle()
        
        guard let index = AudioManager.activeEpisodes.firstIndex(where: { $0.ID == AudioManager.activeEpisode!.ID }) else { return }
        
        if index + 1 !=  AudioManager.activeEpisodes.count {
            playNextEpisodeWith(nextIndex: index + 1)
//            audioPlayerDelegate.updateActiveCell(atIndex: index + 1, forType: .episode)
//            if isClosed {
//                animateNextEpisodeIn()
//            }
        } else if AudioManager.activeEpisodes.count < AudioManager.itemCount {
            AudioManager.currentState = .fetching
//            audioPlayerDelegate.fetchMoreEpisodes()
        } else {
            print("last episode")
            let path = Bundle.main.path(forResource: "end.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                AudioManager.audioPlayer = try AVAudioPlayer(contentsOf: url)
                AudioManager.audioPlayer.play()
//                endSession()
            } catch {
                print(error)
            }
        }
    }
    
    static func playNextEpisodeWith(nextIndex: Int) {
        let nextEpisode = activeEpisodes[nextIndex]
        
        FileManager.getImageWith(imageID: nextEpisode.imageID) { image in
            DispatchQueue.main.async {
                self.activeImage = image
                self.setupEpisode()
                AudioManager.playOrPauseEpisodeWith(audioID: nextEpisode.audioID)
            }
        }
    }
    
    
    static func trackEpisodeProgress() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalCommentPush"), object: nil, userInfo: nil)
    }
    
    static func trackDownloadProgress() {
        
    }
    
    static func setupRemoteTransportControls() {
        commandCenter.togglePlayPauseCommand.addTarget { event in
            if AudioManager.audioPlayer != nil {
                self.playbackButtonPress()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            if AudioManager.audioPlayer != nil {
                self.checkAndFetchNextEpisode()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { event in
            if AudioManager.audioPlayer != nil {
                self.checkAndFetchLastEpisode()
                return .success
            }
            return .commandFailed
        }
    }
    
    static func playbackButtonPress() {
        if AudioManager.currentState == .playing {
            //            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
            //            playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
            //            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            //            playbackCircleLink.isPaused = true
            AudioManager.currentState = .paused
            AudioManager.audioPlayer.pause()
        } else if AudioManager.currentState == .paused || AudioManager.currentState == .ready {
            //            playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
            //            playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
            //            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            AudioManager.audioPlayer.currentTime = timeIn
            AudioManager.currentState = .playing
            trackProgress()
            AudioManager.audioPlayer.play()
        }
    }
    
    static func checkAndFetchLastEpisode() {
        if currentState == .loading {
            AudioDownloadManager.cancelCurrentDownload()
        }
        
        if currentState == .playing {
            audioPlayer.pause()
            pauseDisplayLink()
            currentState = .ready
//            leftHandLabel.text = timeString(time: 0.0)
//            rightHandLabel.text = timeString(time: 0.0)
//            playBackSlider.setValue(0, animated: true)
        }
        
        guard let index = activeEpisodes.firstIndex(where: { $0.ID == activeEpisode.ID }) else { return }
        if index != 0 {
            currentState = .ready
            pauseDisplayLink()
//            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
//            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
//            playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
//            playbackCircleView.setupPlaybackCircle()
            
            playNextEpisodeWith(nextIndex: index - 1)
//            audioPlayerDelegate.updateActiveCell(atIndex: index - 1, forType: .episode)
//            if isClosed {
//                animateLastEpisodeIn()
//            }
        }
    }
    
    
    static func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = "\(activeEpisode.username)"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "\(activeEpisode.programName)"
        nowPlayingInfo[MPMediaItemPropertyTitle] = "\(activeEpisode.caption)"
        
        if let image = activeImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = audioPlayer.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = audioPlayer.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = audioPlayer.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
}
