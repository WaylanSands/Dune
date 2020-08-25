//
//  AudioDownloadManager.swift
//  
//
//  Created by Waylan Sands on 5/8/20.
//

import FirebaseStorage
import FirebaseFirestore

struct AudioDownloadManager {
    
    static let db = Firestore.firestore()
    static var downloadTask: StorageDownloadTask!

    static func fetchEpisodesItemsWith(with programIDs: [String], completion: @escaping ([EpisodeItem]) -> ()) {
        var programSnapshots = [DocumentSnapshot]()
        var counter = 0
        if programIDs.count == 0 {
            completion([])
        }
        
        for eachID in programIDs {
            counter += 1
            
            let programRef = db.collection("programs").document(eachID)
            
            programRef.getDocument { snapshot, error in
                
                if error != nil {
                    print("Error fetching batch of program's episodes: \(error!)")
                } else {
                    programSnapshots.append(snapshot!)
                    if programSnapshots.count == programIDs.count {
                        var episodeItems = [EpisodeItem]()
                        
                        for eachDoc in programSnapshots {
                            let episodeIDs = eachDoc.get("episodeIDs") as! [[String : Any]]
                            for each in episodeIDs {
                                let episodeItem = EpisodeItem(data: each)
                                episodeItems.append(episodeItem)
                            }
                        }
                        completion(episodeItems.sorted(by: >))
                    }
                }
            }
        }
    }
    
    static func fetchEpisodesWith(episodeItems: [EpisodeItem], completion: @escaping ([Episode]) -> ()) {
        var episodeIDs = [String]()
        
        for eachItem in episodeItems {
            let id = eachItem.id
            episodeIDs.append(id)
        }
        let episodesRef = db.collection("episodes").whereField("ID", in: episodeIDs).order(by: "postedAt", descending: true)
        episodesRef.getDocuments { snapshot, error in
            
            if error != nil {
                print("Error fetching batch of episodes: \(error!.localizedDescription)")
                completion([])
            }
            
            if snapshot?.count == 0 {
                print("There are no episodes left to fetch")
                completion([])
            } else {
                
                guard let documents = snapshot?.documents else { return }
                
                var episodes = [Episode]()
                
                for eachDoc in documents {
                    let data = eachDoc.data()
                    episodes.append(Episode(data: data))
                }
                
                if episodes.count == documents.count {
                    completion(episodes)
                }
            }
        }
    }
    
    static func preDownloadEpisodeAudio(audioID: String) {
         DispatchQueue.global(qos: .background).async {
             let storageRef = Storage.storage().reference().child("audio/\(audioID)")
             let documentsURL = FileManager.getDocumentsDirectory()
             let audioURL = documentsURL.appendingPathComponent(audioID)
             storageRef.write(toFile: audioURL)
         }
     }
    
    static func downloadEpisodeAudio(audioID: String, completion: @escaping (URL) -> ()) {
        //        loadingCircle.isHidden = false
        //        loadingCircle.shapeLayer.strokeEnd = 0
        //        loadingCircleLarge.isHidden = false
        //        playPauseButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        //        loadingCircleLarge.shapeLayer.strokeEnd = 0
        //        playbackButton.setImage(UIImage(named: "download-arrow"), for: .normal)
        //        playPauseButton.setImage(UIImage(named: "download-arrow-large"), for: .normal)
        //        playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        DispatchQueue.global(qos: .userInitiated).async {
            let storageRef = Storage.storage().reference().child("audio/\(audioID)")
            let documentsURL = FileManager.getDocumentsDirectory()
            let audioURL = documentsURL.appendingPathComponent(audioID)
            AudioManager.loadingAudioID = audioID
            AudioManager.currentState = .loading
            
            self.downloadTask = storageRef.write(toFile: audioURL) { (url, error) in
                
                if let error = error as NSError? {
                    let code = StorageErrorCode(rawValue: error.code)
                    switch code {
                    case .cancelled:
                        break
                    default:
                        print("Error with downloadTask \(code.debugDescription)")
                    }
                } else {
                    completion(url!)
                }
            }
            self.downloadTask.observe(.progress) { snapshot in
                if snapshot.progress!.fractionCompleted == 1 {
//                    self.loadingCircle.isHidden = true
//                    self.loadingCircle.shapeLayer.strokeEnd = 0
//                    self.loadingCircleLarge.isHidden = true
//                    self.loadingCircleLarge.shapeLayer.strokeEnd = 0
                    DispatchQueue.main.async {
//                        self.playbackButton.setImage(UIImage(named: "play-episode-icon"), for: .normal)
//                        self.playPauseButton.setImage(UIImage(named: "play-audio-icon"), for: .normal)
//                        self.playbackButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
                    }
                } else {
//                    self.loadingCircle.shapeLayer.strokeEnd = CGFloat(snapshot.progress!.fractionCompleted)
//                    self.loadingCircleLarge.shapeLayer.strokeEnd = CGFloat(snapshot.progress!.fractionCompleted)
                }
            }
        }
    }
    
    
    static func cancelCurrentDownload() {
        if let task = downloadTask {
            task.cancel()
        }
    }
    
    
}
