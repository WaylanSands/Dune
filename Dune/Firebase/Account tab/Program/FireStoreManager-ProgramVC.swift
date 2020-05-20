//
//  FireStoreManager-ProgramVC.swift
//  Dune
//
//  Created by Waylan Sands on 6/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import Firebase


extension FireStoreManager {
    
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
    
    static func createAdditionalProgramWith(programName: String, summary: String, tags: [String], image: UIImage, completion: @escaping () ->()) {
        
        let programID = NSUUID().uuidString
        CurrentProgram.hasMultiplePrograms = true
        User.subscriptionIDs?.append(programID)
        
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            let newProgramRef = db.collection("programs").document(programID)
            
            
            programRef.updateData([
                "hasMultiplePrograms" : true,
                "programIDs" :  FieldValue.arrayUnion([programID])
            ]) { (error) in
                if let error = error {
                    print("Error adding new program to current: \(error.localizedDescription)")
                } else {
                    print("Successfully added new program")
                }
            }
            
            newProgramRef.setData([
                "ID" : programID,
                "name" : programName,
                "ownerID" : User.ID!,
                "summary": summary,
                "tags": tags,
                "username" : User.username!,
                "isPrimaryProgram" : false,
                "episodeIDs" : [],
                "subscriberCount" : 0,
                "hasIntro" : false,
                "subscriberIDs": [],
                "primaryCategory" : CurrentProgram.primaryCategory!
            ]) { error in
                if error != nil {
                    print("Error creating secondary program \(error!)")
                } else {
                    
                    newProgramRef.getDocument { snapshot, error in
                        if error != nil {
                            print("Error adding sub program to array \(error!)")
                        } else {
                            guard let data = snapshot?.data() else { return }
                            
                            if CurrentProgram.subPrograms == nil {
                                CurrentProgram.subPrograms = [Program]()
                                CurrentProgram.programIDs = [String]()
                            }
                            
                            CurrentProgram.subPrograms?.append(Program(data: data))
                            CurrentProgram.programIDs?.append(programID)
                            CurrentProgram.subPrograms?.last?.image = image
                            completion()
                        }
                    }
                    FireStorageManager.storeSubProgram(image: image, to: programID)
                }
            }
            userRef.updateData(["subscriptionIDs" : FieldValue.arrayUnion([programID])])
        }
    }
    
    // Fetch first batch of program's episodes ordered by date
    static func fetchEpisodesIDsWith(with programIDs: [String], completion: @escaping ([String]) -> ()) {
        print("Fetching episodes")
        var counter = 0
        var programSnapshots = [DocumentSnapshot]()
        
        for eachID in programIDs {
            
            counter += 1
            
            let programRef = db.collection("programs").document(eachID)
            
            programRef.getDocument { snapshot, error in
                
                if error != nil {
                    print("Error fetching batch of program's episodes: \(error!)")
                } else {
                    programSnapshots.append(snapshot!)
                    
                    if programSnapshots.count == programIDs.count {
                        
                        var episodeIDsGrouped = [[String: Any]]()
                        
                        for eachDoc in programSnapshots {
                            let episodeIDs = eachDoc.get("episodeIDs") as! [[String : Any]]
                            episodeIDsGrouped += episodeIDs
                        }
                                                                        
                        let sortedDictArray = episodeIDsGrouped.sorted { (docA, docB) -> Bool in
                            let docAValue = docA["timeStamp"] as! Timestamp
                            let docBValue = docB["timeStamp"] as! Timestamp
                            
                            let docADate = docAValue.dateValue()
                            let docBDate = docBValue.dateValue()
                            
                            return docADate < docBDate
                        }
                        
                        var sortedArray = [String]()
                        
                        for each in sortedDictArray {
                            let ID = each["ID"] as! String
                            sortedArray.append(ID)
                        }
                        completion(sortedArray)
                    }
    
                    
                }
            }
        }
    }
    
    // Fetch 'another' batch of program's episodes, ordered by date, starting from the last snapshot
    static func fetchProgramsEpisodesFrom(with programID: String, lastSnapshot: DocumentSnapshot, limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        
        let episodesRef = db.collection("episodes").whereField("programID", isEqualTo: programID).start(afterDocument: lastSnapshot).limit(to: limit)
        
        episodesRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of trending episodes: \(error!)")
            } else if snapshot?.count == 0 {
                print("There are no episodes left to fetch")
                guard let data = snapshot?.documents else { return }
                completion(data)
            } else {
                guard let data = snapshot?.documents else { return }
                
                let sortedByDate = data.sorted { (docA, docB) -> Bool in
                    let docADate = docA.get("postedAt") as! Timestamp
                    let docBDate = docB.get("postedAt") as! Timestamp
                    
                    let dateA = docADate.dateValue()
                    let dateB = docBDate.dateValue()
                    
                    return dateA > dateB
                }
                
                completion(sortedByDate)
            }
        }
    }
    
    // Fetch all of user's subscriptions
    static func fetchUsersSubscriptions(completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
        var counter = 0
        var ownIDs = [String]()
        let subscriptions = User.subscriptionIDs!
        let subCount = subscriptions.count
        var querySnapshot = [QueryDocumentSnapshot]()
        
        if User.isPublisher! {
            if CurrentProgram.hasMultiplePrograms! {
                ownIDs += CurrentProgram.programIDs!
                ownIDs.append(CurrentProgram.ID!)
            } else {
                ownIDs.append(CurrentProgram.ID!)
            }
        }
        print("Own IDs \(ownIDs)")
        for eachSub in subscriptions {
            counter += 1
            if !ownIDs.contains(eachSub) {
                let programRef = db.collection("programs").whereField("ID", isEqualTo: eachSub)
                
                programRef.getDocuments { (snapshot, error) in
                    
                    if error != nil {
                        print("Error fetching batch of program's episodes: \(error!)")
                    } else {
                        guard let documents = snapshot?.documents else { return }
                        for each in documents {
                            querySnapshot.append(each)
                        }
                        
                        if subCount == counter {
                            completion(querySnapshot)
                        }
                    }
                }
            }
        }
    }
    
}
