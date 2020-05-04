//
//  BackgroundMusicView.swift
//  Dune
//
//  Created by Waylan Sands on 27/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class BackgroundMusicView: UIView {
                
        let playPauseButton: UIButton = {
           let button = UIButton()
            button.setImage(UIImage(named: "play-music-icon"), for: .normal)
            button.isUserInteractionEnabled = false
            button.layer.cornerRadius = 5
            button.clipsToBounds = true
            return button
        }()
        
        let cellContentView: UIView = {
           let view = UIButton()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
//            view.layer.cornerRadius = 6
//            view.clipsToBounds = true
            return view
        }()
        
        let trackArtistLabel: UILabel = {
           let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            label.textColor = .white
            return label
        }()
        
        let trackTitleLabel: UILabel = {
           let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.textColor = .white
            return label
        }()
        
        let trackTime: UILabel = {
           let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            label.textColor = CustomStyle.secondShade
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addTrackDetails(track: MusicOption) {
        playPauseButton.backgroundColor = track.color
        trackArtistLabel.text = track.artist
        trackTitleLabel.text = track.title
        trackTime.text = track.time
    }
        
        func configureViews() {
            self.addSubview(cellContentView)
            cellContentView.translatesAutoresizingMaskIntoConstraints = false
            cellContentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            cellContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            cellContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            cellContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            
            cellContentView.addSubview(playPauseButton)
            playPauseButton.translatesAutoresizingMaskIntoConstraints = false
            playPauseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
            playPauseButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
            playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            playPauseButton.leadingAnchor.constraint(equalTo: cellContentView.leadingAnchor, constant: 10).isActive = true
            
            cellContentView.addSubview(trackArtistLabel)
            trackArtistLabel.translatesAutoresizingMaskIntoConstraints = false
            trackArtistLabel.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 10).isActive = true
            trackArtistLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
            
            cellContentView.addSubview(trackTitleLabel)
            trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            trackTitleLabel.leadingAnchor.constraint(equalTo: trackArtistLabel.leadingAnchor).isActive = true
            trackTitleLabel.topAnchor.constraint(equalTo: trackArtistLabel.bottomAnchor, constant: 2).isActive = true
            
            cellContentView.addSubview(trackTime)
            trackTime.translatesAutoresizingMaskIntoConstraints = false
            trackTime.trailingAnchor.constraint(equalTo: cellContentView.trailingAnchor, constant: -20).isActive = true
            trackTime.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }

}



