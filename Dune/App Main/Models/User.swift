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
    static var email: String?
    static var socialSignUp: Bool?
    static var password: String?
    static var birthDate: String?
    static var isSetUp: Bool?
    static var interests: [String]?
    static var programID: String?
    static var programIDs: [String]?
    static var likedEpisodes: [String]?
    static var sharedEpisodes: [String]?
    static var savedContent: [String]?
    static var draftEpisodeIDs: [String]?
    static var completedOnBoarding: Bool?
    static var upVotedComments: [String]?
    static var recommendedProgram: Program?
    static var downVotedComments: [String]?
    static var surveysCompleted: [String]?
    
    // Location
    static var geoPoint: GeoPoint?
    static var country: String?

    // Push notifications
    static var didAllowNotifications: Bool?
    static var didAllowNewEpisodeNotifications: Bool?
    static var didAllowTaggingNotifications: Bool?
    static var didAllowCommentNotifications: Bool?
    static var didAllowMarketingNotifications: Bool?
    static var didAllowEpisodeLikeNotifications: Bool?
    static var didAllowEpisodeCommentNotifications: Bool?
    static var didAllowNewSubscriptionNotifications: Bool?
    
    // Email
    static var didAllowEmailNotifications: Bool?
    
    // For progress tracking
//    static var playedEpisodeIDs: [String]?

    
    static func modelUser(data: [String: Any]) {
        ID = data["ID"] as? String
        email = data["email"] as? String
        isSetUp = data["isSetUp"] as? Bool
        username = data["username"] as? String
        birthDate = data["birthDate"] as? String
        programID = data["programID"] as? String
        interests = data["interests"] as? [String]
        programIDs = data["programIDs"] as? [String]
        likedEpisodes = data["likedEpisodes"] as? [String]
        sharedEpisodes = data["sharedEpisodes"] as? [String]
        savedContent = data["savedContent"] as? [String]
        surveysCompleted = data["surveysCompleted"] as? [String]
        draftEpisodeIDs = data["draftEpisodeIDs"] as? [String]
        completedOnBoarding = data["completedOnBoarding"] as? Bool
        upVotedComments = data["upVotedComments"] as? [String]
        downVotedComments = data["downVotedComments"] as? [String]
        
        // Location
        country = data["country"] as? String
        geoPoint = data["geoPoint"] as? GeoPoint

        //Push Notifications
        didAllowNotifications = data["didAllowNotifications"] as? Bool
        didAllowTaggingNotifications = data["didAllowTaggingNotifications"] as? Bool
        didAllowCommentNotifications = data["didAllowCommentNotifications"] as? Bool
        didAllowMarketingNotifications = data["didAllowMarketingNotifications"] as? Bool
        didAllowEpisodeLikeNotifications = data["didAllowEpisodeLikeNotifications"] as? Bool
        didAllowNewEpisodeNotifications = data["didAllowNewEpisodeNotifications"] as? Bool
        didAllowEpisodeCommentNotifications = data["didAllowEpisodeCommentNotifications"] as? Bool
        didAllowNewSubscriptionNotifications = data["didAllowNewSubscriptionNotifications"] as? Bool
        
        // Email
        didAllowEmailNotifications = data["didAllowEmailNotifications"] as? Bool
        
        // Progress tracking

        if let episodes = likedEpisodes {
            print("Search")
            FireStoreManager.topThreeInterests(with: episodes)
        }
    }
    
    static var playedEpisodeIDs: [String] = {
        if UserDefaults.standard.stringArray(forKey: "playedEpisodes") == nil {
            UserDefaults.standard.setValue([], forKey: "playedEpisodes")
        }
        return UserDefaults.standard.stringArray(forKey: "playedEpisodes")!
    }()
    
    static func appendPlayedEpisode(ID: String, progress: CGFloat) {
        var IDs = UserDefaults.standard.stringArray(forKey: "playedEpisodes")!
        if !hasPlayed(ID: ID) {
            IDs.append(ID)
            UserDefaults.standard.setValue(IDs, forKey: "playedEpisodes")
        }
        UserDefaults.standard.setValue(progress, forKey: ID)
    }
    
    static func hasPlayed(ID: String) -> Bool {
        return playedEpisodeIDs.contains(ID)
    }
    
    static func progressFor(ID: String) -> CGFloat? {
        let progress = UserDefaults.standard.float(forKey: ID)
        return CGFloat(progress)
    }
    
    static func signOutUser() {
        username = nil
        email = nil
        country = nil
        isSetUp = nil
        interests = nil
        socialSignUp = nil
        password = nil
        birthDate = nil
        programID = nil
        programIDs = nil
        likedEpisodes = nil
        sharedEpisodes = nil
        savedContent = nil
        draftEpisodeIDs = nil
        completedOnBoarding = nil
        upVotedComments = nil
        recommendedProgram = nil
        downVotedComments = nil
        surveysCompleted = nil
        
        // Pushes
        didAllowNotifications = nil
        didAllowTaggingNotifications = nil
        didAllowCommentNotifications = nil
        didAllowMarketingNotifications = nil
        didAllowNewEpisodeNotifications = nil
        didAllowEpisodeLikeNotifications = nil
        didAllowEpisodeCommentNotifications = nil
        didAllowNewSubscriptionNotifications = nil
        
        // Email
        didAllowEmailNotifications = nil
    }
    
}

