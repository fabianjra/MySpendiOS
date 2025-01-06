//
//  DateTimeInterval.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

enum DateTimeInterval: String, CaseIterable, Identifiable {
    public var id: Self { self }
    
    case day = "Daily"
    case week = "Weekly"
    case month = "Monthly"
    case year = "Yearly"
    
    var componentType: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        }
    }
}
