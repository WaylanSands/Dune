//
//  FireStoreManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import CloudKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseStorage

struct FireStoreManager {
    
    static let db = Firestore.firestore()
    
    static func addVersionControl() {
        
        db.collection("versionControl").document("current")
            .addSnapshotListener { snapshot, error in
                guard let doc = snapshot else { return }
                guard let data = doc.data() else { return }
                
                let latestBuild = data["build"] as! String
                let onAppStore = data["onAppStore"] as! Bool
                let appStoreLink = data["appStoreLink"] as! String
                let latestVersion = data["version"] as! String
                
                if (VersionControl.version != latestVersion || VersionControl.build != Double(latestBuild)) && !onAppStore {
//                    VersionControl.currentBuild = Double(latestBuild)!
//                    print("Not the right version")
//
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    let newBuild = CustomAlertView(alertType: .oldVersion)
//
//                    appDelegate.newVersionAlert(alert: newBuild)
                    
                } else if onAppStore {
                    print("It's on the AppStore")
                    VersionControl.appStoreLink = appStoreLink
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let onAppStore = CustomAlertView(alertType: .onTheAppStore)

                    appDelegate.newVersionAlert(alert: onAppStore)
                }
        }
    }
    

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
                    print("Successfully added imagePath to channel")
                }
            }
        }
    }
    
    static func topThreeInterests(with IDs: [String]) {
        DispatchQueue.global(qos: .background).async {
            
            var categories = [String]()
            var counter = 0
            for each in IDs {
                let episodeRef = db.collection("episodes").document(each)
                
                episodeRef.getDocument { snapshot, error in
                    counter += 1

                    if error != nil {
                        print("Error fetching episode for Interest")
                    }
                    
                    guard let category = snapshot!.get("category") as? String else { return }
                    categories.append(category)
                    
                    if counter == IDs.count {
                        let sorted = categories.sorted(by: { $0 < $1 })
                        User.interests = Array(sorted.removingDuplicates().prefix(3))
                    }
                }
            }
        }
    }
    
    static func autoSubscribeToInterests(completion: @escaping (Bool) ->()) {
        DispatchQueue.global(qos: .background).async {
            var counter = 0
            
            for each in User.interests! {
                let channelQuery = db.collection("programs").whereField("primaryCategory", isEqualTo: each).order(by: "subscriberCount", descending: true).limit(to: 2)
                            
                channelQuery.getDocuments { (snapshot, error) in
                    counter += 1
                    if error != nil {
                        print("Error")
                        return
                    }
                    
                    let docs = snapshot!.documents
                    
                    for doc in docs {
                        subscribeToProgramWith(programID: doc.documentID)
                        addSubscriptionToProgramWith(programID: doc.documentID)
                        CurrentProgram.subscriptionIDs?.append(doc.documentID)
                    }
                    
                    if counter == User.interests!.count {
                        if CurrentProgram.subscriptionIDs!.count > 4 {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    static func autoSubscribeToTop(completion: @escaping () ->()) {
        DispatchQueue.global(qos: .background).async {
    
                var counter = 0
                let popularCategories = ["News", "Education", "Business"]
                for each in popularCategories {
                    
                    let programRef = db.collection("programs").whereField("primaryCategory", isEqualTo: each).order(by: "subscriberCount", descending: true).limit(to: 2)
                    
                    programRef.getDocuments { snapshot, error in
                        counter += 1
                        
                        if error != nil {
                            print("Error fetching episode for Interest")
                        }
                        
                        let docs = snapshot!.documents
                        
                        for doc in docs {
                            subscribeToProgramWith(programID: doc.documentID)
                            addSubscriptionToProgramWith(programID: doc.documentID)
                            CurrentProgram.subscriptionIDs?.append(doc.documentID)
                        }
                        
                        if counter == popularCategories.count {
                            completion()
                        }
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
                    print("Successfully added imagePath to channel")
                }
            }
        }
    }
    
    //MARK: Edit Program
    static func updatePrimaryProgramName() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
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
    
    static func updateUserUsername() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "username" : User.username!
            ]) { (error) in
                if let error = error {
                    print("Error updating username: \(error.localizedDescription)")
                } else {
                    print("Successfully updated username")
                    updateProgramUsername()
                }
            }
        }
    }
    
    static func updateProgramUsername() {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(CurrentProgram.ID!)
            
            programRef.updateData([
                "username" : User.username!
            ]) { error in
                if error != nil {
                    print("Error updating username: \(error!.localizedDescription)")
                } else {
                    print("Successfully updated username")
                    programRef.getDocument { (snapshot, error) in
                        if error != nil {
                            print("Error updating username: \(error!.localizedDescription)")
                        } else {
                            guard let data = snapshot!.data() else { return }
                            let episodes = data["episodeIDs"] as! [[String : Any]]
                            
                            var episodeIDs = [String]()
                            
                            for each in episodes {
                                episodeIDs.append(each["ID"] as! String)
                            }
                            
                            if episodeIDs.count == episodes.count {
                                updateEpisodesUsernameTo(name: User.username!, for: episodeIDs)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    static func updateEpisodesUsernameTo(name: String, for episodeIDs: [String]) {
        DispatchQueue.global(qos: .userInitiated).async {
            for eachID in episodeIDs {
                let episodeRef = db.collection("episodes").document(eachID)
                episodeRef.updateData(["username" : User.username!])
            }
        }
    }
    
    static func updateUserBirthDate() {
        print("updateUserBirthDate")
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "birthDate" : User.birthDate!
            ]) { error in
                if let error = error {
                    print("Error updating user's birthDate: \(error.localizedDescription)")
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
    
    static func updateUser(summary: String, tags: [String]) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            
            userRef.updateData([
                "summary" :  summary,
                "tags" :     tags
            ]) { (error) in
                if let error = error {
                    print("Error updating user's details: \(error.localizedDescription)")
                } else {
                    print("Success updating user's details")
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
    
    static func updateUserLocationWith(country: String, lat: Double, lon: Double) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            User.country = country
            userRef.updateData([
                "geoPoint" :  GeoPoint(latitude: lat, longitude: lon),
                "country" :  country,

            ]) { (error) in
                if let error = error {
                    print("Error updating user's location: \(error.localizedDescription)")
                } else {
                    print("Success updating user's location")
                }
            }
        }
    }
    
    static func checkIfUsernameExists(name: String, completion: @escaping (Bool)->()) {
        
        FirebaseStatus.isChecking = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let usersRef =  db.collection("users")
            
            usersRef.whereField("username", isEqualTo: name).getDocuments { (snapshot, error) in
                
                FirebaseStatus.isChecking = false
                
                if error != nil {
                    print("Error getting document: \(error!.localizedDescription)")
                }
                
                guard let snapshot = snapshot else {
                    completion(true)
                    return
                }
                
                if snapshot.isEmpty {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    static func checkIfUserExists(ID: String, completion: @escaping (Bool)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let usersRef =  db.collection("users").document(ID)
            
            usersRef.getDocument(completion: { (snapshot, error) in
                if error != nil {
                    print("Error getting document: \(error!.localizedDescription)")
                } else {
                    
                    if snapshot!.exists {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
            
        }
    }
    
    
    static func getProgramData(completion: @escaping (Bool) -> ()) {
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
                    completion(true)
                }
            }
        }
    }
    
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
    
    static func getEpisodeWith(episodeID: String, completion: @escaping (Episode) -> ()) {
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let episodeRef = db.collection("episodes").document(episodeID)
            episodeRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("Error fetching episode \(error!.localizedDescription)")
                } else {
                    guard let data = snapshot?.data() else { return }
                    completion(Episode(data: data))
                }
            }
        }
    }
    
    static func getDailyEpisodes(completion: @escaping ([Episode]) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            let day = Date(timeIntervalSinceNow: dayInterval)
            let twentyFourHours = Timestamp(date: day)
            var episodes = [Episode]()
            var counter: Int = 0
            
            for eachID in CurrentProgram.subscriptionIDs! {
                counter += 1
                
                let episodesRef = db.collection("episodes")
                    .whereField("programID", isEqualTo: eachID)
                    .whereField("postedAt", isLessThan: twentyFourHours)
                
                episodesRef.getDocuments { snapshot, error in
                    if error != nil {
                        print("Error fetching daily episodes \(error!.localizedDescription)")
                        completion([])
                    }
                    
                    for eachDoc in snapshot!.documents {
                        let data = eachDoc.data()
                        episodes.append(Episode(data: data))
                    }
                    
                    if counter == CurrentProgram.subscriptionIDs?.count {
                        completion(episodes)
                    }
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
            let trendingRef = db.collection("lastSevenDays").document(episodeRef.documentID)

            let ID = episodeRef.documentID
            let currentTime = Timestamp()
            
            trendingRef.setData([
                "ID": trendingRef.documentID,
                "postedAt" : currentTime,
                "duration" : duration,
                "imageID" : imageID,
                "category" : CurrentProgram.primaryCategory!,
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
            ])
            
            episodeRef.setData([
                "ID": ID,
                "postedAt" : currentTime,
                "duration" : duration,
                "imageID" : imageID,
                "category" : CurrentProgram.primaryCategory!,
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
                        "episodeIDs" : FieldValue.arrayUnion([[
                            "ID" : ID ,
                            "timeStamp" : currentTime,
                            "category"  : CurrentProgram.primaryCategory!
                            ]])
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added episodeID to program")
                            let usernames = checkIfUserWasTagged(caption: caption)
                            if !usernames.isEmpty {
                                FireBaseComments.addMentionToProgramWith(usernames: usernames, caption: caption, contentID: ID, primaryEpisodeID: nil, mentionType: .episodeTag)
                            }
                            completion(true)
                            FirebaseNotifications.notifySubscribersWith(episodeID: ID, channelID: programID, channelName: programName, imageID: imageID, caption: caption)
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    // MARK: - Push Subscribers With New Episode
    
    static func publishEpisodeWithLinkMedia(programID: String, imageID: String, imagePath: String, programName: String, caption: String, richLink: String, linkIsSmall: Bool, linkImage: UIImage, linkHeadline: String, canonicalUrl: String, tags: [String], audioID: String, audioURL: URL, duration: String, completion: @escaping (Bool) ->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let episodeRef = db.collection("episodes").document()
            let trendingRef = db.collection("lastSevenDays").document(episodeRef.documentID)

            let linkImageID = NSUUID().uuidString
            let ID = episodeRef.documentID
            
            let currentTime = Timestamp()
            
            trendingRef.setData([
                "ID": trendingRef.documentID,
                "postedAt" : currentTime,
                "category" : CurrentProgram.primaryCategory!,
                "duration" : duration,
                "imageID" : imageID,
                "imagePath" :imagePath,
                "programName" : programName,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "richLink" : richLink,
                "linkIsSmall" :  linkIsSmall,
                "linkHeadline" : linkHeadline,
                "canonicalUrl" : canonicalUrl,
                "linkImageID" : linkImageID,
                "programID" : programID,
                "ownerID" : User.ID!,
                "audioPath" : audioURL.absoluteString,
                "audioID" : audioID,
                "likeCount" : 0,
                "commentCount" : 0,
                "shareCount" : 0,
                "listenCount" : 0,
            ])
            
            episodeRef.setData([
                "ID": ID,
                "postedAt" : currentTime,
                "category" : CurrentProgram.primaryCategory!,
                "duration" : duration,
                "imageID" : imageID,
                "imagePath" :imagePath,
                "programName" : programName,
                "username" : User.username!,
                "caption" : caption,
                "tags" : tags,
                "richLink" : richLink,
                "linkIsSmall" :  linkIsSmall,
                "linkHeadline" : linkHeadline,
                "canonicalUrl" : canonicalUrl,
                "linkImageID" : linkImageID,
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
                        "episodeIDs" : FieldValue.arrayUnion([[
                            "ID" : ID ,
                            "timeStamp" : currentTime,
                            "category"  : CurrentProgram.primaryCategory!
                            ]])
                    ]) { (error) in
                        if let error = error {
                            print("There has been an error adding the episodeID to program: \(error.localizedDescription)")
                        } else {
                            print("Successfully added episodeID to program")
                            let usernames = checkIfUserWasTagged(caption: caption)
                            if !usernames.isEmpty {
                                FireBaseComments.addMentionToProgramWith(usernames: usernames, caption: caption, contentID: ID, primaryEpisodeID: nil, mentionType: .episodeTag)
                            }
                            storeRichLink(image: linkImage, imageID: linkImageID) {
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    static func storeRichLink(image: UIImage, imageID: String, completion: @escaping ()->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let storageRef = Storage.storage().reference().child("linkImages/\(imageID)")
            
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let errorMessage = error {
                        print("There has was an error adding the image \(errorMessage)")
                        return
                    } else {
                        print("complete")
                        completion()
                    }
                })
            }
            storeRichImageWith(fileName: imageID, image: image)
        }
    }
    
    static func storeRichImageWith(fileName: String, image: UIImage) {
        
        if let data = image.jpegData(compressionQuality: 1) {
            let cacheURL = FileManager.getCacheDirectory()
            let fileURL = cacheURL.appendingPathComponent(fileName)
            
            do {
                try data.write(to: fileURL, options: .atomic)
                print("Storing image")
            }
            catch {
                print("Unable to Write Data to Disk (\(error.localizedDescription))")
            }
        }
    }
    
    static func checkIfUserWasTagged(caption: String) -> [String] {
        let words = caption.components(separatedBy: " ")
        var taggedUsers = [String]()
        for word in words{
            if word.hasPrefix("@"){
                let user = word.dropFirst()
                taggedUsers.append(String(user))
            }
        }
        print("Tagged users are \(taggedUsers)")
        return(taggedUsers)
    }
    
    
    static func fetchAndCreateProgramWith(programID: String, completion: @escaping (Program) ->())  {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error fetching the program \(error!)")
                } else {
                    guard let data = snapshot?.data() else { return }
                    let program = Program(data: data)
                    if program.isPrimaryProgram && !program.programIDs!.isEmpty {
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
    
    static func fetchAndCreatePossibleProgramWith(programID: String, completion: @escaping (Program?) ->())  {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            programRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error fetching the program \(error!)")
                    completion(nil)
                } else {
                    guard let data = snapshot?.data() else { return }
                    let program = Program(data: data)
                    if program.isPrimaryProgram && !program.programIDs!.isEmpty {
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
    
    
    static func deleteProgram(with ID: String, introID: String?, imageID: String?) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(ID)
            let episodeRef = db.collection("episodes").whereField("programID", isEqualTo: ID)
            let draftEpRef = db.collection("draftEpisodes").whereField("programID", isEqualTo: ID)
            let subscriptionsRef = db.collection("programs").whereField("subscriptionIDs", arrayContains: ID)
            let subscribersRef = db.collection("programs").whereField("subscriberIDs", arrayContains: ID)
            let pendingRef = db.collection("programs").whereField("pendingChannels", arrayContains: ID)
            let deniedRef = db.collection("programs").whereField("deniedChannels", arrayContains: ID)
            
            if introID != nil {
                FireStorageManager.deleteIntroFileFromStorage(fileName: introID!)
            }
            
            if imageID != nil {
                FireStorageManager.deleteImageFileFromStorage(imageID: imageID!)
            }
            
            programRef.delete { error in
                if error != nil {
                    print("Error attempting to delete program \(error!.localizedDescription)")
                }
            }
            
            subscribersRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get subscriber documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData([
                            "subscriberIDs" : FieldValue.arrayRemove([ID]),
                            "subscriberCount" : FieldValue.increment(Double(-1))
                        ])
                    }
                }
            }
            
            subscriptionsRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get get subscription documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData(["subscriptionIDs" : FieldValue.arrayRemove([ID])])
                    }
                }
            }
            
            episodeRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get program episode documents \(error!.localizedDescription)")
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
                    print("Error attempting to get draft episode documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        let data = each.data()
                        let ID =  data["ID"] as! String
                        let audioID = data["fileName"] as! String
                        userRef.updateData(["draftEpisodeIDs" : FieldValue.arrayRemove([ID])])
                        FireStorageManager.deleteDraftFileFromStorage(fileName: audioID)
                        User.draftEpisodeIDs?.removeAll(where: { $0 == ID })
                        each.reference.delete()
                    }
                }
            }
            
            pendingRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get get pending documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData(["subscriptionIDs" : FieldValue.arrayRemove([ID])])
                    }
                }
            }
            
            deniedRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get get denied documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData(["subscriptionIDs" : FieldValue.arrayRemove([ID])])
                    }
                }
            }
            
            let primaryProgramRef = db.collection("programs").document(CurrentProgram.ID!)
            
            primaryProgramRef.updateData(["programIDs" : FieldValue.arrayRemove([ID])]) { error in
                if error != nil {
                    print("Error attempting to fetch primaryProgram document \(error!.localizedDescription)")
                } else {
                    print("Successfully removed programID from primary program")
                }
            }
            
        }
    }
    
    static var programsToDelete: Int = 0
    
    static func deleteProgram(with ID: String, introID: String?, imageID: String?, isSubProgram: Bool, completion: @escaping ()->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let userRef = db.collection("users").document(User.ID!)
            let programRef = db.collection("programs").document(ID)
            let episodeRef = db.collection("episodes").whereField("programID", isEqualTo: ID)
            let draftEpRef = db.collection("draftEpisodes").whereField("programID", isEqualTo: ID)
            let programsRef = db.collection("programs").whereField("subscriptionIDs", arrayContains: ID)
            let subscriberRef = db.collection("programs").whereField("subscriberIDs", arrayContains: ID)
            let pendingRef = db.collection("programs").whereField("pendingChannels", arrayContains: ID)
            let deniedRef = db.collection("programs").whereField("deniedChannels", arrayContains: ID)
            
            if introID != nil {
                FireStorageManager.deleteIntroFileFromStorage(fileName: introID!)
            }
            
            if imageID != nil {
                FireStorageManager.deleteImageFileFromStorage(imageID: imageID!)
            }
            
//            InstanceID.instanceID().deleteID
                        
            programsRef.getDocuments { (snapshot, error) in
                if error != nil {
                    print("Error attempting to get subscription documents \(error!.localizedDescription)")
                } else {
                    for each in snapshot!.documents {
                        each.reference.updateData(["subscriptionIDs" : FieldValue.arrayRemove([ID])])
                    }
                }
                
                subscriberRef.getDocuments { (snapshot, error) in
                    if error != nil {
                        print("Error attempting to get subscriber documents \(error!.localizedDescription)")
                    } else {
                        for each in snapshot!.documents {
                            each.reference.updateData([
                                "subscriberIDs" : FieldValue.arrayRemove([ID]),
                                "subscriberCount" : FieldValue.increment(Double(-1))
                            ])
                        }
                    }
                    
                    programRef.delete { error in
                        if error != nil {
                            print("Error attempting to delete program \(error!.localizedDescription)")
                        }
                        
                        episodeRef.getDocuments { (snapshot, error) in
                            if error != nil {
                                print("Error attempting to get program episode documents \(error!.localizedDescription)")
                            } else {
                                for each in snapshot!.documents {
                                    let data = each.data()
                                    let audioID = data["audioID"] as! String
                                    FireStorageManager.deletePublishedAudioFromStorage(audioID: audioID)
                                    each.reference.delete()
                                }
                            }
                            
                            pendingRef.getDocuments { (snapshot, error) in
                                if error != nil {
                                    print("Error attempting to get get pending documents \(error!.localizedDescription)")
                                } else {
                                    for each in snapshot!.documents {
                                        each.reference.updateData(["pendingChannels" : FieldValue.arrayRemove([ID])])
                                    }
                                }
                                
                                deniedRef.getDocuments { (snapshot, error) in
                                    if error != nil {
                                        print("Error attempting to get get denied documents \(error!.localizedDescription)")
                                    } else {
                                        for each in snapshot!.documents {
                                            each.reference.updateData(["deniedChannels" : FieldValue.arrayRemove([ID])])
                                        }
                                    }
                                    
                                    draftEpRef.getDocuments { (snapshot, error) in
                                        if error != nil {
                                            print("Error attempting to get draft episode documents \(error!.localizedDescription)")
                                        } else {
                                            for each in snapshot!.documents {
                                                let data = each.data()
                                                let fileName = data["fileName"] as! String
                                                FireStorageManager.deleteDraftFileFromStorage(fileName: fileName)
                                                each.reference.delete()
                                            }
                                        }
                                        
                                        if isSubProgram {
                                            let programRef = db.collection("programs").document(CurrentProgram.ID!)
                                            programRef.updateData(["programIDs" : FieldValue.arrayRemove([ID])])
                                            programsToDelete -= 1
                                            
                                            if programsToDelete == 0 {
                                                completion()
                                            }
                                        } else {
                                            userRef.delete { error in
                                                if error != nil {
                                                    print("Error attempting to delete user \(error!.localizedDescription)")
                                                }
                                            }
                                            if CurrentProgram.programIDs != nil && CurrentProgram.programIDs!.count != 0 {
                                                programsToDelete = CurrentProgram.programIDs!.count
                                                for eachID in CurrentProgram.programIDs! {
                                                    let programRef = db.collection("programs").document(eachID)
                                                    
                                                    programRef.getDocument { (snapshot, error) in
                                                        if error != nil {
                                                            print("Error obtaining subprograms during deletion \(error!.localizedDescription)")
                                                        } else {
                                                            guard let data = snapshot!.data() else { return }
                                                            let introID = data["introID"] as? String
                                                            let imageID = data["imageID"] as! String
                                                            
                                                            deleteProgram(with: eachID, introID: introID, imageID: imageID, isSubProgram: true) {
                                                                completion()
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
                }
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
    
    static func removeEpisodeIDFromProgram(programID: String, episodeID: String, time: Timestamp, category: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            let programRef = db.collection("programs").document(programID)
            
            let element = ["ID" : episodeID, "category" : category, "timeStamp" : time] as [String : Any]
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
            
            db.collection("lastSevenDays").document(ID).delete() { err in
                if let err = err {
                    print("Error deleting episode document: \(err)")
                } else {
                    print("Trending document successfully deleted!")
                }
            }
            
            db.collection("episodes").document(ID).delete() { err in
                if let err = err {
                    print("Error deleting episode document: \(err)")
                } else {
                    print("Episode document successfully deleted!")
                }
            }
        }
    }
    
    
    static func reportProgramWith(programID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            db.collection("reportedPrograms").document(programID)
                .setData([
                    "reporters" : FieldValue.arrayUnion([User.ID!])
                ] , merge: true)
        }
    }
    
    static func reportEpisodeWith(episodeID: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            db.collection("reportedEpisodes").document(episodeID)
                .setData([
                    "reporters" : FieldValue.arrayUnion([User.ID!])
                ] , merge: true)
        }
    }
    
    static func getUserData(completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        let userRef = db.collection("users").document(uid)
        DispatchQueue.global(qos: .userInitiated).async {
            
            userRef.getDocument { (snapshot, error) in
                if error != nil {
                    print("There was an error getting users document: \(snapshot!)")
                } else {
                    guard let data = snapshot?.data() else { return }
                    User.modelUser(data: data)
                    let onBoarded = data["completedOnBoarding"] as! Bool
                    
                    if onBoarded {
                        FireStoreManager.getProgramData { success in
                            if success {
                                completion(true)
                            } else {
                                print("Error getting program data")
                            }
                        }
                    } else {
                        completion(true)
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
        let trendingRef = db.collection("lastSevenDays").document(episodeID)
        
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
            
            trendingRef.updateData([
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
        User.likedEpisodes?.append(episodeID)
    }
    
    
    static func updateUserWithUnLiked(episodeID: String) {
        let userRef = db.collection("users").document(User.ID!)
        
        userRef.updateData([
            "likedEpisodes" : FieldValue.arrayRemove([episodeID])
        ])
        if let index = User.likedEpisodes?.firstIndex(of: episodeID) {
            User.likedEpisodes?.remove(at: index)
        }
    }
    
    static func updateListenCountFor(episode ID: String) {
        
        let listen: Double = 1
        
        let episodeRef = db.collection("episodes").document(ID)
        let trendingRef = db.collection("lastSevenDays").document(ID)

        DispatchQueue.global(qos: .default).async {
            
            episodeRef.updateData([
                "listenCount" : FieldValue.increment(listen)
            ])
            
            trendingRef.updateData([
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
