//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected: DateTimeInterval = UserDefaultsDate.dateTimeInterval //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        UserDefaultsDate.dateTimeInterval = dateTimeInterval
        DateTimeIntervalSelected = UserDefaultsDate.dateTimeInterval
    }
    
    func resetDateTimeInterval() {
        UserDefaultsDate.removeDateTimeInterval
        DateTimeIntervalSelected = UserDefaultsDate.dateTimeInterval
    }
}
