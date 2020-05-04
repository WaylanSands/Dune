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
                print("Success updating program with unsubscribe")
            }
        }
    }
    
     // Subscriber to a program
    static func subscribeUserToProgramWith(programID: String) {
        
        let userRef = db.collection("users").document(User.ID!)
                
        userRef.updateData([
            "subscriptionIDs" : FieldValue.arrayUnion([programID]),
        ]) { error in
            if error != nil {
                print("Error adding subscription to user")
            } else {
                print("Success adding subscription to user")
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
                print("Error adding subscription to user")
            } else {
                print("Success adding subscription to user")
            }
        }
    }
    
    
    
    
}
