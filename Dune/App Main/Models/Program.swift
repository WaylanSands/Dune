//
//  Program.swift
//  Dune
//
//  Created by Waylan Sands on 1/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

public class Program: Comparable {
    
    var ID: String
    var rep: Int
    var name: String
    var username: String
    var ownerID: String
    var summary: String
    var webLink: String?
    var hasMentions: Bool
    var repMethods: [String]
    var isPrimaryProgram: Bool
    var tags: [String]
    var subscriberCount: Int
    var episodeIDs: [[String : Any]]
    var subscriberIDs: [String]
    var subscriptionIDs: [String]
    var hasIntro: Bool
    var subPrograms: [Program]?
    var programIDs: [String]?
    var image: UIImage?
    var imageID: String?
    var imagePath: String?
    var introID: String?
    var introPath: String?
    var primaryCategory: String?
    var hasBeenPlayed = false
    var playBackProgress: CGFloat = 0
    
    // Private Channels
    var channelState: PrivacyStatus
    var pendingChannels: [String]
    var deniedChannels: [String]
    var isPrivate: Bool

    
    init(data: [String: Any]) {
        rep = data["rep"] as! Int
        ID = data["ID"] as! String
        name = data["name"] as! String
        hasMentions = data["hasMentions"] as! Bool
        username = data["username"] as! String
        summary = data["summary"] as! String
        ownerID = data["ownerID"] as! String
        hasIntro = data["hasIntro"] as! Bool
        repMethods = data["repMethods"] as! [String]
        subscriberCount = data["subscriberCount"] as! Int
        tags = data["tags"] as! [String]
        isPrimaryProgram = data["isPrimaryProgram"] as! Bool
        episodeIDs = data["episodeIDs"] as! [[String : Any]]
        subscriberIDs = data["subscriberIDs"] as! [String]
        webLink = data["webLink"] as? String
        programIDs = data["programIDs"] as? [String]
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        introID = data["introID"] as? String
        introPath = data["introPath"] as? String
        subscriptionIDs = data["subscriptionIDs"] as! [String]
        primaryCategory = data["primaryCategory"] as? String
        
        
        // Private channel
        pendingChannels = data["pendingChannels"] as! [String]
        deniedChannels = data["deniedChannels"] as! [String]
        
        let state = data["channelState"] as? String
        switch state {
        case PrivacyStatus.madePublic.rawValue:
            channelState = .madePublic
            isPrivate  = false
        case PrivacyStatus.madePrivate.rawValue:
            channelState = .madePrivate
            isPrivate  = true
        default:
            channelState = .madePublic
            isPrivate  = false
        }
        
        if imageID != nil {
            FileManager.getImageWith(imageID: imageID!) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            self.image = #imageLiteral(resourceName: "missing-image-large")
        }
        
        if isPrimaryProgram && !programIDs!.isEmpty {
            FireStoreManager.fetchSubProgramsWithIDs(programIDs: programIDs!, for: self) {
            }
        }
    }
    
    func programsIDs() -> [String] {
        if !self.programIDs!.isEmpty {
            var ids = programIDs!
            ids.append(ID)
            return ids
        } else {
            return [ID]
        }
    }
    
    public static func < (lhs: Program, rhs: Program) -> Bool {
        return lhs.subscriberCount < rhs.subscriberCount
    }
    
    public static func == (lhs: Program, rhs: Program) -> Bool {
         return lhs.subscriberCount == rhs.subscriberCount
    }
    
}
