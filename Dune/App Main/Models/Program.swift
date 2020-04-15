//
//  Channel.swift
//  Dune
//
//  Created by Waylan Sands on 13/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

struct Program {
    static var ID: String?
    static var name: String?
    static var ownerID: String?
    static var hasIntro: Bool?
    static var image: UIImage?
    static var storedImageID: String?
    static var imagePath: String?
    static var storedIntroID: String?
    static var introPath: String?
    static var summary: String?
    static var isPrimaryProgram: Bool?
    static var primaryCategory: String?
    static var hasMultiplePrograms: Bool?
    static var tags: [String?]?
    static var episodeIDs: [String]?
    static var subscriberIDs: [String]?
}
