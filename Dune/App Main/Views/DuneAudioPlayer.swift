//
//  DuneAudioPlayer.swift
//  Dune
//
//  Created by Waylan Sands on 18/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

enum playerStatus {
    case playing
    case paused
    case ready
}

protocol DuneAudioPlayerDelegate {
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType,  episodeID: String)
    func updateActiveCell(atIndex: Int, forType: PlayBackType)
    func showCommentsFor(episode: Episode)
    func playedEpisode(episode: Episode)
}

class DuneAudioPlayer: UIView {
       
    var downloadedEpisodes = [Episode]()
    var audioPlayer: AVAudioPlayer!
    var currentState: playerStatus = .ready
    var topImageConstraint: NSLayoutConstraint!
    let playbackCircleView = PlaybackCircleView()
    var audioPlayerDelegate: DuneAudioPlayerDelegate!
    var episode: Episode!

    var isOutOfPosition = true
    var optionsArePresented = false
    var optionsAreHidden = false
    var yPosition: CGFloat!
    
    var episodeIndex: Int!
    var episodeID: String!
    var likeCount = 0
    var likedEpisode = false
    
    var withOutNavBar = true

    var playbackCircleLink: CADisplayLink!
    
    let playbackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.88)
        return view
    }()
    
    let playbackBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.88)
        return view
    }()
    
    let programImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like-button-icon"), for: .normal)
        button.addTarget(self, action: #selector(likeButtonPress), for: .touchUpInside)
        return button
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "comment-button-icon"), for: .normal)
        button.addTarget(self, action: #selector(commentButtonPress), for: .touchUpInside)
        return button
    }()
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.text = ""
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "share-button-icon"), for: .normal)
        return button
    }()
    
    let shareCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        label.isUserInteractionEnabled = false
        label.text = ""
        return label
    }()
    
    let listenIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "listen-icon")
        return imageView
    }()

    let listenCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .medium)
        label.textAlignment = .left
        label.textColor = .white
        label.isUserInteractionEnabled = false
        return label
    }()

    let playbackButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(playbackButtonPress), for: .touchUpInside)
        button.padding = 20
        return button
    }()
    
    lazy var slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))

    override init(frame: CGRect) {
        super.init(frame: frame)
        playbackCircleView.setupPlaybackCircle()
        configureViews()
        
        slideDown.direction = .down
        slideDown.delegate = self
        playbackView.addGestureRecognizer(slideDown)
        playbackView.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureViews() {
        self.addSubview(playbackView)
        playbackView.pinEdges(to: self)
        
        playbackView.addSubview(programImageView)
        programImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageConstraint = programImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)
        topImageConstraint.isActive = true
        programImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        programImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        programImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        playbackView.addSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.topAnchor.constraint(equalTo: programImageView.topAnchor, constant: 2).isActive = true
        programNameLabel.leadingAnchor.constraint(equalTo: programImageView.trailingAnchor, constant: 10.0).isActive = true
        
        playbackView.addSubview(playbackButton)
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        playbackButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playbackButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        playbackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playbackButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        playbackView.addSubview(playbackCircleView)
        playbackCircleView.translatesAutoresizingMaskIntoConstraints = false
        playbackCircleView.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0).isActive = true
        playbackCircleView.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor, constant: 0).isActive = true
        
        playbackView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor, constant: 2).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: playbackButton.leadingAnchor, constant: -18).isActive = true
    }
    
    func configureSettingOptions() {
        topImageConstraint.constant = 15
        
        playbackView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: captionLabel.leadingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        playbackView.addSubview(likeCountLabel)
        likeCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 7).isActive = true
        likeCountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        playbackView.addSubview(commentButton)
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: 15).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        commentButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        playbackView.addSubview(commentCountLabel)
        commentCountLabel.translatesAutoresizingMaskIntoConstraints = false
        commentCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 7).isActive = true
        commentCountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        playbackView.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: commentCountLabel.trailingAnchor, constant: 15).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        playbackView.addSubview(shareCountLabel)
        shareCountLabel.translatesAutoresizingMaskIntoConstraints = false
        shareCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        shareCountLabel.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 7).isActive = true
        shareCountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(listenIconImage)
        listenIconImage.translatesAutoresizingMaskIntoConstraints = false
        listenIconImage.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 10).isActive = true
        listenIconImage.leadingAnchor.constraint(equalTo: shareCountLabel.trailingAnchor, constant: 10).isActive = true
        listenIconImage.widthAnchor.constraint(equalToConstant: 18).isActive = true
        listenIconImage.heightAnchor.constraint(equalToConstant: 18).isActive = true

        self.addSubview(listenCountLabel)
        listenCountLabel.translatesAutoresizingMaskIntoConstraints = false
        listenCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        listenCountLabel.leadingAnchor.constraint(equalTo: listenIconImage.trailingAnchor, constant: 7).isActive = true
        listenCountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    func addBottomSection() {
         self.addSubview(playbackBottomView)
         playbackBottomView.translatesAutoresizingMaskIntoConstraints = false
         playbackBottomView.topAnchor.constraint(equalTo: playbackView.bottomAnchor).isActive = true
         playbackBottomView.leadingAnchor.constraint(equalTo: playbackView.leadingAnchor).isActive = true
         playbackBottomView.trailingAnchor.constraint(equalTo: playbackView.trailingAnchor).isActive = true
         playbackBottomView.heightAnchor.constraint(equalToConstant: 70).isActive = true
     }
    
    func configureWithoutOptions() {
        topImageConstraint.constant = 12
        likeButton.removeFromSuperview()
        likeCountLabel.removeFromSuperview()
        commentButton.removeFromSuperview()
        commentCountLabel.removeFromSuperview()
        shareButton.removeFromSuperview()
        shareCountLabel.removeFromSuperview()
        listenIconImage.removeFromSuperview()
        listenCountLabel.removeFromSuperview()
    }
        
    func playOrPause(episode: Episode, with url: URL, image: UIImage) {
        
        FireStoreManager.updateListenCountFor(episode: episode.ID)
        audioPlayerDelegate.playedEpisode(episode: episode)
        setupLikeButtonAndCounterFor(episode: episode)
        programNameLabel.text = episode.programName
        captionLabel.text = episode.caption
        programImageView.image = image
        self.episode = episode

        switch currentState {
        case .ready:
            playAudioFrom(url: url)
        case .playing:
            if audioPlayer.url != url {
                playAudioFrom(url: url)
            } else {
                audioPlayer.pause()
                playbackCircleLink.isPaused = true
                currentState = .paused
            }
        case .paused:
            if audioPlayer.url == url {
                playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                currentState = .playing
                trackEpisodePlayback()
                audioPlayer.play()
            } else {
                playAudioFrom(url: url)
            }
        }
    }
    
    func episodeHadBeenPlayed() {
        audioPlayerDelegate.showCommentsFor(episode: episode)
    }
    
        func setupLikeButtonAndCounterFor(episode: Episode) {

            episodeID = episode.ID
            
            if let likedEpisodes = User.likedEpisodes {
                if likedEpisodes.contains(episode.ID) {
                    likedEpisode = true
                    likeButton.setImage(UIImage(named: "liked-button"), for: .normal)
                } else {
                    likedEpisode = false
                    likeButton.setImage(UIImage(named: "like-button-icon"), for: .normal)
                }
            }
        
            if episode.likeCount == 0 {
                likeCount = 0
                likeCountLabel.text = ""
                likedEpisode = false
            } else {
                likeCount = episode.likeCount
                likeCountLabel.text = String(likeCount)
            }
            
            if episode.listenCount != 0 {
                listenCountLabel.text = String(episode.listenCount)
            }
        }
    
    func updateListenCount() {
        guard let episode = downloadedEpisodes.first(where: { $0.ID == self.episode.ID }) else { return }
        episode.listenCount += 1
        listenCountLabel.text = String(episode.listenCount)
    }
    
    func trackEpisodePlayback() {
        playbackCircleLink = CADisplayLink(target: self, selector: #selector(updatePlaybackPosition))
        playbackCircleLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func updatePlaybackPosition() {
        let duration = audioPlayer.duration
        let currentTime = audioPlayer.currentTime
        let percentagePlayed = CGFloat(currentTime / duration)
        playbackCircleView.shapeLayer.strokeEnd = percentagePlayed
        audioPlayerDelegate.updateProgressBarWith(percentage: percentagePlayed, forType: .episode, episodeID: episode.ID)
    }
     
     func playAudioFrom(url: URL) {
         checkIfOptionsNeedToBePresented()
         playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
         playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         audioPlayer = try! AVAudioPlayer(contentsOf: url)
         audioPlayer.delegate = self
         audioPlayer.volume = 1.0
         currentState = .playing
         trackEpisodePlayback()
         audioPlayer.play()
     }
    
    func checkIfOptionsNeedToBePresented() {
        
        if episode.likeCount >= 10 && (optionsArePresented || isOutOfPosition) {
            animateAudioPlayerWithoutOptions()
        } else if episode.likeCount < 10 && (!optionsArePresented || isOutOfPosition) {
            animateAudioPlayerWithOptions()
        }
    }
    
    @objc func dismissView() {
       finishSession()
    }
    
    @objc func playbackButtonPress() {
        if currentState == .playing {
            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            playbackCircleLink.isPaused = true
            currentState = .paused
            audioPlayer.pause()
        } else if currentState == .paused || currentState == .ready {
            playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            currentState = .playing
            trackEpisodePlayback()
            audioPlayer.play()
        }
    }
    
    func playNextEpisodeWith(nextIndex: Int) {
        let nextEpisode = downloadedEpisodes[nextIndex]
        
        FileManager.getImageWith(imageID: nextEpisode.imageID) { image in
            self.getAudioWith(audioID: nextEpisode.audioID) { url in
                self.playOrPause(episode: nextEpisode, with: url, image: image)
            }
        }
    }
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let documentsURL = FileManager.getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            FireStorageManager.downloadEpisodeAudio(audioID: audioID) { url in
                completion(url)
            }
        }
    }
    
    @objc func likeButtonPress() {
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode.ID } ) else { return }
        
        if likedEpisode == false {
            likedEpisode = true
            likeCount += 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "liked-button"), for: .normal)
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episodeID, by: .increase)
            
            episode.likeCount += 1
            downloadedEpisodes[index] = episode
            
        } else {
            likedEpisode = false
            likeCount -= 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "like-button-icon"), for: .normal)
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episodeID, by: .decrease)
            
            episode.likeCount -= 1
            downloadedEpisodes[index] = episode
            
            if likeCount == 0 {
                likeCountLabel.text = ""
            }
        }
    }
    
    func animateAudioPlayerWithOptions() {
        isOutOfPosition = false
        optionsArePresented = true
        configureSettingOptions()
        topImageConstraint.constant = 15
        let position = yPosition - 100
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame = CGRect(x: 0, y: position, width: self.frame.width, height: 100)
        }, completion: nil)
    }
    
    func animateAudioPlayerWithoutOptions() {
        isOutOfPosition = false
        optionsArePresented = false
        configureWithoutOptions()
        let position = yPosition - 70
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame = CGRect(x: 0, y: position, width: self.frame.width, height: 70)
        }, completion: nil)
    }
    
    func transitionOutOfView() {
        isOutOfPosition = true
        let height =  UIScreen.main.bounds.height
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
             self.frame = CGRect(x: 0, y: height, width: self.frame.width, height: 70)
        }, completion: nil)
    }
    
    func updateYPositionWith(value: CGFloat) {
        yPosition = value
        if !isOutOfPosition {
            if optionsArePresented {
                self.frame.origin.y = value - 100
            } else {
                self.frame.origin.y = value - 70
            }
        }
    }
    
    func finishSession() {
        isOutOfPosition = true
        optionsArePresented = false
        optionsAreHidden = false
        transitionOutOfView()
        currentState = .ready
        if audioPlayer != nil {
            audioPlayer.setVolume(0, fadeDuration: 2)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.audioPlayer.volume = 1
                self.audioPlayer.stop()
            }
        }
    }
    
    func pauseSession() {
        currentState = .paused
        if audioPlayer != nil {
            audioPlayer.setVolume(0, fadeDuration: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
                self.playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
                self.playbackCircleLink.isPaused = true
                self.audioPlayer.volume = 1
                self.audioPlayer.pause()
            }
        }
    }
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    @objc func commentButtonPress() {
        audioPlayerDelegate.showCommentsFor(episode: episode)
    }
    
}


extension DuneAudioPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentState = .ready
        playbackCircleLink.isPaused = true
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        playbackCircleView.setupPlaybackCircle()
        
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode!.ID }) else { return }
        updateListenCount()

        if (downloadedEpisodes.count - 1) > index {
            playNextEpisodeWith(nextIndex: index + 1)
            audioPlayerDelegate.updateActiveCell(atIndex: index + 1, forType: .episode)
        } else {
            finishSession()
        }
    }
    
}

extension DuneAudioPlayer: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
