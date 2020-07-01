//
//  Comment.swift
//  Dune
//
//  Created by Waylan Sands on 30/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct Comment {
    
    var isTableViewHeader = false
    var profileImageID: String
    var profileImage: UIImage?
    var postedDate: Timestamp
    var subCommentCount: Int
    var isUnwrapped = false
    var isSubComment: Bool
    var primaryID: String?
    var episodeID: String
    var timeSince: String
    var username: String
    var programID: String
    var comment: String
    var voteCount: Int
    var ID : String
    
    init(data: [String: Any]) {
        postedDate = data["postedDate"] as! Timestamp
        let date = postedDate.dateValue()
        timeSince = date.timeAgoDisplay()
        profileImageID = data["profileImageID"] as! String
        subCommentCount = data["subCommentCount"] as! Int
        isSubComment = data["isSubComment"] as! Bool
        episodeID = data["episodeID"] as! String
        primaryID = data["primaryID"] as? String
        programID = data["programID"] as! String
        username = data["username"] as! String
        voteCount = data["voteCount"] as! Int
        comment = data["comment"] as! String
        ID = data["ID"] as! String
    }
    
    init(episode: Episode) {
        postedDate = episode.timeStamp
        let date = postedDate.dateValue()
        timeSince = date.timeAgoDisplay()
        profileImageID = episode.imageID
        programID = episode.programID
        username = episode.username
        comment = episode.caption
        isTableViewHeader = true
        episodeID = episode.ID
        isSubComment = false
        subCommentCount = 0
        voteCount = .max
        ID = episode.ID
        primaryID = nil
    }
    
    
}
