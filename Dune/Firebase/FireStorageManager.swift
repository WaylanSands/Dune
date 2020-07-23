//
//  FireStorageManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import FirebaseStorage

struct FireStorageManager {
    
    static func storeSubProgram(image: UIImage, to programID: String) {
        
        let imageID = NSUUID().uuidString + ".jpg"

        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(imageID)")
            
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if let errorMessage = error {
                        print("There has was an error adding the image \(errorMessage)")
                        return
                    } else {
                        print("complete")
                        storageRef.downloadURL { (url, error) in
                            
                            if error != nil {
                                print("Error getting image url")
                            }
                            
                            if let url = url {
                                FireStoreManager.addImagePathToSubProgram(with: programID, imageID: imageID, imagePath: url.path)
                            }
                        }
                    }
                })
            }
        }
    }

    
    static func downloadSubscriptionImageAndSaveToDocuments(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        let storageRef = Storage.storage().reference().child("images/\(imageID)")
        let image = UIImage()
        
        storageRef.getData(maxSize: .max) { data, error in
            
            if let data = image.jpegData(compressionQuality: 0.5) {
                
                let documentsURL = FileManager.getDocumentsDirectory()
                let filePath = documentsURL.appendingPathComponent(imageID)
                
                do {
                    try data.write(to: filePath)
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
                catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            } else {
                print("Error getting subscriber image from Firebase")
            }
        }
    }
    
    static func downloadNonSubscriptionImageAndSaveToCache(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        let storageRef = Storage.storage().reference().child("images/\(imageID)")
        let image = UIImage()
        
        storageRef.getData(maxSize: .max) { data, error in
            
            if let data = image.jpegData(compressionQuality: 0.5) {
                
                let cacheURL = FileManager.getCacheDirectory()
                let filePath = cacheURL.appendingPathComponent(imageID)
                
                do {
                    try data.write(to: filePath)
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
                catch {
                    print("Unable to Write Data to Disk (\(error))")
                }
            } else {
                print("Error getting non-subscriber image from Firebase")
            }
        }
    }
    
    static func storeEpisodeAudio(fileName: String, data: Data, completion: @escaping (URL)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("audio/\(fileName)")
            
            let uploadTask = storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                
                if let errorMessage = error {
                    print("There has was an error storing the audio \(errorMessage)")
                } else {
                    print("complete")
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                            print("Error getting audio url")
                        }
                        
                        if let url = url {
                            deleteDraftFileFromStorage(fileName: fileName)
                            completion(url)
                            
                        }
                    }
                }
            })
            uploadTask.observe(.progress) { snapshot in
            }
        }
    }
    
    static func storeIntroAudio(fileName: String, data: Data, completion: @escaping (URL)->()) {
         
         DispatchQueue.global(qos: .userInitiated).async {
             
             let storageRef = Storage.storage().reference().child("introAudio/\(fileName)")
             
             let uploadTask = storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                 
                 if let errorMessage = error {
                     print("There has was an error storing the intro \(errorMessage)")
                 } else {
                     print("Intro has been stored in Firebase Storage")
                     storageRef.downloadURL { (url, error) in
                         
                         if error != nil {
                             print("Error getting audio url")
                         }
                         
                         if let url = url {
                             completion(url)
                         }
                     }
                 }
             })
             uploadTask.observe(.progress) { snapshot in
             }
         }
     }
    
    static func storeDraftEpisodeAudio(audioID: String, data: Data, completion: @escaping (URL)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("draftAudio/\(audioID)")
            
            storageRef.putData (data, metadata: nil, completion: { (metadata, error) in
                
                if let errorMessage = error {
                    print("There has was an error storing the draft audio \(errorMessage)")
                } else {
                    print("complete")
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                            print("Error getting audio url")
                        }
                        
                        if let url = url {
                            completion(url)
                        }
                    }
                }
            })
        }
    }

    
    static func deleteDraftFileFromStorage(fileName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("draftAudio/\(fileName)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("Error deleting the draft audio from storage \(error!.localizedDescription)")
                } else {
                    print("Success deleting draft audio file")
                }
            }
        }
    }
    
    static func deleteIntroFileFromStorage(fileName: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("introAudio/\(fileName)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("Error deleting intro from storage")
                } else {
                    print("Intro file deleted successfully")
                }
            }
        }
    }
    
    static func deletePublishedAudioFromStorage(audioID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("audio/\(audioID)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("Error deleting audio from storage")
                } else {
                    print("Audio file deleted successfully")
                }
            }
        }
    }
    
    static func deleteImageFileFromStorage(imageID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("images/\(imageID)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("Error deleting the program image from Firebase")
                } else {
                    print("Draft file deleted successfully")
                }
            }
        }
    }
    
    static func deleteIntroAudioFromStorage(audioID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("introAudio/\(audioID)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("Error deleting introAudio from storage")
                } else {
                    print("introAudio file deleted successfully")
                }
            }
        }
    }
    
    
    static func downloadEpisodeAudio(audioID: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("audio/\(audioID)")
            let tempURL = FileManager.getTempDirectory()
            let audioURL = tempURL.appendingPathComponent(audioID)
            
        let task =  storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    completion(url!)
                }
            }
            task.observe(.progress) { snapshot in
                print(snapshot.progress!)
            }
        }
    }
    
    
    static func downloadIntroAudio(audioID: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("introAudio/\(audioID)")
            let tempURL = FileManager.getTempDirectory()
            let audioURL = tempURL.appendingPathComponent(audioID)
            
            storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    completion(url!)
                }
            }
        }
    }
    
    // Download background music and save to cache
    static func downloadBackgroundMusicToCache(audioID: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("backgroundMusic/\(audioID)")
            let cacheURL = FileManager.getCacheDirectory()
            let audioURL = cacheURL.appendingPathComponent(audioID)
            
            storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    completion(url!)
                }
            }
        }
    }
    
    static func downloadLowAudioToCache(audioID: String) {
        
        DispatchQueue.global(qos: .background).async {
            
            let storageRef = Storage.storage().reference().child("backgroundMusic/\(audioID)")
            let cacheURL = FileManager.getCacheDirectory()
            let audioURL = cacheURL.appendingPathComponent(audioID)
            
            storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Added low audio to cache")
                }
            }
        }
    }
    
    // Download draft episode from Firebase Storage
    static func downloadDraftEpisodeAudio(audioID: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("draftAudio/\(audioID)")
            let tempURL = FileManager.getTempDirectory()
            let audioURL = tempURL.appendingPathComponent(audioID)
            
            storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("Returning with audio file from firebase")
                    completion(url!)
                }
            }
        }
    }
    
    // Download image and store in cache directory
    static func downloadAccountImage(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let storageRef = Storage.storage().reference().child("images/\(imageID)")
            let cacheURL = FileManager.getCacheDirectory()
            let imageURL = cacheURL.appendingPathComponent(imageID)
            storageRef.write(toFile: imageURL) { (url, error) in
                if error != nil {
                    print(error!)
                    if let image = UIImage(named: "missing-image-large") {
                        completion(image)
                    }
                } else {
                    if let data = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: data) {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    // Download image and store in cache directory
    static func downloadLinkImage(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("linkImages/\(imageID)")
            let cacheURL = FileManager.getCacheDirectory()
            let imageURL = cacheURL.appendingPathComponent(imageID)
            storageRef.write(toFile: imageURL) { (url, error) in
                if error != nil {
                    print(error!)
                } else {
                    let imageData = try! Data(contentsOf: url!)
                    if let image = UIImage(data: imageData) {
                        completion(image)
                    } else {
                        print("Failed to return Firebase file into an image")
                    }
                }
            }
        }
    }
    
    static func storeCachedProgram(image: UIImage, with ID: String, for programID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(ID)")
            
            if let image = image.jpegData(compressionQuality: .zero) {
                
                storageRef.putData(image, metadata: nil, completion: { (metadata, error) in
                    
                    if let errorMessage = error {
                        print("There has was an error adding the image \(errorMessage)")
                    } else {
                        print("Image added to Firebase Storage")
                        storageRef.downloadURL { (url, error) in
                            
                            if error != nil {
                                print("Error getting image url")
                            } else {
                                FireStoreManager.addImagePathToProgram(with: programID, imagePath: url!.path, imageID: ID)
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func storeCachedTwitter(image: UIImage, with ID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(ID)")
            
            if let image = image.jpegData(compressionQuality: .zero) {
                
                storageRef.putData(image, metadata: nil, completion: { (metadata, error) in
                    
                    if let errorMessage = error {
                        print("There has was an error adding the image \(errorMessage)")
                    } else {
                        print("Image added to Firebase Storage")
                    }
                })
            }
        }
    }
    
}
