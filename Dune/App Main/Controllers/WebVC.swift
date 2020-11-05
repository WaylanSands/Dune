//
//  WebVC.swift
//  Dune
//
//  Created by Waylan Sands on 7/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import WebKit

protocol NavBarPlayerDelegate: class {
    func playOrPauseEpisode()
}

class WebVC: UIViewController {
    
    enum PlaybackStatus {
        case paused
        case playing
        case ready
    }
    
    var url: URL!
    
    var currentStatus: PlaybackStatus? {
        didSet {
            switch currentStatus {
            case .paused:
                print("paused")
                addPauseIcon()
            case .playing:
                print("playing")
                addPlayIcon()
            case .ready:
                hidePlayBackOptions()
            case .none:
                print("not yet set")
            }
        }
    }
    
    let playbackCircleView = PlaybackCircleView()
    let loadingCircle = LoadingAudioView()
    
    var delegate: NavBarPlayerDelegate!
    var webView = WKWebView()
    
    let playbackButton: ExtendedButton = {
        let button = ExtendedButton()
        button.setImage(UIImage(named: "play-music-icon"), for: .normal)
        button.addTarget(self, action: #selector(playbackButtonPress), for: .touchUpInside)
        button.padding = 20
        return button
    }()
    
    func addPauseIcon() {
        playbackButton.setImage(UIImage(named: "play-music-icon"), for: .normal)
    }
    
    func addPlayIcon() {
         playbackButton.setImage(UIImage(named: "pause-music-icon"), for: .normal)
    }
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = CustomStyle.primaryBlue
        view.sizeToFit()
        return view
    }()
        
    let backButton = UIBarButtonItem(image: UIImage(named: "backWeb-icon"), style: .plain, target: self, action: #selector(backPress))
    let forwardButton = UIBarButtonItem(image: UIImage(named: "forwardWeb-icon"), style: .plain, target: self, action: #selector(forwardPress))
    let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let reloadButton = UIBarButtonItem(image: UIImage(named: "reloadWeb-icon"), style: .plain, target: self, action: #selector(refreshPress))

    let toolbar: UIToolbar = {
        let bar = UIToolbar()
        return bar
    }()
    
    let customNavBar: CustomNavBar = {
       let navBar = CustomNavBar()
        navBar.leftButton.setImage(#imageLiteral(resourceName: "drop-arrow"), for: .normal)
        navBar.backgroundColor = CustomStyle.blackNavBar
        navBar.leftButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        return navBar
    }()
    
    required init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.modalPresentationStyle = .fullScreen
        self.url = url
        if let host = url.absoluteURL.host {
            customNavBar.titleLabel.text = host
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        playbackCircleView.setupNavBarCircle()
        
        view.addSubview(customNavBar)
        customNavBar.pinNavBarTo(view)
        
        customNavBar.addSubview(playbackButton)
        playbackButton.translatesAutoresizingMaskIntoConstraints = false
        playbackButton.centerYAnchor.constraint(equalTo: customNavBar.leftButton.centerYAnchor).isActive = true
        playbackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        playbackButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        playbackButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        customNavBar.addSubview(playbackCircleView)
        playbackCircleView.translatesAutoresizingMaskIntoConstraints = false
        playbackCircleView.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0).isActive = true
        playbackCircleView.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor, constant: 0).isActive = true
        playbackCircleView.backgroundColor = .red
        
        customNavBar.addSubview(loadingCircle)
        loadingCircle.translatesAutoresizingMaskIntoConstraints = false
        loadingCircle.centerYAnchor.constraint(equalTo: playbackButton.centerYAnchor, constant: 0).isActive = true
        loadingCircle.centerXAnchor.constraint(equalTo: playbackButton.centerXAnchor, constant: 0).isActive = true
        loadingCircle.setupLoadingAnimation()
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor).isActive =  true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =  true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive =  true
        
        view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =  true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        toolbar.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive =  true
        
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor).isActive =  true
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive =  true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fixedSpace.width = 40
        toolbar.setItems([backButton, fixedSpace, forwardButton, spacer, reloadButton], animated: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
            if progressView.progress == 1 {
                progressView.isHidden = true
            }
        }
    }
    
    func toggleStatus() {
        switch currentStatus {
        case .playing:
            currentStatus =  .paused
        case .paused:
              currentStatus = .playing
        default:
            break
        }
    }
    
    func hidePlayBackOptions() {
        playbackCircleView.isHidden  = true
        playbackButton.isHidden = true
        loadingCircle.isHidden = true
    }
    
    func unHidePlayBackOptions() {
        playbackCircleView.isHidden  = false
        playbackButton.isHidden = false
        loadingCircle.isHidden = false
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func playbackButtonPress() {
        delegate.playOrPauseEpisode()
        toggleStatus()
    }
    
    @objc func backPress() {
        webView.goBack()
    }
    
    @objc func forwardPress() {
        webView.goForward()
    }
    
    @objc func refreshPress() {
        webView.reload()
    }
}

extension WebVC: DuneAudioPlayerDelegate {
  
    func fetchMoreEpisodes() {
        print("Should fetch more episodes: Needs implementation")
    }
    
    func updateProgressBarWith(percentage: CGFloat, forType: PlayBackType, episodeID: String) {
        if currentStatus ==  .ready {
            currentStatus = .playing
            unHidePlayBackOptions()
        }
        playbackCircleView.shapeLayer.strokeEnd = percentage
    }
    
    func updateActiveCell(atIndex: Int, forType: PlayBackType) {
        // No implementation needed
    }
    
//    func showCommentsFor(episode: Episode) {
//        // No implementation needed
//    }
    
    func showSettingsFor(episode: Episode) {
        // No implementation needed
    }
    
}

