//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected: DateTimeInterval = DateTimeInterval.userDefaultsValue //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        DateTimeInterval.userDefaultsValue = dateTimeInterval
        DateTimeIntervalSelected = DateTimeInterval.userDefaultsValue
    }
    
    func resetDateTimeInterval() {
        DateTimeInterval.removeUserDefaultsValue
        DateTimeIntervalSelected = DateTimeInterval.userDefaultsValue
    }
}
