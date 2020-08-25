//
//  FileManager+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 14/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension FileManager {
    
    static let fileManager = FileManager.default
    
    static func fileExistsWith(path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            return true
        } else {
            return false
        }
    }
    
    static func getDocumentsDirectory() -> URL {
         let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
         let documentsDirectory = paths[0]
         return documentsDirectory
     }
     
     static func getCacheDirectory() -> URL {
          let paths = FileManager.default.urls(for:.cachesDirectory, in: .userDomainMask)
          let cacheDirectory = paths[0]
          return cacheDirectory
      }
    
    static func getTempDirectory() -> URL {
        return FileManager.default.temporaryDirectory
     }
    
    static func clearDocumentsDirectory() {
        print("Clearing documents directory")
        let documentsDirectory = getDocumentsDirectory()
        let contentURLs = try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        
        guard let fileURLs = contentURLs else { return }
        
        for eachFile in fileURLs {
            do {
                try fileManager.removeItem(at: eachFile)
            } catch {
                print("Error clearing document directory")
            }
        }
    }
    
   static func clearTmpDirectory() {
        print("Clearing temp directory")
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try FileManager.default.contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try FileManager.default.removeItem(atPath: fileUrl.path)
            }
        } catch {
            print("Error clearing temp directory")
        }
    }
    
   static func clearCacheDirectory() {
        print("Clearing cache directory")
        do {
            let cacheURL = getCacheDirectory()
            let cacheDirectory = try FileManager.default.contentsOfDirectory(atPath: cacheURL.path)
            try cacheDirectory.forEach { file in
                let fileUrl = cacheURL.appendingPathComponent(file)
                try FileManager.default.removeItem(atPath: fileUrl.path)
            }
        } catch {
            print("Error clearing cache directory")
        }
    }
    
    static func checkCacheFor(imageID: String, completion: @escaping (UIImage?) -> ()) {

        let cacheURL = getCacheDirectory()
        let possibleURL = cacheURL.appendingPathComponent(imageID)
        
        if fileExistsWith(path: possibleURL.path){
            let imageData = try! Data(contentsOf: possibleURL)
            if let image = UIImage(data: imageData) {
                completion(image)
            } else {
                print("Error getting the image from cache")
            }
        } else {
             print("No image exists in cache")
             completion(nil)
        }
    }
    
    static func getAudioFileFromTempDirectory(fileName: String, fileExtension: String) -> Data? {
        
        let tempDirectory = FileManager.getTempDirectory()
        var fileURL: URL
        
        if fileName.contains(".") {
             fileURL = tempDirectory.appendingPathComponent(fileName)
        } else {
             fileURL = tempDirectory.appendingPathComponent(fileName + fileExtension)
        }
        
        print("The Filename is \(fileName)")
        
        if fileExistsWith(path: fileURL.path) {
            let fileManger = FileManager.default
            let track = fileManger.contents(atPath: fileURL.path)
            return track
        } else {
            print("There is no data with that fileName")
            return nil
        }
    }
    
    static func getTrimmedAudioFileFromTempDirectory(fileName: String) -> Data? {
        
        let tempDirectory = FileManager.getTempDirectory()
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        if fileExistsWith(path: fileURL.path) {
            let fileManger = FileManager.default
            let track = fileManger.contents(atPath: fileURL.path)
            return track
        } else {
            print("There is no data with that fileName")
            return nil
        }
    }
    
    static func getAudioURLFromTempDirectory(fileName: String, completion: @escaping (URL) -> ())  {

        let documentsDirectory = FileManager.getTempDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if fileExistsWith(path: fileURL.path) {
            print("File found in temp directory")
            completion(fileURL)
        } else {
            print("File not in temp directory, attempting to fetch from Firebase Storage")
            FireStorageManager.downloadDraftEpisodeAudio(audioID: fileName) { url in
                completion(url)
            }
        }
    }
    
    static func removeFileFromTempDirectory(fileName: String) {
        
        let tempDirectory = FileManager.getTempDirectory()
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        if fileExistsWith(path: fileURL.path) {
            do {
                 try FileManager.default.removeItem(atPath: fileURL.path)
            }
            catch {
                print("Unable to remove file")
            }
             print("Successfully removed file")
        } else {
            print("File does not exist")
        }
    }
    
    
    static func removeAudioFilesFromDocumentsDirectory(completion: @escaping () -> ()) {
        
        let documentsUrl =  getDocumentsDirectory()
        DispatchQueue.global(qos: .background).async {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
                
                for each in directoryContents {
                    if each.pathExtension != "png" && each.pathExtension != "jpg"  {
                        do {
                            try fileManager.removeItem(at: each)
                        } catch {
                        }
                    }
                    if directoryContents.count == 1 {
                        completion()
                    }
                }
            } catch {
                print(error)
                completion()
            }
        }
    }
    
        static func printContentsOfDocumentsDirectory() {
            let documentsURL = getDocumentsDirectory()
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
                if directoryContents.count == 0 {
                    print("The documents directory is empty")
                }
                for each in directoryContents {
                    print("""
                        ****************************************
                        Content in documents folder
                        \(each.lastPathComponent)
                        """)
                }
            } catch {
                print(error)
            }
        }
    
    static func printContentsOfTempDirectory() {
        let tempURL = FileManager.default.temporaryDirectory
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: tempURL, includingPropertiesForKeys: nil)
           
            for each in directoryContents {
                print("""
                    ****************************************
                    Content in temp folder
                    \(each.lastPathComponent)
                    """)
            }
        } catch {
            print(error)
        }
    }
    
    static func deviceRemainingFreeSpaceInBytes() -> Int {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? Int
            else {
                print("Error determining space of documents directory")
                 return 0
        }
        return freeSize
    }
    
    static func excludeFileFromBackup(withURL url: URL) {
        var resourceURL = url
        var resourceValue = URLResourceValues()
        resourceValue.isExcludedFromBackup = true
        do {
            try resourceURL.setResourceValues(resourceValue)
        } catch {
            print("Issue excluding \(resourceURL) from iCloud backup")
        }
    }
    
    static func storeSelectedProgramImage(image: UIImage, imageID: String?, programID: String) {
                
        let imageID = imageID ?? NSUUID().uuidString + ".jpg"
        
        if CurrentProgram.ID != programID {
            let program = CurrentProgram.subPrograms?.first(where: { $0.ID == programID })
            program?.imageID = imageID
        } else {
            CurrentProgram.imageID = imageID
        }
        
        if let data = image.jpegData(compressionQuality: 0.5) {
           
            let cacheURL = getCacheDirectory()
            let fileURL = cacheURL.appendingPathComponent(imageID)
            
            if fileExistsWith(path: fileURL.path) {
                do {
                    try fileManager.removeItem(at: fileURL)
                } catch {
                    print("Unable to remove file from cache \(error)")
                }
            } else {
                print("There is no data with that fileName")
            }

            do {
                try data.write(to: fileURL)
                print("Adding image to cache")
                FireStorageManager.storeCachedProgram(image: image, with: imageID, for: programID)
            }
            catch {
                print("Unable to add Image to cache: (\(error))")
            }
        }
    }
    
    static func storeInitialProgramImage(image: UIImage, programID: String) {
        
        let imageID = NSUUID().uuidString + ".jpg"
        CurrentProgram.imageID = imageID
        CurrentProgram.image = image

        if let data = image.jpegData(compressionQuality: 0.5) {
           
            let cacheURL = getCacheDirectory()
            
            let fileURL = cacheURL.appendingPathComponent(imageID)
            
            if fileExistsWith(path: fileURL.path) {
                do {
                    try fileManager.removeItem(at: fileURL)
                } catch {
                    print("Unable to remove file from cache \(error)")
                }
            } else {
                print("There is no data with that fileName")
            }

            do {
                try data.write(to: fileURL)
                print("Adding image to cache")
                FireStorageManager.storeCachedProgram(image: image, with: imageID, for: programID)
            }
            catch {
                print("Unable to add Image to cache: (\(error))")
            }
        }
    }
    
    static func storeTwitterProgramImage(image: UIImage) {
        
        let imageID = NSUUID().uuidString + ".jpg"
        CurrentProgram.imageID = imageID
        CurrentProgram.image = image
        DispatchQueue.global(qos: .background).async {
            if let data = image.jpegData(compressionQuality: 0.5) {
                
                let cacheURL = getCacheDirectory()
                
                let fileURL = cacheURL.appendingPathComponent(imageID)
                
                if fileExistsWith(path: fileURL.path) {
                    do {
                        try fileManager.removeItem(at: fileURL)
                    } catch {
                        print("Unable to remove file from cache \(error)")
                    }
                }
                
                do {
                    try data.write(to: fileURL)
                    print("Adding image to cache")
                    FireStorageManager.storeCachedTwitter(image: image, with: imageID)
                }
                catch {
                    print("Unable to add Image to cache: (\(error))")
                }
            }
        }
    }
    
    
    // Check image isn't already in cache, if not download and store there
    static func getImageWith(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(imageID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if fileExistsWith(path: fileURL.path) {
                let imageData = try! Data(contentsOf: fileURL)
                if let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Failed to turn file into an Image")
                }
            } else {
                FireStorageManager.downloadAccountImage(imageID: imageID) { image in
                    completion(image)
                }
            }
        }
    }
    
    // Check image isn't already in cache, if not download and store there
    static func getLinkImageWith(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(imageID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if fileExistsWith(path: fileURL.path) {
                let imageData = try! Data(contentsOf: fileURL)
                if let image = UIImage(data: imageData) {
                    completion(image)
                } else {
                    print("Failed to turn file into an Image")
                }
            } else {
                FireStorageManager.downloadLinkImage(imageID: imageID) { image in
                    completion(image)
                }
            }
        }
    }
    
    // Check music isn't already in cache, if not download and store there.
    static func getMusicURLWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(audioID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if fileExistsWith(path: fileURL.path) {
                completion(fileURL)
            } else {
                print("Fetching music from Firebase Storage")
                FireStorageManager.downloadBackgroundMusicToCache(audioID: audioID) { url in
                    completion(url)
                }
                
            }
        }
    }
    
    // Check music isn't already in cache, if not download and store there.
    static func getMusicURLWith(audioID: String) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(audioID)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if !fileExistsWith(path: fileURL.path) {
                print("Downloading low-audio to cache")
                FireStorageManager.downloadLowAudioToCache(audioID: audioID)
            }
        }
    }
    
   static func fetchImageFrom(url: String, completion: @escaping (UIImage?) ->()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageURL = URL(string: url), let imageData = try? Data(contentsOf: imageURL) else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }


}

