//
//  DeviceSizes.swift
//  Snippets
//
//  Created by Waylan Sands on 22/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import AVFoundation

extension UIDevice {
    
    static let safeBottomHeight = UIApplication.shared.keyWindow!.safeAreaInsets.bottom
    
    static func vibrate() {
        var audioPlayer: AVAudioPlayer!
        let path = Bundle.main.path(forResource: "end.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error)
        }
        
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playback)
        }
        catch{
            print("Failed")
        }
        
        audioPlayer.play()
//        AudioServicesPlayAlertSound(.init(1073))
    }
    
    enum DeviceType: String {
        case iPhone4S
        case iPhoneSE
        case iPhone8
        case iPhone8Plus
        case iPhone11
        case iPhone11Pro
        case iPhone11ProMax
        case unknown
    }
    
    var deviceType: DeviceType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4S
        case 1136:
            return .iPhoneSE
        case 1334:
            return .iPhone8
        case 1920, 2208:
            return .iPhone8Plus
        case 1792:
            return .iPhone11
        case 2436:
            return .iPhone11Pro
        case 2688:
            return .iPhone11ProMax
        default:
            return .unknown
        }
    }
    
    func navBarHeight() -> CGFloat {
        let deviceSize = UIDevice.current.deviceType
        
        switch deviceSize {
        case .iPhone4S, .iPhoneSE, .iPhone8:
            return 64.0
        case .iPhone8Plus:
            return 64.0
        case .iPhone11:
            if #available(iOS 14.0, *) {
                return 92.0
            } else {
                return 88.0
            }
        case .iPhone11Pro:
            return 88.0
        case .iPhone11ProMax:
            return 88.0
        case .unknown:
            return 64.0
        }
    }
    
    func navBarButtonTopAnchor() -> CGFloat {
        let deviceSize = UIDevice.current.deviceType
        
        switch deviceSize {
        case .iPhone4S, .iPhoneSE, .iPhone8:
            return 25.0
        case .iPhone8Plus:
            return 25.0
        case .iPhone11:
            return 50.0
        case .iPhone11Pro:
            return 50.0
        case .iPhone11ProMax:
            return 50.0
        case .unknown:
            return 45.0
        }
    }
    
    func buttonHeight() -> CGFloat {
        let deviceSize = UIDevice.current.deviceType
        
        switch deviceSize {
        case .iPhone4S, .iPhoneSE:
            return 36.0
        default:
            return 40.0
        }
        
    }
    
}



