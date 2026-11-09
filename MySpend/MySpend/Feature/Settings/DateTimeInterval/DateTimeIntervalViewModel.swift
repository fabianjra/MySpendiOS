//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Observation

@Observable
final class DateTimeIntervalViewModel {
    
    var selectedDateInterval = UserDefaultsManager.dateTimeInterval {
        didSet {
            UserDefaultsManager.dateTimeInterval = self.selectedDateInterval
        }
    }
    
    func resetDateTimeInterval() {
        UserDefaultsManager.removeValue(for: .dateTimeInterval)
        selectedDateInterval = UserDefaultsManager.dateTimeInterval
    }
}
