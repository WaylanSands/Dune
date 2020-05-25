//
//  DuneIntroPlayer.swift
//  Dune
//
//  Created by Waylan Sands on 18/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

class DuneIntroPlayer: UIView {
    
    var audioPlayer: AVAudioPlayer!
    var currentState: playerStatus = .ready
    let playbackCircleView = PlaybackCircleView()
    var playbackDelegate: PlaybackBarDelegate!
    var isProgramPageIntro: Bool?
    
    var isInPosition = false
    var yPosition: CGFloat!
    
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
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
         label.isUserInteractionEnabled = false
        label.text = "@\(User.username!)"
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
        programImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
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
        
        playbackView.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor, constant: 2).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: playbackButton.leadingAnchor, constant: -18).isActive = true
    }
    
    func addBottomSection() {
         self.addSubview(playbackBottomView)
         playbackBottomView.translatesAutoresizingMaskIntoConstraints = false
         playbackBottomView.topAnchor.constraint(equalTo: playbackView.bottomAnchor).isActive = true
         playbackBottomView.leadingAnchor.constraint(equalTo: playbackView.leadingAnchor).isActive = true
         playbackBottomView.trailingAnchor.constraint(equalTo: playbackView.trailingAnchor).isActive = true
         playbackBottomView.heightAnchor.constraint(equalToConstant: 70).isActive = true
     }
    
    func playOrPauseWith(url: URL, name: String, image: UIImage) {
        programImageView.image = image
        programNameLabel.text = name
        
        print(self.frame.maxY)
        
        if isInPosition == false {
            animatePlayerIntoPosition()
        }
        
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
                print("Now paused")
            }
        case .paused:
            if audioPlayer.url == url {
                playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                currentState = .playing
                trackIntroPlayback()
                audioPlayer.play()
                print("You selected to resume")
            } else {
                playAudioFrom(url: url)
            }
        }
    }
    
    func trackIntroPlayback() {
        playbackCircleLink = CADisplayLink(target: self, selector: #selector(updatePlaybackPosition))
        playbackCircleLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func updatePlaybackPosition() {
        let duration = audioPlayer.duration
        let currentTime = audioPlayer.currentTime
        let percentagePlayed = CGFloat(currentTime / duration)
        playbackCircleView.shapeLayer.strokeEnd = percentagePlayed
        if isProgramPageIntro == false {
            playbackDelegate.updateProgressBarWith(percentage: percentagePlayed, forType: .program)
        }
    }
    
    func playAudioFrom(url: URL) {
        playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        currentState = .playing
        trackIntroPlayback()
        audioPlayer.play()
        print("Now playing")
    }
    
    @objc func playbackButtonPress() {
        if currentState == .playing {
            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            playbackCircleLink.isPaused = true
            currentState = .paused
            print("Now paused")
            audioPlayer.pause()
        } else if currentState == .paused || currentState == .ready {
            playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            currentState = .playing
            trackIntroPlayback()
            audioPlayer.play()
            print("Now play")
        }
    }
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let documentsURL = FileManager.getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            FireStorageManager.downloadIntroAudio(audioID: audioID) { url in
                completion(url)
            }
        }
    }
    
    func animatePlayerIntoPosition() {
        isInPosition = true
        print("Triggered to move to \(yPosition!)")
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
        self.frame = CGRect(x: 0, y: self.yPosition, width: self.frame.width, height: 70)
        }, completion: nil)
    }
    
    func transitionOutOfView() {
        isInPosition = false
        let height =  UIScreen.main.bounds.height
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame = CGRect(x: 0, y: height, width: self.frame.width, height: 70)
        }, completion: nil)
    }
    
    func finishSession() {
        isInPosition = false
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
    
    func updateYPositionWith(value: CGFloat) {
        if isInPosition {
            self.frame.origin.y = value
        }
    }
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
    
    @objc func dismissView() {
        print("Swipe")
       finishSession()
    }
    
    func addTouchTarget() {
        let gestureRec = UIGestureRecognizer.init(target: self, action: #selector(touchDismiss))
        playbackView.addGestureRecognizer(gestureRec)
    }
    
    @objc func touchDismiss() {
        print("DISMISS")
    }
    
    
    
}


extension DuneIntroPlayer: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Finished playing episode")
        currentState = .ready
        playbackCircleLink.isPaused = true
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        
        finishSession()
    }
    
}


extension DuneIntroPlayer: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
