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
}
