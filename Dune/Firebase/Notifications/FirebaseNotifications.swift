//
//  FirebaseNotifications.swift
//  Dune
//
//  Created by Waylan Sands on 21/9/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging
import FirebaseFirestore

enum DuneNotification: String {
    case newEpisodes = "didAllowNewEpisodeNotifications"
    case taggingNotifications = "didAllowTaggingNotifications"
    case commentNotifications = "didAllowCommentNotifications"
    case marketingNotifications = "didAllowMarketingNotifications"
    case episodeLikeNotifications = "didAllowEpisodeLikeNotifications"
    case episodeCommentNotifications = "didAllowEpisodeCommentNotifications"
    case newSubscriberNotifications = "didAllowNewSubscriptionNotifications"
}

struct FirebaseNotifications {
    
    static let db = Firestore.firestore()
    
    static var askedPermission: Bool {
        return UserDefaults.standard.bool(forKey: "askedPermissionForNotifications")
    }

    static func updateUsersFirebaseRegistration()  {
                
        Messaging.messaging().token { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let token = result {
                print("Received remote instance token")
                updateFirebaseRegistration(token: token)
                allowAllNotifications()
            }
        }
    }
    
    static func userDidAllowNotifications(_ allowed: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").document(User.ID!)
            User.didAllowNotifications = allowed
            
            userRef.updateData([
                "didAllowNotifications" : allowed
            ]) { (error) in
                if let error = error {
                    print("Error updating user's notification status: \(error.localizedDescription)")
                } else {
                    print("Successfully updated user's notification status")
                }
            }
        }
    }

    static func updateFirebaseRegistration(token: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "firebaseRegistrationToken" : token
            ]) { (error) in
                if let error = error {
                    print("Error updating user's token: \(error.localizedDescription)")
                } else {
                    print("Successfully updated user's token")
                }
            }
        }
    }
    
    static func toggle(notification: DuneNotification, on: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").document(User.ID!)
            let notificationType = notification.rawValue
            
            switch notification {
            case .commentNotifications:
                User.didAllowCommentNotifications = on
            case .taggingNotifications:
                User.didAllowTaggingNotifications = on
            case .marketingNotifications:
                User.didAllowMarketingNotifications = on
            case .newEpisodes:
                User.didAllowNewEpisodeNotifications = on
            case .episodeLikeNotifications:
                User.didAllowEpisodeLikeNotifications = on
            case .episodeCommentNotifications:
                User.didAllowEpisodeCommentNotifications = on
            case .newSubscriberNotifications:
                User.didAllowNewSubscriptionNotifications = on
            }
            
            userRef.updateData([
                notificationType : on,
            ]) { (error) in
                if let error = error {
                    print("Error toggling \(notificationType): \(error.localizedDescription)")
                } else {
                    print("Successfully toggled \(notificationType)")
                }
            }
        }
    }
    
    static func allowAllNotifications() {
        
        User.didAllowNotifications = true
        User.didAllowTaggingNotifications = true
        User.didAllowCommentNotifications = true
        User.didAllowMarketingNotifications = true
        User.didAllowNewEpisodeNotifications = true
        User.didAllowEpisodeLikeNotifications = true
        User.didAllowEpisodeCommentNotifications = true
        User.didAllowNewSubscriptionNotifications = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "didAllowNotifications" : true,
                "didAllowTaggingNotifications" : true,
                "didAllowCommentNotifications" : true,
                "didAllowMarketingNotifications" : true,
                "didAllowNewEpisodeNotifications" : true,
                "didAllowEpisodeLikeNotifications" : true,
                "didAllowEpisodeCommentNotifications" : true,
                "didAllowNewSubscriptionNotifications" : true,
            ]) { (error) in
                if let error = error {
                    print("Error allowing all notifications: \(error.localizedDescription)")
                } else {
                    print("Successfully allowed all notifications")
                }
            }
        }
    }
    
    static func subscribeToChannelsNotifications(channelID: String, register: Bool) {
        
        if User.didAllowNotifications == true {
            if register {
                Messaging.messaging().subscribe(toTopic: channelID) { error in
                    if error == nil {
                        print("Subscribed to channel for notifications")
                    }
                }
            } else {
                Messaging.messaging().unsubscribe(fromTopic: channelID) { error in
                    print("Unsubscribed from channel")
                }
            }
        }
    }
    
    static func unsubscribeFromAllChannels() {
        for eachID in CurrentProgram.subscriptionIDs! {
            Messaging.messaging().unsubscribe(fromTopic: eachID) { error in
                print("Unsubscribed from all channels")
            }
        }
    }
    
    static func subscribeToAllChannels() {
        for eachID in CurrentProgram.subscriptionIDs! {
            Messaging.messaging().subscribe(toTopic: eachID) { error in
                print("Subscribed to channel with ID \(eachID)")
            }
        }
    }
    
    static func notifySubscribersWith(episodeID: String, channelID: String, channelName: String, imageID: String, caption: String) {
                
//        var message = {
//                "notification": {
//                    "title" : "Portugal vs. Denmark",
//                    "body" : "great match!"
//                },
//                "data" : {
//                    "Nick" : "Mario",
//                    "Room" : "PortugalVSDenmark"
//                },
//                "topic": channelID
//            }
//
//
//            // Send a message to devices subscribed to the provided topic.
//            admin.messaging().send(message)
//              .then((response) => {
//                // Response is a message ID string.
//                console.log('Successfully sent message:', response);
//              })
//              .catch((error) => {
//                console.log('Error sending message:', error);
//              });
    }
    
}


// When User has ID {
// if askedPermission && didAllowNotifications && Userdefaults token != User token {
// Update token
// Update subscriptions
//
//

// if all are off and one is toggled {
// ask for permission
// turn all on if ok
//}

//if askedPermission && didAllowNotifications == false {
//    turn all off
//}


// Channel token = token
// channel didAllowNotifications

//if each is off turn off corrisponding button

// toggle field with button

// Check publisher notfications from listenr

// channel didAllowTaggingNotifications
// channel didAllowCommentNotifications
// channel didAllowTaggingNotifications
// channel didAllowCommentNotifications
// channel didAllowMarketingNotifications// channel didAllowEpisodeLikeNotifications
// channel didAllowEpisodeCommentNotifications
// channel didAllowNewSubscriptionNotifications








