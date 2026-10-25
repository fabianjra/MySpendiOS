//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Observation

@Observable
final class DateTimeIntervalViewModel {
    
    var DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval {
        didSet {
            UserDefaultsManager.dateTimeInterval = self.DateTimeIntervalSelected
        }
    }
    
    func resetDateTimeInterval() {
        UserDefaultsManager.removeValue(for: .dateTimeInterval)
        DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval
    }
}
