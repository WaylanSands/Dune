//
//  UIDatePicker+Ext.swift
//  Dune
//
//  Created by Waylan Sands on 5/3/20.
//  Copyright © 2020 Waylan Sands. All rights reserved.
//

import Foundation
import UIKit

extension UIDatePicker {
    
func setYearValidation() {
    let currentDate: Date = Date()
    var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC")!
    var components: DateComponents = DateComponents()
    components.calendar = calendar
    components.year = -0
    let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
    components.year = -110
    let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
    self.minimumDate = minDate
    self.maximumDate = maxDate
}
    
    
    func dateToStringMMMddYYY() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self.date)
    }
    
    
    
}

