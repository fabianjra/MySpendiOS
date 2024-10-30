//
//  Date+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 29/10/24.
//

import Foundation

extension Date {
    
    public func toStringShortLocale() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        
        return formatter.string(from: self)
    }
}
