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
}
