//
//  Channel.swift
//  Dune
//
//  Created by Waylan Sands on 13/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

enum PrivacyStatus: String {
    case madePublic
    case madePrivate
}

struct CurrentProgram {
    
    static var rep: Int?
    static var ID: String?
    static var name: String?
    static var username: String?
    static var ownerID: String?
    static var image: UIImage?
    static var repMethods: [String]?
    static var subPrograms: [Program]?
    static var mentions: [Mention]?
    static var subscriberCount: Int?
    static var hasMentions: Bool?
    static var imageID: String?
    static var imagePath: String?
    static var hasIntro: Bool?
    static var introID: String?
    static var introPath: String?
    static var summary: String?
    static var webLink: String?
    static var isPrimaryProgram: Bool?
    static var primaryCategory: String?
    static var programIDs: [String]?
    static var tags: [String]?
    static var subscriptionIDs: [String]?
    static var episodeIDs: [[String: Any]]?
    static var subscriberIDs: [String]?
    static var isPublisher: Bool?
    
    // Private Channels
    static var privacyStatus: PrivacyStatus?
    static var pendingChannels: [String]?
    static var deniedChannels: [String]?
    static var isPrivate: Bool?
    
    static func modelProgram(data: [String: Any]) {
        ID = data["ID"] as? String
        rep = data["rep"] as? Int
        name = data["name"] as? String
        username = data["username"] as? String
        subscriberCount = data["subscriberCount"] as? Int
        summary = data["summary"] as? String
        webLink = data["webLink"] as? String
        ownerID = data["ownerID"] as? String
        hasIntro = data["hasIntro"] as? Bool
        hasMentions = data["hasMentions"] as? Bool
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        introID = data["introID"] as? String
        introPath = data["introPath"] as? String
        repMethods = data["repMethods"] as? [String]
        programIDs = data["programIDs"] as? [String]
        isPrimaryProgram = data["isPrimaryProgram"] as? Bool
        primaryCategory = data["primaryCategory"] as? String
        tags = data["tags"] as? [String]
        episodeIDs = data["episodeIDs"] as? [[String: Any]]
        subscriberIDs = data["subscriberIDs"] as? [String]
        subscriptionIDs = data["subscriptionIDs"] as? [String]
        isPublisher = data["isPublisher"] as? Bool
        
        // Private channel
        pendingChannels = data["pendingChannels"] as? [String]
        deniedChannels = data["deniedChannels"] as? [String]
        
        let state = data["channelState"] as? String
        switch state {
        case PrivacyStatus.madePublic.rawValue:
            privacyStatus = .madePublic
            isPrivate = false
        case PrivacyStatus.madePrivate.rawValue:
            privacyStatus = .madePrivate
             isPrivate = true
        default:
            privacyStatus = .madePublic
            isPrivate = false
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
        
        if !programIDs!.isEmpty {
            FireStoreManager.fetchSubProgramsWithIDs(programIDs: programIDs!, for: nil) {
            }
        }  else {
            subPrograms = [Program]()
        }
        
    }
    
    static func programsIDs() -> [String] {
        if !self.programIDs!.isEmpty {
            var ids = programIDs!
            ids.append(ID!)
            return ids
        } else {
            return [CurrentProgram.ID!]
        }
    }
    
    static func signOutProgram() {
        pendingChannels = nil
        deniedChannels = nil
        isPublisher = nil
        rep = nil
        ID = nil
        name = nil
        username = nil
        ownerID = nil
        image = nil
        repMethods = nil
        subPrograms = nil
        mentions = nil
        subscriberCount = nil
        privacyStatus = nil
        hasMentions = nil
        imageID = nil
        imagePath = nil
        hasIntro = nil
        introID = nil
        introPath = nil
        summary = nil
        webLink = nil
        isPrimaryProgram = nil
        primaryCategory = nil
        programIDs = nil
        tags = nil
        subscriptionIDs = nil
        episodeIDs = nil
        subscriberIDs = nil
    }
    
    
}
