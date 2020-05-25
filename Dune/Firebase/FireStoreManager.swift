//
//  FireStoreManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Firebase

struct FireStoreManager {
    
    static let db = Firestore.firestore()
    
    static func addImagePathToProgram(with programID: String, imagePath: String, imageID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            if programID != CurrentProgram.ID! {
                let program = CurrentProgram.subPrograms?.first(where: { $0.ID == programID })
                program?.imagePath = imagePath
            } else {
                CurrentProgram.imagePath = imagePath
            }
            
            programRef.updateData([
                "imagePath" : imagePath,
                "imageID" : imageID
            ]) { (error) in
                if let error = error {
                    print("There has been an error adding the imagePath to program: \(error.localizedDescription)")
                } else {
                    print("Successfully added imagePath to program")
                }
            }
        }
    }
    
    static func addImagePathToSubProgram(with programID: String, imageID: String, imagePath: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let program = CurrentProgram.subPrograms?.first(where: {$0.ID == programID})
            program?.imagePath = imagePath
            program?.imageID = imageID
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "imagePath" : imagePath,
                "imageID" : imageID
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
    
    static func updateSubProgramWith(name: String, programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "name" :  name
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
    
    
    static func updateProgram(summary: String, tags: [String], for programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "summary" :  summary,
                "tags" :     tags
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
    
    static func deleteDraftEpisodeWith(ID: String) {
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let epRef = db.collection("draftEpisodes").document(ID)
            
            epRef.delete { error in
                if error != nil {
                    print("Error attempting to delete draft episode")
                } else {
                    print("Success deleting draft episode")
                }
            }
        }
    }
    
    static func publishEpisode(programID: String, imageID: String, imagePath: String, programName: String, caption: String, tags: [String], audioID: String, audioURL: URL, duration: String, completion: @escaping (Bool) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("episodes").document()
            let ID = episodeRef.documentID
            let currentTime = Timestamp()
            
            episodeRef.setData([
                "ID": ID,
                "postedAt" : currentTime,
                "duration" : duration,
                "imageID" : imageID,
                "imagePath" :imagePath,
                "programName" : programName,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "programID" : programID,
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
                    
                    let programRef = db.collection("programs").document(programID)
                    
                    programRef.updateData([
                        "episodeIDs" : FieldValue.arrayUnion([["ID" : ID , "timeStamp" : currentTime]])
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added episodeID to program")
                            completion(true)
                        }
                    }
                    
                }
            }
        }
    }
    
    static func publishEpisodeWithLink(programID: String, imageID: String, imagePath: String, programName: String, caption: String, richLink: String, linkIsSmall: Bool, tags: [String], audioID: String, audioURL: URL, duration: String, completion: @escaping (Bool) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("episodes").document()
            let ID = episodeRef.documentID
            let currentTime = Timestamp()
            
            episodeRef.setData([
                "ID": ID,
                "postedAt" : currentTime,
                "duration" : duration,
                "imageID" : imageID,
                "imagePath" :imagePath,
                "programName" : programName,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "richLink" : richLink,
                "linkIsSmall" :  linkIsSmall,
                "programID" : programID,
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
                    
                    let programRef = db.collection("programs").document(programID)
                    
                    programRef.updateData([
                        "episodeIDs" : FieldValue.arrayUnion([["ID" : ID , "timeStamp" : currentTime]])
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added episodeID to program")
                            completion(true)
                        }
                    }
                    
                }
            }
        }
    }
    
    
    static func fetchAndCreateProgramWith(programID: String, completion: @escaping (Program) ->())  {
        
         DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error fetching the program \(error!)")
                } else {
                    print("Success fetching program")
                    guard let data = snapshot?.data() else { return }
                    let program = Program(data: data)
                    completion(program)
                }
            }
        }
    }
    
    static func addIntroToProgram(programID: String, introID: String, introPath: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.updateData([
                "hasIntro" : true,
                "introID": introID,
                "introPath" : introPath,
            ]) { error in
                if error != nil {
                    print("Error adding intro to program \(error!)")
                } else {
                    print("Successfully added intro to program")
                }
            }
        }
    }
    
    static func removeIntroFromProgram() {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "hasIntro" : false,
                "introID": FieldValue.delete(),
                "introPath" : FieldValue.delete(),
            ]) { error in
                if error != nil {
                    print("Error adding intro to program \(error!)")
                } else {
                    print("Successfully added intro to program")
                }
            }
        }
    }
    
    // MARK: Delete a program
    static func deleteProgram(with ID: String, introID: String?, imageID: String?, isSubProgram: Bool) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(ID)
            let episodeRef = db.collection("episodes").whereField("programID", isEqualTo: ID)
            let draftEpRef = db.collection("draftEpisodes").whereField("programID", isEqualTo: ID)
            let usersRef = db.collection("users").whereField("subscriptionIDs", arrayContains: ID)

            programRef.delete { error in
                if error != nil {
                    print("Error attempting to delete program")
                }
            }
            
            episodeRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get program episode documents ")
                } else {
                    for each in snapshot!.documents {
                        let data = each.data()
                        let audioID = data["audioID"] as! String
                        FireStorageManager.deletePublishedAudioFromStorage(audioID: audioID)
                        each.reference.delete()
                    }
                }
            }
            
            draftEpRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get draft episode documents ")
                } else {
                    for each in snapshot!.documents {
                        let data = each.data()
                        let audioID = data["audioID"] as! String
                        FireStorageManager.deleteDraftFileFromStorage(fileName: audioID)
                        each.reference.delete()
                    }
                }
            }
            
            usersRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get draft episode documents ")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData(["subscriptionIDs" : FieldValue.arrayRemove([ID])])
                    }
                }
            }
            
            if introID != nil {
                FireStorageManager.deleteIntroFileFromStorage(fileName: introID!)
            }
            
            if imageID != nil {
                FireStorageManager.deleteImageFileFromStorage(imageID: imageID!)
            }
            
            if isSubProgram {
                print("Is a sub program")
                let programRef = db.collection("programs").document(CurrentProgram.ID!)
                programRef.updateData(["programIDs" : FieldValue.arrayRemove([ID])])
            }
        }
    }
    
    
    static func saveDraftEpisode(ID: String, fileName: String, programID: String, programName: String,  wasTrimmed: Bool, startTime: Double, endTime: Double, caption: String, tags: [String], audioURL: URL, duration: String, completion: @escaping (Bool)->()) {

        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("draftEpisodes").document(ID)
            
         episodeRef.setData([
                "ID": ID,
                "addedAt" : FieldValue.serverTimestamp(),
                "fileName" : fileName,
                "wasTrimmed" : wasTrimmed,
                "startTime" : startTime,
                "endTime" : endTime,
                "duration" : duration,
                "programName" : programName,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "programID" : programID,
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
    
    static func removeMultipleProgramsStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "hasMultiplePrograms" : false
            ]) { (error) in
                if let error = error {
                    print("Error removing multiple programs status: \(error.localizedDescription)")
                } else {
                    print("Success removing multiple programs status")
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
    
    static func removeEpisodeIDFromProgram(programID: String, episodeID: String, time: Timestamp) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            let element = ["ID" : episodeID, "timeStamp" : time] as [String : Any]
            print("removing \(element)")
            
            programRef.updateData([
                "episodeIDs" : FieldValue.arrayRemove([element])
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
                    let onBoarded = data["completedOnBoarding"] as! Bool
                    
                    if isPublisher && onBoarded {
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
        User.likedEpisodesIDs?.append(episodeID)
    }
    
    
    static func updateUserWithUnLiked(episodeID: String) {
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "likedEpisodes" : FieldValue.arrayRemove([episodeID])
        ])
        if let index = User.likedEpisodesIDs?.firstIndex(of: episodeID) {
            User.likedEpisodesIDs?.remove(at: index)
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
    
    // MARK: Episode Tag Lookup
    static func getEpisodesWith(tag: String, completion: @escaping ([Episode]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            var taggedEpisodes = [Episode]()
            
            let episodeRef = db.collection("episodes").whereField("tags", arrayContains: tag)
            
            episodeRef.getDocuments(completion: { (snapshot, error) in
                if error != nil {
                    print("There was an error getting tagged episodes")
                } else {
                    var counter = 0
                    for each in snapshot!.documents {
                        
                        counter += 1
                        let data = each.data()
                        let episode = Episode(data: data)
                        taggedEpisodes.append(episode)
                        
                        if counter == snapshot?.count {
                            completion(taggedEpisodes)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: Program Tag Lookup
    static func getProgramsWith(tag: String, completion: @escaping ([Program]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            var taggedEpisodes = [Program]()
            
            let episodeRef = db.collection("programs").whereField("tags", arrayContains: tag)
            
            episodeRef.getDocuments(completion: { (snapshot, error) in
                if error != nil {
                    print("There was an error getting tagged programs")
                } else {
                    var counter = 0
                    for each in snapshot!.documents {
                        
                        counter += 1
                        let data = each.data()
                        let program = Program(data: data)
                        taggedEpisodes.append(program)
                        
                        if counter == snapshot?.count {
                            completion(taggedEpisodes)
                        }
                    }
                }
            })
        }
    }
    
}

