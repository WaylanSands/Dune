//
//  FireStoreManager+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 1/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

import Foundation
import FirebaseMessaging
import FirebaseFirestore

extension FireStoreManager {
    
    static func fetchProgramsOrderedBySubscriptions(limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs").order(by: "subscriberCount", descending: true).limit(to: limit)
        programsRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of programs: \(error!)")
            } else if snapshot?.count == 0 {
                 print("There are no programs to fetch")
            } else {
                guard let data = snapshot?.documents else { return }
                completion(data)
            }
        }
    }
    
    static func fetchProgramsOrderedBySubscriptionsFrom(lastSnapshot: DocumentSnapshot, limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs").order(by: "subscriberCount", descending: true).start(afterDocument: lastSnapshot).limit(to: limit)
        
        programsRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of programs: \(error!)")
            } else if snapshot?.count == 0 {
                 print("There are no programs left to fetch")
                 guard let data = snapshot?.documents else { return }
                 completion(data)
            } else {
                guard let data = snapshot?.documents else { return }
                completion(data)
            }
        }
    }
    
    static func fetchSubProgramsWithIDs(programIDs: [String], for program: Program?, completion: @escaping () ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var programCount = 0
            let programsRef = db.collection("programs").whereField("ID", in: programIDs)
            
            programsRef.getDocuments { snapshot, error in
                
                if error != nil {
                    print("Error fetching batch of programs: \(error!)")
                } else if snapshot?.count == 0 {
                    print("There are no programs to fetch")
                } else {
                    guard let data = snapshot?.documents else { return }
                    
                    if program == nil {
                        CurrentProgram.subPrograms = [Program]()
                    } else {
                        program?.subPrograms = [Program]()
                    }
                    
                    for each in data {
                        programCount += 1
                        let programData = each.data()
                        let loadedProgram = Program(data: programData)
                        
                        if program == nil {
                            CurrentProgram.subPrograms!.append(loadedProgram)
                        } else {
                            program!.subPrograms!.append(loadedProgram)
                        }
                        
                        if programCount == snapshot?.count {
                            completion()
                        }
                    }
                }
            }
        }
    }

    static func updatePublishedEpisodeWith(richLink: String?, episodeID: String, caption: String, tags: [String]?, completion: @escaping (Bool) ->()) {

        DispatchQueue.global(qos: .userInitiated).async {
            
            var episodeTags = [String]()
            
            if tags != nil {
                episodeTags = tags!
            }
            
            let episodeRef = db.collection("episodes").document(episodeID)
            let trendingRef = db.collection("lastSevenDays").document(episodeID)
            
            trendingRef.updateData([
                "caption" : caption,
                "tags" : episodeTags,
                "richLink" : richLink ?? FieldValue.delete()
            ])
            
            episodeRef.updateData([
                "caption" : caption,
                "tags" : episodeTags,
                "richLink" : richLink ?? FieldValue.delete()
            ]) { error in
                if error != nil {
                    print("Error updating published episode")
                    completion(false)
                } else {
                    print("Episode has been updated")
                    let usernames = checkIfUserWasTagged(caption: caption)
                    if !usernames.isEmpty {
                        FireBaseComments.addMentionToProgramWith(usernames: usernames, caption: caption, contentID: episodeID, primaryEpisodeID: nil, mentionType: .episodeTag)
                    }
                    completion(true)
                }
            }
        }
    }
    
    static func updatePublishedEpisodeWithLinkFor(episodeID: String, caption: String, tags: [String]?, richLink: String, linkImageID: String, linkIsSmall: Bool, linkImage: UIImage, linkHeadline: String, canonicalUrl: String, completion: @escaping (Bool) ->()) {

        DispatchQueue.global(qos: .userInitiated).async {
            
            var episodeTags = [String]()
            
            if tags != nil {
                episodeTags = tags!
            }
            
            let episodeRef = db.collection("episodes").document(episodeID)
            let trendingRef = db.collection("lastSevenDays").document(episodeID)
            
            trendingRef.updateData([
                "caption" : caption,
                "tags" : episodeTags,
                "richLink" : richLink,
                "linkIsSmall" :  linkIsSmall,
                "linkHeadline" : linkHeadline,
                "canonicalUrl" : canonicalUrl,
                "linkImageID" : linkImageID,
            ])
            
            episodeRef.updateData([
                "caption" : caption,
                "tags" : episodeTags,
                "richLink" : richLink,
                "linkIsSmall" :  linkIsSmall,
                "linkHeadline" : linkHeadline,
                "canonicalUrl" : canonicalUrl,
                "linkImageID" : linkImageID,
            ]) { error in
                if error != nil {
                    print("Error updating published episode")
                    completion(false)
                } else {
                    print("Episode has been updated")
                    let usernames = checkIfUserWasTagged(caption: caption)
                    if !usernames.isEmpty {
                        FireBaseComments.addMentionToProgramWith(usernames: usernames, caption: caption, contentID: episodeID, primaryEpisodeID: nil, mentionType: .episodeTag)
                    }
                    storeRichLink(image: linkImage, imageID: linkImageID) {
                        completion(true)
                    }
                }
            }
        }
    }
    
    static func addSubscriptionToProgramWith(programID: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("programs").document(programID)
            
            userRef.updateData([
                "subscriberIDs" : FieldValue.arrayUnion([CurrentProgram.ID!]),
                "subscriberCount" : FieldValue.increment(Double(1)),
            ]) { error in
                if error != nil {
                    print("Error subscribing user to program")
                    completion(false)
                } else {
                    print("Success adding user as subscriber")
                    completion(true)
                }
            }
        }
    }
    
    static func subscribeToProgramWith(programID: String) {
        if FirebaseNotifications.askedPermission {
            print("WAS ASKED")
            FirebaseNotifications.subscribeToChannelsNotifications(channelID: programID, register: true)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.registerForPushNotifications()
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("programs").document(CurrentProgram.ID!)
            
            userRef.updateData([
                "subscriptionIDs" : FieldValue.arrayUnion([programID]),
            ]) { error in
                if error != nil {
                    print("Error subscribing user to channel")
                } else {
                    print("Success subscribing user to channel")
                }
            }
        }
    }
    
    static func registerForPushNotifications() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.promptForPushNotifications { granted in
            if granted {
                FirebaseNotifications.allowAllNotifications()
                FirebaseNotifications.subscribeToAllChannels()
            }
        }
    }
    
    // MARK: - Register New Episode Notifications

    
    static func addSubscriptionToProgramWith(programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "subscriberIDs" : FieldValue.arrayUnion([CurrentProgram.ID!]),
                "subscriberCount" : FieldValue.increment(Double(1)),
            ]) { error in
                if error != nil {
                    print("Error adding subscriber to channel")
                } else {
                    print("Success adding subscriber to channel")
                }
            }
        }
    }

    
    static func unsubscribeFromProgramWith(programID: String) {
        FirebaseNotifications.subscribeToChannelsNotifications(channelID: programID, register: false)

        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "subscriptionIDs" : FieldValue.arrayRemove([programID])
            ]) { error in
                if error != nil {
                    print("Error removing subscription from user")
                } else {
                    print("Success removing subscription from user")
                }
            }
        }
    }
    
    static func removeSubscriptionFromProgramWith(programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "subscriberIDs" : FieldValue.arrayRemove([CurrentProgram.ID!]),
                "subscriberCount" : FieldValue.increment(Double(-1)),
            ]) { error in
                if error != nil {
                    print("Error removing subscriber from Channel")
                } else {
                    print("Success removing subscriber from Channel")
                }
            }
        }
    }
    
    static func usedCategories(completion: @escaping ([String]) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            var snapshots = [(String, Int)]()
            var counter = 0
            for each in Category.allCases {
                let programRef = db.collection("programs").whereField("primaryCategory", isEqualTo: each.rawValue)
                programRef.getDocuments { (snapshot, error) in
                    counter += 1
                    if error != nil {
                        print("Error searching for program with category")
                    } else {
                        if snapshot!.documents.count > 0 {
                            snapshots.append((each.rawValue, snapshot!.count))
                        }
                    }
                    if counter == Category.allCases.count {
                        let sortedSnaps = snapshots.sorted(by: { $0.1 > $1.1 })
                        let categories = sortedSnaps.map({ $0.0 })
                        completion(categories)
                    }
                }
            }
        }
    }
    
    static func fetchProgramsWithinCategory(limit: Int, category: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
                            .whereField("primaryCategory", isEqualTo: category)
                            .order(by: "subscriberCount", descending: true)
                            .limit(to: limit)
        
        programsRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of programs: \(error!)")
            } else if snapshot?.count == 0 {
                 print("There are no programs to fetch")
            } else {
                guard let data = snapshot?.documents else { return }
                completion(data)
            }
        }
    }
    
    static func change(ID: String) {
        DispatchQueue.global(qos: .background).async {
            let programsRef = db.collection("programs").document(ID)
            programsRef.updateData([
                "isGlobal": FieldValue.delete(),
                "locationType": "Global",
            ])
        }
    }
    
    
    static func fetchMoreProgramsWithinCategoryFrom(lastSnapshot: DocumentSnapshot, limit: Int, category: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
                            .whereField("primaryCategory", isEqualTo: category)
                            .order(by: "subscriberCount", descending: true)
                            .start(afterDocument: lastSnapshot)
                            .limit(to: limit)
        
        programsRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of programs: \(error!)")
            } else if snapshot?.count == 0 {
                 print("There are no programs to fetch")
                 completion([])
            } else {
                guard let data = snapshot?.documents else { return }
                completion(data)
            }
        }
    }
    
    static func searchForProgramStartingWith(string: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
        
        programsRef.whereField("name", isGreaterThan: string).limit(to: 5).getDocuments { (snapshot, error) in
            
            if error != nil {
               print("there was an error")
            } else {
                guard let shots = snapshot?.documents else { return }
                completion(shots)
            }
        }
    }
    
}
