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

class DuneAudioPlayer: UIView {
    
//    var episodeImage: UIImage
//    var programName: String
//    var handel: String
//    var likesOverTen: Bool
//    var likeCount: Int
//    var listens: Int
//    var commentCount: Int
//    var saveCount: Int
//    var shareLink: URL
    
    
    var audioPlayer: AVAudioPlayer!
    var currentState: playerStatus = .ready
    
    let programImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let programNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureViews() {
        self.addSubview(programImageView)
        programImageView.translatesAutoresizingMaskIntoConstraints = false
        programImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        programImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        programImageView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        programImageView.widthAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        self.addSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0).isActive = true
        programNameLabel.leadingAnchor.constraint(equalTo: programImageView.trailingAnchor, constant: 10.0).isActive = true
        
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor).isActive = true
        
        self.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
//        captionLabel.trailingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true

    }
    
    func playOrPauseEpisode(url: URL, image: UIImage, programName: String, username: String, caption: String) {
        
        programImageView.image = image
        programNameLabel.text = programName
        usernameLabel.text = username
        
         switch currentState {
         case .ready:
             playAudioFrom(url: url)
         case .playing:
             if audioPlayer.url != url {
                 print(audioPlayer.url!)
                 print(url)
                 playAudioFrom(url: url)
             } else {
                 currentState = .paused
                 audioPlayer.pause()
                 print("Paused")
             }
         case .paused:
             if audioPlayer.url == url {
                 audioPlayer.play()
                 currentState = .playing
             } else {
                 playAudioFrom(url: url)
             }
         }
     }
     
     func playAudioFrom(url: URL) {
         audioPlayer = try! AVAudioPlayer(contentsOf: url)
         audioPlayer.volume = 1.0
         currentState = .playing
         audioPlayer.play()
         print("Playing")
     }
    
    
}

