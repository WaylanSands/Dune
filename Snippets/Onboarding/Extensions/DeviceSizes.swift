//
//  DeviceSizes.swift
//  Snippets
//
//  Created by Waylan Sands on 22/1/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

extension UIDevice {
    
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
}

//let deviceType = UIDevice.current.deviceType
//
//func styleSnap() {
//    switch deviceType {
//    case .iPhone4S:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.white, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .iPhoneSE:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.secondShade, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .iPhone8:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.thirdShade, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .iPhone8Plus:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.fourthShade, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .iPhone11:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryBlue, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .iPhone11ProMax:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.primaryRed, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    case .unknown:
//        CustomStyle.styleRoundedSignUpButton(color: CustomStyle.snapColor, image: #imageLiteral(resourceName: "snap-icon"), button: bitmojiButton)
//    default:
//        return
//    }
//}


//func styleSnap() {
//    switch deviceType {
//    case .iPhone4S:
//    case .iPhoneSE:
//    case .iPhone8:
//    case .iPhone8Plus:
//    case .iPhone11:
//    case .iPhone11ProMax:
//    case .unknown:
//    default:
//        return
//    }
//}
