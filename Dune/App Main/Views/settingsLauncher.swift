//
//  settingsLauncher.swift
//  Dune
//
//  Created by Waylan Sands on 6/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    let options: [Setting]
    let type: settingsType
    var settingsDelegate: SettingsLauncherDelegate?
    var touchPoint: CGPoint?
    var y: CGFloat?
    
    let windowView = UIApplication.shared.windows.last
    
    let blackView = UIView()
    
    let collectionContentView: UIView = {
      let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let  cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let slideDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissView(gesture:)))
        slideDown.direction = .down
        cv.addGestureRecognizer(slideDown)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let cellID = "cellID"
    let cellHeight: CGFloat = 50
    
    init(options: [Setting], type: settingsType) {
        self.type = type
        self.options = options
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingsLauncherCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func showSettings() {
       
        collectionView.setContentOffset(.zero, animated: false)
        if let window =  UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            print(window.frame.size)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(collectionContentView)
            collectionContentView.addSubview(collectionView)
            
            var height = CGFloat(options.count) * cellHeight
            
            if height >= (window.frame.height - 50) {
                height = window.frame.height - 200
            }
            y = window.frame.height - height
            
            collectionContentView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height + 40)
            
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: collectionContentView.topAnchor, constant: 10).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                print("yes it ran")
                self.blackView.alpha = 1
                self.collectionContentView.frame.origin.y = self.y! - 40
            }, completion: nil)
            
        }
        else {
            print("yes this is where it failed")
        }
    }
    
    @objc func handelDismiss() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window =  UIApplication.shared.windows.last {
                self.collectionContentView.frame.origin.y = window.frame.height
            }
        }
    }
    
    @objc func dismissView(gesture: UISwipeGestureRecognizer) {
        print("swipe")
        UIView.animate(withDuration: 0.4) {
            if let window =  UIApplication.shared.windows.last {
                self.collectionContentView.frame.origin.y = window.frame.height
            }
        }
    }
}

extension SettingsLauncher: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SettingsLauncherCell
        cell.setting = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = options[indexPath.item]

        if setting.name != "Cancel" {
            switch type {
            case .categories:
                CurrentProgram.primaryCategory = setting.name
                self.settingsDelegate!.selectionOf(setting: setting.name)
            case .countries:
                break
            case .sharing:
                break
            case .subscriptionEpisode:
                break
            case .ownEpisode:
                self.settingsDelegate!.selectionOf(setting: setting.name)
            }
        }
        handelDismiss()
    }
}

protocol SettingsLauncherDelegate {
    func selectionOf(setting: String)
}


