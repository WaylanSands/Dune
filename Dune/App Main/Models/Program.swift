//
//  Program.swift
//  Dune
//
//  Created by Waylan Sands on 1/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class Program {
    
    var ID: String
    var name: String
    var username: String
    var ownerID: String
    var summary: String
    var webLink: String?
    var isPrimaryProgram: Bool
    var tags: [String]
    var subscriberCount: Int
    var episodeIDs: [[String : Any]]
    var subscriberIDs: [String]
    var hasIntro: Bool
    var hasMultiplePrograms: Bool?
    var subPrograms: [Program]?
    var programIDs: [String]?
    var image: UIImage?
    var imageID: String?
    var imagePath: String?
    var introID: String?
    var introPath: String?
    var primaryCategory: String?
    
    init(data: [String: Any]) {        
        ID = data["ID"] as! String
        name = data["name"] as! String
        username = data["username"] as! String
        summary = data["summary"] as! String
        ownerID = data["ownerID"] as! String
        hasIntro = data["hasIntro"] as! Bool
        subscriberCount = data["subscriberCount"] as! Int
        tags = data["tags"] as! [String]
        isPrimaryProgram = data["isPrimaryProgram"] as! Bool
        episodeIDs = data["episodeIDs"] as! [[String : Any]]
        subscriberIDs = data["subscriberIDs"] as! [String]
        webLink = data["webLink"] as? String
        hasMultiplePrograms = data["hasMultiplePrograms"] as? Bool
        programIDs = data["programIDs"] as? [String]
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        introID = data["introID"] as? String
        introPath = data["introPath"] as? String
        primaryCategory = data["primaryCategory"] as? String
        
        if imageID != nil {
            
            FileManager.getImageWith(imageID: imageID!) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            self.image = #imageLiteral(resourceName: "missing-image-large")
        }
        
            if isPrimaryProgram && hasMultiplePrograms! {
                FireStoreManager.fetchSubProgramsWithIDs(programIDs: programIDs!, for: self) {
                    print("Sub programs added")
                }
            }
    }
    
    func programsIDs() -> [String] {
        if self.hasMultiplePrograms! {
            var ids = programIDs!
            ids.append(ID)
            return ids
        } else {
            return [CurrentProgram.ID!]
        }
    }

}
