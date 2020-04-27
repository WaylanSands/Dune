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
    
    func clearTmpDirectory() {
        print("Clearing temp directory")
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
    
    static func storeInDocuments(image: UIImage, urlString: String) {
    
        if let data = image.jpegData(compressionQuality: 0.5) {
            let documents = getDocumentsDirectory()
            let fileURL = URL(string: urlString)
            let fileName = fileURL!.lastPathComponent
            let url = documents.appendingPathComponent(fileName)

            do {
                try data.write(to: url)
            }
            catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
    
    static func storeInCustomDocumentFolder(image: UIImage, urlString: String) {
    
        if let data = image.jpegData(compressionQuality: 0.5) {
            let path = getDocumentsDirectory()
            let customPath = path.appendingPathComponent("user/profile-image", isDirectory: true)
            let fileURL = URL(string: urlString)
            let fileName = fileURL!.lastPathComponent
            let url = customPath.appendingPathComponent(fileName)

            do {
                try data.write(to: url)
                print(url)
            }
            catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }

    
    static func getAndStoreImage(withUrl: String, completion: @escaping (UIImage) -> ()) {
        
        let paths = getDocumentsDirectory()
        let fileURL = URL(string: withUrl)
        let fileName = fileURL!.lastPathComponent
        let imagePath = paths.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: imagePath.path) {
            if let image = UIImage(contentsOfFile: imagePath.path) {
                completion(image)
                 print("Getting from storage")
            }
        } else {
            let url = URL(string: withUrl)
            DispatchQueue.global().async {
                print("downloading image")
                if let imageData = try? Data(contentsOf: url!) {
                    if let image = UIImage(data: imageData) {
                        storeInDocuments(image: image, urlString: withUrl)
                        completion(image)
                    }
                }
            }
        }
    }
    
    static func getAndStoreImageInCustomFolder(withUrl: String, completion: @escaping (UIImage) -> ()) {
        print("Getting stored image")
        let paths = getDocumentsDirectory()
        let customPath = paths.appendingPathComponent("user/profile-image", isDirectory: true)
        
        var objcTrueBool: ObjCBool = true
        let hasCreatedCustomFolder = FileManager.default.fileExists(atPath: customPath.path, isDirectory: &objcTrueBool)
        
        if hasCreatedCustomFolder == false {
            do {
                try FileManager.default.createDirectory(at: customPath, withIntermediateDirectories: true, attributes: nil)
                 print("Created directory")
            }
            catch {
                print("There has been an error creating the custom folder")
            }
            
            let fileURL = URL(string: withUrl)
            let fileName = fileURL!.lastPathComponent
            let imagePath = customPath.appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: imagePath.path) {
                if let image = UIImage(contentsOfFile: imagePath.path) {
                    completion(image)
                    print("Getting from storage")
                }
            } else {
                let url = URL(string: withUrl)
                DispatchQueue.global().async {
                    print("downloading image")
                    if let imageData = try? Data(contentsOf: url!) {
                        if let image = UIImage(data: imageData) {
                            storeInCustomDocumentFolder(image: image, urlString: withUrl)
                            completion(image)
                        }
                    }
                }
            }
        } else {
            
        }
    }
    
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
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
        let fileURL = documentsDirectory.appendingPathComponent(fileName + fileExtension)
        
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

        let documentsDirectory = FileManager.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(fileName + ".m4a")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            completion(fileURL)
        } else {
            print("There is no data with that fileName")
            completion(nil)
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
    
    static func printContentsIn(folder: userFolder) {
                
        let folderName: String
        let programFolder: String
        
        if User.isPublisher! {
            programFolder = "program-\(Program.ID!)"
            
            switch folder {
            case .user:
                folderName = "user"
            case .image:
                folderName = "user/image"
            case .program:
                folderName = "user/\(programFolder)"
            case .programDrafts:
                folderName = "user/\(programFolder)/drafts"
            case .programImage:
                folderName = "user/\(programFolder)/image"
            case .programIntro:
                folderName = "user/\(programFolder)/intro"
            }
            
        } else {
            switch folder {
            case .user:
                folderName = "user"
            case .image:
                folderName = "user/image"
            default:
                print("Error non publisher requesting publisher folder")
                fatalError()
            }
        }
                
        let documentsURL = FileManager.getDocumentsDirectory()
        let folderURL = documentsURL.appendingPathComponent(folderName, isDirectory: true)
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            
            if directoryContents.count == 0 {
                print("The \(folderName) is empty")
            }
            
            for each in directoryContents {
                print("Folder contains: \(each.lastPathComponent)")
            }
        } catch {
            print(error)
        }
    }
    

    
    
    // Create primary User folder along with subfolders
    
    static func createUserFolderForPublisher(programID: String) {
        
        let programFolder = "program-\(programID)"
        let documentsURL = getDocumentsDirectory()
        
        let userURL = documentsURL.appendingPathComponent("user", isDirectory: true)
        let programURL = documentsURL.appendingPathComponent("user/\(programFolder)", isDirectory: true)
        let programImageURL = documentsURL.appendingPathComponent("user/\(programFolder)/image", isDirectory: true)
        let programDraftsURL = documentsURL.appendingPathComponent("user/\(programFolder)/drafts", isDirectory: true)
        let programIntroURL = documentsURL.appendingPathComponent("user/\(programFolder)/intro", isDirectory: true)
        
        var objcTrueBool: ObjCBool = true
        let hasCreatedCustomFolder = FileManager.default.fileExists(atPath: userURL.path, isDirectory: &objcTrueBool)
        
        if hasCreatedCustomFolder == false {
            do {
                try FileManager.default.createDirectory(at: userURL, withIntermediateDirectories: true, attributes: nil)
                print("Created user directory")
                try FileManager.default.createDirectory(at: programURL, withIntermediateDirectories: true, attributes: nil)
                print("Created program directory")
                try FileManager.default.createDirectory(at: programImageURL, withIntermediateDirectories: true, attributes: nil)
                print("Created image directory with program")
                try FileManager.default.createDirectory(at: programDraftsURL, withIntermediateDirectories: true, attributes: nil)
                print("Created drafts directory within program")
                try FileManager.default.createDirectory(at: programIntroURL, withIntermediateDirectories: true, attributes: nil)
                print("Created intro directory within program")
            }
            catch {
                print("There has been an error creating a custom folder")
            }
        } else {
             clearDocumentsDirectory()
             createUserFolderForPublisher(programID: programID)
        }
    }
    
    static func removeFilesIn(folder: userFolder, completion: @escaping () ->()) {
        
        let folderName: String
        let programFolder: String
        
        if User.isPublisher! {
            programFolder = "program-\(Program.ID!)"
            
            switch folder {
            case .user:
                folderName = "user"
            case .image:
                folderName = "user/image"
            case .program:
                folderName = "user/\(programFolder)"
            case .programDrafts:
                folderName = "user/\(programFolder)/drafts"
            case .programImage:
                folderName = "user/\(programFolder)/image"
            case .programIntro:
                folderName = "user/\(programFolder)/intro"
            }
            
        } else {
            switch folder {
            case .user:
                folderName = "user"
            case .image:
                folderName = "user/image"
            default:
                print("Error non publisher requesting publisher folder")
                fatalError()
            }
        }
        
        let fileManager = FileManager.default
        let documentsURL = FileManager.getDocumentsDirectory()
        let folderURL = documentsURL.appendingPathComponent(folderName, isDirectory: true)
        
        do {
            let contentURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            
            if contentURLs.count == 0 {
                 completion()
            }
            
            for each in contentURLs {
                do {
                    try fileManager.removeItem(at: each)
                    print("Removed file: \(each.lastPathComponent) from folder: \(folderName)")
                    completion()
                } catch {
                    print("Error removing items from \(folderName)")
                }
            }
        } catch {
            print("Error getting content URLs from from \(folderName)")
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
    
    static func storeSelectedProgram(image: UIImage, completion: @escaping () ->()) {
        
        let newFileName = NSUUID().uuidString
        let programImageFolder = "user/program-\(Program.ID!)/image"
        Program.imageID = newFileName
        
        if let data = image.jpegData(compressionQuality: 0.5) {
            let documentsURL = getDocumentsDirectory()
            let folderURL = documentsURL.appendingPathComponent(programImageFolder, isDirectory: true)
            let imageURL = folderURL.appendingPathComponent(newFileName)
            
            do {
                try data.write(to: imageURL)
                print("Adding image to \(programImageFolder)")
                completion()
            }
            catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
    
    static func getProgramImage(completion: @escaping (UIImage) ->()) {
        DispatchQueue.global().async {
            let programImageFolder = "user/program-\(Program.ID!)/image"
            
            let documentsURL = getDocumentsDirectory()
            let folderURL = documentsURL.appendingPathComponent(programImageFolder, isDirectory: true)
            let url = folderURL.appendingPathComponent(Program.imageID!)
            
            let imageData = try? Data(contentsOf: url)
            
            if imageData != nil {
                if let image = UIImage(data: imageData!) {
                    completion(image)
                }
            } else {
                printContentsIn(folder: .user)
                printContentsIn(folder: .programImage)
                print("Has not saved an image to programImage folder")
                completion(#imageLiteral(resourceName: "missing-image-large"))
            }
        }
    }
    
    static func getSubscriptionImage(with imageID: String, completion: @escaping (UIImage) ->()) {
       
        DispatchQueue.global().async {
            let documentsURL = getDocumentsDirectory()
            let url = documentsURL.appendingPathComponent(imageID)
            
            let imageData = try? Data(contentsOf: url)
            
            if imageData != nil {
                if let image = UIImage(data: imageData!) {
                    completion(image)
                }
            } else {
                print("Could not get subscription image from documents")
            }
        }
    }
    
//    static func storeAudioFileInDocuments(audioID: String, audioData: Data, completion: @escaping (Bool) ->()) {
//
//        let documentsURL = getDocumentsDirectory()
//        let availableSpace = deviceRemainingFreeSpaceInBytes()
//        let audioURL = documentsURL.appendingPathComponent(audioID)
//
//            if audioData.count < availableSpace {
//
//                    do {
//                        try audioData.write(to: audioURL)
//                        print("Adding audio to documents directory")
//                        completion(true)
//                    }
//                    catch {
//                        print("Unable to store audio in documents directory (\(error))")
//                        completion(false)
//                    }
//            } else {
//                removeAudioFilesFromDocumentsDirectory {
//                }
//        }
//
//        do {
//            try audioData.write(to: audioURL)
//            print("Adding audio to documents directory")
//            completion(true)
//        }
//        catch {
//            print("Unable to store audio in documents directory (\(error))")
//            completion(false)
//        }
//    }
    
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

    
}

enum userFolder {
    case user
    case image
    case program
    case programImage
    case programDrafts
    case programIntro
}
