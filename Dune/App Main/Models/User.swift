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
    static var isPublisher: Bool?
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
    
    static func modelUser(data: [String: Any]) {
        ID = data["ID"] as? String
        username = data["username"] as? String
        email = data["email"] as? String
        birthDate = data["birthDate"] as? String
        isPublisher = data["isPublisher"] as? Bool
        programID = data["programID"] as? String
        programIDs = data["programIDs"] as? [String]
        likedEpisodes = data["likedEpisodes"] as? [String]
        sharedEpisodes = data["sharedEpisodes"] as? [String]
        savedContent = data["savedContent"] as? [String]
        draftEpisodeIDs = data["draftEpisodeIDs"] as? [String]
        completedOnBoarding = data["completedOnBoarding"] as? Bool
        upVotedComments = data["upVotedComments"] as? [String]
        downVotedComments = data["downVotedComments"] as? [String]
    }
    
    static func signOutUser() {
        username = nil
        email = nil
        socialSignUp = nil
        password = nil
        birthDate = nil
        isPublisher = nil
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
    }
    
}

