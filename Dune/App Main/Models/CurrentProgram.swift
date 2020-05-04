//
//  Channel.swift
//  Dune
//
//  Created by Waylan Sands on 13/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

struct CurrentProgram {
    
    static var ID: String?
    static var name: String?
    static var ownerID: String?
    static var hasIntro: Bool?
    static var image: UIImage?
    static var imageID: String?
    static var imagePath: String?
    static var introID: String?
    static var introPath: String?
    static var summary: String?
    static var isPrimaryProgram: Bool?
    static var primaryCategory: String?
    static var hasMultiplePrograms: Bool?
    static var tags: [String?]?
    static var episodeIDs: [String]?
    static var subscriberIDs: [String]?
    
    static func modelProgram(data: [String: Any]) {
        print("Modelling Program Singleton")
        ID = data["ID"] as? String
        name = data["name"] as? String
        summary = data["summary"] as? String
        ownerID = data["ownerID"] as? String
        hasIntro = data["hasIntro"] as? Bool
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        introID = data["introID"] as? String
        introPath = data["introPath"] as? String
        hasMultiplePrograms = data["hasMultiplePrograms"] as? Bool
        isPrimaryProgram = data["isPrimaryProgram"] as? Bool
        primaryCategory = data["primaryCategory"] as? String
        tags = data["tags"] as? [String]
        episodeIDs = data["episodeIDs"] as? [String]
        subscriberIDs = data["subscriberIDs"] as? [String]
        
        print("This is the image ID \(imageID!)")
        
        guard let imageID = imageID else { return }
        print("This ran")
        FileManager.getImageWith(imageID: imageID) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    
}


