//
//  DateTimeIntervalManager.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/11/26.
//

import SwiftUI

@Observable
final class DateTimeIntervalManager {
    static let shared = DateTimeIntervalManager()
    
    var defaultInterval: DateTimeInterval = UserDefaultsManager.dateTimeInterval {
        didSet {
            UserDefaultsManager.dateTimeInterval = self.defaultInterval
        }
    }
    
    private init() {}
}
