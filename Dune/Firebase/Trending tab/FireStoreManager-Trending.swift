//
//  FireStoreManager-Trending.swift
//  Dune
//
//  Created by Waylan Sands on 5/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseFirestore

extension FireStoreManager {
    
    static let minuteInterval: TimeInterval = 60.0
    static let hourInterval: TimeInterval = 60.0 * minuteInterval
    static let dayInterval: TimeInterval = 24 * hourInterval
    static let weekInterval: TimeInterval = 7 * dayInterval
    
    // Fetch first batch of trending episodes from last week, ordered by likes
    static func fetchTrendingEpisodesWith(limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let week = Date(timeIntervalSinceNow: weekInterval)
        let oneWeek = Timestamp(date: week)
        
        let episodesRef = db.collection("episodes").whereField("postedAt", isLessThan: oneWeek).limit(to: limit)

        episodesRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of trending episodes: \(error!)")
            } else if snapshot?.count == 0 {
                print("There are no episodes to fetch")
                guard let data = snapshot?.documents else { return }
                completion(data)
            } else {
                guard let data = snapshot?.documents else { return }
                
                let sortedByLikes = data.sorted { (docA, docB) -> Bool in
                    docA.get("likeCount") as! Int > docB.get("likeCount") as! Int
                }
                
                completion(sortedByLikes)
            }
        }
    }
    
    
     // Fetch 'another' batch of trending episodes from last week, ordered by likes, starting from the last snapshot
    static func fetchTrendingEpisodesFrom(lastSnapshot: DocumentSnapshot, limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let week = Date(timeIntervalSinceNow: weekInterval)
        let oneWeek = Timestamp(date: week)
        
                let episodesRef = db.collection("episodes").whereField("postedAt", isLessThan: oneWeek).start(afterDocument: lastSnapshot).limit(to: limit)
                
        episodesRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of trending episodes: \(error!)")
            } else if snapshot?.count == 0 {
                 print("There are no episodes left to fetch")
                 guard let data = snapshot?.documents else { return }
                 completion(data)
            } else {
                guard let data = snapshot?.documents else { return }
                                
                let sortedByLikes = data.sorted { (docA, docB) -> Bool in
                    docA.get("likeCount") as! Int > docB.get("likeCount") as! Int
                }
                
                completion(sortedByLikes)
            }
        }
    }
    
}
