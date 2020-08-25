//
//  DynamicLinkHandler.swift
//  Dune
//
//  Created by Waylan Sands on 1/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import FirebaseAuth
import FirebaseStorage
import FirebaseDynamicLinks

struct DynamicLinkHandler {
    
    static func handleIncomingLink(_ dynamicLink: DynamicLink, completion: @escaping (Program?) ->()) {
        
        if let url = dynamicLink.url {
            print("Incoming link parameter: \(url.absoluteString)")
            
            guard dynamicLink.matchType == .unique || dynamicLink.matchType == .default else {
                print("Link not strong enough match")
                completion(nil)
                return
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
                completion(nil)
                return
            }
            
            if components.path == "/episodes" {
                print("Shared an episode")
                
                if let programID = queryItems.first(where: {$0.name == "programID"}) {
                    guard let id = programID.value else { completion(nil)
                        return
                    }
                    if Auth.auth().currentUser != nil {
                        FireStoreManager.fetchAndCreatePossibleProgramWith(programID: id) { program in
                            completion(program)
                        }
                    } else {
                        completion(nil)
                    }
                }
                
                for each in queryItems {
                    print(each)
                }
            } else if components.path == "/programs" {
                for each in queryItems {
                    print(each)
                }
            } else if components.path == "/app" {
                for each in queryItems {
                    print(each)
                }
            }
            
        } else {
            print("Dynamic link has no object")
            completion(nil)
        }
    }
    
    
    static func handleIncomingLinkOnOpen(_ dynamicLink: DynamicLink) {
        
        guard let url  = dynamicLink.url else { return }
        print("Incoming link parameter: \(url.absoluteString)")
        
        if dynamicLink.matchType == .unique || dynamicLink.matchType == .default  {
            print("Link not strong enough match")
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return
        }
        
        if components.path == "/episodes" {
            print("Clicked a shared episode")
            if let programID = queryItems.first(where: {$0.name == "programID"}) {
                guard let id = programID.value else { return }
                FireStoreManager.fetchAndCreatePossibleProgramWith(programID: id) { program in
                    CurrentProgram.subscriptionIDs = [String]()
                    CurrentProgram.subscriptionIDs?.append(id)
                    User.recommendedProgram = program
                    print(CurrentProgram.subscriptionIDs!)
                }
            }
        } else if components.path == "/programs" {
            for each in queryItems {
                print(each)
            }
        } else if components.path == "/app" {
            for each in queryItems {
                print(each)
            }
        }
        
    }
    
    
    static func visitProfile(program: Program) {
        if CurrentProgram.programsIDs().contains(program.ID) {
            let tabBar = MainTabController()
            tabBar.selectedIndex = 4
            DuneDelegate.newRootView(tabBar)
        } else {
            if program.isPrimaryProgram && !program.programIDs!.isEmpty  {
                let programVC = ProgramProfileVC()
                programVC.program = program
                //               navigationController?.pushViewController(programVC, animated: true)
            } else {
//                let programVC = SingleProgramProfileVC(program: program)
                //               navigationController?.pushViewController(programVC, animated: true)
            }
        }
    }
    
    
    static func createLinkFor(episode: Episode, completion: @escaping (URL)->()) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.dailyune.com"
        components.path = "/episodes"
        
        let episodeIDQueryItem = URLQueryItem(name: "episodeID", value: episode.ID)
        let sharerIDQueryItem = URLQueryItem(name: "sharerID", value: CurrentProgram.ID)
        let programIDQueryItem = URLQueryItem(name: "programID", value: episode.programID)
        components.queryItems = [episodeIDQueryItem, sharerIDQueryItem, programIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print(linkParameter.absoluteString)
        
        guard let shareLink = DynamicLinkComponents(link: linkParameter, domainURIPrefix: "https://dailyune.page.link") else {
            print("Couldn't create share-link")
            return
        }
        
        imagePath(imageID: episode.imageID) { url in
            if let url = url {
                
                if let myBundleID =  Bundle.main.bundleIdentifier {
                    shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
                }
                shareLink.iOSParameters?.appStoreID = "1499893273"
                shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                shareLink.socialMetaTagParameters?.title = episode.programName
                shareLink.socialMetaTagParameters?.descriptionText = episode.caption
                shareLink.socialMetaTagParameters?.imageURL = url
                
                shareLink.shorten { url, warnings, error in
                    if error != nil {
                        print("Error occurred creating short link \(error!.localizedDescription)")
                        return
                    }
                    
                    if let warnings = warnings {
                        for each in warnings {
                            print("Warning with shortened link: \(each)")
                        }
                    }
                    
                    guard let url = url else { return }
                    completion(url)
                }
            }
        }
    }
    
    static func createLinkFor(program: Program, completion: @escaping (URL)->()) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.dailyune.com"
        components.path = "/programs"
        
        let programIDQueryItem = URLQueryItem(name: "programID", value: program.ID)
        let sharerIDQueryItem = URLQueryItem(name: "sharerID", value: CurrentProgram.ID)
        components.queryItems = [programIDQueryItem, sharerIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        print(linkParameter.absoluteString)
        
        guard let shareLink = DynamicLinkComponents(link: linkParameter, domainURIPrefix: "https://dailyune.page.link") else {
            print("Couldn't create share-link")
            return
        }
        
        imagePath(imageID: program.imageID) { url in
            if let url = url {
                
                if let myBundleID =  Bundle.main.bundleIdentifier {
                    shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleID)
                }
                shareLink.iOSParameters?.appStoreID = "1499893273"
                shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
                shareLink.socialMetaTagParameters?.title = program.name
                shareLink.socialMetaTagParameters?.descriptionText = program.summary
                shareLink.socialMetaTagParameters?.imageURL = url
                
                shareLink.shorten { url, warnings, error in
                    if error != nil {
                        print("Error occurred creating short link \(error!.localizedDescription)")
                        return
                    }
                    
                    if let warnings = warnings {
                        for each in warnings {
                            print("Warning with shortened link: \(each)")
                        }
                    }
                    
                    guard let url = url else { return }
                    completion(url)
                }
            }
        }
    }
    
    static func imagePath(imageID: String?, completion: @escaping (URL?) ->()) {
        
        let child: String
        
        if imageID == nil || !imageID!.contains(".jpg") {
            child = "shareImage/shareImage.png"
        } else {
            child = "images/\(imageID!)"
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let imageRef = Storage.storage().reference().child(child)
            
            imageRef.downloadURL { url, error in
                if error != nil {
                    print("Error fetching downloadURL for share image: \(error!.localizedDescription)")
                    completion(nil)
                } else {
                    guard let url = url else { return }
                    completion(url)
                }
            }
        }
    }
    
}
