//
//  DuneSquareLinkPreview.swift
//  Dune
//
//  Created by Waylan Sands on 19/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


class DuneSquareLinkPreview: UIView {
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.imageView!.contentMode = .scaleAspectFill
        button.layer.shouldRasterize = true
        button.isOpaque = true
        return button
    }()
      
    let backgroundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomStyle.white
        button.layer.borderWidth = 0.5
        button.layer.borderColor = CustomStyle.fourthShade.cgColor
        button.isOpaque = true
        return button
    }()
    
    let squareLabel: UILabel = {
        let label = UILabel()
        label.textColor = CustomStyle.primaryBlack
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.text = "Fetching"
        return label
    }()
      
      let urlLabel: UILabel = {
          let label = UILabel()
          label.textColor = CustomStyle.fourthShade
          label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
          label.text = "Fetching"
          return label
      }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.05
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func configureViews(){
        
        self.addSubview(backgroundButton)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        backgroundButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        backgroundButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 7).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 7).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        
        self.addSubview(squareLabel)
        squareLabel.translatesAutoresizingMaskIntoConstraints = false
        squareLabel.topAnchor.constraint(equalTo: backgroundButton.topAnchor, constant: 10).isActive = true
        squareLabel.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 15).isActive = true
        squareLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15).isActive = true
        
        self.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.topAnchor.constraint(equalTo: squareLabel.bottomAnchor, constant: 2).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: squareLabel.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: squareLabel.trailingAnchor).isActive = true
        
        imageButton.layer.cornerRadius = 8
        imageButton.clipsToBounds = true
        backgroundButton.layer.cornerRadius = 8
        backgroundButton.clipsToBounds = true
    }

}
