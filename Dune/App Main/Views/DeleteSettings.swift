//
//  DeleteSettings.swift
//  Dune
//
//  Created by Waylan Sands on 6/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class DeleteSettings: UIView {
    
    var madeSelection: (() -> Void)?
    
    private var listenerOptions = [
        "Lack of quality content",
        "Poor audio quality",
        "Poor loading times",
        "Privacy reasons",
    ]
    
    private var publisherOptions = [
        "Lack of quality content",
        "Lack of listeners",
        "Poor audio quality",
        "Studio needs work",
        "Privacy reasons",
    ]
    
    private let headingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = """
        What's your primary reason
        for wanting to leave?
        """
        return label
    }()
    
    private let thanksLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Thanks for the feedback!"
        label.alpha = 0
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return button
    }()
    
    private let optionStackedView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    func topConstant() -> CGFloat {
        switch UIDevice.current.deviceType {
        case .iPhone4S, .iPhoneSE:
             return 100
        case .iPhone8:
            return 140
        case .iPhone8Plus:
             return 170
        case .iPhone11:
             return 220
        case .iPhone11Pro:
             return 200
        case .iPhone11ProMax:
             return 220
        default:
            return 200
        }
    }
    
    
    func showFeedbackOptions() {
        
        if let window =  UIApplication.shared.keyWindow {
            window.addSubview(self)
            self.backgroundColor = UIColor.black.withAlphaComponent(0.95)
            self.frame = window.frame
            self.alpha = 0

            let topAnchorConstant = topConstant()
            
            self.addSubview(headingLabel)
            headingLabel.translatesAutoresizingMaskIntoConstraints = false
            headingLabel.topAnchor.constraint(equalTo: window.topAnchor, constant: topAnchorConstant).isActive = true
            headingLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 30).isActive = true
            headingLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -30).isActive = true
            
            self.addSubview(thanksLabel)
            thanksLabel.translatesAutoresizingMaskIntoConstraints = false
            thanksLabel.centerYAnchor.constraint(equalTo: window.centerYAnchor).isActive = true
            thanksLabel.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 30).isActive = true
            thanksLabel.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -30).isActive = true
            
            self.addSubview(optionStackedView)
            optionStackedView.translatesAutoresizingMaskIntoConstraints = false
            optionStackedView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 60).isActive = true
            optionStackedView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            optionStackedView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            
            if CurrentProgram.isPublisher! {
                addPublisherOptions()
            } else {
                addListenerOptions()
            }
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.alpha = 1
            }, completion: nil)
            
        }
    }
    
    private func addListenerOptions() {
        for each in listenerOptions {
            let button = option(title: each)
            optionStackedView.addArrangedSubview(button)
        }
        addBottomOptions()
    }
    
    private func addBottomOptions() {
        let expectedButton = option(title: "Not what you expected")
        optionStackedView.addArrangedSubview(expectedButton)
        
        let otherButton = option(title: "Other")
        optionStackedView.addArrangedSubview(otherButton)
    }
    
    private func addPublisherOptions() {
        for each in publisherOptions.shuffled() {
            let button = option(title: each)
            optionStackedView.addArrangedSubview(button)
        }
        addBottomOptions()
    }
    
    @objc private func optionSelected(sender: UIButton) {
        if madeSelection != nil {
            madeSelection!()
        }
        handleDismiss()
    }
    
    private func option(title: String) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
        button.setTitle(title, for: .normal)
        return button
    }
    
    @objc private func handleDismiss() {
        headingLabel.isHidden = true
        optionStackedView.isHidden = true
        UIView.animate(withDuration: 1, animations: {
            self.thanksLabel.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.removeFromSuperview()
            }
        }
    }
    
}



