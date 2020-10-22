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
    case programNames
    case categories
    case countries
    case sharing
    case subscriptionEpisode
    case listener
    case program
    case ownEpisode
}

class SettingOptions {
    
    static let categories: [Setting] = [
        Setting(name: Category.finance.rawValue, imageName: nil),
        Setting(name: Category.business.rawValue, imageName: nil),
        Setting(name: Category.comedy.rawValue, imageName: nil),
        Setting(name: Category.education.rawValue, imageName: nil),
        Setting(name: Category.entertainment.rawValue, imageName: nil),
        Setting(name: Category.gaming.rawValue, imageName: nil),
        Setting(name: Category.healthAndFitness.rawValue, imageName: nil),
        Setting(name: Category.history.rawValue, imageName: nil),
        Setting(name: Category.mindfulness.rawValue, imageName: nil),
        Setting(name: Category.globalNews.rawValue, imageName: nil),
        Setting(name: Category.music.rawValue, imageName: nil),
        Setting(name: Category.localNews.rawValue, imageName: nil),
        Setting(name: Category.religionAndSpirituality.rawValue, imageName: nil),
        Setting(name: Category.science.rawValue, imageName: nil),
        Setting(name: Category.sports.rawValue, imageName: nil),
        Setting(name: Category.tech.rawValue, imageName: nil),
        Setting(name: Category.politics.rawValue, imageName: nil),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let sharing: [Setting] = [
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
//        Setting(name: "Share via email", imageName: "email-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let subscriptionEpisode: [Setting] = [
//        Setting(name: "Unsubscribe", imageName: nil),
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Report", imageName: "report-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let nonSubscriptionEpisode: [Setting] = [
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
        Setting(name: "Report", imageName: "report-icon"),

//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let programSettings: [Setting] = [
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
        Setting(name: "Report", imageName: "report-icon"),

//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let programSettingsPrivateOn: [Setting] = [
        Setting(name: "Remove", imageName: nil),
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
        Setting(name: "Report", imageName: "report-icon"),
//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let ownEpisode: [Setting] = [
        Setting(name: "Delete", imageName: "trash-icon"),
        Setting(name: "Edit", imageName: "edit-icon"),
        Setting(name: "Share via SMS", imageName: "message-friend-icon"),
        Setting(name: "Share via...", imageName: "native-share-icon"),
//        Setting(name: "Share on Facebook", imageName: "facebook-friend-icon"),
//        Setting(name: "Share on Twitter", imageName: "twitter-friend-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let listenerSettings: [Setting] = [
        Setting(name: "Report", imageName: "report-icon"),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let listenerSettingsPrivateOn: [Setting] = [
        Setting(name: "Report", imageName: "report-icon"),
        Setting(name: "Remove", imageName: nil),
        Setting(name: "Cancel", imageName: "cancel-icon"),
    ]
    
    static let countries: [String] = [
        "Australia",
        "USA"
    ]
    
    static let deleteListener: [Setting] = [
        Setting(name: "Not enough quality content", imageName: nil),
        Setting(name: "Not enough quality channels", imageName: nil),
        Setting(name: "Poor audio quality", imageName: nil),
        Setting(name: "Content loads slow", imageName: nil),
        Setting(name: "Too many bugs", imageName: nil),
        Setting(name: "Not what you expected", imageName: nil),
    ]
    
    static let deletePublisher: [Setting] = [
        Setting(name: "Not enough quality content", imageName: nil),
        Setting(name: "Not enough listeners", imageName: nil),
        Setting(name: "Poor audio quality", imageName: nil),
        Setting(name: "Studio needs work", imageName: nil),
        Setting(name: "Too many bugs", imageName: nil),
        Setting(name: "Not what you expected", imageName: nil),
    ]
    
}
