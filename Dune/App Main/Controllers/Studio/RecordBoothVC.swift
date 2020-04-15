//
//  recordBoothVC.swift
//  Dune
//
//  Created by Waylan Sands on 16/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

class RecordBoothVC: UIViewController {
    
    enum recordState {
        case ready
        case recording
        case preview
        case playing
        case paused
    }
    
    enum mode {
        case regularPlayback
        case trimming
        case filters
        case backgroundMusic
    }
    
    var recordingWaveFeedbackLink: CADisplayLink!
    var regularPlaybackLink: CADisplayLink!
    var presetPlaybackLink: CADisplayLink!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var engine: AVAudioEngine!
    
    var recordingURL: URL!
    
    var waveWidth: Double?
    var normalizedTime: CGFloat?
    var sliderValue: Float?
    var maxValue: Float = 382
    
    var currentState = recordState.ready
    var currentMode: mode?
    var maxRecordingTime: Double = 60
    var recordingSnapshot: Double = 0
    var scrubbedTime: Double = 0
    var scrubbed = false
    var timer = Timer()
    
    var wastrimmed = false
    var editedDuration: Double?
    var startTime: Double = 0
    var endTime: Double = 0
        
    lazy var tabBar = navigationController?.tabBarController?.tabBar
    lazy var drumUrl = Bundle.main.url(forResource: "drums", withExtension: "mp3")

    
    let responsiveSoundWave: ResponsiveWaveformView = {
        let view = ResponsiveWaveformView()
        view.waveColor = CustomStyle.primaryBlue
        view.backgroundColor = CustomStyle.onboardingBlack
        view.isHidden = true
        return view
    }()
    
    let playBackBars: StaticWaveCreator = {
        let view = StaticWaveCreator()
        view.isHidden = true
        return view
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont.systemFont(ofSize: 29, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.primaryYellow
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(setupRecordingSession), for: .touchUpInside)
        button.setImage(UIImage(named: "record-audio-icon"), for: .normal)
        return button
    }()
    
    let stopButtonView: UIView = {
        let view = PassThoughView()
        view.backgroundColor = CustomStyle.primaryRed
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    let circleTimerView: LoadingCircleView = {
        let view = LoadingCircleView()
        return view
    }()
    
    lazy var playBackSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = maxValue
        slider.setThumbImage(UIImage(named: "slider-thumb"), for: .normal)
        slider.minimumTrackTintColor = CustomStyle.fithShade
        slider.maximumTrackTintColor = CustomStyle.fithShade
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
    
    lazy var musicView: BackgroundMusicView = {
        let view = BackgroundMusicView()
        view.isHidden = true
        return view
    }()
    
    let editingButtonsContainer: UIView = {
        let view = PassThoughView()
        return view
    }()
    
    let addFilterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.seventhShade
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.setImage(UIImage(named: "filter-audio-icon"), for: .normal)
        button.addTarget(self, action: #selector(addFilterButtonPress), for: .touchUpInside)
        return button
    }()
    
    let trimButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.seventhShade
        button.setImage(UIImage(named: "trim-audio-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(trimAudioButtonPress), for: .touchUpInside)
        return button
    }()
    
    let redoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.seventhShade
        button.setImage(UIImage(named: "switch-account-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(recordAgainButtonPress), for: .touchUpInside)
        return button
    }()
    
    let addMusicButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.seventhShade
        button.setImage(UIImage(named: "music-audio-icon"), for: .normal)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addBGMusicButtonPress), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomStyle.onboardingBlack
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        resetEditingModes()
        
        if Track.trackOption != nil {
            addMusic(track: Track.trackOption!)
        } else {
            musicView.isHidden = true
            print("music view was ment to be hidden")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if currentState != .preview {
            addEditingButtons()
        }
    }
    
   @objc func resetViews() {
        currentState = recordState.ready
        trimButton.removeFromSuperview()
        addFilterButton.removeFromSuperview()
        redoButton.removeFromSuperview()
        addMusicButton.removeFromSuperview()
        navigationController?.popViewController(animated: false)
    }
    
    func setupNavigationBar() {
//        self.title = "Record"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let imgBackArrow = #imageLiteral(resourceName: "back-button-white")
        navigationController?.navigationBar.backIndicatorImage = imgBackArrow
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = imgBackArrow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(resetViews))
        
        let navBar = navigationController?.navigationBar
        navBar?.barStyle = .black
        navBar?.setBackgroundImage(UIImage(), for: .default)
        navBar?.shadowImage = UIImage()
        navBar?.tintColor = .white
        tabBar?.isHidden = true
    }
    
    func configureViews() {
        view.addSubview(playBackBars)
        playBackBars.translatesAutoresizingMaskIntoConstraints = false
        playBackBars.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        playBackBars.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        playBackBars.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playBackBars.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(responsiveSoundWave)
        responsiveSoundWave.translatesAutoresizingMaskIntoConstraints = false
        responsiveSoundWave.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
        responsiveSoundWave.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        responsiveSoundWave.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        responsiveSoundWave.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(timerLabel)
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: (view.frame.width / 2) - (timerLabel.intrinsicContentSize.width / 2) - 7).isActive = true
        timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        view.addSubview(recordButton)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        recordButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(circleTimerView)
        circleTimerView.translatesAutoresizingMaskIntoConstraints = false
        circleTimerView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        circleTimerView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        circleTimerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        circleTimerView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        circleTimerView.setupLoadingAnimation()
        
        circleTimerView.addSubview(stopButtonView)
        stopButtonView.translatesAutoresizingMaskIntoConstraints = false
        stopButtonView.centerYAnchor.constraint(equalTo: circleTimerView.centerYAnchor).isActive = true
        stopButtonView.centerXAnchor.constraint(equalTo:circleTimerView.centerXAnchor).isActive = true
        stopButtonView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        stopButtonView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(audioTrimmer)
        audioTrimmer.translatesAutoresizingMaskIntoConstraints = false
        audioTrimmer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40).isActive = true
        audioTrimmer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        audioTrimmer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        audioTrimmer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        audioTrimmer.isHidden = true
        
        view.addSubview(musicView)
        musicView.translatesAutoresizingMaskIntoConstraints = false
        musicView.heightAnchor.constraint(equalToConstant: 66).isActive = true
        musicView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        musicView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        musicView.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: -150).isActive = true
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
        playBackSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        playBackSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    @objc func saveButtonPress() {
        let newEp = AddEpisodeDetails()
        navigationController?.pushViewController(newEp, animated: true)
        
    }
    
    func addMusic(track: MusicOption) {
        musicView.addTrackDetails(track: track)
        musicView.isHidden = false
    }
    
    func recordButtonPress() {
        switch currentState {
        case .ready:
            circleTimerView.animate()
            currentState = .recording
            responsiveSoundWave.isHidden = false
            stopButtonView.isHidden = false
            recordButton.backgroundColor = .clear
            recordButton.setImage(nil, for: .normal)
            startRecording()
            recordingSnapshot = 0
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        case .recording:
            currentState = .preview
            timerLabel.text = "0:00"
            circleTimerView.terminate()
            finishRecording(success: true)
            responsiveSoundWave.isHidden = true
            recordingWaveFeedbackLink.isPaused = true
            recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
            recordButton.backgroundColor = CustomStyle.primaryYellow
            playBackSlider.isHidden = false
            stopButtonView.isHidden = true
            transitionEditingButtons()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Continue", style: .plain, target: self, action: #selector(saveButtonPress))
            navigationItem.rightBarButtonItem!.setTitleTextAttributes(CustomStyle.barButtonAttributes, for: .normal)
        case .preview:
            currentState = .playing
            playBackSlider.setValue(0.0, animated: false)
            recordButton.setImage(UIImage(named: "pause-audio-icon"), for: .normal)
            trackAudio()
            playDefaultRecording()
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
    
    // Make another Recording
    @objc func recordAgainButtonPress() {
        if audioPlayer != nil {
            audioPlayer.stop()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        Track.trackOption = nil
        musicView.isHidden = true
        resetEditingModes()
        currentState = .ready
        timerLabel.text = "0:00"
        audioTrimmer.isHidden = true
        playBackBars.isHidden = true
        playBackSlider.isHidden = true
        pauseSafeRegularPlaybackLink()
        playBackSlider.setValue(0.0, animated: false)
        recordButton.setImage(UIImage(named: "record-audio-icon"), for: .normal)
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
    
    // Get permission to record
    @objc func setupRecordingSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButtonPress()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    
    func trackAudio() {
        regularPlaybackLink = CADisplayLink(target: self, selector: #selector(trackRegularPlayback))
        regularPlaybackLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func trackRegularPlayback() {
        if audioPlayer.currentTime >= (recordingSnapshot - endTime) {
            regularPlaybackLink.isPaused = true
        }
        
        if wastrimmed && audioPlayer.currentTime >= (recordingSnapshot - endTime) {
            audioPlayer.stop()
            print("Stopping trimmed audio")
            audioPlayerDidFinishPlaying(audioPlayer, successfully: true)
        } else {
            normalizedTime = CGFloat((audioPlayer.currentTime *  Double(maxValue)) / recordingSnapshot)
            playBackSlider.setValue(Float(normalizedTime!), animated: false)
            playBackBars.playbackCoverLeading.constant = normalizedTime!
            timerLabel.text = timeString(time: audioPlayer.currentTime)
        }
    }
    
    // Trimming a recording
    @objc func trimAudioButtonPress() {
        resetEditingModes()
        trimButton.backgroundColor = .white
        trimButton.setImage(UIImage(named: "trim-audio-selected"), for: .normal)
        
        audioTrimmer.isHidden = false
        playBackBars.playbackCover.isHidden = true
        playBackBars.showTrimWave()
        
        setRightTimeLabel()
        startTime = 0.0
//        endTime = recordingSnapshot
    }
    
    func setRightTimeLabel()  {
        let rightPercent = (audioTrimmer.doubleslider.value.last! / CGFloat(maxValue)) * 100
        let rightTimePercent = CGFloat(recordingSnapshot / 100) * rightPercent
        let rightTime = Double(rightTimePercent)
        
        audioTrimmer.rightHandLabel.text = timeString(time: rightTime)
    }
    
    @objc func addFilterButtonPress() {
        print("should dismiss")
        resetEditingModes()
        addFilterButton.backgroundColor = .white
        addFilterButton.setImage(UIImage(named: "filter-audio-selected"), for: .normal)
    }
    
    @objc func addBGMusicButtonPress() {
        resetEditingModes()
        addMusicButton.backgroundColor = .white
        addMusicButton.setImage(UIImage(named: "music-audio-selected"), for: .normal)
        
        let musicVC = AddBGMusicVC()
        navigationController?.pushViewController(musicVC, animated: true)
    }
    
    func resetEditingModes() {
        audioTrimmer.isHidden = true
        
        trimButton.backgroundColor = CustomStyle.seventhShade
        trimButton.setImage(UIImage(named: "trim-audio-icon"), for: .normal)
        
        addFilterButton.backgroundColor = CustomStyle.seventhShade
        addFilterButton.setImage(UIImage(named: "filter-audio-icon"), for: .normal)
        
        addMusicButton.backgroundColor = CustomStyle.seventhShade
        addMusicButton.setImage(UIImage(named: "music-audio-icon"), for: .normal)
        
        playBackBars.isHidden = false
        playBackBars.playbackCover.isHidden = false
        
        playBackBars.resetPrimaryWave()
    }
    
    // Helper Time String
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
    func playmerge(audio1: URL, audio2:  URL) {
       
        let composition = AVMutableComposition()
        let compositionAudioTrack1:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!
        let compositionAudioTrack2:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID())!

        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        let destinationUrl = documentDirectoryURL.appendingPathComponent("resultmerge.m4a")

        let filemanager = FileManager.default
        if (!filemanager.fileExists(atPath: destinationUrl.path)) {
            do {
                try filemanager.removeItem(at: destinationUrl)
            }
           
            catch let error as NSError {
               print("The error is: \(error)")
            }
        } else {
            do {
                try filemanager.removeItem(at: destinationUrl)
            } catch let error as NSError {
                 print("The error is: \(error)")
            }
        }

        let url1 = audio1
        let url2 = audio2

        let avAsset1 = AVURLAsset(url: url1 as URL, options: nil)
        let avAsset2 = AVURLAsset(url: url2 as URL, options: nil)

        let tracks1 = avAsset1.tracks(withMediaType: AVMediaType.audio)
        let tracks2 = avAsset2.tracks(withMediaType: AVMediaType.audio)

        let assetTrack1:AVAssetTrack = tracks1[0]
        let assetTrack2:AVAssetTrack = tracks2[0]

        let duration1: CMTime = assetTrack1.timeRange.duration
        let duration2: CMTime = assetTrack2.timeRange.duration

        let timeRange1 = CMTimeRangeMake(start: CMTime.zero, duration: duration1)
        let timeRange2 = CMTimeRangeMake(start: CMTime.zero, duration: duration2)
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
                print("complete")
            }

            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: destinationUrl)
                self.audioPlayer.numberOfLoops = 0
                self.audioPlayer.prepareToPlay()
                self.audioPlayer.volume = 1.0
                self.audioPlayer.play()
                self.audioPlayer.delegate=self
            }
            catch let error as NSError {
                print(error)
            }
        })
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)

            // if you want to filter the directory contents you can do like this:
            let mp3Files = directoryContents.filter{ $0.pathExtension == "m4a" }
            print("mp3 urls:",mp3Files)
            let mp3FileNames = mp3Files.map{ $0.deletingPathExtension().lastPathComponent }
            print("mp3 list:", mp3FileNames)

        } catch {
            print(error)
        }
    }
    
}

// Audio Extensions

extension RecordBoothVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        pauseSafeRegularPlaybackLink()
        playBackSlider.setValue(Float(audioTrimmer.doubleslider.value.first!), animated: false)
        recordButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
        playBackBars.playbackCoverLeading.constant = 0
        currentState = .preview
        timerLabel.text = "0:00"
        print("Player Ended")
    }
    
    func startRecording() {
        recordingURL = FileManager.getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            recordingWaveFeedbackLink = CADisplayLink(target: self, selector: #selector(updateMeters))
            recordingWaveFeedbackLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
            recordingWaveFeedbackLink.isPaused = false
        } catch {
            finishRecording(success: false)
        }
    }
    
    @objc func updateMeters() {
        audioRecorder.updateMeters()
        let normalizedValue = pow(10, audioRecorder.averagePower(forChannel: 0) / 20)
        responsiveSoundWave.updateWithLevel(CGFloat(normalizedValue))
        
        timerLabel.text = timeString(time: audioRecorder.currentTime)
        
        if audioRecorder.currentTime >= maxRecordingTime {
            currentState = .preview
            timer.invalidate()
        }
    }
    
    func finishRecording(success: Bool) {
        recordingSnapshot = audioRecorder.currentTime
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Success recording")
            playBackBars.setupPlaybackBars(url: recordingURL, snapshot: recordingSnapshot)
            playBackBars.resetPrimaryWave()
            playBackBars.isHidden = false
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
        
        audioPlayer.prepareToPlay()
        playSafeRegularPlaybackLink()
        
        if wastrimmed {
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
        print("resume")
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
        playBackBars.playbackCoverLeading.constant = CGFloat(playBackSlider.value)
        let percent = CGFloat(playBackSlider.value / maxValue) * 100
        let timePercent = CGFloat(recordingSnapshot / 100) * percent
        scrubbedTime = Double(timePercent)
        timerLabel.text = timeString(time: scrubbedTime)
        scrubbed = true
    }
    
    func pauseSafeRegularPlaybackLink() {
        if let link = regularPlaybackLink {
            link.isPaused = true
        }
    }
    
    func playSafeRegularPlaybackLink() {
        if let link = regularPlaybackLink {
            link.isPaused = false
        } else {
            trackAudio()
        }
    }
}

extension RecordBoothVC: TrimmerDelegate {
    
    func trimmerChangedValue() {
        let timeValue = recordingSnapshot / Double(maxValue)
        
        let rightTimeDifference =  CGFloat(maxValue) - audioTrimmer.doubleslider.value.last!
        let rightTime = Double(rightTimeDifference) * timeValue
        
        let leftTimeDifference = audioTrimmer.doubleslider.value.first!
        let leftTime = Double(leftTimeDifference) * timeValue
        
        audioTrimmer.leftHandLabel.text = timeString(time: leftTime)
        audioTrimmer.rightHandLabel.text = timeString(time: recordingSnapshot - rightTime)
        
        editedDuration = (recordingSnapshot - rightTime) - leftTime
        
        startTime = leftTime
        endTime = rightTime
        
        if editedDuration != recordingSnapshot {
            wastrimmed = true
        } else {
            wastrimmed = false
        }
    }
}

