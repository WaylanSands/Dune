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
    var hasIntro: Bool
    var summary: String
    var isPrimaryProgram: Bool
    var hasMultiplePrograms: Bool
    var episodeIDs: [String]
    var subscriberIDs: [String]
    var subscriberCount: Int
    var image: UIImage?
    var imageID: String?
    var imagePath: String?
    var introID: String?
    var introPath: String?
    var primaryCategory: String?
    var tags: [String?]
    
    init(data: [String: Any]) {
        print("Modelling Program")
        
        ID = data["ID"] as! String
        name = data["name"] as! String
        username = data["username"] as! String
        summary = data["summary"] as! String
        ownerID = data["ownerID"] as! String
        hasIntro = data["hasIntro"] as! Bool
        subscriberCount = data["subscriberCount"] as! Int
        hasMultiplePrograms = data["hasMultiplePrograms"] as! Bool
        isPrimaryProgram = data["isPrimaryProgram"] as! Bool
        episodeIDs = data["episodeIDs"] as! [String]
        subscriberIDs = data["subscriberIDs"] as! [String]
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        introID = data["introID"] as? String
        introPath = data["introPath"] as? String
        primaryCategory = data["primaryCategory"] as? String
        tags = data["tags"] as! [String?]
        
        guard let imageID = imageID else { return }
        
        FileManager.getImageWith(imageID: imageID) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    
}
