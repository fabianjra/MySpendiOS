//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected: DateTimeInterval = UserDefaultsManager.dateTimeInterval.getValue() //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        UserDefaultsManager.dateTimeInterval.setValue(dateTimeInterval)
        DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval.getValue()
    }
    
    func resetDateTimeInterval() {
        UserDefaultsManager.dateTimeInterval.removeValue
        DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval.getValue()
    }
}
