//
//  Date+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 22/4/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation


extension Date {
    
    static func currentDateAsTimeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%2i:%02i", minutes, seconds)
    }
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            return "\(secondsAgo)s"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)m"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour)h"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)d"
        }
        
        return "\(secondsAgo / week)w"
    }
    
    static func formattedToString(style: DateFormatter.Style) -> String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = style
        formatter.dateStyle = style
        return formatter.string(from: currentDateTime)

    }
    
}
