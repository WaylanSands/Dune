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
    
    static func changeChannel(state: PrivacyStatus) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "channelState" : state.rawValue
            ]) { (error) in
                if let error = error {
                    print("Error updating programs's state: \(error.localizedDescription)")
                } else {
                    print("Successfully updated program's state to \(state.rawValue)")
                }
            }
        }
    }
    
    
    static func changeSubChannelWith(channelID: String, to state: PrivacyStatus) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(channelID)
            
            programRef.updateData([
                "channelState" : state.rawValue
            ]) { (error) in
                if let error = error {
                    print("Error updating sub-channel's state: \(error.localizedDescription)")
                } else {
                    print("Successfully updated sub-channel's state to \(state.rawValue)")
                }
            }
        }
    }
    
    static func revertChannelToPublicWith(ID: String, completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async {
            let programRef = db.collection("programs").document(ID)
            
            programRef.getDocument { snapshot, error in
                if let error = error {
                    print("Error reverting channel: \(error.localizedDescription)")
                } else {
                         print(2)
                    guard let data = snapshot!.data() else { return }
                    let pendingChannelIDs = data["pendingChannels"] as! [String]
                    let deniedChannelIDs = data["deniedChannels"] as! [String]
                    let requestedIDs = pendingChannelIDs + deniedChannelIDs
                    //                    subscribeChannelsWith(IDs: requestedIDs, to: ID)
                         print(3)
                    programRef.updateData([
                        "pendingChannels" : [],
                        "deniedChannels" : [],
                    ]) { (error) in
                        if let error = error {
                            print("Error reverting channel to public: \(error.localizedDescription)")
                        } else {
                 print(4)
                            if requestedIDs.count != 0 {
                            for eachID in requestedIDs {
                                let channelRef = db.collection("programs").document(eachID)
                                let currentChannelRed = db.collection("programs").document(ID)
                                
                                channelRef.updateData(["subscriptionIDs" : FieldValue.arrayUnion([ID])]) { error in
                                    if error != nil {
                                        print("Error")
                                    } else {
                                        currentChannelRed.updateData([
                                            "subscriberIDs" : FieldValue.arrayUnion([eachID]),
                                            "subscriberCount" : FieldValue.increment(Double(1))
                                        ]) { error in
                                            if error != nil {
                                                print("Error")
                                            } else {
                                                currentChannelRed.updateData([
                                                    "subscriberIDs" : FieldValue.arrayUnion([eachID]),
                                                    "subscriberCount" : FieldValue.increment(Double(1))
                                                ])
                                                completion()
                                            }
                                        }
                                    }
                                }
                                }
                            } else {
                                 completion()
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func subscribeChannelsWith(IDs: [String], to ID: String) {
        DispatchQueue.global(qos: .background).async {
            
            for eachID in IDs {
                let channelRef = db.collection("programs").document(eachID)
                let currentChannelRed = db.collection("programs").document(ID)
                
                channelRef.updateData(["subscriptionIDs" : FieldValue.arrayUnion([ID])])
                
                currentChannelRed.updateData([
                    "subscriberIDs" : FieldValue.arrayUnion([eachID]),
                    "subscriberCount" : FieldValue.increment(Double(1))
                ])
            }
        }
    }

    
    
    static func requestInviteFor(channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let programRef = db.collection("programs").document(channelID)
            
            programRef.updateData(["pendingChannels" : FieldValue.arrayUnion([CurrentProgram.ID!])]) { error in
                if let error = error {
                    print("Error requesting invite: \(error.localizedDescription)")
                } else {
                    print("Success requesting invite")
                }
            }
        }
    }
    
    static func approveRequestFor(_ channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            CurrentProgram.deniedChannels?.removeAll(where: {$0 == channelID})
            CurrentProgram.pendingChannels!.removeAll(where: { $0 == channelID })
            CurrentProgram.subscriberIDs?.append(channelID)
            CurrentProgram.subscriberCount? += 1
            
            let channelRef = db.collection("programs").document(channelID)
            channelRef.updateData(["subscriptionIDs" : FieldValue.arrayUnion([CurrentProgram.ID!])]) { error in
                if let error = error {
                    print("Error approving request: \(error.localizedDescription)")
                } else {
                    print("Success approving request")
                }
            }
            
            let ownerRef = db.collection("programs").document(CurrentProgram.ID!)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayRemove([channelID]),
                "subscriberIDs" : FieldValue.arrayUnion([channelID]),
                "subscriberCount" : FieldValue.increment(Double(1)),
            ]) { error in
                if let error = error {
                    print("Error removing pending channel: \(error.localizedDescription)")
                } else {
                    print("Success removing pending channel")
                }
            }
        }
    }
    
    static func requestRSSConnectionFor(ID: String, urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let requestRef = db.collection("rssRequests").document(User.ID!)
            let programRef = db.collection("programs").document(ID)
            
            programRef.updateData(["RSSURL" : urlString])

            requestRef.setData([
                "programID" : ID,
                "email" : User.email ?? "Social signup",
                "url" :  urlString,
            ]) { (error) in
                if let error = error {
                    print("Error requesting rss connection: \(error.localizedDescription)")
                } else {
                    print("Success requesting rss connection")
                    let url = URL(string: "https://enrm5iad8z4ra2m.m.pipedream.net")!

                    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                        guard let data = data else { return }
                        print(String(data: data, encoding: .utf8)!)
                    }
                    task.resume()
                }
            }
        }
    }
    
    // Sub-Channel
    static func approveRequestFor(_ channelID: String, for channel: Program) {
        DispatchQueue.global(qos: .userInitiated).async {
            let channelRef = db.collection("programs").document(channelID)
            channelRef.updateData(["subscriptionIDs" : FieldValue.arrayUnion([channel.ID])]) { error in
                if let error = error {
                    print("Error approving request: \(error.localizedDescription)")
                } else {
                    print("Success approving request")
                }
            }
            
            let ownerRef = db.collection("programs").document(channel.ID)
            
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayRemove([channelID]),
                "subscriberIDs" : FieldValue.arrayUnion([channelID]),
                "subscriberCount" : FieldValue.increment(Double(1)),
            ]) { error in
                if let error = error {
                    print("Error removing pending channel: \(error.localizedDescription)")
                } else {
                    print("Success removing pending channel")
                }
            }
        }
    }
    
    static func denyRequestFor(_ channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            CurrentProgram.pendingChannels!.removeAll(where: { $0 == channelID })
            CurrentProgram.deniedChannels!.append(channelID)
            
            let ownerRef = db.collection("programs").document(CurrentProgram.ID!)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayUnion([channelID]),
            ]) { error in
                if let error = error {
                    print("Error removing pending channel: \(error.localizedDescription)")
                } else {
                    print("Success removing pending channel")
                }
            }
        }
    }
    
    
    //Sub-Channel
    static func denyRequestFor(_ channelID: String, for channel: Program) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let ownerRef = db.collection("programs").document(channel.ID)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayUnion([channelID]),
            ]) { error in
                if let error = error {
                    print("Error removing pending channel: \(error.localizedDescription)")
                } else {
                    print("Success removing pending channel")
                }
            }
        }
    }
    
    static func returnAllowedFor(_ channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            CurrentProgram.pendingChannels?.append(channelID)
            CurrentProgram.subscriberIDs?.removeAll(where: {$0 == channelID})
            CurrentProgram.subscriberCount? -= 1

            let channelRef = db.collection("programs").document(channelID)
            channelRef.updateData(["subscriptionIDs" : FieldValue.arrayRemove([CurrentProgram.ID!])]) { error in
                if let error = error {
                    print("Error removing subscription: \(error.localizedDescription)")
                } else {
                    print("Success removing subscription")
                }
            }
            
            let ownerRef = db.collection("programs").document(CurrentProgram.ID!)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayUnion([channelID]),
                "subscriberIDs" : FieldValue.arrayRemove([channelID]),
                "subscriberCount" : FieldValue.increment(Double(-1)),
            ]) { error in
                if let error = error {
                    print("Error returning channel to allowed: \(error.localizedDescription)")
                } else {
                    print("Success returning channel to allowed")
                }
            }
        }
    }
    
    //Sub-channel
    static func returnAllowedFor(_ channelID: String, for channel: Program) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let channelRef = db.collection("programs").document(channelID)
            channelRef.updateData(["subscriptionIDs" : FieldValue.arrayRemove([channel.ID])]) { error in
                if let error = error {
                    print("Error removing subscription: \(error.localizedDescription)")
                } else {
                    print("Success removing subscription")
                }
            }
            
            let ownerRef = db.collection("programs").document(channel.ID)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayUnion([channelID]),
                "subscriberIDs" : FieldValue.arrayRemove([channelID]),
                "subscriberCount" : FieldValue.increment(Double(-1)),
            ]) { error in
                if let error = error {
                    print("Error returning channel to allowed: \(error.localizedDescription)")
                } else {
                    print("Success returning channel to allowed")
                }
            }
        }
    }
    
    static func returnRemovedFor(_ channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            CurrentProgram.deniedChannels?.append(channelID)
            CurrentProgram.pendingChannels!.removeAll(where: { $0 == channelID })

            let ownerRef = db.collection("programs").document(CurrentProgram.ID!)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayUnion([channelID]),
                "deniedChannels" : FieldValue.arrayRemove([channelID]),
            ]) { error in
                if let error = error {
                    print("Error returning channel to removed: \(error.localizedDescription)")
                } else {
                    print("Success returning channel to removed")
                }
            }
        }
    }
    
    //Sub-channel
    static func returnRemovedFor(_ channelID: String, for channel: Program) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let ownerRef = db.collection("programs").document(channel.ID)
            ownerRef.updateData([
                "pendingChannels" : FieldValue.arrayUnion([channelID]),
                "deniedChannels" : FieldValue.arrayRemove([channelID]),
            ]) { error in
                if let error = error {
                    print("Error returning channel to removed: \(error.localizedDescription)")
                } else {
                    print("Success returning channel to removed")
                }
            }
        }
    }
    
    static func removedChannelWith(_ channelID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            CurrentProgram.subscriberIDs?.removeAll(where: {$0 == channelID})
            CurrentProgram.deniedChannels?.append(channelID)
            CurrentProgram.subscriberCount? -= 1

            let ownerRef = db.collection("programs").document(CurrentProgram.ID!)
            ownerRef.updateData([
                "subscriberIDs" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayUnion([channelID]),
                "subscriberCount" : FieldValue.increment(Double(-1)),
            ]) { error in
                if let error = error {
                    print("Error removing channel: \(error.localizedDescription)")
                } else {
                    print("Success removing channel")
                }
            }
        }
    }
    
    //Sub-channel
    static func removedChannelWith(_ channelID: String, for ID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ownerRef = db.collection("programs").document(ID)
            ownerRef.updateData([
                "subscriberIDs" : FieldValue.arrayRemove([channelID]),
                "deniedChannels" : FieldValue.arrayUnion([channelID]),
                "subscriberCount" : FieldValue.increment(Double(-1)),
            ]) { error in
                if let error = error {
                    print("Error removing channel: \(error.localizedDescription)")
                } else {
                    print("Success removing channel")
                }
            }
        }
    }
    
    
    
    static func fetchPendingInvitesWith(pendingChannelIDs: [String], completion: @escaping ([Program]) -> ()) {
        
        if pendingChannelIDs.isEmpty {
            completion([])
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var channels = [Program]()
            for eachID in pendingChannelIDs {
                
                let channelRef = db.collection("programs").document(eachID)
                channelRef.getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching pending channels \(error!.localizedDescription)")
                        completion(channels)
                    }
                    
                    guard let data = snapshot!.data()  else { return }
                    channels.append(Program(data: data))
                    
                    if channels.count == pendingChannelIDs.count {
                        completion(channels)
                    }
                }
            }
        }
    }
    
    static func fetchRemovedInvitesWith(channelIDs: [String], completion: @escaping ([Program]) -> ()) {
        
        if channelIDs.count == 0 {
            completion([])
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            var channels = [Program]()
            for eachID in channelIDs {
                
                let channelRef = db.collection("programs").document(eachID)
                channelRef.getDocument { snapshot, error in
                    if error != nil {
                        print("Error fetching denied channels \(error!.localizedDescription)")
                        completion(channels)
                    }
                    
                    guard let data = snapshot!.data()  else { return }
                    channels.append(Program(data: data))
                    
                    if channels.count == channelIDs.count {
                        completion(channels)
                    }
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
    
    static func updateProgramToPublisher() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "isPublisher" : true
            ]) { (error) in
                if let error = error {
                    print("Error updating program to publisher: \(error.localizedDescription)")
                } else {
                    print("Successfully updating program to publisher")
                }
            }
        }
    }
    
    static func updateUserSetUpTo(_ isSetUp: Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            userRef.updateData([
                "isSetUp" : isSetUp
            ]) { (error) in
                if let error = error {
                    print("Error updating user to setup: \(error.localizedDescription)")
                } else {
                    print("Successfully setup")
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
                "isPublisher" : true,
                "hasMentions" : false,
                "name" : programName,
                "ownerID" : User.ID!,
                "summary": summary,
                "locationType": "Global",
                "addedByDune": false,
                "tags": tags,
                "programIDs" : [],
                "privacyStatus": "madePublic",
                "pendingChannels": [],
                "deniedChannels" : [],
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
                        var episodeItems = [EpisodeItem]()

                        for eachDoc in programSnapshots {
                           let episodeIDs = eachDoc.get("episodeIDs") as! [[String : Any]]
                            for each in episodeIDs {
                                let episodeItem = EpisodeItem(data: each)
                                episodeItems.append(episodeItem)
                            }
                        }
                        completion(episodeItems.sorted(by: >))
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
