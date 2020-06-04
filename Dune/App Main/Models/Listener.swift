//
//  Listener.swift
//  Dune
//
//  Created by Waylan Sands on 1/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class Listener {
    
    var ID: String
    var username: String
    var displayName: String
    var summary: String
    var tags: [String]
    var imageID: String?
    var imagePath: String?
    var image: UIImage?
    var subscriberCount: Int
    var webLink: String?
    var subscriberIDs: [String]
    var favouriteIDs: [String]
    var favouritePrograms: [Program]?
    var subscriptionIDs: [String]
    var interests: [String]
    
    init(data: [String: Any]) {
        ID = data["ID"] as! String
        displayName = data["ID"] as! String
        username = data["username"] as! String
        summary = data["summary"] as! String
        subscriberCount = data["subscriberCount"] as! Int
        tags = data["tags"] as! [String]
        interests = data["interests"] as! [String]
        subscriberIDs = data["subscriberIDs"] as! [String]
        webLink = data["webLink"] as? String
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        favouriteIDs = data["favouriteIDs"] as! [String]
        subscriptionIDs = data["subscriptionIDs"] as! [String]
        
        if imageID != nil {
            FileManager.getImageWith(imageID: imageID!) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            self.image = #imageLiteral(resourceName: "missing-image-large")
        }
        
        if favouriteIDs.count != 0 {
            print(favouriteIDs)
            FireStoreManager.fetchFavouriteProgramsWithIDs(programIDs: favouriteIDs, for: self) {
            }
        }
    }
}


