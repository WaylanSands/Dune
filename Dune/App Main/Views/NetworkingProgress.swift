//
//  NetworkingProgress.swift
//  Dune
//
//  Created by Waylan Sands on 23/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class NetworkingProgress: UIView {
        
    let containerView: UIView = {
       let view = UIView()
        view.backgroundColor = CustomStyle.darkestBlack.withAlphaComponent(0)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let taskLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    let downloadProgressBackground: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var downloadProgressBar: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    required init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        addViews()
    }
    
    override func layoutSubviews() {
        animate()
    }

    func animate() {
        let xPosition = downloadProgressBackground.frame.minX
        let yPosition = downloadProgressBackground.frame.minY
        let width = downloadProgressBackground.frame.width
        let height = downloadProgressBackground.frame.height
        
        downloadProgressBar.frame = CGRect(x: xPosition, y: yPosition, width: 0, height: height)
        
        UIView.animate(withDuration: 1,
                                   delay: 0.0,
                                   options: [.curveEaseOut, .repeat],
                                   animations: {
                                   self.downloadProgressBar.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)

        }, completion: { (finished: Bool) -> Void in
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        
        containerView.addSubview(taskLabel)
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        taskLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        taskLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        
        containerView.addSubview(downloadProgressBackground)
        downloadProgressBackground.translatesAutoresizingMaskIntoConstraints = false
        downloadProgressBackground.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 30).isActive = true
        downloadProgressBackground.leadingAnchor.constraint(equalTo: taskLabel.leadingAnchor).isActive = true
        downloadProgressBackground.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        downloadProgressBackground.heightAnchor.constraint(equalToConstant: 6).isActive = true
        
        containerView.addSubview(downloadProgressBar)
       
    }

}
