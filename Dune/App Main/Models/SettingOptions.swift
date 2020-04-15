//
//  SettingOptions.swift
//  Dune
//
//  Created by Waylan Sands on 7/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit

class Setting {
    let name: String
    let imageName: String?
    
    init(name: String, imageName: String?) {
        self.name = name
        self.imageName = imageName
    }
}

enum settingsType {
    case categories
    case countries
    case sharing
}

class SettingOptions {
    
    static let categories: [Setting] = [
        Setting(name: Categories.arts.rawValue, imageName: nil),
        Setting(name: Categories.business.rawValue, imageName: nil),
        Setting(name: Categories.comedy.rawValue, imageName: nil),
        Setting(name: Categories.education.rawValue, imageName: nil),
        Setting(name: Categories.entertainment.rawValue, imageName: nil),
        Setting(name: Categories.gamesAndHobbies.rawValue, imageName: nil),
        Setting(name: Categories.healthAndFitness.rawValue, imageName: nil),
        Setting(name: Categories.history.rawValue, imageName: nil),
        Setting(name: Categories.mindfulness.rawValue, imageName: nil),
        Setting(name: Categories.motivation.rawValue, imageName: nil),
        Setting(name: Categories.music.rawValue, imageName: nil),
        Setting(name: Categories.news.rawValue, imageName: nil),
        Setting(name: Categories.religionAndSpirituality.rawValue, imageName: nil),
        Setting(name: Categories.science.rawValue, imageName: nil),
        Setting(name: Categories.sports.rawValue, imageName: nil),
        Setting(name: Categories.tech.rawValue, imageName: nil),
        Setting(name: Categories.trueCrime.rawValue, imageName: nil),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let sharing: [Setting] = [
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via email", imageName: "email-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let countries: [String] = [
        "Australia",
        "USA"
    ]
    
}
