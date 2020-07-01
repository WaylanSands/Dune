//
//  MentionTV.swift
//  Dune
//
//  Created by Waylan Sands on 17/2/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit
import Firebase

class MentionTV: UITableView {
    
    var programID: String!
    var downloadedMentions = [Mention]()
    
    func registerCustomCell() {
        self.register(ProgramCell.self, forCellReuseIdentifier: "programCell")
        self.backgroundColor = .clear
    }
    
    func resetTableView() {
        downloadedMentions = []
        self.reloadData()
    }
    
    func fetchProgramsSubscriptions() {
        
        FireStoreManager.fetchMentionsFor(programID: programID) { mentions in
            
            if mentions != nil {
                self.downloadedMentions = mentions!
                self.reloadData()
            }
        }
    }
    
}


