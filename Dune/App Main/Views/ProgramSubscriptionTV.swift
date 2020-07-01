////
////  PlaylistVC.swift
////  Dune
////
////  Created by Waylan Sands on 17/2/20.
////  Copyright © 2020 Waylan Sands. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class ProgramSubscriptionTV: UITableView {
//    
//    var downloadedPrograms = [Program]()
//    var moreToLoad = true
//    
//    func registerCustomCell() {
//        self.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
//        self.backgroundColor = .clear
//    }
//    
//    func resetTableView() {
//        downloadedPrograms = []
//        moreToLoad = true
//    }
//    
//    func fetchProgramsSubscriptions() {
//
//        FireStoreManager.fetchUsersSubscriptions() { snapshot in
//            if !snapshot.isEmpty {
//                
//                for eachDocument in snapshot {
//                    
//                    let data = eachDocument.data()
//                    let newProgram = Program(data: data)
//                    
//                    if !self.downloadedPrograms.contains(where: { $0.ID  == newProgram.ID}) {
//                        self.downloadedPrograms.append(newProgram)
//                    }
//                }
//                 self.reloadData()
//            }
//        }
//    }
//    
//    func programsIDs() -> [String] {
//        if !CurrentProgram.programIDs!.isEmpty {
//            var ids = CurrentProgram.programIDs!
//            ids.append(CurrentProgram.ID!)
//            return ids
//        } else {
//            return [CurrentProgram.ID!]
//        }
//    }
//    
//    
//}
//
//
//
//
//
