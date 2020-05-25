//
//  FireStoreManager+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 1/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

import Foundation
import Firebase



extension FireStoreManager {
    
    // Fetch first batch of programs
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
    
    static func updatePublishedEpisodeWith(episodeID: String, caption: String, tags: [String]?, completion: @escaping (Bool) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var episodeTags = [String]()
            
            if tags != nil {
                episodeTags = tags!
            }
            
            let episodeRef = db.collection("episodes").document(episodeID)
            
            episodeRef.updateData([
                "caption" : caption,
                "tags" : episodeTags
            ]) { error in
                if error != nil {
                    print("Error updating published episode")
                    completion(false)
                } else {
                    print("Episode has been updated")
                    completion(true)
                }
            }
        }
    }
    
    // Add a subscriber to a program
    static func updateProgramWithSubscription(programID: String) {
        
        let programRef = db.collection("programs").document(programID)
        
        let sub: Double = 1
        
        programRef.updateData([
            "subscriberIDs" : FieldValue.arrayUnion([User.ID!]),
            "subscriberCount" : FieldValue.increment(sub)
        ]) { error in
            if error != nil {
                print("Error updating program with subscription")
            } else {
                print("Success updating program with subscription")
            }
        }
    }
    
    // Remove a subscriber from a program
    static func updateProgramWithUnSubscribe(programID: String) {
        
        let programRef = db.collection("programs").document(programID)
        
        let sub: Double = -1
        
        programRef.updateData([
            "subscriberIDs" : FieldValue.arrayRemove([User.ID!]),
            "subscriberCount" : FieldValue.increment(sub)
        ]) { error in
            if error != nil {
                print("Error updating program with unsubscribe")
            } else {
                print("Success updating program with Unsubscribe")
            }
        }
    }
    
     // Subscribe to a program
    static func subscribeUserToProgramWith(programID: String) {
        
        let userRef = db.collection("users").document(User.ID!)
                
        userRef.updateData([
            "subscriptionIDs" : FieldValue.arrayUnion([programID]),
        ]) { error in
            if error != nil {
                print("Error subscribing user to program")
            } else {
                print("Success subscribing user to program")
            }
        }
    }
    
     // Unsubscribe from a program
    static func unsubscribeFromProgramWith(programID: String) {
        
        let userRef = db.collection("users").document(User.ID!)
                
        userRef.updateData([
            "subscriptionIDs" : FieldValue.arrayRemove([programID])
        ]) { error in
            if error != nil {
                print("Error removing subscription from user")
            } else {
                print("Success removing subscription from user")
            }
        }
    }
    
    // Fetch first batch of programs within category
    static func fetchProgramsWithinCategory(limit: Int, category: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
                            .whereField("primaryCategory", isEqualTo: category)
                            .order(by: "subscriberCount")
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
    
    static func fetchMoreProgramsWithinCategoryFrom(lastSnapshot: DocumentSnapshot, limit: Int, category: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
                            .whereField("primaryCategory", isEqualTo: category)
                            .order(by: "subscriberCount")
                            .start(afterDocument: lastSnapshot)
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
    
    static func searchForProgramStartingWith(string: String, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let programsRef = db.collection("programs")
        
        programsRef.whereField("name", isGreaterThan: string).limit(to: 5).getDocuments { (snapshot, error) in
            
            if error != nil {
               print("there was an error")
            } else {
                guard let shots = snapshot?.documents else { return }
                completion(shots)
                
//                for each in shots! {
//                    let data = each.data()
//                    let name = data["name"]
//                    print("The name is \(name!)")
//                }
            }
        }
    }
    
}
