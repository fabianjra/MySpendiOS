//
//  DateInterval.swift
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
}
