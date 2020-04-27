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
    var addedAt: String
    var duration: String
    var imageID: String
    var imagePath: String
    var audioID: String
    var audioPath: String
    var programName: String
    var username: String
    var caption: String
    var tags: [String]?
    var programID: String
    var ownerID: String

    init(id: String, addedAt: String, duration: String, imageID: String, audioID: String, audioPath: String, imagePath: String, programName: String, username: String, caption: String, tags: [String]?, programID: String, ownerID: String) {
        self.ID = id
        self.addedAt = addedAt
        self.duration = duration
        self.imageID = imageID
        self.imagePath = imagePath
        self.audioID = audioID
        self.audioPath = audioPath
        self.programName = programName
        self.username = username
        self.caption = caption
        self.tags = tags
        self.programID = programID
        self.ownerID = ownerID
    }
}

class DraftEpisode {
    
    var ID: String
    var addedAt: String
    var fileName: String
    var wasTrimmed: Bool
    var startTime: Double
    var endTime: Double
    var duration: String
    var programName: String
    var username: String
    var caption: String
    var tags: [String]?
    var programID: String
    var ownerID: String

    init(id: String, addedAt: String, fileName: String, wasTrimmed: Bool, startTime: Double, endTime: Double, duration: String, programName: String, username: String, caption: String, tags: [String]?, programID: String, ownerID: String) {
        self.ID = id
        self.addedAt = addedAt
        self.fileName = fileName
        self.wasTrimmed = wasTrimmed
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.programName = programName
        self.username = username
        self.caption = caption
        self.tags = tags
        self.programID = programID
        self.ownerID = ownerID
    }
}

    
