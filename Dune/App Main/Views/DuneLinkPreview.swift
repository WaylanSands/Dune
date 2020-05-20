//
//  DuneLinkPreview.swift
//  Dune
//
//  Created by Waylan Sands on 16/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


class DuneLinkPreview: UIView {
    
    let imageButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.imageView!.contentMode = .scaleAspectFill
        return view
    }()
      
      let backgroundButton: UIButton = {
          let view = UIButton()
          view.backgroundColor = CustomStyle.secondShade
          return view
      }()
      
      let mainLabel: UILabel = {
          let label = UILabel()
          label.textColor = CustomStyle.primaryBlack
          label.font = UIFont.systemFont(ofSize: 13, weight: .bold)
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
    
    
    func  configureViews() {
        self.addSubview(imageButton)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50).isActive = true
        
        self.addSubview(backgroundButton)
        backgroundButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundButton.topAnchor.constraint(equalTo: imageButton.bottomAnchor).isActive = true
        backgroundButton.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor).isActive = true
        backgroundButton.trailingAnchor.constraint(equalTo: imageButton.trailingAnchor).isActive = true
        backgroundButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addSubview(mainLabel)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.topAnchor.constraint(equalTo: backgroundButton.topAnchor, constant: 8).isActive = true
        mainLabel.leadingAnchor.constraint(equalTo: imageButton.leadingAnchor, constant: 15).isActive = true
        mainLabel.trailingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: -15).isActive = true
        
        self.addSubview(urlLabel)
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        urlLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 1).isActive = true
        urlLabel.leadingAnchor.constraint(equalTo: mainLabel.leadingAnchor).isActive = true
        urlLabel.trailingAnchor.constraint(equalTo: mainLabel.trailingAnchor).isActive = true
        
        imageButton.layer.cornerRadius = 8
        imageButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageButton.clipsToBounds = true
        
        backgroundButton.layer.cornerRadius = 8
        backgroundButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundButton.clipsToBounds = true
    }
    
}

