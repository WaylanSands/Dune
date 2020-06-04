//
//  PlaylistVC.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class ProgramSubscriptionTV: UITableView {
    
    var downloadedPrograms = [Program]()
    var moreToLoad = true
    
    func registerCustomCell() {
        self.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
    }
    
    func resetTableView() {
        downloadedPrograms = []
        moreToLoad = true
    }
    
    func fetchProgramsSubscriptions() {

        FireStoreManager.fetchUsersSubscriptions() { snapshot in
            
            if snapshot.count != 0 {
                
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let newProgram = Program(data: data)
                    
                    if !self.downloadedPrograms.contains(where: { $0.ID  == newProgram.ID}) {
                        self.downloadedPrograms.append(newProgram)
                    }
                    
                    if counter == User.subscriptionIDs!.count - self.programsIDs().count {
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    func fetchUserSubscriptions() {

        FireStoreManager.fetchUsersSubscriptions() { snapshot in
            
            if snapshot.count != 0 {
                
                var counter = 0
                
                for eachDocument in snapshot {
                    counter += 1
                    
                    let data = eachDocument.data()
                    let newProgram = Program(data: data)
                    
                    if !self.downloadedPrograms.contains(where: { $0.ID  == newProgram.ID}) {
                        self.downloadedPrograms.append(newProgram)
                    }
                    
                    if counter == User.subscriptionIDs!.count{
                        self.reloadData()
                    }
                }
            }
        }
    }
    
    func programsIDs() -> [String] {
        if CurrentProgram.hasMultiplePrograms! {
            var ids = CurrentProgram.programIDs!
            ids.append(CurrentProgram.ID!)
            return ids
        } else {
            return [CurrentProgram.ID!]
        }
    }
    
    
}





