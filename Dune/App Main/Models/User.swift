//
//  User.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

struct User {
    
    static var ID: String?
    static var username: String?
    static var displayName: String?
    static var storedImageID: String?
    static var imagePath: String?
    static var image: UIImage?
    static var email: String?
    static var password: String?
    static var birthDate: String?
    static var isPublisher: Bool?
    static var programID: String?
    static var hasMultiplePrograms: Bool?
    static var hasUnpublishedContent: Bool?
    static var programs: [String]?         // Episode IDs
    static var subscriptionIDs: [String]?    // Program IDs
    static var likedContent: [String]?     // Episode IDs
    static var savedContent: [String]?     // Episode IDs
    static var draftEpisodes: [String]?    // Episode IDs
    static var interests: [String]?    // Categories
    
    static func modelUser(data: [String: Any]) {
        print("Modeling User Singleton")
        ID = data["userID"] as? String
        username = data["username"] as? String
        displayName = data["displayName"] as? String
        storedImageID = data["storedImageID"] as? String
        imagePath = data["primaryImagePath"] as? String
        email = data["email"] as? String
        birthDate = data["birthDate"] as? String
        isPublisher = data["isPublisher"] as? Bool
        programID = data["programID"] as? String
        hasMultiplePrograms = data["hasMultiplePrograms"] as? Bool
        hasUnpublishedContent = data["hasUnpublishedContent"] as? Bool
        programs = data["programs"] as? [String]
        subscriptionIDs = data["subscriptionIDs"] as? [String]
        likedContent = data["likedContent"] as? [String]
        savedContent = data["savedContent"] as? [String]
        draftEpisodes = data["draftEpisodes"] as? [String]
        interests = data["interests"] as? [String]
    }
    
}

