//
//  AddBGMusicVC.swift
//  Dune
//
//  Created by Waylan Sands on 26/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

struct Track {
    static var trackOption: MusicOption?
}

protocol BackgroundMusicDelegate {
    func handleRemovedMusic()
    func addCurrentOption(track: MusicOption)
}

class AddBGMusicVC: UIViewController {
    
    lazy var tabBar = navigationController?.tabBarController?.tabBar
    let tableView = UITableView()
    let backgroundMusic = BackgroundMusic.options
    var cells = [BackgroundMusicCell]()
    var activeCell: BackgroundMusicCell?
    var selectedCell: BackgroundMusicCell?
    var selectedTrack: MusicOption?
    var audioPlayer: AVAudioPlayer!
    var playbackLink: CADisplayLink!
    var currentState: playerStatus = .ready
    var musicDelegate: BackgroundMusicDelegate!
    var audioSession = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onBoardingBlack
        setupNavigationBar()
        configureDelegates()
        configureViews()
        tableView.register(BackgroundMusicCell.self, forCellReuseIdentifier: "musicCell")
        tableView.rowHeight = 66
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Add Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func configureAudioSessionCategory() {
      do {
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
          try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setActive(true)
      } catch {
          print("error.")
      }
    }
    
    func resetSelectedCell() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetViews()
    }
    
    func resetViews() {
        if audioPlayer != nil {
            currentState = .ready
            audioPlayer.stop()
        }
    }
    
    func configureDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configureViews() {
        view.addSubview(tableView)
        tableView.pinEdges(to: view)
        tableView.backgroundColor = CustomStyle.onBoardingBlack
        tableView.separatorStyle = .none
    }
    
    @objc func selectButtonPress() {
        print("Selected pressed")
        
        if audioPlayer != nil {
            playbackLink.isPaused = true
            audioPlayer.stop()
        }
        
        if activeCell != selectedCell {
            selectedCell?.isDeselected()
        }
        
        selectedCell = activeCell
        selectedCell?.cellSelected()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        musicDelegate.addCurrentOption(track: selectedCell!.track)
//        Track.trackOption = selectedCell!.track
    }
    
    @objc func removeButtonPress() {
        selectedCell?.isDeselected()
        musicDelegate.handleRemovedMusic()
        selectedCell = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        selectedTrack = nil
    }
    
    // Helper Time String
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
    func trackMusicTime() {
        playbackLink = CADisplayLink(target: self, selector: #selector(trackPlaybackTime))
        playbackLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func trackPlaybackTime() {
        activeCell?.trackTime.text = self.timeString(time: self.audioPlayer.currentTime)
        activeCell?.trackTime.isHidden = false
        activeCell?.spinner.isHidden = true
    }
    
}

extension AddBGMusicVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let musicCell = tableView.dequeueReusableCell(withIdentifier: "musicCell") as! BackgroundMusicCell
        let track = backgroundMusic[indexPath.row]
        musicCell.setupCellWith(track)
        
        if musicCell.track == selectedTrack {
            musicCell.cellSelected()
            selectedCell = musicCell
            resetSelectedCell()
        }
        
        cells.append(musicCell)
        return musicCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BackgroundMusicCell
                
        for each in cells {
            if each != selectedCell {
                each.deactivateCell()
            }
        }
        
        cell.activate()
        activeCell = cell
        
        let loudAudioID = cell.track.loudAudioID
        let lowAudioID = cell.track.lowAudioID
        
        determineAudioPlayerAction(for: loudAudioID, withLowID: lowAudioID, for: cell)
        
        if cell == selectedCell {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(removeButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        }
    }
    
    func determineAudioPlayerAction(for audioID: String, withLowID: String, for cell: BackgroundMusicCell) {
        
        if currentState == .playing {
            currentState = .paused
            playbackLink.isPaused = true
            activeCell!.deactivateCell()
            audioPlayer.pause()
        } else if currentState == .paused || currentState == .ready {
            activeCell?.trackTime.isHidden = true
            activeCell?.spinner.isHidden = false
            FileManager.getMusicURLWith(audioID: audioID) { [weak self] url in
                guard let self = self else { return }
                self.playMusicWith(url: url, for: cell)
            }
            FileManager.getMusicURLWith(audioID: withLowID)
        }
    }
    
    
    func playMusicWith(url: URL, for cell: BackgroundMusicCell) {
        currentState = .playing
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 1
            audioPlayer.play()
            DispatchQueue.main.async {
                self.trackMusicTime()
            }
        }
        catch {
            print("failed to initialise audio player with url: \(error)")
        }
    }
    
}
