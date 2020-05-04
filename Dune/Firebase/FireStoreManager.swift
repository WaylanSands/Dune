//
//  FireStoreManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import Firebase

struct FireStoreManager {
    
    static let db = Firestore.firestore()
    
    
    static func addImagePathToProgram() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "imagePath" : CurrentProgram.imagePath!,
                "imageID" : CurrentProgram.imageID!
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the imagePath to program: \(error.localizedDescription)")
                } else {
                    print("Successfully added imagePath to program")
                }
            }
        }
    }
    
    static func addImagePathToUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "imagePath" : User.imagePath!,
                "imageID" : User.imageID!
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the imagePath to User: \(error.localizedDescription)")
                } else {
                    print("Successfully added imagePath to user")
                    UserDefaults.standard.set(true, forKey: "hasCustomImage")
                }
            }
        }
    }
    
    static func updatePrimaryProgramName() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            userRef.updateData([
                "displayName" : CurrentProgram.name!
            ]) { (error) in
                if let error = error {
                    print("Error updating user's displayName: \(error.localizedDescription)")
                } else {
                    print("Successfully updated Display name for user")
                }
            }
            
            programRef.updateData([
                "name" :  CurrentProgram.name!
            ]) { (error) in
                if let error = error {
                    print("Error updating program's name: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's name")
                }
            }
        }
    }
    
    static func updateSecondaryProgramName() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "name" :  CurrentProgram.name!
            ]) { (error) in
                if let error = error {
                    print("Error updating program's name: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's name")
                }
            }
        }
    }
    
    static func updateUserDisplayName() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "displayName" : User.displayName!
            ]) { (error) in
                if let error = error {
                    print("Error updating user's displayName: \(error.localizedDescription)")
                } else {
                    print("Successfully updated Display name for user")
                }
            }
        }
    }
    
    static func updateUsername() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "username" : User.username!
            ]) { (error) in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                } else {
                    print("Successfully updated username")
                }
            }
        }
    }
    
    static func updateUserBirthDate() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "birthDate" : User.birthDate!
            ]) { (error) in
                if let error = error {
                    print("Error updating user's displayName: \(error.localizedDescription)")
                } else {
                    print("Successfully updated Display name for user")
                }
            }
        }
    }
    
    static func updatePrimaryCategory() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "primaryCategory" : CurrentProgram.primaryCategory!
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's primaryCategory: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's primaryCategory")
                }
            }
        }
    }
    
    
    static func updateProgramDetails() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "summary" :  CurrentProgram.summary!,
                "tags" :     CurrentProgram.tags!
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's details: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's details")
                }
            }
        }
    }
    
    static func updateUserEmail() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "email" :  User.email!,
            ]) { (error) in
                if let error = error {
                    print("Error updating user's email: \(error.localizedDescription)")
                } else {
                    print("Successfully updated user's email")
                }
            }
        }
    }
    
    static func checkIfUsernameExists(name: String, completion: @escaping (Bool)->()) {
        
        FirebaseStatus.isChecking = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let usersRef =  db.collection("users")
            
            usersRef.whereField("username", isEqualTo: name).getDocuments { (snapshot, err) in
                
                FirebaseStatus.isChecking = false
                
                if let err = err {
                    print("Error getting document: \(err)")
                }
                
                if snapshot!.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func getProgramData(completion: @escaping (Bool) -> ()) {
        print("Fetching program details")
        
        guard let programID = User.programID else { return }
        
        let programRef = db.collection("programs").document(programID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            programRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting the program document")
                    completion(false)
                } else {
                    guard let data = snapshot?.data() else { return }
                    CurrentProgram.modelProgram(data: data)
                    print("Program has been modelled")
                    completion(true)
                }
            }
        }
    }
    
    static func getEpisodesFromPrograms(completion: @escaping ([String]?) -> ()) {
        print("Fetching episode ID's from user following \(User.subscriptionIDs!.count) programs")
        var episodeIDs: [String] = []
        
        guard let subIDs = User.subscriptionIDs else { return }
        var counter = 0
        for eachID in subIDs {
            
            let collectionRef = db.collection("programs").document(eachID)
            
            collectionRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting episodes")
                } else {
                    guard let data = snapshot?.data() else { return }
                    
                    if let epIDs = data["episodeIDs"] {
                        
                        for eachID in (epIDs as! [String]) {
                            episodeIDs.append(eachID)
                        }
                        counter += 1
                        
                        if counter == subIDs.count {
                           
                            if episodeIDs.count == 0 {
                                completion(nil)
                            }
                            getEpisodesInOrder(episodeIDs: episodeIDs, completion: { IDs in
                                completion(IDs)
                            })
                        }
                    } else {
                        completion(nil)
                    }
                }
            }
        }
    }
    
    static func getEpisodesInOrder(episodeIDs: [String], completion: @escaping ([String]) -> ()) {
       
        var sortedEpisodesTuples: [(key: String, value: Date)] = []
        var sortedEpisodeArray: [String] = []
        let numberOfEpisodes = episodeIDs.count
        var episodes: [String: Date] = [:]
        var counter = 0
        
        print("\(episodeIDs.count) episodes in total")
        for eachEp in episodeIDs {
            
            let episodeRef = db.collection("episodes").document(eachEp)
            
            episodeRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting episodes")
                } else {
                    guard let data = snapshot?.data() else { return }
                    
                    let ID = data["ID"] as? String
                    let postedDate = data["postedAt"] as! Timestamp
                    let date =  postedDate.dateValue()
                    
                    episodes[ID!] = date
                    counter += 1
                    
                    if counter == numberOfEpisodes {
                        sortedEpisodesTuples = episodes.sorted() { $0.value > $1.value }
                        for (key,_) in sortedEpisodesTuples {
                            sortedEpisodeArray.append(key)
                        }
                        completion(sortedEpisodeArray)
                    }
                }
            }
        }
    }
    
    //Draft EPISODEs
    static func getDraftEpisodesInOrder(completion: @escaping ([String]?) -> ()) {
        
        let draftIDs = User.draftEpisodeIDs!
        var sortedDraftTuples: [(key: String, value: Date)] = []
        var sortedDraftsArray: [String] = []
        let numberOfDrafts = draftIDs.count
        var drafts: [String: Date] = [:]
        var counter = 0
        
        print("Total number of draft Eps: \(draftIDs.count)")
        for eachDraft in draftIDs {
            
            let episodeRef = db.collection("draftEpisodes").document(eachDraft)
            
            episodeRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting episodes")
                     completion(nil)
                } else {
                    guard let data = snapshot?.data() else { return }
                        let ID = data["ID"] as? String
                        let uploadDate = data["addedAt"] as! Timestamp
                        let date =  uploadDate.dateValue()
                    
                        drafts[ID!] = date
                        counter += 1
                    
                    if counter == numberOfDrafts {
                        sortedDraftTuples = drafts.sorted() { $0.value > $1.value }
                        
                        for (key,_) in sortedDraftTuples {
                            sortedDraftsArray.append(key)
                        }
                        completion(sortedDraftsArray)
                    }
                }
            }
        }
    }
    
    static func getEpisodeDataWith(ID: String, completion: @escaping ([String:Any]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let epRef = db.collection("episodes").document(ID)
            
            epRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting the episode")
                } else {
                    guard let data = snapshot?.data() else { return }
                    completion(data)
                }
            }
        }
    }
    
    static func getDraftEpisodeDataWith(ID: String, completion: @escaping ([String:Any]) -> ()) {
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let epRef = db.collection("draftEpisodes").document(ID)
            
            epRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting the draft episode")
                } else {
                    guard let data = snapshot?.data() else { return }
                    completion(data)
                }
            }
        }
    }
    
    static func publishEpisode(caption: String, tags: [String], audioID: String, audioURL: URL, duration: String, completion: @escaping (Bool) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("episodes").document()
            let ID = episodeRef.documentID
            
            episodeRef.setData([
                "ID": ID,
                "postedAt" : FieldValue.serverTimestamp(),
                "duration" : duration,
                "imageID" : CurrentProgram.imageID!,
                "imagePath" : CurrentProgram.imagePath!,
                "programName" : CurrentProgram.name!,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "programID" : CurrentProgram.ID!,
                "ownerID" : User.ID!,
                "audioPath" : audioURL.absoluteString,
                "audioID" : audioID,
                "likeCount" : 0,
                "commentCount" : 0,
                "shareCount" : 0,
                "listenCount" : 0,
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the publishing the episode: \(error.localizedDescription)")
                } else {
                    print("Successfully published episode")

                    let programRef = db.collection("programs").document(CurrentProgram.ID!)
                    
                    programRef.updateData([
                        "episodeIDs" : FieldValue.arrayUnion([ID])
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added episodeID to program")
                            completion(true)
                        }
                    }
                    removeDraftIDFromUser(episodeID: ID)
                }
            }
        }
    }
    
    static func saveDraftEpisode(fileName: String, wasTrimmed: Bool, startTime: Double, endTime: Double, caption: String, tags: [String], audioURL: URL, duration: String, completion: @escaping (Bool)->()) {

        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("draftEpisodes").document()
            let ID = episodeRef.documentID
            
         episodeRef.setData([
                "ID": ID,
                "addedAt" : FieldValue.serverTimestamp(),
                "fileName" : fileName,
                "wasTrimmed" : wasTrimmed,
                "startTime" : startTime,
                "endTime" : endTime,
                "duration" : duration,
                "programName" : CurrentProgram.name!,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "programID" : CurrentProgram.ID!,
                "ownerID" : User.ID!,
                "audioURL" : audioURL.absoluteString
            ])
          { (error) in
                if let error = error {
                    print("There has been an error adding the draft to Firebase: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("Successfully added draft episode to firebase")
                    completion(true)
                    
                    if User.draftEpisodeIDs == nil {
                        User.draftEpisodeIDs = []
                        User.draftEpisodeIDs?.append(ID)
                    } else {
                        User.draftEpisodeIDs?.append(ID)
                    }
                    addDraftIDToUser(episodeID: ID)
                }
            }
        }
    }
    
    static func addIDToProgram(episodeID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "episodeIDs" : FieldValue.arrayUnion([episodeID])
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                } else {
                    print("Successfully added episodeID to program")
                }
            }
        }
    }
    
    static func addDraftIDToUser(episodeID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "draftEpisodeIDs" : FieldValue.arrayUnion([episodeID])
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the draftEpisodeID to user: \(error.localizedDescription)")
                } else {
                    print("Successfully added draftEpisodeID to user")
                }
            }
        }
    }
    
    static func removeDraftIDFromUser(episodeID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("Error getting users data")
                } else {
                    if let data = snapshot?.data() {
                        
                        let draftIDs = data["draftEpisodeIDs"] as? [String]
                        
                        if draftIDs != nil {
                            if draftIDs!.contains(episodeID) {
                                 removeDraftID(episodeID: episodeID, userRef: userRef)
                            } else {
                                print("Was not a draft episode")
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func removeEpisodeIDFromProgram(episodeID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "episodeIDs" : FieldValue.arrayRemove([episodeID])
            ])
        }
    }
    
    
    
    static func removeDraftID(episodeID: String, userRef: DocumentReference) {
     
        DispatchQueue.global(qos: .userInitiated).async {
            
            userRef.updateData([
                "draftEpisodeIDs" : FieldValue.arrayRemove([episodeID])
            ]) { (error) in
                if let error = error {
                    print("There has been an error removing the draftEpisodeID from user: \(error.localizedDescription)")
                } else {
                    print("Successfully removed draftEpisodeID from user")
                }
            }
        }
    }
    
    static func deleteDraftDocument(ID: String) {
     
        DispatchQueue.global(qos: .userInitiated).async {
            
            db.collection("draftEpisodes").document(ID).delete() { err in
                if let err = err {
                    print("Error deleting document: \(err)")
                } else {
                    print("Document successfully deleted!")
                }
            }
        }
    }
    
    static func deleteEpisodeDocument(ID: String) {
     
        DispatchQueue.global(qos: .userInitiated).async {
            
            db.collection("episodes").document(ID).delete() { err in
                if let err = err {
                    print("Error deleting episode document: \(err)")
                } else {
                    print("Episode document successfully deleted!")
                }
            }
        }
    }
    
    static func getUserData(completion: @escaping () -> ()) {

        guard let uid = Auth.auth().currentUser?.uid else { return }

        let userRef = db.collection("users").document(uid)

        DispatchQueue.global(qos: .userInitiated).async {
            
            userRef.getDocument { (snapshot, error) in
               
                if error != nil {
                    print("There was an error getting users document: \(error!)")
                } else {

                    guard let data = snapshot?.data() else { return }
                    User.modelUser(data: data)
                    
                    let isPublisher = data["isPublisher"] as! Bool
                    
                    if isPublisher {
                        FireStoreManager.getProgramData { success in
                            if success {
                                completion()
                            } else {
                                print("Error getting program data")
                            }
                        }
                    } else {
                         completion()
                    }
                }
            }
        }
    }
    
    static func updateEpisodeLikeCountWith(episodeID: String, by increment: counterIncrement ) {
       
        var like: Double
        
        switch increment {
        case .increase:
            like = 1
        case .decrease:
            like = -1
        }
        
        let episodeRef = db.collection("episodes").document(episodeID)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            episodeRef.updateData([
                "likeCount" : FieldValue.increment(like)
            ]) { error in
                
                if error != nil {
                    print("There was an error updating the like count on the episode")
                } else {
                    
                    if increment == .increase {
                        updateUserWithLiked(episodeID: episodeID)
                    } else {
                        updateUserWithUnLiked(episodeID: episodeID)
                    }
                }
            }
        }
    }
    
    static func updateUserWithLiked(episodeID: String) {
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "likedEpisodes" : FieldValue.arrayUnion([episodeID])
        ])
        User.likedEpisodes?.append(episodeID)
    }
    
    
    static func updateUserWithUnLiked(episodeID: String) {
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "likedEpisodes" : FieldValue.arrayRemove([episodeID])
        ])
        if let index = User.likedEpisodes?.firstIndex(of: episodeID) {
            User.likedEpisodes?.remove(at: index)
        }
    }
    
    static func updateListenCountFor(episode ID: String) {
       
        let listen: Double = 1
        
        let episodeRef = db.collection("episodes").document(ID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            episodeRef.updateData([
                "listenCount" : FieldValue.increment(listen)
            ])
        }
    }
    
    static func updateSubscriptionForProgram(withID: String) {
        
        let programRef = db.collection("programs").document(withID)
        
        let singleValue: Double = 1
        
        programRef.updateData([
            "subscribers" : FieldValue.arrayUnion([User.ID!]),
            "subscriberCount" : FieldValue.increment(singleValue)
        ]) { error in
            
            if error != nil {
                print("Error updating program with subscriber: \(error!)")
            } else {
                updateUserWithSubscriptionFor(program: withID)
            }
        }
    }
    
    static func updateUserWithSubscriptionFor(program ID: String) {
        
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData(["subscriptions" : FieldValue.arrayUnion([ID])]) { error in
            if error != nil {
                print("Error adding programID to user's subscription array \(error!)")
            }
        }
        
        
    }
    
    
}

