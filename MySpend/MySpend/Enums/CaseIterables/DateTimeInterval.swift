//
//  DateTimeInterval.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

/**
 Allows user to select a Date Time interval to show transactions.
 
 - String: The picker segmented needs to show the value description.
 - CaseIterable: The picker segmented needs to iterate each item.
 - Identifiable: To asign and ID to every item when iterate.
 - Codable: To Set and Get valures in UserDefaults.
 */
enum DateTimeInterval: String, CaseIterable, Identifiable, Codable, LocalizableProtocol {
    public var id: Self { self }
    
    case day
    case week
    case month
    case year
    
    var componentType: Calendar.Component {
        switch self {
        case .day: return .day
        case .week: return .weekOfYear
        case .month: return .month
        case .year: return .year
        }
    }
    
    var table: String { LocalizableTable.enums }
}
