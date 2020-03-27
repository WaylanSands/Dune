//
//  AccountType.swift
//  Dune
//
//  Created by Waylan Sands on 2/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation

enum accountType: String {
    case publisher
    case listener
}

enum publisherType: String {
    case channel = "channels"
    case program = "programs"
}
