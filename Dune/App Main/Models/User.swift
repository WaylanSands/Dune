//
//  User.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

struct User {
    static var userID: String?
    static var username: String?
    static var displayName: String?
    static var profileImage: String?
    static var email: String?
    static var password: String?
    static var birthDate: String?
    static var accountType: String?
    static var hasChannel: Bool?
    static var hasProgram: Bool?
    static var hasUnpublishedContent: Bool?
    static var channelID: String?
    static var programID: String?
    static var programs: [String]?         // Episode IDs
    static var subscriptions: [String]?    // Program IDs
    static var likedContent: [String]?     // Episode IDs
    static var savedContent: [String]?     // Episode IDs
    static var draftEpisodes: [String]?    // Episode IDs
    static var interests: [String]?    // Categories
}
