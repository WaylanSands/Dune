//
//  PlayBarTrack.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase


class Episode {
    
    var ID: String
    var timeSince: String
    var timeStamp: Timestamp
    var duration: String
    var imageID: String
    var imagePath: String
    var audioID: String
    var audioPath: String
    var programName: String
    var username: String
    var caption: String
    var tags: [String]?
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    var listenCount: Int
    var programID: String
    var ownerID: String

    init(data: [String: Any]) {
         ID = data["ID"] as! String
        
        let postedDate = data["postedAt"] as! Timestamp
        let date = postedDate.dateValue()
        let time = date.timeAgoDisplay()
        
        timeSince = time
        timeStamp = data["postedAt"] as! Timestamp
        duration = data["duration"] as! String
        imageID = data["imageID"] as! String
        imagePath = data["imagePath"] as! String
        audioID = data["audioID"] as! String
        audioPath = data["audioPath"] as! String
        programName = data["programName"] as! String
        username = data["username"] as! String
        caption = data["caption"] as! String
        likeCount = data["likeCount"] as! Int
        commentCount = data["commentCount"] as! Int
        shareCount = data["shareCount"] as! Int
        listenCount = data["listenCount"] as! Int
        tags = data["tags"] as! [String]?
        programID = data["programID"] as! String
        ownerID = data["ownerID"] as! String
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

enum counterIncrement {
    case increase
    case decrease
}

    
