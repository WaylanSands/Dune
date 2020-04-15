//
//  SettingsLauncherCell.swift
//  Dune
//
//  Created by Waylan Sands on 6/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SettingsLauncherCell: UICollectionViewCell {
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            
            if setting?.name == "Cancel" {
//                nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//                nameLabel.textColor = CustomStyle.linkBlue
                borderLineView.isHidden = true
            }
            
            if let imageName = setting?.imageName {
                iconImageView.image = UIImage(named: imageName)
                 configureCellWithImage()
            } else {
                configureCellWithoutImage()
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? CustomStyle.secondShade : .white
        }
    }
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Settings"
        return label
    }()
    
    let iconImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let borderLineView: UIView = {
       let view = UIView()
        view.backgroundColor = CustomStyle.secondShade
        return view
    }()
    

override init(frame: CGRect) {
    super.init(frame: frame)
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    
    func configureCellWithImage() {
        self.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 19).isActive = true

        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15).isActive = true
        
        self.addSubview(borderLineView)
        borderLineView.translatesAutoresizingMaskIntoConstraints = false
        borderLineView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        borderLineView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        borderLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
    func configureCellWithoutImage() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        
        self.addSubview(borderLineView)
        borderLineView.translatesAutoresizingMaskIntoConstraints = false
        borderLineView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        borderLineView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        borderLineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
    
}
