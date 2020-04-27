//
//  FireStorageManager.swift
//  Dune
//
//  Created by Waylan Sands on 11/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

struct FireStorageManager {
    
    static func storeProgramImageInFolder(selectedImage: UIImage) {
        
        // If user does not have an imageID assign one
        if  Program.imageID == nil {
            let imageID = NSUUID().uuidString
            Program.imageID = imageID
            User.imageID = imageID
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(Program.imageID!)")
            
            if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                
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
                                Program.imagePath = url.absoluteString
                                User.imagePath = url.absoluteString
                                FireStoreManager.addImagePathToProgram()
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func storeProgram(image: UIImage) {
        print("Storing image in Firebase Storage")
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(Program.imageID!)")
            
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
                                Program.imagePath = url.absoluteString
                                FireStoreManager.addImagePathToProgram()
                            }
                        }
                    }
                })
            }
        }
    }
    
    static func storeUserImage(selectedImage: UIImage) {
        
        // If user does not have an image assign one
        if  User.imageID == nil {
            let imageID = NSUUID().uuidString
            User.imageID = imageID
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(User.imageID!)")
            
            if let uploadData = selectedImage.jpegData(compressionQuality: 0.5) {
                
                let uploadTask = storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
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
                                User.imagePath = url.absoluteString
                                FireStoreManager.addImagePathToUser()
                            }
                        }
                    }
                })
                uploadTask.observe(.progress) { snapshot in
                }
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
    
    static func storeEpisodeAudio(fileName: String, data: Data, completion: @escaping (URL?)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("audio/\(fileName)")
            
            let uploadTask = storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                
                if let errorMessage = error {
                    print("There has was an error storing the audio \(errorMessage)")
                    completion(nil)
                } else {
                    print("complete")
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                            print("Error getting audio url")
                            completion(nil)
                        }
                        
                        if let url = url {
                            completion(url)
                            // Remove draft episode from user
                        }
                    }
                }
            })
            uploadTask.observe(.progress) { snapshot in
            }
        }
    }
    
    static func storeDraftEpisodeAudio(fileName: String, data: Data, completion: @escaping (URL?)->()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("draftAudio/\(fileName)")
            
            storageRef.putData(data, metadata: nil, completion: { (metadata, error) in
                
                if let errorMessage = error {
                    print("There has was an error storing the draft audio \(errorMessage)")
                    completion(nil)
                } else {
                    print("complete")
                    storageRef.downloadURL { (url, error) in
                        
                        if error != nil {
                            print("Error getting audio url")
                            completion(nil)
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
            
            // Delete the file
            deleteRef.delete { error in
                if error != nil {
                    print("There was an error deleting the draft from storage")
                } else {
                    print("Draft file deleted successfully")
                }
            }
        }
    }
    
    static func deletePublishedAudioFromStorage(audioID: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("audio/\(audioID)")
            
            // Delete the file
            deleteRef.delete { error in
                if error != nil {
                    print("There was an error deleting the audio from storage")
                } else {
                    print("Audio file deleted successfully")
                }
            }
        }
    }
    
    static func deleteProgramImageFileFromStorage(imageID: String, completion: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let deleteRef = Storage.storage().reference().child("images/\(imageID)")
            
            deleteRef.delete { error in
                if error != nil {
                    print("There was an error deleting the draft from Firebase Storage")
                    completion()
                } else {
                    print("Draft file deleted successfully")
                    completion()
                }
            }
        }
    }
    
    
    static func downloadEpisodeAudio(audioID: String, completion: @escaping (URL) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("audio/\(audioID)")
            let documentsURL = FileManager.getDocumentsDirectory()
            let audioURL = documentsURL.appendingPathComponent(audioID)
            
            storageRef.write(toFile: audioURL) { (url, error) in
                
                if error != nil {
                    print(error!)
                } else {
                    print("This is the url: \(url!)")
                    completion(url!)
//                    FileManager.printContentsOfDocumentsDirectory()
                }
            }
        }
    }
    
}