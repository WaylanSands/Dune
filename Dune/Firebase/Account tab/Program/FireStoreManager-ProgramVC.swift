//
//  FireStoreManager-ProgramVC.swift
//  Dune
//
//  Created by Waylan Sands on 6/5/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import FirebaseFirestore


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
    
//    if !CurrentProgram.repMethods!.contains(comment.ID) {
//        FireStoreManager.updateProgramRep(programID: comment.programID, repMethod: comment.ID, rep: -4)
//        FireStoreManager.updateProgramMethodsUsed(programID: CurrentProgram.ID!, repMethod: comment.ID)
//        CurrentProgram.repMethods?.append(comment.ID)
//    }
    
    static func updateProgramRep(programID: String, repMethod: String, rep: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRep = Double(rep)
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "rep" : FieldValue.increment(programRep),
                "repMethod" : FieldValue.arrayUnion([repMethod])
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's rep: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's rep")
                }
            }
        }
    }
    
    static func updateProgramMethodsUsed(programID: String, repMethod: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "repMethod" : FieldValue.arrayUnion([repMethod])
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's rep methods: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's rep methods")
                }
            }
        }
    }
    
    static func updateUserToPublisher() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "isPublisher" : true
            ]) { (error) in
                if let error = error {
                    print("Error updating user to publisher: \(error.localizedDescription)")
                } else {
                    print("Successfully updating user to publisher")
                }
            }
        }
    }
    
    static func createAdditionalProgramWith(programName: String, summary: String, tags: [String], image: UIImage, completion: @escaping () ->()) {
        
        let programID = NSUUID().uuidString
        CurrentProgram.subscriptionIDs!.append(programID)
                
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            let newProgramRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "subscriptionIDs" : FieldValue.arrayUnion([programID]),
                "programIDs" :  FieldValue.arrayUnion([programID]),
            ]) { (error) in
                if let error = error {
                    print("Error adding new program to current: \(error.localizedDescription)")
                } else {
                    print("Successfully added new program")
                }
            }
            
            newProgramRef.setData([
                "ID" : programID,
                "rep" : 15,
                "repMethods" : [],
                "hasMentions" : false,
                "CurrentProgram" : false,
                "name" : programName,
                "ownerID" : User.ID!,
                "summary": summary,
                "tags": tags,
                "programIDs" : [],
                "username" : User.username!,
                "isPrimaryProgram" : false,
                "episodeIDs" : [],
                "subscriberCount" : 0,
                "subscriptionIDs" : [programID],
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
                            FireStoreManager.updateProgramRep(programID: programID, repMethod: "creation", rep: 15)
                            CurrentProgram.subPrograms?.append(Program(data: data))
                            CurrentProgram.programIDs?.append(programID)
                            CurrentProgram.subPrograms?.last?.image = image
                            completion()
                        }
                    }
                    FireStorageManager.storeSubProgram(image: image, to: programID)
                }
            }
        }
    }
    
    static func fetchEpisodesItemsWith(with programIDs: [String], completion: @escaping ([EpisodeItem]) -> ()) {
        var programSnapshots = [DocumentSnapshot]()
        var counter = 0
        if programIDs.count == 0 {
            completion([])
        }

        for eachID in programIDs {
            
            counter += 1
            
            let programRef = db.collection("programs").document(eachID)
            
            programRef.getDocument { snapshot, error in
                
                if error != nil {
                    print("Error fetching batch of program's episodes: \(error!)")
                } else {
                    programSnapshots.append(snapshot!)
                    
                    if programSnapshots.count == programIDs.count {
                        
//                        var episodeIDsGrouped = [[String: Any]]()
                        var episodeItems = [EpisodeItem]()
                        
                        for eachDoc in programSnapshots {
                           let episodeIDs = eachDoc.get("episodeIDs") as! [[String : Any]]
                            
                            for each in episodeIDs {
                                let episodeItem = EpisodeItem(data: each)
                                episodeItems.append(episodeItem)
                            }
//                            episodeIDsGrouped += episodeIDs
                        }
                        
//                        let sortedEpisodeItems = episodeItems.sorted()
                        completion(episodeItems.sorted(by: >))
                                                                        
//                        let sortedDictArray = episodeIDsGrouped.sorted { (docA, docB) -> Bool in
//                            let docAValue = docA["timeStamp"] as! Timestamp
//                            let docBValue = docB["timeStamp"] as! Timestamp
//
//                            let docADate = docAValue.dateValue()
//                            let docBDate = docBValue.dateValue()
//
//                            return docADate > docBDate
//                        }
                        
//                        var sortedArray = [String]()
                        
//                        for each in sortedDictArray {
//                            let ID = each["ID"] as! String
//                            sortedArray.append(ID)
//                        }
                                                
//                        for each in sortedEpisodeItems {
//                            sortedArray.append(each.id)
//                        }
//
//
//                        (sortedArray)
                    }
                }
            }
        }
    }
    
    // Fetch 'another' batch of program's episodes, ordered by date, starting from the last snapshot
//    static func fetchProgramsEpisodesFrom(with programID: String, lastSnapshot: DocumentSnapshot, limit: Int, completion: @escaping ([QueryDocumentSnapshot]) -> ()) {
//
//        let episodesRef = db.collection("episodes").whereField("programID", isEqualTo: programID).start(afterDocument: lastSnapshot).limit(to: limit)
//
//        episodesRef.getDocuments { snapshot, error in
//
//            if error != nil {
//                print("Error fetching batch of trending episodes: \(error!)")
//            } else if snapshot?.count == 0 {
//                print("There are no episodes left to fetch")
//                guard let data = snapshot?.documents else { return }
//                completion(data)
//            } else {
//                guard let data = snapshot?.documents else { return }
//
//                let sortedByDate = data.sorted { (docA, docB) -> Bool in
//                    let docADate = docA.get("postedAt") as! Timestamp
//                    let docBDate = docB.get("postedAt") as! Timestamp
//
//                    let dateA = docADate.dateValue()
//                    let dateB = docBDate.dateValue()
//
//                    return dateA > dateB
//                }
//
//                completion(sortedByDate)
//            }
//        }
//    }
    
    static func fetchEpisodesWith(episodeItems: [EpisodeItem], completion: @escaping ([Episode]) -> ()) {
        var episodeIDs = [String]()
           
        for eachItem in episodeItems {
            let id = eachItem.id
            episodeIDs.append(id)
        }
        let episodesRef = db.collection("episodes").whereField("ID", in: episodeIDs).order(by: "postedAt", descending: true)
        episodesRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of episodes: \(error!.localizedDescription)")
                completion([])
            }
            
            if snapshot?.count == 0 {
                print("There are no episodes left to fetch")
                completion([])
            } else {
                
                guard let documents = snapshot?.documents else { return }
                
                var episodes = [Episode]()
                
                for eachDoc in documents {
                    let data = eachDoc.data()
                    episodes.append(Episode(data: data))
                }

                if episodes.count == documents.count {
                    completion(episodes)
                }
            }
        }
    }
    
    static func fetchAllEpisodesWith(episodeItems: [EpisodeItem], completion: @escaping ([Episode]) -> ()) {
        
        var episodes = [Episode]()
        
        for eachItem in episodeItems {
            
            let episodesRef = db.collection("episodes").document(eachItem.id)
            episodesRef.getDocument { snapshot, error in
                
                if error != nil {
                    print("Error fetching episode: \(error!.localizedDescription)")
                    completion([])
                } else {
                    
                    guard let data = snapshot!.data() else { return }
                    episodes.append(Episode(data: data))
                    
                    if episodes.count == episodeItems.count {
                        completion(episodes)
                    }
                }
            }
            
        }
    }
    
    static func fetchProgramsSubscribersWith(subscriberIDs: [String], completion: @escaping ([Program]?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            print(subscriberIDs)
            var programs = [Program]()
            for eachID in subscriberIDs {
                db.collection("programs").document(eachID).getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching program's subscribers \(error!.localizedDescription)")
                        completion(nil)
                    }
                    guard let data = snapshot?.data() else { return }
                    programs.append(Program(data: data))
                    print(Program(data: data).name)                    
                    if programs.count == subscriberIDs.count {
                        completion(programs)
                    }
                }
            }
        }
    }
    
    static func fetchProgramsWith(IDs: [String], completion: @escaping ([Program]?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            var programs = [Program]()
            for eachID in IDs {
                db.collection("programs").document(eachID).getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching programs \(error!.localizedDescription)")
                        completion(nil)
                    }
                    guard let data = snapshot?.data() else { return }
                    programs.append(Program(data: data))
                    
                    if programs.count == IDs.count {
                        completion(programs)
                    }
                }
            }
        }
    }
    
    static func getProgramWith(username: String, completion: @escaping (Program?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").whereField("username", isEqualTo: username)
                        
            programRef.getDocuments { snapshot, error in
                if error != nil {
                    print("Error getting program with username")
                    completion(nil)
                }
                
                if snapshot!.isEmpty {
                    print("No program with that username")
                    completion(nil)
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                print("User exists")
                
                for each in documents {
                    let data = each.data()
                    let isPrimary = data["isPrimaryProgram"] as! Bool
                    if isPrimary {
                        let program = Program(data: data)
                        if !program.programIDs!.isEmpty {
                            fetchSubProgramsWithIDs(programIDs: program.programIDs!, for: program) {
                                completion(program)
                            }
                        } else {
                            completion(program)
                        }
                    }
                }
            }
        }
    }
    
    static func fetchMentionsFor(programID: String, completion: @escaping ([Mention]?) -> ()) {
         DispatchQueue.global(qos: .userInitiated).async {
            
            let mentionRef = db.collection("programs").document(programID).collection("mentions")
            
            mentionRef.getDocuments { snapshot, error in
                if error != nil {
                    print("Error fetching programs mentions \(error!.localizedDescription)")
                    completion(nil)
                }
                
                let documents = snapshot!.documents
                
                var mentions = [Mention]()
                
                for eachDoc in documents {
                    let data = eachDoc.data()
                    mentions.append(Mention(data: data))
                }
                completion(mentions)
            }
            
            
        }
    }
    
    static func updateProgramsWeblinkWith(urlString: String, programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "webLink" : urlString
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's web link: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's web link")
                }
            }
        }
    }
    
//    static func updateUsersWeblinkWith(urlString: String) {
//        DispatchQueue.global(qos: .userInitiated).async {
//
//            let userRef = db.collection("users").document(User.ID!)
//
//            userRef.updateData([
//                "webLink" : urlString
//            ]) { (error) in
//                if let error = error {
//                    print("Error updating user's web link: \(error.localizedDescription)")
//                } else {
//                    print("Success updating user's web link")
//                }
//            }
//        }
//    }
    
}
