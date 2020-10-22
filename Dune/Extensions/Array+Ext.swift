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
    
    func sortedByLocation() -> [Program] {
        let locale = Locale.current
        let sortedBySubs = self.sorted(by: { $0.subscriberCount > $1.subscriberCount })
        var locationSort = [Program]()
        
        if let usersRegionCode = locale.regionCode {
            for each in sortedBySubs {
                if each.locationType != .global {
                    if each.regionCode == usersRegionCode {
                        locationSort.append(each)
                    }
                }
            }
        }
        
        for each in sortedBySubs {
            if !locationSort.contains(each) {
                locationSort.append(each)
            }
        }

        return locationSort
    }

}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
