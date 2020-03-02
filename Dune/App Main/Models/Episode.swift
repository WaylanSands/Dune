//
//  PlayBarTrack.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

struct Episode {
    var episodeNumber: Int
    var smallProgramImage: UIImage
    var programName: String
    var accountHandel: String
    var episodeTitle: String
    var likes: Int
    var likesOverTen: Bool
    var listens: Int
    var commentCount: Int
    var saveCount: Int
    var shareLink: String
    var uploadDate: Date?
    
    init(program: Program, episodeNumber: Int) {
    self.episodeNumber = episodeNumber
    self.smallProgramImage = program.image!
    self.programName = program.name
    self.accountHandel = program.handel
    self.episodeTitle = program.episodes![episodeNumber].episodeTitle
    self.likes = program.episodes![episodeNumber].likes
    self.likesOverTen = program.episodes![episodeNumber].likesOverTen
    self.listens = program.episodes![episodeNumber].listens
    self.commentCount = program.episodes![episodeNumber].commentCount
    self.saveCount = program.episodes![episodeNumber].saveCount
    self.shareLink = program.episodes![episodeNumber].shareLink
    }
    
    func checkLikeCount() -> Bool {
        if likes >= 10 {
            return true
        } else {
            return false
        }
    }
    
}

