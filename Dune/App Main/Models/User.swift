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
    static var summary: String?
    static var tags: [String]?
    static var imageID: String?
    static var imagePath: String?
    static var image: UIImage?
    static var email: String?
    static var socialSignUp: Bool?
    static var subscriberCount: Int?
    static var webLink: String?
    static var subscriberIDs: [String]?
    static var password: String?
    static var birthDate: String?
    static var isPublisher: Bool?
    static var programID: String?
    static var hasMultiplePrograms: Bool?
    static var favouriteIDs: [String]?
    static var favouritePrograms: [Program]?
    static var programIDs: [String]?
    static var subscriptionIDs: [String]?
    static var likedEpisodes: [String]?
    static var sharedEpisodes: [String]?
    static var savedContent: [String]?
    static var draftEpisodeIDs: [String]?
    static var interests: [String]?
    static var completedOnBoarding: Bool?
    static var upVotedComments: [String]?
    static var downVotedComments: [String]?
    
    static func modelUser(data: [String: Any]) {
        print("Modelling User")
        ID = data["ID"] as? String
        webLink = data["webLink"] as? String
        summary = data["summary"] as? String
        tags = data["tags"] as? [String]
        username = data["username"] as? String
        subscriberCount = data["subscriberCount"] as? Int
        subscriberIDs = data["subscriberIDs "] as? [String]
        displayName = data["displayName"] as? String
        favouriteIDs = data["favouriteIDs"] as? [String]
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
        sharedEpisodes = data["sharedEpisodes"] as? [String]
        savedContent = data["savedContent"] as? [String]
        draftEpisodeIDs = data["draftEpisodeIDs"] as? [String]
        interests = data["interests"] as? [String]
        completedOnBoarding = data["completedOnBoarding"] as? Bool
        upVotedComments = data["upVotedComments"] as? [String]
        downVotedComments = data["downVotedComments"] as? [String]
        
        if imageID != nil {
            FileManager.getImageWith(imageID: imageID!) { image in
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } else {
            self.image = #imageLiteral(resourceName: "missing-image-large")
        }
        
        if !isPublisher! && favouriteIDs?.count != 0 {
            FireStoreManager.fetchFavouriteProgramsWithIDs(programIDs: favouriteIDs!, for: nil) {
            }
        }
    }
    
    static func signOutUser() {
        ID = nil
        username = nil
        tags = nil
        displayName = nil
        favouriteIDs = nil
        subscriberIDs = nil
        subscriberCount = nil
        webLink = nil
        summary = nil
        imageID = nil
        imagePath = nil
        image = nil
        email = nil
        password = nil
        birthDate = nil
        isPublisher = nil
        programID = nil
        hasMultiplePrograms = nil
        programIDs = nil
        subscriptionIDs = nil
        likedEpisodes = nil
        sharedEpisodes = nil
        savedContent = nil
        draftEpisodeIDs = nil
        interests = nil
        completedOnBoarding = nil
    }
    
}

