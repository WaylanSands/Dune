//
//  ImageCache.swift
//  Dune
//
//  Created by Waylan Sands on 14/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

class CacheControl {
    
    static func storeImage(urlString: String, image: UIImage) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let url = URL(fileURLWithPath: path)
        
        let data = image.jpegData(compressionQuality: 0.5)
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "ImageCache") as? [String:String]
        
        if dict == nil {
            dict = [String:String]()
        }
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "ImageCache")
    }
   
    static func storeAudio(url: URL) {
        let path = NSTemporaryDirectory().appending(UUID().uuidString)
        let urlString = url.absoluteString

        let data = try? Data.init(contentsOf: url)
        try? data?.write(to: url)
        
        var dict = UserDefaults.standard.object(forKey: "audioCache") as? [String:String]
        
        if dict == nil {
            dict = [String:String]()
        }
        
        dict![urlString] = path
        UserDefaults.standard.set(dict, forKey: "audioCache")
    }
    
    static func loadImageFromFolderOrDownloadAndSave(programID: String, imageID: String, imagePath: String, completion: @escaping (UIImage) -> ()) {
        
        if User.subscriptionIDs!.contains(programID) {
            if let subscriptionImagesDict = UserDefaults.standard.object(forKey: "subscriptionImages") as? [String: [String:String]] {
                if let programDict = subscriptionImagesDict["programID"] {
                    if imageID == programDict["imageID"] {
                        FileManager.getSubscriptionImage(with: imageID) { image in
                            completion(image)
                        }
                    } else {
                        createSubscriptionImageDict(programID: programID, imageID: imagePath, imagePath: imagePath)
                        FireStorageManager.downloadSubscriptionImageAndSaveToDocuments(imageID: imageID) { image in
                            completion(image)
                        }
                    }
                } else {
                    createSubscriptionImageDict(programID: programID, imageID: imageID, imagePath: imagePath)
                }
            } else {
                print("Error no subscriptionImagesDict saved")
            }
        } else {
            // The user is not subscribed to this program. Check cache folder for image.
            FileManager.checkCacheFor(imageID: imageID) { image in
                if image != nil {
                    completion(image!)
                } else {
                    // There is no image in the cache for this program
                    FireStorageManager.downloadNonSubscriptionImageAndSaveToCache(imageID: imageID) { image in
                        completion(image)
                    }
                }
            }
        }
    }
    
    // Creating a new program Image dictionary and adding it to the subscriptionImages object
    static func createSubscriptionImageDict(programID: String, imageID: String, imagePath: String) {
        if var subscriptionImagesDict = UserDefaults.standard.object(forKey: "subscriptionImages") as? [String: [String:String]] {
            let newAddition: [String : [String:String]] = [programID : [imageID: imagePath]]
            
            // First removing the old dictionary if present
            subscriptionImagesDict.removeValue(forKey: programID)
            appendToDict(lhs: &subscriptionImagesDict, rhs: newAddition)
            print("Added new dictionary to subscriptionImages dictionary")
        }
    }
    
    
    // Helper method adding to a dictionary
    static func appendToDict(lhs: inout [String: [String:String]], rhs: [String : [String:String]]) {
                for (key, value) in rhs {
                    lhs[key] = value
                }
    }
    
     // Helper to create subscriptionImages dictionary
    static func createSubscriptionImageDict() {
        print("Creating subscriptionImages dictionary")
        var dict = UserDefaults.standard.object(forKey: "subscriptionImages") as? [String: [String:String]]
    
        if dict != nil {
            dict = [String : [String:String]]()
        }
        UserDefaults.standard.set(dict, forKey: "subscriptionImages")
    }
}
