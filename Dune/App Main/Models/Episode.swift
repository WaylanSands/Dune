//
//  PlayBarTrack.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class Episode {
    
    var ID: String
    var image: UIImage
    var programName: String
    var username: String
    var caption: String
    var tags: [String]?
    var programID: String
    var ownerID: String

    init(id: String, image: UIImage, programName: String, username: String, caption: String, tags: [String]?, programID: String, ownerID: String) {
        self.ID = id
        self.image = image
        self.programName = programName
        self.username = username
        self.caption = caption
        self.tags = tags
        self.programID = programID
        self.ownerID = ownerID
    }
    
    
  
}

