//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected: DateTimeInterval = UserDefaultsKey.dateTimeInterval.getValue() //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        UserDefaultsKey.dateTimeInterval.setValue(dateTimeInterval)
        DateTimeIntervalSelected = UserDefaultsKey.dateTimeInterval.getValue()
    }
    
    func resetDateTimeInterval() {
        UserDefaultsKey.dateTimeInterval.removeValue()
        DateTimeIntervalSelected = UserDefaultsKey.dateTimeInterval.getValue()
    }
}
