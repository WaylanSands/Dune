//
//  User.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

struct User {
    
    static var ID: String?
    static var username: String?
    static var displayName: String?
    static var imageID: String?
    static var imagePath: String?
    static var image: UIImage?
    static var email: String?
    static var password: String?
    static var birthDate: String?
    static var isPublisher: Bool?
    static var programID: String?
    static var hasMultiplePrograms: Bool?
    static var programIDs: [String]?
    static var subscriptionIDs: [String]?    // Program IDs
    static var likedEpisodes: [String]?     // Episode IDs
    static var savedContent: [String]?     // Episode IDs
    static var draftEpisodeIDs: [String]?    // Episode IDs
    static var interests: [String]?    // Categories
    
    static func modelUser(data: [String: Any]) {
        print("Modelling User Singleton")
        ID = data["ID"] as? String
        username = data["username"] as? String
        displayName = data["displayName"] as? String
        imageID = data["imageID"] as? String
        imagePath = data["imagePath"] as? String
        email = data["email"] as? String
        birthDate = data["birthDate"] as? String
        isPublisher = data["isPublisher"] as? Bool
        programID = data["programID"] as? String
        hasMultiplePrograms = data["hasMultiplePrograms"] as? Bool
        programIDs = data["programIDs"] as? [String]
        subscriptionIDs = data["subscriptionIDs"] as? [String]
        likedEpisodes = data["likedEpisodes"] as? [String]
        savedContent = data["savedContent"] as? [String]
        draftEpisodeIDs = data["draftEpisodeIDs"] as? [String]
        interests = data["interests"] as? [String]
    }
    
}


//class CurrentUser {
//
//    var ID: String
//    var username: String
//    var displayName: String
//    var imageID: String?
//    var imagePath: String?
//    var image: UIImage?
//    var email: String
//    var password: String
//    var birthDate: String
//    var isPublisher: Bool
//    var programID: String?
//    var hasMultiplePrograms: Bool?
//    var programIDs: [String]?
//    var subscriptionIDs: [String]?
//    var likedEpisodes: [String]?
//    var savedContent: [String]?
//    var draftEpisodeIDs: [String]?
//    var interests: [String]?
//
//
//    init(userSnapshot: DocumentSnapshot) {
//        guard let data = userSnapshot.data() else { return }
//        self.ID = data["ID"] as! String
//        self.username = data["username"] as! String
//        self.displayName = data["displayName"] as! String
//        imageID = data["imageID"] as? String
//        imagePath = data["imagePath"] as? String
//        email = data["email"] as! String
//        self.birthDate = data["birthDate"] as! String
//        self.isPublisher = data["isPublisher"] as! Bool
//        programID = data["programID"] as? String
//        hasMultiplePrograms = data["hasMultiplePrograms"] as? Bool
//        programIDs = data["programIDs"] as? [String]
//        subscriptionIDs = data["subscriptionIDs"] as? [String]
//        likedEpisodes = data["likedEpisodes"] as? [String]
//        savedContent = data["savedContent"] as? [String]
//        draftEpisodeIDs = data["draftEpisodeIDs"] as? [String]
//        interests = data["interests"] as? [String]
//    }
    
//}
