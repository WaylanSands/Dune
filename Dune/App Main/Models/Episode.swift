//
//  PlayBarTrack.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore
import LinkPresentation

class Episode: Comparable {
    
     static func < (lhs: Episode, rhs: Episode) -> Bool {
         return lhs.postedDate < rhs.postedDate
     }
    
     static func == (lhs: Episode, rhs: Episode) -> Bool {
         return lhs.postedDate == rhs.postedDate
     }
    
    var ID: String
    var timeSince: String
    var timeStamp: Timestamp
    var postedDate: Date
    var category: String
    var duration: String
    var imageID: String
    var imagePath: String
    var audioID: String
    var audioPath: String
    var programName: String
    var username: String
    var caption: String
    var tags: [String]?
    var richLink: String?
    var linkIsSmall: Bool?
    var linkImageID: String?
    var linkHeadline: String?
    var canonicalUrl: String?
    var likeCount: Int
    var commentCount: Int
    var shareCount: Int
    var listenCount: Int
    var programID: String
    var ownerID: String
    var hasBeenPlayed = false
    var playBackProgress: CGFloat = 0
    var commentsRef: CollectionReference?
    

    init(data: [String: Any]) {
         ID = data["ID"] as! String
        
        let postedAt = data["postedAt"] as! Timestamp
        postedDate = postedAt.dateValue()
        let time = postedDate.timeAgoDisplay()
        
        timeSince = time
        timeStamp = data["postedAt"] as! Timestamp
        category = data["category"] as! String
        richLink = data["richLink"] as? String
        linkIsSmall = data["linkIsSmall"] as? Bool
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
        linkImageID = data["linkImageID"] as? String
        linkHeadline = data["linkHeadline"] as? String
        canonicalUrl = data["canonicalUrl"] as? String
        commentsRef = data["commentsRef"] as? CollectionReference
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

    
class EpisodeItem: Comparable {
    
    static func < (lhs: EpisodeItem, rhs: EpisodeItem) -> Bool {
        return lhs.postedDate < rhs.postedDate
    }
    
    static func == (lhs: EpisodeItem, rhs: EpisodeItem) -> Bool {
         return lhs.postedDate == rhs.postedDate
    }
    
    var id: String
    var category: String
    var postedDate: Date
    
    init(data:  [String: Any]) {
        self.id = data["ID"] as! String
        self.category =  data["category"] as! String
        let timeStamp = data["timeStamp"] as! Timestamp
        self.postedDate = timeStamp.dateValue()
    }
    
}
