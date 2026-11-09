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
    
    var defaultInterval: DateInterval = UserDefaultsManager.dateInterval {
        didSet {
            UserDefaultsManager.dateInterval = self.defaultInterval
        }
    }
    
    private init() {}
}
