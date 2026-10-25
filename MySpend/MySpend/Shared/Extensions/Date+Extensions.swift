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
    
    /**
     Returns `baseDate` keeping its Y-M-D but replacing the time with the current hour/minute/second.
     If the resulting value would roll over to the next day (e.g. current time is already past 23:59:59 of that day),
     it is clamped to 23:59:59 of `baseDate`.
     */
    public var dateWithCurrentTime: Date {
        let calendar = Calendar.current
        
        // Preserve day/month/year.
        let ymd = calendar.dateComponents([.year, .month, .day], from: self)
        
        // Use the live clock for time.
        let hms = calendar.dateComponents([.hour, .minute, .second, .nanosecond], from: .now)
        
        var comps = DateComponents()
        comps.year        = ymd.year
        comps.month       = ymd.month
        comps.day         = ymd.day
        comps.hour        = hms.hour
        comps.minute      = hms.minute
        comps.second      = hms.second
        comps.nanosecond  = hms.nanosecond
        
        // Candidate value.
        let candidate = calendar.date(from: comps) ?? self
        
        // 23 : 59 : 59 of the same day.
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? self
        
        // Si ya se pasó al siguiente dia porque es mayor a media noche, entonces devuelve los ultimos minutos y segundos del dia actual.
        return candidate > endOfDay ? endOfDay : candidate
    }
}
