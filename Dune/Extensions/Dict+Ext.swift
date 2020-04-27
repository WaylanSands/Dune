//
//  Dict+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 26/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

extension Dictionary {
    
    static func appendToDict(lhs: inout [String: [String:String]], rhs: [String: [String:String]]) {
        for (key, value) in rhs {
            lhs[key] = value
        }
    }
    
}
