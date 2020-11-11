//
//  recordBoothVC.swift
//  Dune
//
//  Created by Waylan Sands on 16/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
import MultiSlider

class RecordBoothVC: UIViewController {
    
    enum recordState {
        case ready
        case recording
        case preview
        case playing
        case paused
    }
    
    enum RecordingScope {
        case intro
        case episode
    }
    
    var selectedProgram: Program?
        
    var recordingDisplayLink: CADisplayLink!
    var playbackDisplayLink: CADisplayLink!
    
    var audioSession = AVAudioSession.sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!

    var currentScope: RecordingScope!
    
    let mergedFileName = NSUUID().uuidString
    let fileName = NSUUID().uuidString
    var recordingURL: URL!
    var voiceURL: URL?
    
    var currentState = recordState.ready
    var maxRecordingTime: Double = 600
    var minRecordingTime: Double = 10
    var recordingSnapshot: Double = 0
    var normalizedTime: CGFloat?
    var scrubbedTime: Double = 0
    var scrubbed = false
    
    var currentOption: MusicOption?
    var hasMergedTracks = false
    
    var editedDuration: Double = 0
    var startTime: Double = 0
    var endTime: Double = 0
    var wasTrimmed = false
    
    // For various screens
    var imageTopConstant: CGFloat = 120
    var recordButtonBottomConstant: CGFloat = -60
    var lottieWaveTopConstant: CGFloat = 40

    var maxValue: Float = Float(UIScreen.main.bounds.width) - Float(60)
    
    let introTooShortAlert = CustomAlertView(alertType: .shortIntroLength)
    let boothBackOutAlert = CustomAlertView(alertType: .boothBackOut)
    let tooShortAlert = CustomAlertView(alertType: .shortAudioLength)
    let nextVersionAlert = CustomAlertView(alertType: .nextVersion)
    
    
    // When uploading an intro
    var networkingIndicator = NetworkingProgress()
    
    let playBackBars: StaticWaveCreator = {
        let view = StaticWaveCreator()
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.textColor = .white
        return label
    }()
    
    var lottieWave: AnimationView = {
        var animation = AnimationView(name: "lottieWave")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        animation.isHidden = true
        animation.alpha = 0.9
        animation.play()
        return animation
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = hexStringToUIColor(hex: "#FF195A")
        button.layer.cornerRadius = 32
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        button.layer.borderWidth = 6
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(recordButtonPress), for: .touchUpInside)
        return button
    }()
    
    // Progress timer for recording
    let circleTimerView = CircleTimerView()
    
    let stopButtonView: UIView = {
        let view = PassThoughView()
        view.backgroundColor = CustomStyle.primaryRed
        view.layer.cornerRadius = 17.5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    lazy var playBackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = maxValue
        slider.setThumbImage(UIImage(named: "slider-thumb"), for: .normal)
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.white.withAlphaComponent(0.3)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(changePlaybackValue), for: .valueChanged)
        slider.isHidden = true
        return slider
    }()
    
    lazy var audioTrimmer: AudioTrimmerView = {
        let view = AudioTrimmerView()
        view.isHidden = true
        view.trimmerDelegate = self
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(User.username!)"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let rightHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    let leftHandLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textColor = .white
        label.isHidden = true
        return label
    }()
    
    lazy var musicView: BackgroundMusicView = {
        let view = BackgroundMusicView()
        view.isHidden = true
        return view
    }()
    
    let editingButtonsContainer: UIView = {
        let view = PassThoughView()
        return view
    }()
    
    let duneLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "white-dune-logo")
        return imageView
    }()
    
    lazy var episodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let programImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowRadius = 20
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.layer.shouldRasterize = true
        return imageView
    }()
    
    let addFilterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.setImage(UIImage(named: "audio-to-video"), for: .normal)
        button.addTarget(self, action: #selector(addFilterButtonPress), for: .touchUpInside)
        return button
    }()
    
    let trimButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trim-audio-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(trimAudioButtonPress), for: .touchUpInside)
        return button
    }()
    
    let redoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "redo-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(recordAgainButtonPress), for: .touchUpInside)
        return button
    }()
    
    let addMusicButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "music-audio-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addBGMusicButtonPress), for: .touchUpInside)
        return button
    }()
    
    let gradientOverlayView: UIView = {
        let view = UIView()
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        styleForScreens()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        boothBackOutAlert.alertDelegate = self
        configureAudioSessionCategory()
        duneTabBar.isHidden = true
        setupNavigationBar()
        resetEditingModes()
        setProgramImage()
        
        setupEpisodeLabel()
        
        if currentOption != nil {
            addMusic(track: currentOption!)
            if recordingSnapshot < currentOption!.duration {
                recordingSnapshot = currentOption!.duration
                updatePlaybackSliderTimeLabels()
            }
        } else {
            musicView.isHidden = true
        }
        
        if currentScope == .intro {
            episodeLabel.text = "Audio summary"
        }
    }
    
    func setupEpisodeLabel() {
        
        if selectedProgram != nil {
            let episodeCount = selectedProgram!.episodeIDs.count
            episodeLabel.text = "Episode \(episodeCount + 1)"
        } else {
            let episodeCount = CurrentProgram.episodeIDs!.count
            episodeLabel.text = "Episode \(episodeCount + 1)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentState != .preview  {
            playBackBars.isHidden = true
            addEditingButtons()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        if audioPlayer != nil {
            audioPlayer.setVolume(0, fadeDuration: 2)
            self.currentState = .preview
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.audioPlayer.stop()
                self.audioPlayer.volume = 1
                self.audioPlayer.currentTime = 0
                self.playBackSlider.value = 0
                self.recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
                self.pauseSafeRegularPlaybackLink()
            }
        }
        
        if audioPlayer != nil {
            audioPlayer.stop()
        }

    }
    
    @objc func popVC() {
        if currentState != .ready {
            view.addSubview(boothBackOutAlert)
        } else {
            resetViews()
            duneTabBar.isHidden = false
            navigationController?.popViewController(animated: true)
        }
    }
    
    func configureAudioSessionCategory() {
      do {
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .spokenAudio, options: [.defaultToSpeaker, .allowBluetooth])
          try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      } catch {
          print("error.")
      }
    }
    
    @objc func resetViews() {
            self.currentOption = nil
            self.hasMergedTracks = false
            self.currentState = recordState.ready
            self.trimButton.removeFromSuperview()
            self.addFilterButton.removeFromSuperview()
            self.redoButton.removeFromSuperview()
            self.addMusicButton.removeFromSuperview()
            self.navigationController?.popViewController(animated: false)
    }
    
    func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(resetViews))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-button-white"), style: .plain, target: self, action: #selector(popVC))
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.tintColor = .white
//        tabBar!.barTintColor = .none
//        tabBar?.isTranslucent = true
//        tabBar?.isHidden = true
    }
    
    func addGradient() {
        view.addSubview(gradientOverlayView)
        gradientOverlayView.pinEdges(to: view)
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let color = UIColor.black
        gradient.colors = [color.withAlphaComponent(0.0).cgColor, color.withAlphaComponent(0.3).cgColor, color.withAlphaComponent(0.8).cgColor]
        gradientOverlayView.layer.insertSublayer(gradient, at: 0)
        gradientOverlayView.backgroundColor = .clear
    }
    
    func setProgramImage() {
        
        if selectedProgram == nil {
            programImageView.image = CurrentProgram.image
            view.backgroundColor = CurrentProgram.image?.averageColor
        } else {
            programImageView.image = selectedProgram?.image
            view.backgroundColor = selectedProgram!.image!.averageColor
        }
    }
    
    func styleForScreens() {
        switch UIDevice.current.deviceType {
        case .iPhone4S:
            break
        case .iPhoneSE:
            episodeLabel.isHidden = true
            duneLogoImageView.isHidden = true
            imageTopConstant = 80
            recordButtonBottomConstant = -20
            lottieWaveTopConstant = 7
        case .iPhone8:
            recordButtonBottomConstant = -25
            lottieWaveTopConstant = 5
        case .iPhone8Plus:
            recordButtonBottomConstant = -25
            lottieWaveTopConstant = 12
        case .iPhone11:
            lottieWaveTopConstant = 40
            imageTopConstant = 180
        case .iPhone11Pro, .iPhone12:
            lottieWaveTopConstant = 32
            imageTopConstant = 170
        case .iPhone11ProMax, .iPhone12ProMax:
            lottieWaveTopConstant = 40
            imageTopConstant = 190
        case .unknown:
            break
        }
    }
    
    func configureViews() {
        view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIDevice.current.navBarButtonTopAnchor()).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: recordButtonBottomConstant).isActive = true
        recordButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
    
        view.addSubview(circleTimerView)
        circleTimerView.translatesAutoresizingMaskIntoConstraints = false
        circleTimerView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        circleTimerView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        circleTimerView.configureLoadingView()
        
        circleTimerView.addSubview(stopButtonView)
        stopButtonView.translatesAutoresizingMaskIntoConstraints = false
        stopButtonView.centerYAnchor.constraint(equalTo: circleTimerView.centerYAnchor).isActive = true
        stopButtonView.centerXAnchor.constraint(equalTo:circleTimerView.centerXAnchor).isActive = true
        stopButtonView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        stopButtonView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        view.addSubview(programImageView)
        programImageView.translatesAutoresizingMaskIntoConstraints = false
        programImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: imageTopConstant).isActive = true
        programImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        programImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        programImageView.heightAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        programImageView.backgroundColor = .green
        
        view.addSubview(musicView)
        musicView.translatesAutoresizingMaskIntoConstraints = false
        musicView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        musicView.leadingAnchor.constraint(equalTo: programImageView.leadingAnchor).isActive = true
        musicView.trailingAnchor.constraint(equalTo: programImageView.trailingAnchor).isActive = true
        musicView.bottomAnchor.constraint(equalTo: programImageView.bottomAnchor).isActive = true
        
        view.addSubview(episodeLabel)
        episodeLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeLabel.bottomAnchor.constraint(equalTo: programImageView.topAnchor, constant: -20).isActive = true
        episodeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 15).isActive = true
        
        view.addSubview(duneLogoImageView)
        duneLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        duneLogoImageView.centerYAnchor.constraint(equalTo: episodeLabel.centerYAnchor, constant: 0).isActive = true
        duneLogoImageView.trailingAnchor.constraint(equalTo: episodeLabel.leadingAnchor, constant: -10).isActive = true
        duneLogoImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        duneLogoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.topAnchor.constraint(equalTo: programImageView.bottomAnchor, constant: 30).isActive = true
        
        view.addSubview(lottieWave)
        lottieWave.translatesAutoresizingMaskIntoConstraints = false
        lottieWave.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: lottieWaveTopConstant).isActive = true
        lottieWave.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
        lottieWave.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
        lottieWave.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(playBackBars)
        playBackBars.translatesAutoresizingMaskIntoConstraints = false
        playBackBars.topAnchor.constraint(equalTo: programImageView.bottomAnchor).isActive = true
        playBackBars.leadingAnchor.constraint(equalTo: programImageView.leadingAnchor).isActive = true
        playBackBars.trailingAnchor.constraint(equalTo: programImageView.trailingAnchor).isActive = true
        playBackBars.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(audioTrimmer)
        audioTrimmer.translatesAutoresizingMaskIntoConstraints = false
        audioTrimmer.topAnchor.constraint(equalTo: programImageView.bottomAnchor).isActive = true
        audioTrimmer.leadingAnchor.constraint(equalTo: programImageView.leadingAnchor).isActive = true
        audioTrimmer.trailingAnchor.constraint(equalTo: programImageView.trailingAnchor).isActive = true
        audioTrimmer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        audioTrimmer.isHidden = true
    }
    
    func addEditingButtons() {
        view.addSubview(editingButtonsContainer)
        editingButtonsContainer.pinEdges(to: view)
        
        editingButtonsContainer.addSubview(trimButton)
        trimButton.translatesAutoresizingMaskIntoConstraints = false
        trimButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        trimButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        trimButton.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trimButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        
        editingButtonsContainer.addSubview(addFilterButton)
        addFilterButton.translatesAutoresizingMaskIntoConstraints = false
        addFilterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addFilterButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addFilterButton.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        addFilterButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        
        editingButtonsContainer.addSubview(redoButton)
        redoButton.translatesAutoresizingMaskIntoConstraints = false
        redoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        redoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        redoButton.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        redoButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        
        editingButtonsContainer.addSubview(addMusicButton)
        addMusicButton.translatesAutoresizingMaskIntoConstraints = false
        addMusicButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addMusicButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addMusicButton.leadingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        addMusicButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        
        view.addSubview(playBackSlider)
        playBackSlider.translatesAutoresizingMaskIntoConstraints = false
        playBackSlider.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -40).isActive = true
        playBackSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        playBackSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(leftHandLabel)
        leftHandLabel.translatesAutoresizingMaskIntoConstraints = false
        leftHandLabel.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor, constant: 5).isActive = true
        leftHandLabel.leadingAnchor.constraint(equalTo: playBackSlider.leadingAnchor).isActive = true
        
        view.addSubview(rightHandLabel)
        rightHandLabel.translatesAutoresizingMaskIntoConstraints = false
        rightHandLabel.topAnchor.constraint(equalTo: playBackSlider.bottomAnchor, constant: 5).isActive = true
        rightHandLabel.trailingAnchor.constraint(equalTo: playBackSlider.trailingAnchor).isActive = true
    }
    
    @objc func saveIntroAndReturnToProfile() {
        
        if recordingSnapshot >= 10 {
            view.addSubview(networkingIndicator)
            networkingIndicator.taskLabel.text = "Uploading Intro"
            
            print("Storing episode on Firebase")
            let fileExtension = ".\(recordingURL.pathExtension)"
            
            var name: String
            
            if currentOption != nil {
                name = mergedFileName
            } else {
                name = fileName
            }
            
            
            let audioTrack = FileManager.getAudioFileFromTempDirectory(fileName: name, fileExtension: fileExtension)
            
            guard let episode = audioTrack else { return }

            FireStorageManager.storeIntroAudio(fileName: fileName + fileExtension, data: episode) { url in
                
                if self.selectedProgram == nil {
                    CurrentProgram.hasIntro = true
                    CurrentProgram.introPath = url.path
                    CurrentProgram.introID = self.fileName + fileExtension
                    
                    if !CurrentProgram.repMethods!.contains("intro") {
                        FireStoreManager.updateProgramRep(programID: CurrentProgram.ID!, repMethod: "intro", rep: 10)
                        CurrentProgram.repMethods?.append("intro")
                        CurrentProgram.rep! += 10
                    }
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        FireStoreManager.addIntroToProgram(programID: CurrentProgram.ID!, introID: self.fileName + fileExtension, introPath: url.path)
                    }
                } else {
                    let program = self.getSelectedProgram()
                    program.introID = self.fileName + fileExtension
                    program.introPath = url.path
                    program.hasIntro = true
                    DispatchQueue.global(qos: .userInitiated).async {
                        FireStoreManager.addIntroToProgram(programID: program.ID, introID: self.fileName + fileExtension, introPath: url.path)
                    }
                    if !program.repMethods.contains("intro") {
                        FireStoreManager.updateProgramRep(programID: program.ID, repMethod: "intro", rep: 10)
                        FireStoreManager.updateProgramMethodsUsed(programID: program.ID, repMethod: "intro")
                        program.rep += 10
                        guard let index = CurrentProgram.subPrograms?.firstIndex(where: { $0.ID == program.ID }) else { return }
                        CurrentProgram.subPrograms![index] = program
                    }
                }
                
                self.networkingIndicator.removeFromSuperview()
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            view.addSubview(introTooShortAlert)
        }
    }
    
    func getSelectedProgram() -> Program {
        let program = CurrentProgram.subPrograms?.first(where: { $0.ID == selectedProgram?.ID })
        return program!
    }
    
    // MARK: Continue Button Press
    
    @objc func continueButtonPress() {
        let duration: Double
        
        if wasTrimmed {
            duration = editedDuration
        } else {
            duration = recordingSnapshot
        }
        
        if duration >= minRecordingTime {
            let addEpisodeDetails = AddEpisodeDetails()
            addEpisodeDetails.recordingURL = recordingURL
            addEpisodeDetails.wasTrimmed = wasTrimmed
            addEpisodeDetails.startTime = startTime
            addEpisodeDetails.endTime = endTime
            addEpisodeDetails.duration = (recordingSnapshot - endTime)
            
            if currentOption != nil {
                addEpisodeDetails.episodeFileName = mergedFileName
            } else {
                addEpisodeDetails.episodeFileName = fileName
            }
            
            if selectedProgram != nil {
                addEpisodeDetails.selectedProgram = selectedProgram
            }
            
            navigationController?.pushViewController(addEpisodeDetails, animated: true)
        } else {
            print("Too short of a recording")
            view.addSubview(tooShortAlert)
        }
    }
    
    func addMusic(track: MusicOption) {
        musicView.addTrackDetails(track: track)
        musicView.isHidden = false
    }
    
    
    // MARK: Record button press
   @objc func recordButtonPress() {
        switch currentState {
        case .ready:
            circleTimerView.animate()
            currentState = .recording
            recordButton.layer.borderColor = UIColor.clear.cgColor
            recordButton.setImage(nil, for: .normal)
            startRecording()
            recordingSnapshot = 0
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        case .recording:
            currentState = .preview
            timerLabel.text = "0:00"
            circleTimerView.terminate()
            finishRecording(success: true)
            lottieWave.isHidden = true
            recordingDisplayLink.isPaused = true
            recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
            recordButton.backgroundColor = CustomStyle.white
            playBackSlider.isHidden = false
            stopButtonView.isHidden = true
            transitionEditingButtons()
            timerLabel.isHidden = true
            rightHandLabel.isHidden = false
            leftHandLabel.isHidden = false
            updatePlaybackSliderTimeLabels()
            if currentScope == .intro {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Use", style: .plain, target: self, action: #selector(saveIntroAndReturnToProfile))
                navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            } else {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(continueButtonPress))
                navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
            }
        case .preview:
            currentState = .playing
            playBackSlider.setValue(0.0, animated: false)
            recordButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)

            if currentOption == nil || hasMergedTracks {
                trackAudio()
                playDefaultRecording()
            } else if !hasMergedTracks {
                FileManager.getMusicURLWith(audioID: currentOption!.lowAudioID) { url in
                    self.playMerge(audio1: self.recordingURL, audio2: url)
                    self.hasMergedTracks = true
                }
            }
        case .playing:
            pausePlayback()
            currentState = .paused
            recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        case .paused:
            currentState = .playing
            recordButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
            resumeRegularPlayback()
        }
    }
    
    @objc func recordAgainButtonPress() {
        
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        currentOption = nil
        //        hasMergedTracks = false
        musicView.isHidden = true
        resetEditingModes()
        currentState = .ready
        timerLabel.text = "0:00"
        
        recordButton.backgroundColor = hexStringToUIColor(hex: "#FF195A")
        recordButton.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        recordButton.setImage(UIImage(), for: .normal)
        
        audioTrimmer.resetTrimmer()
        timerLabel.isHidden = false
        rightHandLabel.isHidden = true
        leftHandLabel.isHidden = true
        wasTrimmed = false
        startTime = 0
        endTime = 0
        
        playBackBars.isHidden = true
        playBackSlider.isHidden = true
        pauseSafeRegularPlaybackLink()
        playBackSlider.setValue(0.0, animated: false)
        
        addFilterButton.removeFromSuperview()
        addMusicButton.removeFromSuperview()
        trimButton.removeFromSuperview()
        redoButton.removeFromSuperview()
        addEditingButtons()
    }
    
    func transitionEditingButtons() {
        CustomAnimation.transitionFilter(button: addFilterButton, to: recordButton)
        CustomAnimation.transitionMusic(button: addMusicButton, to: recordButton)
        CustomAnimation.transitionTrim(button: trimButton, to: recordButton)
        CustomAnimation.transitionRedo(button: redoButton, to: recordButton)
    }
    
    func trackAudio() {
        playbackDisplayLink = CADisplayLink(target: self, selector: #selector(trackRegularPlayback))
        playbackDisplayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func trackRegularPlayback() {
        
        if audioPlayer.currentTime >= (recordingSnapshot - endTime) {
            playbackDisplayLink.isPaused = true
        }
        
        if audioPlayer.currentTime >= (recordingSnapshot - endTime) - 1.5 {
            audioPlayer.setVolume(0.5, fadeDuration: 1.5)
        }
        
        if wasTrimmed && audioPlayer.currentTime >= (recordingSnapshot - endTime) {
            audioPlayer.stop()
            print("Stopping trimmed audio")
            audioPlayerDidFinishPlaying(audioPlayer, successfully: true)
        } else {
            normalizedTime = CGFloat((audioPlayer.currentTime *  Double(maxValue)) / recordingSnapshot)
            playBackSlider.setValue(Float(normalizedTime!), animated: false)
//            playBackBars.playbackCoverLeading.constant = normalizedTime!
            timerLabel.text = timeString(time: audioPlayer.currentTime)
            
            let leftTime = timeIn()
            let rightTime = timeToGo()
            
            leftHandLabel.text = timeString(time: leftTime)
            rightHandLabel.text = timeString(time: rightTime)
        }
    }
    
    // Trimming a recording
    @objc func trimAudioButtonPress() {
        
        if !audioTrimmer.isHidden {
            resetEditingModes()
        } else {
            resetEditingModes()
            trimButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            playBackBars.isHidden = false
            audioTrimmer.isHidden = false
            audioTrimmer.rightHandLabel.text = timeString(time: recordingSnapshot)
            timerLabel.isHidden = true
            playBackBars.playbackCover.isHidden = true
            playBackBars.showTrimWave()
            startTime = 0.0
        }
    }
    
    @objc func addFilterButtonPress() {
        resetEditingModes()
        view.addSubview(nextVersionAlert)
    }
    
    // MARK: BackGround music
    @objc func addBGMusicButtonPress() {
        resetEditingModes()
        let musicVC = AddBGMusicVC()
        if currentOption != nil {
            musicVC.selectedTrack = currentOption
        }
        musicVC.musicDelegate = self
        navigationController?.pushViewController(musicVC, animated: true)
    }
    
    func resetEditingModes() {
        audioTrimmer.isHidden = true
        view.backgroundColor = CurrentProgram.image?.averageColor
        trimButton.backgroundColor = .clear
        programImageView.isHidden = false
        gradientOverlayView.isHidden = false
        playBackBars.isHidden = true
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
    func playMerge(audio1: URL, audio2:  URL) {
        
        var recordedURL: URL
        
        if voiceURL != nil {
            recordedURL = voiceURL!
        } else {
            recordedURL = audio1
            voiceURL = audio1
        }
        
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
        let compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

        let tempDirectory = FileManager.getTempDirectory()
        let destinationUrl = tempDirectory.appendingPathComponent(mergedFileName + ".m4a")
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: destinationUrl.path) {
            do {
                try fileManager.removeItem(at: destinationUrl)
            }
            catch let error as NSError {
                print("The error is: \(error)")
            }
        }
        
        let url1 = recordedURL
        let url2 = audio2
        
        let avAsset1 = AVURLAsset(url: url1 as URL, options: nil)
        let avAsset2 = AVURLAsset(url: url2 as URL, options: nil)
        
        let tracks1 = avAsset1.tracks(withMediaType: AVMediaType.audio)
        let tracks2 = avAsset2.tracks(withMediaType: AVMediaType.audio)
        
        let assetTrack1: AVAssetTrack = tracks1[0]
        let assetTrack2: AVAssetTrack = tracks2[0]
        
        let duration1 = Double(avAsset1.duration.value) / Double(avAsset1.duration.timescale)
        let duration2 = Double(avAsset2.duration.value) / Double(avAsset2.duration.timescale)
        
        let trueDuration1: CMTime = CMTime(seconds: duration1 - editedDuration, preferredTimescale: 1)
        let trueDuration2: CMTime = CMTime(seconds: duration2 - editedDuration, preferredTimescale: 1)
        
        let timeRange1 = CMTimeRangeMake(start: CMTime(seconds: startTime, preferredTimescale: 1), duration: trueDuration1)
        let timeRange2 = CMTimeRangeMake(start: CMTime(seconds: startTime, preferredTimescale: 1), duration: trueDuration2)

        do {
            try compositionAudioTrack1.insertTimeRange(timeRange1, of: assetTrack1, at: CMTime.zero)
            try compositionAudioTrack2.insertTimeRange(timeRange2, of: assetTrack2, at: CMTime.zero)
        }
        catch {
            print("The darn error is: \(error)")
        }
        
        let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
        assetExport?.outputFileType = AVFileType.m4a
        assetExport?.outputURL = destinationUrl
        
        assetExport?.exportAsynchronously(completionHandler: {
            switch assetExport!.status {
            case AVAssetExportSessionStatus.failed:
                print("failed \(assetExport!.error!)")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(assetExport!.error!)")
            case AVAssetExportSessionStatus.unknown:
                print("unknown\(assetExport!.error!)")
            case AVAssetExportSessionStatus.waiting:
                print("waiting\(assetExport!.error!)")
            case AVAssetExportSessionStatus.exporting:
                print("exporting\(assetExport!.error!)")
            default:
                DispatchQueue.main.async {
                    self.recordingURL = destinationUrl
                    self.playDefaultRecording()
                }
            }
        })
    }
    
    func duration(for resource: String) -> Double {
        let asset = AVURLAsset(url: URL(fileURLWithPath: resource))
        return Double(CMTimeGetSeconds(asset.duration))
    }
}

// Audio Extensions
extension RecordBoothVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pauseSafeRegularPlaybackLink()
        playBackSlider.setValue(Float(audioTrimmer.doubleSlider.value.first!), animated: false)
        recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        currentState = .preview
        timerLabel.text = "0:00"
        print("Player Ended")
    }
    
    func startRecording() {
        recordingURL = FileManager.getTempDirectory().appendingPathComponent(fileName + ".m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            lottieWave.isHidden = false
            audioRecorder.isMeteringEnabled = true
            recordingDisplayLink = CADisplayLink(target: self, selector: #selector(updateMeters))
            recordingDisplayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            recordingDisplayLink.isPaused = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    @objc func updateMeters() {
        audioRecorder.updateMeters()
        timerLabel.text = timeString(time: audioRecorder.currentTime)
        if audioRecorder.currentTime >= maxRecordingTime {
            recordButtonPress()
        }
    }
    
    func finishRecording(success: Bool) {
        recordingSnapshot = audioRecorder.currentTime
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Success recording")
            playBackBars.setupPlaybackBars(url: recordingURL, snapshot: recordingSnapshot)
        } else {
            print("Recording failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    // PLAY
    func playDefaultRecording() {
        audioPlayer = try! AVAudioPlayer(contentsOf: recordingURL)
        playSafeRegularPlaybackLink()
        audioPlayer.volume = 1
        
        if wasTrimmed {
            print("play trimmed")
            audioPlayer.currentTime = startTime
        }
        
        if scrubbed == true {
            print("play scrubbed")
            audioPlayer.currentTime = scrubbedTime
            scrubbed = false
            audioPlayer.delegate = self
            audioPlayer.play()
        } else {
            timerLabel.text = "0:00"
            audioPlayer.delegate = self
            audioPlayer.play()
        }
    }
    
    func pausePlayback() {
        print("pause")
        audioPlayer.pause()
        pauseSafeRegularPlaybackLink()
    }
    
    func resumeRegularPlayback() {
        playSafeRegularPlaybackLink()
        if scrubbed == true {
            audioPlayer = try! AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = scrubbedTime
            scrubbed = false
            audioPlayer.delegate = self
            audioPlayer.play()
        } else {
            audioPlayer.delegate = self
            audioPlayer.play()
        }
    }
    
    @objc func changePlaybackValue() {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        pauseSafeRegularPlaybackLink()
        currentState = .paused
        recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        
        let leftTime = timeIn()
        let rightTime = timeToGo()
        
        leftHandLabel.text = timeString(time: leftTime)
        rightHandLabel.text = timeString(time: rightTime)
        
        scrubbed = true
    }
    
    func updatePlaybackSliderTimeLabels() {
        let leftTime = timeIn()
        let rightTime = timeToGo()
        
        leftHandLabel.text = timeString(time: leftTime)
        rightHandLabel.text = timeString(time: rightTime)
    }
    
    func timeIn() -> Double {
        let percent = CGFloat(playBackSlider.value / maxValue) * 100
        let timePercent = CGFloat(recordingSnapshot / 100) * percent
        scrubbedTime = Double(timePercent)
        return scrubbedTime
    }
    
    func timeToGo() -> Double {
        let percent = CGFloat(playBackSlider.value / maxValue) * 100
        let timePercent = CGFloat(recordingSnapshot / 100) * percent
        scrubbedTime = Double(timePercent)
        return recordingSnapshot - scrubbedTime
    }
    
    func pauseSafeRegularPlaybackLink() {
        if let link = playbackDisplayLink {
            link.isPaused = true
        }
    }
    
    func playSafeRegularPlaybackLink() {
        if let link = playbackDisplayLink {
            link.isPaused = false
        } else {
            trackAudio()
        }
    }
}

extension RecordBoothVC: TrimmerDelegate {
    
    func trimmerChangedValue() {
        let timeValue = recordingSnapshot / Double(maxValue)
        
        let rightTimeDifference =  CGFloat(maxValue) - audioTrimmer.doubleSlider.value.last!
        let rightTime = Double(rightTimeDifference) * timeValue
        
        let leftTimeDifference = audioTrimmer.doubleSlider.value.first!
        let leftTime = Double(leftTimeDifference) * timeValue
        
        audioTrimmer.leftHandLabel.text =  timeString(time: leftTime)
        audioTrimmer.rightHandLabel.text = timeString(time: recordingSnapshot - rightTime)
        
        editedDuration = (recordingSnapshot - rightTime) - leftTime
        
        startTime = leftTime
        endTime = rightTime
        
        if editedDuration != recordingSnapshot {
            wasTrimmed = true
        } else {
            wasTrimmed = false
        }
    }
}

extension RecordBoothVC: BackgroundMusicDelegate {
    
    func handleRemovedMusic() {
        if voiceURL != nil {
            recordingURL = voiceURL
            recordingSnapshot = duration(for: recordingURL.path)
        }
            audioTrimmer.resetTrimmer()
            currentOption = nil
            wasTrimmed = false
            scrubbed = false
            editedDuration = 0
            startTime = 0
            endTime = 0
    }
    
    func addCurrentOption(track: MusicOption) {
        currentOption = track
        audioTrimmer.resetTrimmer()
        hasMergedTracks = false
        wasTrimmed = false
        scrubbed = false
        editedDuration = 0
        startTime = 0
        endTime = 0
    }
}

extension RecordBoothVC: CustomAlertDelegate {
    
    func primaryButtonPress() {
        duneTabBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    func cancelButtonPress() {
        //
    }

}

