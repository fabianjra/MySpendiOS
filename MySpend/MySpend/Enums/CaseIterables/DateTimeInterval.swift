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
    
    var today: String {
        switch self {
        case .day: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
}
