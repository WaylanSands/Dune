//
//  Mention.swift
//  Dune
//
//  Created by Waylan Sands on 6/6/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

enum MentionType: String {
    case commentReply
    case commentTag
    case episodeTag
}

class Mention {
    var ID: String
    var type: String
    var image: UIImage?
    var imageID: String
    var caption: String
    var taggedID: String
    var contentID: String
    var timeSince: String
    var postedDate: Timestamp
    var publisherID: String
    var primaryEpisodeID: String
    var publisherUsername: String
    
    init(data: [String: Any]) {
        postedDate = data["postedDate"] as! Timestamp
        let date = postedDate.dateValue()
        timeSince = date.timeAgoDisplay()
        publisherUsername = data["publisherUsername"] as! String
        primaryEpisodeID = data["primaryEpisodeID"] as! String
        publisherID = data["publisherID"] as! String
        contentID = data["contentID"] as! String
        taggedID = data["taggedID"] as! String
        imageID = data["imageID"] as! String
        caption = data["caption"] as! String
        type = data["type"] as! String
        ID = data["ID"] as! String
    }
}
