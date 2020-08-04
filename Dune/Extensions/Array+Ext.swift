//
//  Array+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 24/7/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import UIKit


extension Array where Element == Episode {
    
    func sortedByLikes() -> [Episode] {
        return self.sorted(by: { $0.likeCount > $1.likeCount })
    }
    
    
}


extension Array where Element == Program {
    
    func sortedByKind() -> [Program] {
        return self.sorted(by: { $0.isPublisher != $1.isPublisher })
    }
    
    
}
