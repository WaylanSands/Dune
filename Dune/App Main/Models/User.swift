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
    var userID: String
    var name: String
    var handel: String
    var image: UIImage
    var email: String
    var age: Int
    var accountType: AccountType
    var hasChannel: Bool
    var hasProgram: Bool
    var hasUnpublishedContent: Bool
    var channelID: String
    var programID: String
    var subscriptions: [String] // Program IDs
    var likedContent: [String]? // Episode IDs
    var savedContent: [String]? // Episode IDs
    var draftEpisodes: [String]? // Episode IDs
    var interests: [Categories] // Categories
    //    var country: enum
    
//    init(user: userDocument) {
//        self.age = user.age
//    }
}
