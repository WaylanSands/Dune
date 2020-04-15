//
//  TVLoadingAnimationView.swift
//  Dune
//
//  Created by Waylan Sands on 31/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class TVLoadingAnimationView: UIView {
    
    let imageViewSize: CGFloat = 65
    let gradient = CAGradientLayer()
    
    
    let cellview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // FIRST CELL
    
    let programImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let bottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let captionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let bottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let firstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let bottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let bottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let bottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.alpha = 0.5
        return view
    }()
    
    // SECOND CELL
    
    let secProgramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let secBottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let secCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let secBottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let secFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secBottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secBottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secBottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let secUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
         view.alpha = 0.5
        return view
    }()
    
    // Third Cell
    
    let thirdProgramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let thirdBottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let thirdCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let thirdBottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let thirdFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdBottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdBottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdBottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let thirdUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
         view.alpha = 0.5
        return view
    }()
    
    // Fourth Cell
    
    
    let forthProgramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let forthBottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let forthCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let forthBottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let forthFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthBottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthBottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthBottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let forthUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
         view.alpha = 0.5
        return view
    }()
    
    // Fifth Cell
    
    
    let fifProgramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let fifBottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let fifCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let fifBottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let fifFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifBottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifBottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifBottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let fifUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
         view.alpha = 0.5
        return view
    }()
    
    // Sixth Cell
    
    
    let sixProgramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let sixBottomprogramImageView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 7
        view.clipsToBounds = true
        return view
    }()
    
    let sixCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let sixBottomCaptionView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    let sixFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixBottomFirstTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixBottomSecondTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.thirdShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixBottomThirdTagView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        return view
    }()
    
    let sixUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
         view.alpha = 0.5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        makeGradient()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeGradient() {
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.5, 1]
        gradient.frame =  CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.height, height:  UIScreen.main.bounds.height)
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 4
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -3.0 * UIScreen.main.bounds.width
        animation.toValue = 3.0 * UIScreen.main.bounds.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        gradient.add(animation, forKey: "shimmerKey")
    }
    
    func configureView() {
        
        // First cell Bottom Layer
        self.addSubview(bottomprogramImageView)
        bottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomprogramImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 150).isActive = true
        bottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        bottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        bottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(bottomCaptionView)
        bottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCaptionView.topAnchor.constraint(equalTo: bottomprogramImageView.topAnchor).isActive = true
        bottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        bottomCaptionView.leadingAnchor.constraint(equalTo: bottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        bottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(bottomFirstTagView)
        bottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        bottomFirstTagView.topAnchor.constraint(equalTo: bottomCaptionView.bottomAnchor, constant: 10).isActive = true
        bottomFirstTagView.leadingAnchor.constraint(equalTo: bottomCaptionView.leadingAnchor).isActive = true
        bottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        bottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(bottomSecondTagView)
        bottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        bottomSecondTagView.centerYAnchor.constraint(equalTo: bottomFirstTagView.centerYAnchor).isActive = true
        bottomSecondTagView.leadingAnchor.constraint(equalTo: bottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        bottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        bottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(bottomThirdTagView)
        bottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        bottomThirdTagView.centerYAnchor.constraint(equalTo: bottomSecondTagView.centerYAnchor).isActive = true
        bottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        bottomThirdTagView.leadingAnchor.constraint(equalTo: bottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        bottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(underlineView)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.topAnchor.constraint(equalTo: bottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        underlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        underlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Second Cell Bottom Layer
        self.addSubview(secBottomprogramImageView)
        secBottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        secBottomprogramImageView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 10).isActive = true
        secBottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        secBottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        secBottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(secBottomCaptionView)
        secBottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        secBottomCaptionView.topAnchor.constraint(equalTo: secBottomprogramImageView.topAnchor).isActive = true
        secBottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        secBottomCaptionView.leadingAnchor.constraint(equalTo: secBottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        secBottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(secBottomFirstTagView)
        secBottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        secBottomFirstTagView.topAnchor.constraint(equalTo: secBottomCaptionView.bottomAnchor, constant: 10).isActive = true
        secBottomFirstTagView.leadingAnchor.constraint(equalTo: secBottomCaptionView.leadingAnchor).isActive = true
        secBottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        secBottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(secBottomSecondTagView)
        secBottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        secBottomSecondTagView.centerYAnchor.constraint(equalTo: secBottomFirstTagView.centerYAnchor).isActive = true
        secBottomSecondTagView.leadingAnchor.constraint(equalTo: secBottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        secBottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        secBottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(secBottomThirdTagView)
        secBottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        secBottomThirdTagView.centerYAnchor.constraint(equalTo: secBottomSecondTagView.centerYAnchor).isActive = true
        secBottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secBottomThirdTagView.leadingAnchor.constraint(equalTo: secBottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        secBottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(secUnderlineView)
        secUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        secUnderlineView.topAnchor.constraint(equalTo: secBottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        secUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        secUnderlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        secUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Third cell Bottom Layer
        self.addSubview(thirdBottomprogramImageView)
        thirdBottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdBottomprogramImageView.topAnchor.constraint(equalTo: secUnderlineView.bottomAnchor, constant: 10).isActive = true
        thirdBottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        thirdBottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        thirdBottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(thirdBottomCaptionView)
        thirdBottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        thirdBottomCaptionView.topAnchor.constraint(equalTo: thirdBottomprogramImageView.topAnchor).isActive = true
        thirdBottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        thirdBottomCaptionView.leadingAnchor.constraint(equalTo: thirdBottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        thirdBottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(thirdBottomFirstTagView)
        thirdBottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdBottomFirstTagView.topAnchor.constraint(equalTo: thirdBottomCaptionView.bottomAnchor, constant: 10).isActive = true
        thirdBottomFirstTagView.leadingAnchor.constraint(equalTo: thirdBottomCaptionView.leadingAnchor).isActive = true
        thirdBottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        thirdBottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(thirdBottomSecondTagView)
        thirdBottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdBottomSecondTagView.centerYAnchor.constraint(equalTo: thirdBottomFirstTagView.centerYAnchor).isActive = true
        thirdBottomSecondTagView.leadingAnchor.constraint(equalTo: thirdBottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        thirdBottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thirdBottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(thirdBottomThirdTagView)
        thirdBottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdBottomThirdTagView.centerYAnchor.constraint(equalTo: thirdBottomSecondTagView.centerYAnchor).isActive = true
        thirdBottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdBottomThirdTagView.leadingAnchor.constraint(equalTo: thirdBottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        thirdBottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(thirdUnderlineView)
        thirdUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        thirdUnderlineView.topAnchor.constraint(equalTo: thirdBottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        thirdUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thirdUnderlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thirdUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Fourth cell Bottom Layer
        self.addSubview(forthBottomprogramImageView)
        forthBottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        forthBottomprogramImageView.topAnchor.constraint(equalTo: thirdUnderlineView.bottomAnchor, constant: 10).isActive = true
        forthBottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        forthBottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        forthBottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(forthBottomCaptionView)
        forthBottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        forthBottomCaptionView.topAnchor.constraint(equalTo: forthBottomprogramImageView.topAnchor).isActive = true
        forthBottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        forthBottomCaptionView.leadingAnchor.constraint(equalTo: forthBottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        forthBottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(forthBottomFirstTagView)
        forthBottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        forthBottomFirstTagView.topAnchor.constraint(equalTo: forthBottomCaptionView.bottomAnchor, constant: 10).isActive = true
        forthBottomFirstTagView.leadingAnchor.constraint(equalTo: forthBottomCaptionView.leadingAnchor).isActive = true
        forthBottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        forthBottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(forthBottomSecondTagView)
        forthBottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        forthBottomSecondTagView.centerYAnchor.constraint(equalTo: forthBottomFirstTagView.centerYAnchor).isActive = true
        forthBottomSecondTagView.leadingAnchor.constraint(equalTo: forthBottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        forthBottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        forthBottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(forthBottomThirdTagView)
        forthBottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        forthBottomThirdTagView.centerYAnchor.constraint(equalTo: forthBottomSecondTagView.centerYAnchor).isActive = true
        forthBottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        forthBottomThirdTagView.leadingAnchor.constraint(equalTo: forthBottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        forthBottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(forthUnderlineView)
        forthUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        forthUnderlineView.topAnchor.constraint(equalTo: forthBottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        forthUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        forthUnderlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        forthUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
       
        // Fifth cell Bottom Layer
        self.addSubview(fifBottomprogramImageView)
        fifBottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        fifBottomprogramImageView.topAnchor.constraint(equalTo: forthUnderlineView.bottomAnchor, constant: 10).isActive = true
        fifBottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        fifBottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        fifBottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(fifBottomCaptionView)
        fifBottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        fifBottomCaptionView.topAnchor.constraint(equalTo: fifBottomprogramImageView.topAnchor).isActive = true
        fifBottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        fifBottomCaptionView.leadingAnchor.constraint(equalTo: fifBottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        fifBottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(fifBottomFirstTagView)
        fifBottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        fifBottomFirstTagView.topAnchor.constraint(equalTo: fifBottomCaptionView.bottomAnchor, constant: 10).isActive = true
        fifBottomFirstTagView.leadingAnchor.constraint(equalTo: fifBottomCaptionView.leadingAnchor).isActive = true
        fifBottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        fifBottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(fifBottomSecondTagView)
        fifBottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        fifBottomSecondTagView.centerYAnchor.constraint(equalTo: fifBottomFirstTagView.centerYAnchor).isActive = true
        fifBottomSecondTagView.leadingAnchor.constraint(equalTo: fifBottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        fifBottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fifBottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(fifBottomThirdTagView)
        fifBottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        fifBottomThirdTagView.centerYAnchor.constraint(equalTo: fifBottomSecondTagView.centerYAnchor).isActive = true
        fifBottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fifBottomThirdTagView.leadingAnchor.constraint(equalTo: fifBottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        fifBottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(fifUnderlineView)
        fifUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        fifUnderlineView.topAnchor.constraint(equalTo: fifBottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        fifUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        fifUnderlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        fifUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Sixth cell Bottom Layer
        self.addSubview(sixBottomprogramImageView)
        sixBottomprogramImageView.translatesAutoresizingMaskIntoConstraints = false
        sixBottomprogramImageView.topAnchor.constraint(equalTo: fifUnderlineView.bottomAnchor, constant: 10).isActive = true
        sixBottomprogramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        sixBottomprogramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        sixBottomprogramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        self.addSubview(sixBottomCaptionView)
        sixBottomCaptionView.translatesAutoresizingMaskIntoConstraints = false
        sixBottomCaptionView.topAnchor.constraint(equalTo: sixBottomprogramImageView.topAnchor).isActive = true
        sixBottomCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        sixBottomCaptionView.leadingAnchor.constraint(equalTo: sixBottomprogramImageView.trailingAnchor, constant: 10).isActive = true
        sixBottomCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        self.addSubview(sixBottomFirstTagView)
        sixBottomFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        sixBottomFirstTagView.topAnchor.constraint(equalTo: sixBottomCaptionView.bottomAnchor, constant: 10).isActive = true
        sixBottomFirstTagView.leadingAnchor.constraint(equalTo: sixBottomCaptionView.leadingAnchor).isActive = true
        sixBottomFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sixBottomFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(sixBottomSecondTagView)
        sixBottomSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        sixBottomSecondTagView.centerYAnchor.constraint(equalTo: sixBottomFirstTagView.centerYAnchor).isActive = true
        sixBottomSecondTagView.leadingAnchor.constraint(equalTo: sixBottomFirstTagView.trailingAnchor,constant: 6).isActive = true
        sixBottomSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sixBottomSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(sixBottomThirdTagView)
        sixBottomThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        sixBottomThirdTagView.centerYAnchor.constraint(equalTo: sixBottomSecondTagView.centerYAnchor).isActive = true
        sixBottomThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sixBottomThirdTagView.leadingAnchor.constraint(equalTo: sixBottomSecondTagView.trailingAnchor,constant: 6).isActive = true
        sixBottomThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.addSubview(sixUnderlineView)
        sixUnderlineView.translatesAutoresizingMaskIntoConstraints = false
        sixUnderlineView.topAnchor.constraint(equalTo: sixBottomThirdTagView.bottomAnchor,constant: 10).isActive = true
        sixUnderlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sixUnderlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        sixUnderlineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        // Top Layer
        self.addSubview(cellview)
        cellview.translatesAutoresizingMaskIntoConstraints = false
        cellview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cellview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cellview.layer.mask = gradient
        
        // First Cell top layer
        cellview.addSubview(programImageView)
        programImageView.translatesAutoresizingMaskIntoConstraints = false
        programImageView.topAnchor.constraint(equalTo: cellview.topAnchor, constant: 150).isActive = true
        programImageView.leadingAnchor.constraint(equalTo: cellview.leadingAnchor, constant: 16).isActive = true
        programImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        programImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(captionView)
        captionView.translatesAutoresizingMaskIntoConstraints = false
        captionView.topAnchor.constraint(equalTo: programImageView.topAnchor).isActive = true
        captionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        captionView.leadingAnchor.constraint(equalTo: programImageView.trailingAnchor, constant: 10).isActive = true
        captionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(firstTagView)
        firstTagView.translatesAutoresizingMaskIntoConstraints = false
        firstTagView.topAnchor.constraint(equalTo: captionView.bottomAnchor, constant: 10).isActive = true
        firstTagView.leadingAnchor.constraint(equalTo: captionView.leadingAnchor).isActive = true
        firstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        firstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(secondTagView)
        secondTagView.translatesAutoresizingMaskIntoConstraints = false
        secondTagView.centerYAnchor.constraint(equalTo: firstTagView.centerYAnchor).isActive = true
        secondTagView.leadingAnchor.constraint(equalTo: firstTagView.trailingAnchor,constant: 6).isActive = true
        secondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        secondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(thirdTagView)
        thirdTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdTagView.centerYAnchor.constraint(equalTo: secondTagView.centerYAnchor).isActive = true
        thirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdTagView.leadingAnchor.constraint(equalTo: secondTagView.trailingAnchor,constant: 6).isActive = true
        thirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // Second cell top layer
        cellview.addSubview(secProgramImageView)
        secProgramImageView.translatesAutoresizingMaskIntoConstraints = false
        secProgramImageView.topAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: 10).isActive = true
        secProgramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        secProgramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        secProgramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(secCaptionView)
        secCaptionView.translatesAutoresizingMaskIntoConstraints = false
        secCaptionView.topAnchor.constraint(equalTo: secProgramImageView.topAnchor).isActive = true
        secCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        secCaptionView.leadingAnchor.constraint(equalTo: secProgramImageView.trailingAnchor, constant: 10).isActive = true
        secCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(secFirstTagView)
        secFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        secFirstTagView.topAnchor.constraint(equalTo: secCaptionView.bottomAnchor, constant: 10).isActive = true
        secFirstTagView.leadingAnchor.constraint(equalTo: secCaptionView.leadingAnchor).isActive = true
        secFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        secFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(secSecondTagView)
        secSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        secSecondTagView.centerYAnchor.constraint(equalTo: secFirstTagView.centerYAnchor).isActive = true
        secSecondTagView.leadingAnchor.constraint(equalTo: secFirstTagView.trailingAnchor,constant: 6).isActive = true
        secSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        secSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(secThirdTagView)
        secThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        secThirdTagView.centerYAnchor.constraint(equalTo: secSecondTagView.centerYAnchor).isActive = true
        secThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        secThirdTagView.leadingAnchor.constraint(equalTo: secSecondTagView.trailingAnchor,constant: 6).isActive = true
        secThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // Third Cell top layer
        cellview.addSubview(thirdProgramImageView)
        thirdProgramImageView.translatesAutoresizingMaskIntoConstraints = false
        thirdProgramImageView.topAnchor.constraint(equalTo: secUnderlineView.bottomAnchor, constant: 10).isActive = true
        thirdProgramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        thirdProgramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        thirdProgramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(thirdCaptionView)
        thirdCaptionView.translatesAutoresizingMaskIntoConstraints = false
        thirdCaptionView.topAnchor.constraint(equalTo: thirdProgramImageView.topAnchor).isActive = true
        thirdCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        thirdCaptionView.leadingAnchor.constraint(equalTo: thirdProgramImageView.trailingAnchor, constant: 10).isActive = true
        thirdCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(thirdFirstTagView)
        thirdFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdFirstTagView.topAnchor.constraint(equalTo: thirdCaptionView.bottomAnchor, constant: 10).isActive = true
        thirdFirstTagView.leadingAnchor.constraint(equalTo: thirdCaptionView.leadingAnchor).isActive = true
        thirdFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        thirdFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(thirdSecondTagView)
        thirdSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdSecondTagView.centerYAnchor.constraint(equalTo: thirdFirstTagView.centerYAnchor).isActive = true
        thirdSecondTagView.leadingAnchor.constraint(equalTo: thirdFirstTagView.trailingAnchor,constant: 6).isActive = true
        thirdSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        thirdSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(thirdThirdTagView)
        thirdThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        thirdThirdTagView.centerYAnchor.constraint(equalTo: thirdSecondTagView.centerYAnchor).isActive = true
        thirdThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        thirdThirdTagView.leadingAnchor.constraint(equalTo: thirdSecondTagView.trailingAnchor,constant: 6).isActive = true
        thirdThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // Fourth Cell top layer
        cellview.addSubview(forthProgramImageView)
        forthProgramImageView.translatesAutoresizingMaskIntoConstraints = false
        forthProgramImageView.topAnchor.constraint(equalTo: thirdUnderlineView.bottomAnchor, constant: 10).isActive = true
        forthProgramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        forthProgramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        forthProgramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(forthCaptionView)
        forthCaptionView.translatesAutoresizingMaskIntoConstraints = false
        forthCaptionView.topAnchor.constraint(equalTo: forthProgramImageView.topAnchor).isActive = true
        forthCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        forthCaptionView.leadingAnchor.constraint(equalTo: forthProgramImageView.trailingAnchor, constant: 10).isActive = true
        forthCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(forthFirstTagView)
        forthFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        forthFirstTagView.topAnchor.constraint(equalTo: forthCaptionView.bottomAnchor, constant: 10).isActive = true
        forthFirstTagView.leadingAnchor.constraint(equalTo: forthCaptionView.leadingAnchor).isActive = true
        forthFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        forthFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(forthSecondTagView)
        forthSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        forthSecondTagView.centerYAnchor.constraint(equalTo: forthFirstTagView.centerYAnchor).isActive = true
        forthSecondTagView.leadingAnchor.constraint(equalTo: forthFirstTagView.trailingAnchor,constant: 6).isActive = true
        forthSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        forthSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(forthThirdTagView)
        forthThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        forthThirdTagView.centerYAnchor.constraint(equalTo: forthSecondTagView.centerYAnchor).isActive = true
        forthThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        forthThirdTagView.leadingAnchor.constraint(equalTo: forthSecondTagView.trailingAnchor,constant: 6).isActive = true
        forthThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // Fifth Cell top layer
        cellview.addSubview(fifProgramImageView)
        fifProgramImageView.translatesAutoresizingMaskIntoConstraints = false
        fifProgramImageView.topAnchor.constraint(equalTo: forthUnderlineView.bottomAnchor, constant: 10).isActive = true
        fifProgramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        fifProgramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        fifProgramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(fifCaptionView)
        fifCaptionView.translatesAutoresizingMaskIntoConstraints = false
        fifCaptionView.topAnchor.constraint(equalTo: fifProgramImageView.topAnchor).isActive = true
        fifCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        fifCaptionView.leadingAnchor.constraint(equalTo: fifProgramImageView.trailingAnchor, constant: 10).isActive = true
        fifCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(fifFirstTagView)
        fifFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        fifFirstTagView.topAnchor.constraint(equalTo: fifCaptionView.bottomAnchor, constant: 10).isActive = true
        fifFirstTagView.leadingAnchor.constraint(equalTo: fifCaptionView.leadingAnchor).isActive = true
        fifFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        fifFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(fifSecondTagView)
        fifSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        fifSecondTagView.centerYAnchor.constraint(equalTo: fifFirstTagView.centerYAnchor).isActive = true
        fifSecondTagView.leadingAnchor.constraint(equalTo: fifFirstTagView.trailingAnchor,constant: 6).isActive = true
        fifSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        fifSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(fifThirdTagView)
        fifThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        fifThirdTagView.centerYAnchor.constraint(equalTo: fifSecondTagView.centerYAnchor).isActive = true
        fifThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fifThirdTagView.leadingAnchor.constraint(equalTo: fifSecondTagView.trailingAnchor,constant: 6).isActive = true
        fifThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        // Sixth Cell top layer
        cellview.addSubview(sixProgramImageView)
        sixProgramImageView.translatesAutoresizingMaskIntoConstraints = false
        sixProgramImageView.topAnchor.constraint(equalTo: fifUnderlineView.bottomAnchor, constant: 10).isActive = true
        sixProgramImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        sixProgramImageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        sixProgramImageView.widthAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        
        cellview.addSubview(sixCaptionView)
        sixCaptionView.translatesAutoresizingMaskIntoConstraints = false
        sixCaptionView.topAnchor.constraint(equalTo: sixProgramImageView.topAnchor).isActive = true
        sixCaptionView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        sixCaptionView.leadingAnchor.constraint(equalTo: sixProgramImageView.trailingAnchor, constant: 10).isActive = true
        sixCaptionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
        
        cellview.addSubview(sixFirstTagView)
        sixFirstTagView.translatesAutoresizingMaskIntoConstraints = false
        sixFirstTagView.topAnchor.constraint(equalTo: sixCaptionView.bottomAnchor, constant: 10).isActive = true
        sixFirstTagView.leadingAnchor.constraint(equalTo: sixCaptionView.leadingAnchor).isActive = true
        sixFirstTagView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sixFirstTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(sixSecondTagView)
        sixSecondTagView.translatesAutoresizingMaskIntoConstraints = false
        sixSecondTagView.centerYAnchor.constraint(equalTo: sixFirstTagView.centerYAnchor).isActive = true
        sixSecondTagView.leadingAnchor.constraint(equalTo: sixFirstTagView.trailingAnchor,constant: 6).isActive = true
        sixSecondTagView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        sixSecondTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        cellview.addSubview(sixThirdTagView)
        sixThirdTagView.translatesAutoresizingMaskIntoConstraints = false
        sixThirdTagView.centerYAnchor.constraint(equalTo: sixSecondTagView.centerYAnchor).isActive = true
        sixThirdTagView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sixThirdTagView.leadingAnchor.constraint(equalTo: sixSecondTagView.trailingAnchor,constant: 6).isActive = true
        sixThirdTagView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        self.bringSubviewToFront(underlineView)
        self.bringSubviewToFront(secUnderlineView)
        self.bringSubviewToFront(thirdUnderlineView)
        self.bringSubviewToFront(forthUnderlineView)
        self.bringSubviewToFront(fifUnderlineView)
        self.bringSubviewToFront(sixUnderlineView)
    }
    
}
