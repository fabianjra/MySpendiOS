//
//  DateTimeInterval.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation
import SwiftUICore

/**
 Allows user to select a Date Time interval to show transactions.
 
 - String: The picker segmented needs to show the value description.
 - CaseIterable: The picker segmented needs to iterate each item.
 - Identifiable: To asign and ID to every item when iterate.
 - Codable: To Set and Get valures in UserDefaults.
 */
enum DateTimeInterval: String, CaseIterable, Identifiable, Codable {
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
    
    var localized: String {
        String(localized: String.LocalizationValue(rawValue), table: Tables.main)
    }
}
