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
    var episodeID: String
    var programID: String
    var primaryGenre: Categories
    var status: EpisodeStatus
    var Image: UIImage
    var programName: String
    var userHandel: String
    var episodeTitle: String
    var likeCount: Int
    var likesOverTen: Bool
    var listenCount: Int
    var commentCount: Int
    var comments: [String] // Comment IDs
    var saveCount: Int
    var shareLink: URL
    var uploadDate: Date?
    var tags: [String]
}

