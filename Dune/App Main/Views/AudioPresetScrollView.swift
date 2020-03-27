//
//  AudioPresetScrollView.swift
//  Dune
//
//  Created by Waylan Sands on 23/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

protocol AudioPresetDelegate {
    func presetButtonPressed(sender: AudioPresetButton)
}

class AudioPresetScrollView: UIScrollView {
    
    let none = AudioPresetButton(backgroundColor: CustomStyle.primaryBlue, title: "None")
    let presetOne = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#27A6E0"), title: "Miami")
    let presetTwo = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#AACC55"), title: "NASA")
    let presetThree = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#FF6D6D"), title: "Stern")
    let presetFour = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#FFBA3F"), title: "Liquid")
    let presetFive = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#8067FF"), title: "Frank")
    let presetSix = AudioPresetButton(backgroundColor: hexStringToUIColor(hex: "#35C396"), title: "Radio")
    
    
    var activeButton: AudioPresetButton?
    var presetDelegate: AudioPresetDelegate!
    lazy var presets: [AudioPresetButton] = [none, presetOne, presetTwo, presetThree, presetFour, presetFive, presetSix]

    
    let presetContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    required init() {
//        activeButton = presetOne
        super.init(frame: .zero)
        self.showsHorizontalScrollIndicator = false
        configureButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureButtons() {
        self.addSubview(presetContentView)
        
        presetContentView.addSubview(none)
        none.translatesAutoresizingMaskIntoConstraints = false
        none.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        none.leadingAnchor.constraint(equalTo: presetContentView.leadingAnchor).isActive = true
        none.heightAnchor.constraint(equalToConstant: 60).isActive = true
        none.widthAnchor.constraint(equalToConstant: 60).isActive = true
        none.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        none.buttonIsActive()
        
        presetContentView.addSubview(presetOne)
        presetOne.translatesAutoresizingMaskIntoConstraints = false
        presetOne.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetOne.leadingAnchor.constraint(equalTo: none.trailingAnchor, constant: 10).isActive = true
        presetOne.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetOne.widthAnchor.constraint(equalToConstant: 60).isActive = true
        presetOne.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.addSubview(presetTwo)
        presetTwo.translatesAutoresizingMaskIntoConstraints = false
        presetTwo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetTwo.leadingAnchor.constraint(equalTo: presetOne.trailingAnchor, constant: 10).isActive = true
        presetTwo.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetTwo.widthAnchor.constraint(equalToConstant: 60).isActive = true
        presetTwo.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.addSubview(presetThree)
        presetThree.translatesAutoresizingMaskIntoConstraints = false
        presetThree.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetThree.leadingAnchor.constraint(equalTo: presetTwo.trailingAnchor, constant: 10).isActive = true
        presetThree.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetThree.widthAnchor.constraint(equalToConstant: 60).isActive = true
         presetThree.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.addSubview(presetFour)
        presetFour.translatesAutoresizingMaskIntoConstraints = false
        presetFour.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetFour.leadingAnchor.constraint(equalTo: presetThree.trailingAnchor, constant: 10).isActive = true
        presetFour.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetFour.widthAnchor.constraint(equalToConstant: 60).isActive = true
         presetFour.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.addSubview(presetFive)
        presetFive.translatesAutoresizingMaskIntoConstraints = false
        presetFive.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetFive.leadingAnchor.constraint(equalTo: presetFour.trailingAnchor, constant: 10).isActive = true
        presetFive.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetFive.widthAnchor.constraint(equalToConstant: 60).isActive = true
        presetFive.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.addSubview(presetSix)
        presetSix.translatesAutoresizingMaskIntoConstraints = false
        presetSix.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetSix.leadingAnchor.constraint(equalTo: presetFive.trailingAnchor, constant: 10).isActive = true
        presetSix.heightAnchor.constraint(equalToConstant: 60).isActive = true
        presetSix.widthAnchor.constraint(equalToConstant: 60).isActive = true
        presetSix.addTarget(self, action: #selector(presetButtonPress(sender:)), for: .touchUpInside)
        
        presetContentView.translatesAutoresizingMaskIntoConstraints = false
        presetContentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        presetContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        presetContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        presetContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        presetContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        presetContentView.widthAnchor.constraint(equalToConstant: CGFloat((presetContentView.subviews.count * 70) + (presetContentView.subviews.count * 10))).isActive = true
        
    }
    
    @objc func hitTest() {
         print("hit")
    }
    
    @objc func presetButtonPress(sender: AudioPresetButton) {
        print("hit")
        activeButton = sender
        sender.buttonIsActive()
        
        presetDelegate.presetButtonPressed(sender: sender)
        
        for eachButton in presets {
            if eachButton != activeButton {
                eachButton.buttonIsInactive()
            }
        }
    }
}
