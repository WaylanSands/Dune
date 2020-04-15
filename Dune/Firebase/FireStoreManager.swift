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
            
            let programRef = db.collection("programs").document(Program.ID!)
            
            programRef.updateData([
                "imagePath" : Program.imagePath!,
                "storedImageID" : Program.storedImageID!
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the imagePath to program: \(error.localizedDescription)")
                } else {
                    print("Successfully added imagePath to program")
                    addImagePathToUser()
                }
            }
        }
    }
    
    static func addImagePathToUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "imagePath" : User.imagePath!,
                "storedImageID" : User.storedImageID!
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
            let programRef = db.collection("programs").document(Program.ID!)
            
            userRef.updateData([
                "displayName" : Program.name!
            ]) { (error) in
                if let error = error {
                    print("Error updating user's displayName: \(error.localizedDescription)")
                } else {
                    print("Successfully updated Display name for user")
                }
            }
            
            programRef.updateData([
                "name" :  Program.name!
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
            
            let programRef = db.collection("programs").document(Program.ID!)
            
            programRef.updateData([
                "name" :  Program.name!
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
            
            let programRef = db.collection("programs").document(Program.ID!)
            
            programRef.updateData([
                "primaryCategory" : Program.primaryCategory!
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
            
            let programRef = db.collection("programs").document(Program.ID!)
            
            programRef.updateData([
                "summary" :  Program.summary!,
                "tags" :     Program.tags!
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
    
    static func getEpisodesFromPrograms(completion: @escaping ([String]) -> ()) {
        
        var episodeIDs: [String] = []
        
        guard let subIDs = User.subscriptionIDs else { return }
        
        for eachID in subIDs {
            
            let collectionRef = db.collection("programs").document(eachID)
            
            collectionRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting episodes")
                } else {
                    guard let data = snapshot?.data() else { return }
                    guard let epIDs = data["episodeIDs"] else { return }
                    
                    for eachID in (epIDs as! [String]) {
                        episodeIDs.append(eachID)
                    }
                    
                    if episodeIDs.count == subIDs.count {
                        print("Finished with \(episodeIDs)")
                        getEpisodesInOrder(episodeIDs: episodeIDs, completion: { IDs in
                            completion(IDs)
                        })
                    }
                }
            }
        }
    }
    
    static func getEpisodesInOrder(episodeIDs: [String], completion: @escaping ([String]) -> ()){
       
        var sortedEpisodesTuples: [(key: String, value: Int)] = []
        var sortedEpisodeArray: [String] = []
        let numberOfEpisodes = episodeIDs.count
        var episodes: [String: Int] = [:]
        var counter = 0
        
        print("Number of eps \(episodeIDs.count)")
        for eachEp in episodeIDs {
            
            let episodeRef = db.collection("episodes").document(eachEp)
            
            episodeRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting episodes")
                } else {
                    guard let data = snapshot?.data() else { return }
                    
                    let ID = data["ID"] as? String
                    let uploadDate = data["postedAt"] as? Int
                    
                    episodes[ID!] = uploadDate
                    print("Episodes \(episodes)")
                    
                    counter += 1
                    
                    if counter == numberOfEpisodes {
                       sortedEpisodesTuples = episodes.sorted() { $0.value < $1.value }
                             
                             for (key,_) in sortedEpisodesTuples {
                                 sortedEpisodeArray.append(key)
                             }
                        completion(sortedEpisodeArray)
                    }
                }
            }
        }
    }
    
    static func getEpisodedataWith(ID: String, completion: @escaping ([String:Any]) -> ()) {
         print("Starting dispatch")
        DispatchQueue.global(qos: .userInitiated).async {
        
        let epRef = db.collection("episodes").document(ID)
        
            epRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting the episode")
                } else {
                    guard let data = snapshot?.data() else { return }
                    print("Returining with ep data")
                    completion(data)
                }
            }
        }
    }
    
    
}
