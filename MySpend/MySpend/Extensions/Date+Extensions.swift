//
//  Date+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 29/10/24.
//

import Foundation

extension Date {
    
    public var toStringShortLocale: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
    
    /**
     This function checks if two dates fall on the same calendar day, disregarding the time.
     It compares the year, month, and day components of the current date (self) with another date passed as a parameter (toCompare).
     
     **Example:**
     ```swift
     if model.dateTransaction.isSameDate(.now) {
        // model.dateTransaction is today.
     }
     ```

     - Returns: True if both dates share the same year, month, and day; otherwise, it returns false.
     
     - Authors: Fabian JRA
     
     - Date: December 2024
     */
    public func isSameDate(_ toCompare: Date) -> Bool {
        
        let calendar = Calendar.current

        let dateComponents1 = calendar.dateComponents([.year, .month, .day], from: self)
        let dateComponents2 = calendar.dateComponents([.year, .month, .day], from: toCompare)

        return dateComponents1 == dateComponents2
    }
}
