//
//  DuneAudioPlayer.swift
//  Dune
//
//  Created by Waylan Sands on 18/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import FirebaseStorage

enum playerStatus {
    case loading
    case fetching
    case playing
    case paused
    case ready
}

enum sliderStatus {
    case unchanged
    case moved
    case ended
    case began
}

protocol DuneAudioPlayerDelegate {
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType,  episodeID: String)
    func updateActiveCell(atIndex: Int, forType: PlayBackType)
    func showCommentsFor(episode: Episode)
    func playedEpisode(episode: Episode)
    func fetchMoreEpisodes()
}

class DunePlayBar: UIView {
    
    var audioPlayerDelegate: DuneAudioPlayerDelegate!
    var audioSession = AVAudioSession.sharedInstance()
    var currentState: playerStatus = .ready
    var audioPlayer: AVAudioPlayer!
    var currentAudioID: String?
    var loadingAudioID: String?
    var episode: Episode!
    var itemCount = 0
    var index = 0
    
    var screenHeight = UIScreen.main.bounds.height
    var playerHeight: CGFloat = 600
    
    var downloadedEpisodes: [Episode] = [] {
        willSet {
            index = downloadedEpisodes.count
        }
        didSet {
            if currentState == .fetching {
                currentState = .ready
                episode = downloadedEpisodes[index]
                playOrPauseEpisodeWith(audioID: episode.audioID)
            }
        }
    }
    
    // Command centre
    var commandCenter = MPRemoteCommandCenter.shared()
    
    // Loading progress
    
    let playbackCircleView = PlaybackCircleView()
    let loadingCircleLarge = LoadingAudioView()
    let loadingCircle = LoadingAudioView()
    var playbackCircleLink: CADisplayLink!
    
    var isOutOfPosition = true
    var yPosition: CGFloat!
    
    var likedEpisode = false
    //    var episodeIndex: Int!
    var episodeID: String!
    var image: UIImage!
    var likeCount = 0
    
    var withOutNavBar = true
    
    // Gesture properties
    var panningAllowed = true
    var isTransitioning = false
    var animatingEpisode = false
    var isClosed = true
    var isOpen = false
    
    // For various screen sizes
    var imageViewYConstant: CGFloat = 30
    var safetyHeight: CGFloat = 0
    
    lazy var maxValue = Float(UIScreen.main.bounds.width) - Float(40)
    var scrubbedTime: Double = 0
    var sliderStatus: sliderStatus = .unchanged
    
    let playbackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.88)
        return view
    }()
    
    let pullView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 2.5
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
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
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
    
    let largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        imageView.alpha = 0
        return imageView
    }()
    
    let largeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    lazy var captionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.textColor = CustomStyle.white
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.isSelectable = false
        textView.alpha = 0
        return textView
    }()
    
    let socialStackedView: UIStackView = {
        let view = UIStackView()
        view.distribution = .fillEqually
        return view
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
        imageView.contentMode = .scaleAspectFit
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
    
    lazy var playBackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = maxValue
        slider.setThumbImage(UIImage(named: "slider-thumb"), for: .normal)
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(onSliderValChanged), for: .valueChanged)
        return slider
    }()
    
    
    let dropButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "drop-arrow"), for: .normal)
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        button.alpha = 0
        button.padding = 10
        return button
    }()
    
    @objc func closeView() {
        animateCloseWith(duration: 1)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                sliderStatus = .began
            case .moved:
                sliderStatus = .moved
            case .ended:
                sliderStatus = .ended
                if currentState == .playing {
                    updatePlayerWithScrubbedTime()
                } else {
                    audioPlayer.currentTime = scrubbedTime
                    sliderStatus = .unchanged
                }
            default:
                break
            }
        }
    }
    
    let rightHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    let leftHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        return label
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        button.addTarget(self, action: #selector(playbackButtonPress), for: .touchUpInside)
        button.layer.cornerRadius = 30
        return button
    }()
    
    let lastEpisodeButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "last-episode-icon"), for: .normal)
        button.addTarget(self, action: #selector(checkAndFetchLastEpisode), for: .touchUpInside)
        button.padding = 15
        return button
    }()
    
    let nextEpisodeButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "next-episode-icon"), for: .normal)
        button.addTarget(self, action: #selector(checkAndFetchNextEpisode), for: .touchUpInside)
        button.padding = 15
        return button
    }()
    
    // Only for iPhone SE
    lazy var slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playbackCircleView.setupPlaybackCircle()
        configureAudioSessionCategory()
        setupRemoteTransportControls()
        styleForScreens()
        configureViews()
        
        if UIDevice.current.deviceType != .iPhone4S && UIDevice.current.deviceType != .iPhoneSE {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            self.addGestureRecognizer(pan)
            pan.delegate = self
        } else {
            playbackView.addGestureRecognizer(slideDown)
            slideDown.direction = .down
            slideDown.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupProgressTracking() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.progressTracking), name: NSNotification.Name(rawValue: "progressTracking"), object: nil)
    }
    
    func removeProgressTracking() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "progressTracking"), object: nil)
    }
    
    @objc func progressTracking() {
        print("wammy")
    }
    
    //MARK: Panning
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        determineSwipe(velocity: velocity)
        
        if let view = gesture.view {
            let viewOriginY = view.frame.origin.y - safetyHeight
            let topYPosition = screenHeight - self.frame.height
            
            if viewOriginY <= screenHeight - 160 && !isOpen  {
                animateOpenWith(duration: 1)
            }
            
            if viewOriginY < topYPosition + 50 && isOpen && gesture.state == .ended  {
                animateOpenWith(duration: 0.2)
            }
            
            if viewOriginY >= topYPosition + 50 && isOpen {
                animateCloseWith(duration: 1)
            }
            
            if viewOriginY <= topYPosition && translation.y < 0.0  {
                animateOpenWith(duration: 1)
            } else if viewOriginY < topYPosition + 50 && isOpen {
                view.frame.origin.y = translation.y + view.frame.origin.y
            } else if viewOriginY >= screenHeight - 130 && !isTransitioning && isClosed {
                animateOut()
            }
            
            if viewOriginY > screenHeight - 160 && !isTransitioning && gesture.state == .ended {
                animateCloseWith(duration: 0.2)
            }
            
        }
        gesture.setTranslation(.zero, in: self.superview)
    }
    
    func determineSwipe(velocity: CGPoint) {
        let leftSwipe = CGPoint(x: -500, y: 0)
        let rightSwipe = CGPoint(x: 500, y: 0)
        let swipeUp = CGPoint(x: 0, y: -500)
        let swipeDown = CGPoint(x: 0, y: 500)
        
        switch true {
        case velocity.x < leftSwipe.x:
            if !animatingEpisode && isClosed && !isTransitioning && audioPlayer != nil {
                print("Swipe left")
                animateNextEpisodeIn()
                checkAndFetchNextEpisode()
            }
        case velocity.x > rightSwipe.x:
            if !animatingEpisode && isClosed && !isTransitioning && audioPlayer != nil {
                print("Swipe right")
                checkAndFetchLastEpisode()
            }
        case velocity.y < swipeUp.y:
            animateOpenWith(duration: 0.7)
        case velocity.y > swipeDown.y:
            if isClosed && !isTransitioning {
                animateOut()
            }
        default:
            break
        }
    }
    
    func animateNextEpisodeIn() {
        animatingEpisode = true
        UIView.animate(withDuration: 0.2, animations: {
            self.programImageView.frame.origin.x = self.programImageView.frame.origin.x - 50
            self.programNameLabel.frame.origin.x = self.programNameLabel.frame.origin.x - 50
            self.captionLabel.frame.origin.x = self.captionLabel.frame.origin.x - 50
            self.programImageView.alpha = 0.5
            self.programNameLabel.alpha = 0.5
            self.captionLabel.alpha = 0.5
        }, completion: { _ in
            self.programImageView.frame.origin.x = 16
            self.programNameLabel.frame.origin.x = 70
            self.captionLabel.frame.origin.x = 70
            self.programImageView.alpha = 1
            self.programNameLabel.alpha = 1
            self.captionLabel.alpha = 1
            self.animatingEpisode = false
        })
    }
    
    func animateLastEpisodeIn() {
        animatingEpisode = true
        UIView.animate(withDuration: 0.2, animations: {
            self.programImageView.frame.origin.x = self.programImageView.frame.origin.x + 50
            self.programNameLabel.frame.origin.x = self.programNameLabel.frame.origin.x + 50
            self.captionLabel.frame.origin.x = self.captionLabel.frame.origin.x + 50
            self.programImageView.alpha = 0.5
            self.programNameLabel.alpha = 0.5
            self.captionLabel.alpha = 0.5
        }, completion: { _ in
            self.programImageView.frame.origin.x = 16
            self.programNameLabel.frame.origin.x = 70
            self.captionLabel.frame.origin.x = 70
            self.programImageView.alpha = 1
            self.programNameLabel.alpha = 1
            self.captionLabel.alpha = 1
            self.animatingEpisode = false
        })
    }
    
    @objc func checkAndFetchNextEpisode() {
        print("Current state: \(currentState)")
        if currentState == .loading {
            cancelCurrentDownload()
        } else if currentState == .fetching {
            print("Already fetching")
            return
        }
        if currentState == .playing {
            audioPlayer.pause()
            playbackCircleLink.isPaused = true
            currentState = .ready
            leftHandLabel.text = timeString(time: 0.0)
            rightHandLabel.text = timeString(time: 0.0)
            playBackSlider.setValue(0, animated: true)
        }
        
        if playbackCircleLink != nil {
            playbackCircleLink.isPaused = true
        }
        
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        playbackCircleView.setupPlaybackCircle()
        
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode!.ID }) else { return }
        
        if index + 1 != downloadedEpisodes.count {
            playNextEpisodeWith(nextIndex: index + 1)
            audioPlayerDelegate.updateActiveCell(atIndex: index + 1, forType: .episode)
            print("Inside")
            if isClosed {
                animateNextEpisodeIn()
            }
        } else if downloadedEpisodes.count < itemCount {
            currentState = .fetching
            audioPlayerDelegate.fetchMoreEpisodes()
        } else {
            print("last episode")
            let path = Bundle.main.path(forResource: "end.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
                endSession()
            } catch {
                print(error)
            }
        }
    }
    
    func prefetchNextEpisode() {
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode!.ID }) else { return }
        if (downloadedEpisodes.count - 1) > index {
            let documentsURL = FileManager.getDocumentsDirectory()
            let episode = downloadedEpisodes[index + 1]
            let fileURL = documentsURL.appendingPathComponent(episode.audioID)
            if FileManager.default.fileExists(atPath: fileURL.path) {
            } else {
                preDownloadEpisodeAudio(audioID: episode.audioID)
            }
        }
    }
    
    func preDownloadEpisodeAudio(audioID: String) {
        DispatchQueue.global(qos: .background).async {
            let storageRef = Storage.storage().reference().child("audio/\(audioID)")
            let documentsURL = FileManager.getDocumentsDirectory()
            let audioURL = documentsURL.appendingPathComponent(audioID)
            storageRef.write(toFile: audioURL)
        }
    }
    
    @objc func checkAndFetchLastEpisode() {
        if currentState == .loading {
            cancelCurrentDownload()
        }
        
        if currentState == .playing {
            audioPlayer.pause()
            playbackCircleLink.isPaused = true
            currentState = .ready
            leftHandLabel.text = timeString(time: 0.0)
            rightHandLabel.text = timeString(time: 0.0)
            playBackSlider.setValue(0, animated: true)
        }
        
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode!.ID }) else { return }
        if index != 0 {
            currentState = .ready
            if playbackCircleLink != nil {
                playbackCircleLink.isPaused = true
            }
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
            playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
            playbackCircleView.setupPlaybackCircle()
            
            playNextEpisodeWith(nextIndex: index - 1)
            print("updateActiveCell 1")
            audioPlayerDelegate.updateActiveCell(atIndex: index - 1, forType: .episode)
            if isClosed {
                animateLastEpisodeIn()
            }
        }
    }
    
    func animateOpenWith(duration: Double) {
        panningAllowed = false
        isTransitioning = true
        let yPosition = screenHeight - self.frame.height
        
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y = yPosition
            self.playbackCircleView.alpha = 0
            self.programImageView.alpha = 0
            self.programNameLabel.alpha = 0
            self.captionTextView.alpha = 1
            self.largeImageView.alpha = 1
            self.largeNameLabel.alpha = 1
            self.playbackButton.alpha = 0
            self.loadingCircle.alpha = 0
            self.captionLabel.alpha = 0
            self.dropButton.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isTransitioning = false
                self.panningAllowed = true
                self.isClosed = false
                self.isOpen = true
            }
        }
    }
    
    func animateCloseWith(duration: Double) {
        isClosed = false
        isTransitioning = true
        panningAllowed = false
        let bottomYPosition = yPosition - 64
        UIView.animate(withDuration: duration, animations: {
            self.frame.origin.y = bottomYPosition
            self.playbackCircleView.alpha = 1
            self.programImageView.alpha = 1
            self.programNameLabel.alpha = 1
            self.playbackButton.alpha = 1
            self.captionTextView.alpha = 0
            self.largeImageView.alpha = 0
            self.largeNameLabel.alpha = 0
            self.loadingCircle.alpha = 1
            self.captionLabel.alpha = 1
            self.dropButton.alpha = 0
            self.isTransitioning = false
            self.panningAllowed = true
            self.isOpen = false
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() +  0.5) {
                self.isClosed = true
            }
        }
    }
    
    func animateOut() {
        isOpen = false
        finishSession()
        isClosed = false
        panningAllowed = false
        isTransitioning = true
        let yPosition = self.frame.height
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.y = yPosition + 250
        }) { _ in
            self.resetPlayBarAlphas()
        }
    }
    
    func resetPlayBarAlphas() {
        self.playbackCircleView.alpha = 1
        self.programImageView.alpha = 1
        self.programNameLabel.alpha = 1
        self.captionTextView.alpha = 0
        self.largeNameLabel.alpha = 0
        self.largeImageView.alpha = 0
        self.playbackButton.alpha = 1
        self.loadingCircle.alpha = 1
        self.captionLabel.alpha = 1
        self.dropButton.alpha = 0
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
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
            safetyHeight = 34
        case .iPhone8:
            imageViewYConstant = 60
            safetyHeight = 34
        case .iPhone8Plus:
            safetyHeight = 34
            imageViewYConstant = 50
        case .iPhone11:
            break
        case .iPhone11Pro:
            break
        case .iPhone11ProMax:
            break
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        self.addSubview(playbackView)
        playbackView.pinEdges(to: self)
        
        playbackView.addSubview(pullView)
        pullView.translatesAutoresizingMaskIntoConstraints = false
        pullView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pullView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        pullView.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
        pullView.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        
        playbackView.addSubview(programImageView)
        programImageView.translatesAutoresizingMaskIntoConstraints = false
        programImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        programImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        programImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        programImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        playbackView.addSubview(programNameLabel)
        programNameLabel.translatesAutoresizingMaskIntoConstraints = false
        programNameLabel.topAnchor.constraint(equalTo: programImageView.topAnchor, constant: 2).isActive = true
        programNameLabel.leadingAnchor.constraint(equalTo: programImageView.trailingAnchor, constant: 10.0).isActive = true
        
        playbackView.addSubview(playbackButton)
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        playbackButton.centerYAnchor.constraint(equalTo: programImageView.centerYAnchor).isActive = true
        playbackButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        playbackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playbackButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        playbackView.addSubview(playbackCircleView)
        playbackCircleView.translatesAutoresizingMaskIntoConstraints = false
        playbackCircleView.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0).isActive = true
        playbackCircleView.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor, constant: 0).isActive = true
        
        playbackView.addSubview(loadingCircle)
        loadingCircle.translatesAutoresizingMaskIntoConstraints = false
        loadingCircle.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0).isActive = true
        loadingCircle.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor, constant: 0).isActive = true
        loadingCircle.setupLoadingAnimation()
        
        playbackView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.topAnchor.constraint(equalTo: programNameLabel.bottomAnchor, constant: 2).isActive = true
        captionLabel.leadingAnchor.constraint(equalTo: programNameLabel.leadingAnchor).isActive = true
        captionLabel.trailingAnchor.constraint(equalTo: playbackButton.leadingAnchor, constant: -18).isActive = true
        
        playbackView.addSubview(largeImageView)
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        largeImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: imageViewYConstant).isActive = true
        largeImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        largeImageView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        largeImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        playbackView.addSubview(largeNameLabel)
        largeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        largeNameLabel.topAnchor.constraint(equalTo: largeImageView.bottomAnchor, constant: 10).isActive = true
        largeNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        largeNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        playbackView.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.topAnchor.constraint(equalTo: largeNameLabel.bottomAnchor, constant: 10).isActive = true
        captionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        captionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        captionTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
        
        playbackView.addSubview(socialStackedView)
        socialStackedView.translatesAutoresizingMaskIntoConstraints = false
        socialStackedView.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 20).isActive = true
        socialStackedView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        socialStackedView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        
        socialStackedView.addArrangedSubview(likeButton)
        socialStackedView.addArrangedSubview(likeCountLabel)
        socialStackedView.addArrangedSubview(commentButton)
        socialStackedView.addArrangedSubview(commentCountLabel)
        socialStackedView.addArrangedSubview(shareButton)
        socialStackedView.addArrangedSubview(shareCountLabel)
        socialStackedView.addArrangedSubview(listenIconImage)
        socialStackedView.addArrangedSubview(listenCountLabel)
        
        playbackView.addSubview(playBackSlider)
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        playBackSlider.topAnchor.constraint(equalTo: socialStackedView.bottomAnchor, constant: 40).isActive = true
        playBackSlider.leadingAnchor.constraint(equalTo: playbackView.leadingAnchor, constant: 20).isActive = true
        playBackSlider.trailingAnchor.constraint(equalTo: playbackView.trailingAnchor, constant: -20).isActive = true
        
        playbackView.addSubview(leftHandLabel)
        leftHandLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHandLabel.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor, constant: 5).isActive = true
        leftHandLabel.leadingAnchor.constraint(equalTo: playBackSlider.leadingAnchor).isActive = true
        
        playbackView.addSubview(rightHandLabel)
        rightHandLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHandLabel.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor, constant: 5).isActive = true
        rightHandLabel.trailingAnchor.constraint(equalTo: playBackSlider.trailingAnchor).isActive = true
        
        playbackView.addSubview(playPauseButton)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor, constant: 40).isActive = true
        playPauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playPauseButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        playbackView.addSubview(loadingCircleLarge)
        loadingCircleLarge.translatesAutoresizingMaskIntoConstraints = false
        loadingCircleLarge.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor, constant: 0).isActive = true
        loadingCircleLarge.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor, constant: 0).isActive = true
        loadingCircleLarge.configureLargePlayback()
        loadingCircleLarge.setupLoadingAnimation()
        
        playbackView.addSubview(lastEpisodeButton)
        lastEpisodeButton.translatesAutoresizingMaskIntoConstraints = false
        lastEpisodeButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor).isActive = true
        lastEpisodeButton.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor, constant: -90).isActive = true
        
        playbackView.addSubview(nextEpisodeButton)
        nextEpisodeButton.translatesAutoresizingMaskIntoConstraints = false
        nextEpisodeButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor).isActive = true
        nextEpisodeButton.centerXAnchor.constraint(equalTo: playPauseButton.centerXAnchor, constant: 90).isActive = true
        
        playbackView.addSubview(dropButton)
        dropButton.translatesAutoresizingMaskIntoConstraints = false
        dropButton.topAnchor.constraint(equalTo: playbackView.topAnchor, constant: 15).isActive = true
        dropButton.leadingAnchor.constraint(equalTo: playbackView.leadingAnchor, constant: 16).isActive = true
        
    }
    
    func addBottomSection() {
        self.addSubview(playbackBottomView)
        playbackBottomView.translatesAutoresizingMaskIntoConstraints = false
        playbackBottomView.topAnchor.constraint(equalTo: playbackView.bottomAnchor).isActive = true
        playbackBottomView.leadingAnchor.constraint(equalTo: playbackView.leadingAnchor).isActive = true
        playbackBottomView.trailingAnchor.constraint(equalTo: playbackView.trailingAnchor).isActive = true
        playbackBottomView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func setEpisodeDetailsWith(episode: Episode, image: UIImage) {
//        AudioManager.activeEpisode = episode
//        AudioManager.activeImage = image
        audioPlayerDelegate.playedEpisode(episode: episode)
        setupLikeButtonAndCounterFor(episode: episode)
        programNameLabel.text = episode.programName
        largeNameLabel.text = "@\(episode.username)"
        captionTextView.text = episode.caption
        captionLabel.text = episode.caption
        programImageView.image = image
        largeImageView.image = image
        self.episode = episode
    }
    
    func continueState() {
        guard let episode = AudioManager.activeEpisode else { return }
        guard let image = AudioManager.activeImage else { return }
        audioPlayerDelegate.playedEpisode(episode: episode)
        setupLikeButtonAndCounterFor(episode: episode)
        programNameLabel.text = episode.programName
        largeNameLabel.text = "@\(episode.username)"
        captionTextView.text = episode.caption
        captionLabel.text = episode.caption
        programImageView.image = image
        largeImageView.image = image
        self.episode = episode
        fastTrackToPosition()
    }
    
    func playOrPauseEpisodeWith(audioID: String) {
        
        switch currentState {
        case .ready:
            getAudioWith(audioID: audioID) { url in
                self.playAudioFrom(url: url)
            }
        case .playing:
            if currentAudioID != audioID {
                audioPlayer.pause()
                playbackCircleLink.isPaused = true
                currentState = .paused
                getAudioWith(audioID: audioID) { url in
                    self.playAudioFrom(url: url)
                }
            } else {
                playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
                playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
                audioPlayer.pause()
                playbackCircleLink.isPaused = true
                currentState = .paused
            }
        case .paused:
            if currentAudioID == audioID {
                playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
                playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
                playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                currentState = .playing
                trackEpisodePlayback()
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
                cancelCurrentDownload()
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
    
    func getAudioWith(audioID: String, completion: @escaping (URL) -> ()) {
        let documentsURL = FileManager.getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(audioID)
        FireStoreManager.updateListenCountFor(episode: episode.ID)
        currentAudioID = audioID
        if FileManager.fileExistsWith(path: fileURL.path) {
            completion(fileURL)
        } else {
            downloadEpisodeAudio(audioID: audioID) { url in
                self.playPauseButton.backgroundColor = .white
                completion(url)
            }
        }
    }
    
    var downloadTask: StorageDownloadTask!
    
    func downloadEpisodeAudio(audioID: String, completion: @escaping (URL) -> ()) {
        loadingCircle.isHidden = false
        loadingCircle.shapeLayer.strokeEnd = 0
        loadingCircleLarge.isHidden = false
        playPauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        loadingCircleLarge.shapeLayer.strokeEnd = 0
        playbackButton.setImage(UIImage(named: "download-arrow"), for: .normal)
        playPauseButton.setImage(UIImage(named: "download-arrow-large"), for: .normal)
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let storageRef = Storage.storage().reference().child("audio/\(audioID)")
            let documentsURL = FileManager.getDocumentsDirectory()
            let audioURL = documentsURL.appendingPathComponent(audioID)
            self.loadingAudioID = audioID
            self.currentState = .loading
            
            self.downloadTask = storageRef.write(toFile: audioURL) { (url, error) in
                
                if let error = error as NSError? {
                    let code = StorageErrorCode(rawValue: error.code)
                    switch code {
                    case .cancelled:
                        break
                    default:
                        print("Error with downloadTask \(code.debugDescription)")
                    }
                } else {
                    completion(url!)
                }
            }
            self.downloadTask.observe(.progress) { snapshot in
                if snapshot.progress!.fractionCompleted == 1 {
                    self.loadingCircle.isHidden = true
                    self.loadingCircle.shapeLayer.strokeEnd = 0
                    self.loadingCircleLarge.isHidden = true
                    self.loadingCircleLarge.shapeLayer.strokeEnd = 0
                    DispatchQueue.main.async {
                        self.playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
                        self.playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
                        self.playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
                    }
                } else {
                    self.loadingCircle.shapeLayer.strokeEnd = CGFloat(snapshot.progress!.fractionCompleted)
                    self.loadingCircleLarge.shapeLayer.strokeEnd = CGFloat(snapshot.progress!.fractionCompleted)
                }
            }
        }
    }
    
    func cancelCurrentDownload() {
        if let task = downloadTask {
            loadingCircle.shapeLayer.strokeEnd = 0
            loadingCircleLarge.shapeLayer.strokeEnd = 0
            task.cancel()
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
            likeCountLabel.text = likeCount.roundedWithAbbreviations
        }
        
        if episode.listenCount != 0 {
            listenCountLabel.text = episode.listenCount.roundedWithAbbreviations
        }
        
        if episode.commentCount != 0 {
            commentCountLabel.text = episode.commentCount.roundedWithAbbreviations
        }
    }
    
    func updateListenCount() {
        guard let episode = downloadedEpisodes.first(where: { $0.ID == self.episode.ID }) else { return }
        episode.listenCount += 1
        listenCountLabel.text = String(episode.listenCount)
    }
    
    //MARK: Episode Tracking
    func trackEpisodePlayback() {
        playbackCircleLink = CADisplayLink(target: self, selector: #selector(updatePlaybackPosition))
        playbackCircleLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    //MARK: Episode Tracking
    func trackEpisodeProgress() {
        playbackCircleLink = CADisplayLink(target: self, selector: #selector(updatePlaybackPosition))
        playbackCircleLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func updatePlaybackPosition() {
        let duration = audioPlayer.duration
        let currentTime = audioPlayer.currentTime
        let percentagePlayed = CGFloat(currentTime / duration)
        let normalizedTime = CGFloat((currentTime * Double(maxValue)) / duration)
        
        if sliderStatus != .moved && sliderStatus != .ended {
            playBackSlider.setValue(Float(normalizedTime), animated: false)
        }
        
        let leftTime = timeIn()
        let rightTime = timeToGo()
        
        leftHandLabel.text = timeString(time: leftTime)
        rightHandLabel.text = timeString(time: rightTime)
        
        playbackCircleView.shapeLayer.strokeEnd = percentagePlayed
        audioPlayerDelegate.updateProgressBarWith(percentage: percentagePlayed, forType: .episode, episodeID: episode.ID)
    }
    
    func updatePlayerWithScrubbedTime() {
        audioPlayer.currentTime = scrubbedTime
        sliderStatus = .unchanged
        audioPlayer.play()
    }
    
    func timeIn() -> Double {
        let percent = CGFloat(playBackSlider.value / maxValue) * 100
        let timePercent = CGFloat(audioPlayer.duration / 100) * percent
        scrubbedTime = Double(timePercent)
        return scrubbedTime
    }
    
    func timeToGo() -> Double {
        let percent = CGFloat(playBackSlider.value / maxValue) * 100
        let timePercent = CGFloat(audioPlayer.duration / 100) * percent
        scrubbedTime = Double(timePercent)
        return audioPlayer.duration - scrubbedTime
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
    func playAudioFrom(url: URL) {
        animateToPositionIfNeeded()
        playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
        playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        playPauseButton.backgroundColor = .white
        audioPlayer.delegate = self
        audioPlayer.volume = 1.0
        currentState = .playing
        trackEpisodePlayback()
        prefetchNextEpisode()
        audioPlayer.play()
        setupNowPlaying()
    }
    
    func animateToPositionIfNeeded() {
        if isOutOfPosition {
            animatePlayerToPosition()
        }
    }
    
    @objc func dismissView() {
        finishSession()
    }
    
    @objc func playbackButtonPress() {
        if currentState == .playing {
            playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
            playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
            playbackCircleLink.isPaused = true
            currentState = .paused
            audioPlayer.pause()
        } else if currentState == .paused || currentState == .ready {
            print("State \(currentState)")
            playbackButton.setImage(UIImage(named: "pause-episode-icon"), for: .normal)
            playPauseButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
            playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            audioPlayer.currentTime = timeIn()
            currentState = .playing
            trackEpisodePlayback()
            audioPlayer.play()
        }
    }
    
    func playNextEpisodeWith(nextIndex: Int) {
        let nextEpisode = downloadedEpisodes[nextIndex]
        
        FileManager.getImageWith(imageID: nextEpisode.imageID) { [unowned self] image in
            DispatchQueue.main.async {
                self.setEpisodeDetailsWith(episode: nextEpisode, image: image)
                self.playOrPauseEpisodeWith(audioID: nextEpisode.audioID)
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
            if !CurrentProgram.repMethods!.contains(episode.ID) {
                FireStoreManager.updateProgramRep(programID: episode.programID, repMethod: episode.programID, rep: 6)
                FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: episode.programID)
                CurrentProgram.repMethods?.append(episode.ID)
            }
            
            episode.likeCount += 1
            downloadedEpisodes[index] = episode
            
        } else {
            likedEpisode = false
            likeCount -= 1
            likeCountLabel.text = String(likeCount)
            likeButton.setImage(UIImage(named: "like-button-icon"), for: .normal)
            FireStoreManager.updateEpisodeLikeCountWith(episodeID: episodeID, by: .decrease)
            if !CurrentProgram.repMethods!.contains(episode.ID) {
                FireStoreManager.updateProgramRep(programID: episode.programID, repMethod: episode.programID, rep: -4)
                FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: episode.programID)
                CurrentProgram.repMethods?.append(episode.ID)
            }
            
            episode.likeCount -= 1
            downloadedEpisodes[index] = episode
            
            if likeCount == 0 {
                likeCountLabel.text = ""
            }
        }
    }
    
    func animatePlayerToPosition() {
        animatingEpisode = false
        isOutOfPosition = false
        isTransitioning = false
        panningAllowed = true
        isClosed = true
        isOpen = false
        let position = yPosition - 64
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame = CGRect(x: 0, y: position, width: self.frame.width, height: self.playerHeight)
        }, completion: nil)
    }
    
    func fastTrackToPosition() {
        animatingEpisode = false
        isOutOfPosition = false
        isTransitioning = false
        panningAllowed = true
        isClosed = true
        isOpen = false
        let position = AudioManager.yPosition - 64
        self.frame = CGRect(x: 0, y: position, width: self.frame.width, height: self.playerHeight)
    }
    
    func transitionOutOfView() {
        isOutOfPosition = true
        let height =  UIScreen.main.bounds.height
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame = CGRect(x: 0, y: height, width: self.frame.width, height: self.playerHeight)
        }, completion: nil)
    }
    
    func finishSession() {
        resetPlayBarAlphas()
        transitionOutOfView()
        currentState = .ready
        isOutOfPosition = true
        cancelCurrentDownload()
        if audioPlayer != nil {
            playbackCircleLink.invalidate()
            audioPlayer.setVolume(0, fadeDuration: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                [unowned self] in
                if self.isOutOfPosition {
                    self.audioPlayer.volume = 1
                    self.audioPlayer.stop()
                }
            }
        }
    }
    
    func endSession() {
        resetPlayBarAlphas()
        transitionOutOfView()
        currentState = .ready
        isOutOfPosition = true
        cancelCurrentDownload()
        if audioPlayer != nil {
            playbackCircleLink.invalidate()
            audioPlayer.setVolume(0, fadeDuration: 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                [unowned self] in
                if self.isOutOfPosition {
                    self.audioPlayer.volume = 1
                    self.audioPlayer.stop()
                }
            }
        }
    }
    
    func pauseSession() {
        currentState = .paused
        if audioPlayer != nil {
            audioPlayer.setVolume(0, fadeDuration: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
                self.playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
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
    
    //MARK: RemoteTransportControls
    func setupRemoteTransportControls() {
        commandCenter.togglePlayPauseCommand.addTarget { [unowned self] event in
            if self.audioPlayer != nil {
                self.playbackButtonPress()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] event in
            if self.audioPlayer != nil {
                self.checkAndFetchNextEpisode()
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] event in
            if self.audioPlayer != nil {
                self.checkAndFetchLastEpisode()
                return .success
            }
            return .commandFailed
        }
        
    }
    
    func setupNowPlaying() {
        var nowPlayingInfo = [String : Any]()
        
        nowPlayingInfo[MPMediaItemPropertyArtist] = "\(episode.username)"
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "\(episode.programName)"
        nowPlayingInfo[MPMediaItemPropertyTitle] = "\(episode.caption)"
        
        if let image = programImageView.image {
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

extension DunePlayBar: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        currentState = .ready
        playbackCircleLink.isPaused = true
        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
        playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        playbackCircleView.setupPlaybackCircle()
        
        guard let index = downloadedEpisodes.firstIndex(where: { $0.ID == episode!.ID }) else { return }
        
        if (downloadedEpisodes.count - 1) > index {
            playNextEpisodeWith(nextIndex: index + 1)
            print("updateActiveCell 2")
            audioPlayerDelegate.updateActiveCell(atIndex: index + 1, forType: .episode)
        } else {
            finishSession()
        }
    }
    
}

extension DunePlayBar: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if panningAllowed {
            return true
        } else {
            return false
        }
    }
    
}


