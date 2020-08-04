//
//  BackgroundMusicCell.swift
//  Dune
//
//  Created by Waylan Sands on 26/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class BackgroundMusicCell: UITableViewCell {
    
    var track: MusicOption!
    var isSelectedCell = false
    var spinner = UIActivityIndicatorView(style: .white)
    
    let playPauseButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "play-music-icon"), for: .normal)
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    let cellContentButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = hexStringToUIColor(hex: "#272B33")
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 6
        button.clipsToBounds = true
        return button
    }()
    
    let trackArtistLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.isUserInteractionEnabled = false
        label.textColor = .white
        return label
    }()
    
    let trackTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.isUserInteractionEnabled = false
        label.textColor = .white
        return label
    }()
    
    let trackTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.isUserInteractionEnabled = false
        label.textColor = CustomStyle.fifthShade
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        configureViews()
    }
    
    func setupCellWith(_ track: MusicOption) {
        playPauseButton.backgroundColor = track.color
        trackArtistLabel.text = track.artist
        trackTitleLabel.text = track.title
        trackTime.text = track.time
        self.track = track
        
        if Track.trackOption != nil {
            if track == Track.trackOption {
                cellSelected()
                isSelectedCell = true
            }
    }
        
    }
    func configureViews() {
        self.addSubview(cellContentButton)
        cellContentButton.translatesAutoresizingMaskIntoConstraints = false
        cellContentButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        cellContentButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        cellContentButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        cellContentButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        cellContentButton.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playPauseButton.leadingAnchor.constraint(equalTo: cellContentButton.leadingAnchor, constant: 10).isActive = true
        
        cellContentButton.addSubview(trackArtistLabel)
        trackArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        trackArtistLabel.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 10).isActive = true
        trackArtistLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 17).isActive = true
        
        cellContentButton.addSubview(trackTitleLabel)
        trackTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        trackTitleLabel.leadingAnchor.constraint(equalTo: trackArtistLabel.leadingAnchor).isActive = true
        trackTitleLabel.topAnchor.constraint(equalTo: trackArtistLabel.bottomAnchor, constant: 2).isActive = true
        
        cellContentButton.addSubview(trackTime)
        trackTime.translatesAutoresizingMaskIntoConstraints = false
        trackTime.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        trackTime.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        trackTime.widthAnchor.constraint(equalToConstant: 50).isActive = true

        cellContentButton.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: trackTime.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: trackTime.centerXAnchor).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 20).isActive = true
        spinner.startAnimating()
        spinner.isHidden = true
    }
    
    func activate() {
        playPauseButton.setImage(UIImage(named: "pause-music-icon"), for: .normal)
        trackTime.textColor = .white
    }
    
    func deactivateCell() {
        playPauseButton.setImage(UIImage(named: "play-music-icon"), for: .normal)
        cellContentButton.backgroundColor = hexStringToUIColor(hex: "#272B33")
        trackTime.textColor = CustomStyle.fifthShade
        trackTime.text = track.time
        trackArtistLabel.textColor = .white
        trackTitleLabel.textColor = .white
    }
    
    func isDeselected() {
        playPauseButton.setImage(UIImage(named: "play-music-icon"), for: .normal)
        cellContentButton.backgroundColor = hexStringToUIColor(hex: "#272B33")
        trackTime.textColor = CustomStyle.fifthShade
        trackArtistLabel.textColor = .white
        trackTitleLabel.textColor = .white
    }
    
    func cellSelected() {
        playPauseButton.setImage(UIImage(named: "play-music-icon"), for: .normal)
        cellContentButton.backgroundColor = CustomStyle.secondShade
        trackArtistLabel.textColor = CustomStyle.primaryBlack
        trackTitleLabel.textColor = CustomStyle.primaryBlack
        trackTime.textColor = CustomStyle.primaryBlack
        trackTime.text = track.time
    }
    
}
