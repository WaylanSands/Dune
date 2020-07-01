//
//  Channel.swift
//  Dune
//
//  Created by Waylan Sands on 13/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

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
        ID = nil
        rep = nil
        name = nil
        hasMentions = nil
        username = nil
        ownerID = nil
        image = nil
        imageID = nil
        webLink = nil
        repMethods = nil
        imagePath = nil
        hasIntro = nil
        introID = nil
        introPath = nil
        summary = nil
        subscriberCount = nil
        isPrimaryProgram = nil
        primaryCategory = nil
        programIDs = nil
        subPrograms = nil
        mentions = nil
        tags = nil
        episodeIDs = nil
        subscriberIDs = nil
        subscriptionIDs = nil
    }

    
    
}


