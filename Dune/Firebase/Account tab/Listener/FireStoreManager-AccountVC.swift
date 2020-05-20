//
//  FireStoreManager-AccountVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation


import Firebase

extension FireStoreManager {
        
    // Fetched Liked Episodes
    static func fetchLikedEpisodes(UserID: String, completion: @escaping ([Episode]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var episodeCount = 0
            var likedEpisodes = [Episode]()
            let episodeRef = db.collection("users").document(UserID)
            
            episodeRef.getDocument { (snapshot, error) in
                
                if error != nil {
                    print("Error fetching user's document for liked episodes \(error!)")
                } else {
                    guard let data = snapshot!.data() else { return }
                    let episodeIDs = data["likedEpisodeIDs"] as! [String]
                    
                    for eachID in episodeIDs {
                        episodeCount += 1
                        let episodeRef = db.collection("episodes").document(eachID)
                         
                        episodeRef.getDocument { (snapshot, error) in
                            
                            if error != nil {
                                print("Error fetching user's document for liked episodes \(error!)")
                            } else {
                                guard let data = snapshot!.data() else { return }
                                let episode = Episode(data: data)
                                likedEpisodes.append(episode)
                                
                                if episodeCount == episodeIDs.count {
                                    completion(likedEpisodes)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Fetch all of user's subscriptions
    static func fetchListenersSubscriptions(completion: @escaping ([Program]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            var programCount = 0
            var subscriptions = [Program]()
            
            for eachID in User.subscriptionIDs! {
                programCount += 1
                
                let programRef = db.collection("programs").document(eachID)
                
                programRef.getDocument { (snapshot, error) in
                    
                    if error != nil {
                        print("Error fetching user's subscriptions: \(error!)")
                    } else {
                        guard let data = snapshot?.data() else { return }
                        let program = Program(data: data)
                        subscriptions.append(program)
                        
                        if programCount == User.subscriptionIDs!.count {
                            completion(subscriptions)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
}
