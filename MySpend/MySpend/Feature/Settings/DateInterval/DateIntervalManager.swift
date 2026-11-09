//
//  DateIntervalManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/26.
//

import SwiftUI

@Observable
final class DateIntervalManager {
    static let shared = DateIntervalManager()
    
    var interval: DateInterval = UserDefaultsManager.dateInterval {
        didSet {
            UserDefaultsManager.dateInterval = interval
        }
    }
    
    private init() {}
    
    func resetDateInterval() {
        UserDefaultsManager.removeValue(for: .dateInterval)
        interval = UserDefaultsManager.dateInterval
    }
}
