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
           //catch the error somehow
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
           //catch the error somehow
        }
    }
    
    static func checkCacheFor(imageID: String, completion: @escaping (UIImage?) -> ()) {

        let cacheURL = getCacheDirectory()
        let possibleURL = cacheURL.appendingPathComponent(imageID)
        
        if FileManager.default.fileExists(atPath: possibleURL.path) {
            if let image = UIImage(contentsOfFile: possibleURL.path) {
                completion(image)
            } else {
                print("Error getting the image from cache")
            }
        } else {
             print("No image exists in cache")
             completion(nil)
        }
    }
    
    static func clearDocumentsDirectory() {
        print("Clearing documents directory")
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

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
    
    static func getAudioFileFromDocumentsDirectory(fileName: String, fileExtension: String) -> Data? {
        
        let documentsDirectory = FileManager.getDocumentsDirectory()
        
        var fileURL: URL
        
        if fileName.contains(".m4a") {
             fileURL = documentsDirectory.appendingPathComponent(fileName)
        } else {
             fileURL = documentsDirectory.appendingPathComponent(fileName + fileExtension)
        }
                
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let fileManger = FileManager.default
            let track = fileManger.contents(atPath: fileURL.path)
            return track
        } else {
            print("There is no data with that fileName")
            return nil
        }
    }
    
    static func getAudioFileFromTempDirectory(fileName: String, fileExtension: String) -> Data? {
        
        let tempDirectory = FileManager.getTempDirectory()
        var fileURL: URL
        
        if fileName.contains(".m4a") {
             fileURL = tempDirectory.appendingPathComponent(fileName)
        } else {
             fileURL = tempDirectory.appendingPathComponent(fileName + fileExtension)
        }
        
        print("The Filename is \(fileName)")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
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
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let fileManger = FileManager.default
            let track = fileManger.contents(atPath: fileURL.path)
            return track
        } else {
            print("There is no data with that fileName")
            return nil
        }
    }
    
    static func getAudioURLFrom(fileName: String, completion: @escaping (URL?) -> ())  {
        print("Docs:")
        printContentsOfDocumentsDirectory()
        let documentsDirectory = FileManager.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName + ".m4a")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            print("There is no data with that fileName")
            completion(nil)
        }
        
    }
    
    static func getAudioURLFromTempDirectory(fileName: String, completion: @escaping (URL) -> ())  {

        let documentsDirectory = FileManager.getTempDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("File found in temp directory")
            completion(fileURL)
        } else {
            print("File not in temp directory, attemptng to fetch from Firebase Storage")
            FireStorageManager.downloadDraftEpisodeAudio(audioID: fileName) { url in
                completion(url)
            }
        }
        
    }
    
    static func removeFileFromDocumentsDirectory(fileName: String) {
        
        let documentsDirectory = FileManager.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName + ".m4a")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
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
    
    static func removeFileFromTempDirectory(fileName: String) {
        
        let tempDirectory = FileManager.getTempDirectory()
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
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
    
    static func checkFileExists(filePath: String) -> Bool {
        
        if FileManager.default.fileExists(atPath: filePath) {
            return true
        } else {
            print("There is no file at that path")
            return false
        }
    }
    
    static func removeAudioFilesFromDocumentsDirectory(completion: @escaping () -> ()) {
        
        let documentsUrl =  getDocumentsDirectory()
        let fileManager = FileManager.default
        DispatchQueue.global().async {
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
                
                for each in directoryContents {
                    print(each.lastPathComponent)
                    if each.lastPathComponent != "user" && each.pathExtension != "png" && each.pathExtension != "jpg"  {
                        do {
                            try fileManager.removeItem(at: each)
                            print("Removing \(each.lastPathComponent).\(each.pathExtension) from documents")
                        } catch {
                            print("Error removing \(each.lastPathComponent).\(each.pathExtension) from documents")
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
                // Get the directory contents urls (including subfolders urls)
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
            // Get the directory contents urls (including subfolders urls)
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
    
    static func storeSelectedListener(image: UIImage) {
  
        if let data = image.jpegData(compressionQuality: 0.5) {
            let documentsURL = getDocumentsDirectory()
            let folderURL = documentsURL.appendingPathComponent("user/image", isDirectory: true)
            let url = folderURL.appendingPathComponent(User.imageID!)
            
            do {
                try data.write(to: url)
            }
            catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
    
    static func checkTempDirectoryForAudioFileWith(audioID: String, completion: (URL?) -> ()) {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(audioID)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            print("There is no data with that fileName")
            completion(nil)
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
    
    // Store selected image in cache directory
    static func storeSelectedProgramImage(image: UIImage, imageID: inout String?, programID: String) {
        
        let fileManager = FileManager.default
        
        if imageID == nil {
            imageID = NSUUID().uuidString
        }
        
        if let data = image.jpegData(compressionQuality: 0.5) {
           
            let cacheURL = getCacheDirectory()
            let fileURL = cacheURL.appendingPathComponent(imageID!)
            
            if fileManager.fileExists(atPath: fileURL.path) {
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
                FireStorageManager.storeCachedProgram(image: image, with: imageID!, for: programID)
            }
            catch {
                print("Unable to add Image to cache: (\(error))")
            }
        }
    }
    
    
    // Check image isn't already in cache, if not download and store there
    static func getImageWith(imageID: String, completion: @escaping (UIImage) -> ()) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(imageID)
        
        DispatchQueue.global().async {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let image = UIImage(contentsOfFile: fileURL.path) {
                    completion(image)
                } else {
                    print("Failed to turn file into an Image")
                }
            } else {
                print("Fetching image from Firebase Storage")
                FireStorageManager.downloadProgramImage(imageID: imageID) { image in
                    completion(image)
                }
            }
        }
    }
    
     // Check music isn't already in cache, if not download and store there.
    static func getMusicURLWith(audioID: String, completion: @escaping (URL) -> ()) {
        
        let cacheURL = FileManager.getCacheDirectory()
        let fileURL = cacheURL.appendingPathComponent(audioID)
        
        DispatchQueue.global().async {
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                completion(fileURL)
            } else {
                print("Fetching music from Firebase Storage")
                FireStorageManager.downloadBackgroundMusicToCache(audioID: audioID) { url in
                    completion(url)
                }
            }
        }
    }

    
}

enum userFolder {
    case user
    case image
    case program
    case programImage
    case programDrafts
    case programIntro
}
