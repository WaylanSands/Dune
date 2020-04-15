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
    
    static func storeProgramImage(selectedImage: UIImage) {
        
        // If user does not have an image assign one
        if  Program.storedImageID == nil {
            let imageID = NSUUID().uuidString
            Program.storedImageID = imageID
            User.storedImageID = imageID
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(Program.storedImageID!)")
            
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
                                Program.imagePath = url.absoluteString
                                User.imagePath = url.absoluteString
                                FireStoreManager.addImagePathToProgram()
                            }
                        }
                    }
                })
                
                uploadTask.observe(.progress) { snapshot in
                }
            }
        }
    }
    
    static func storeUserImage(selectedImage: UIImage) {
        
        // If user does not have an image assign one
        if  User.storedImageID == nil {
            let imageID = NSUUID().uuidString
            User.storedImageID = imageID
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let storageRef = Storage.storage().reference().child("images/\(User.storedImageID!)")
            
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
}
