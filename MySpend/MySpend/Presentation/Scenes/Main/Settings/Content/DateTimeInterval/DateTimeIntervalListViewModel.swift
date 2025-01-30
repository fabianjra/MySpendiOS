//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected = UserDefaultsValue.dateTimeInterval //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        UserDefaultsValue.dateTimeInterval = dateTimeInterval
        DateTimeIntervalSelected = UserDefaultsValue.dateTimeInterval
    }
    
    func resetDateTimeInterval() {
        UserDefaultsValue.removeDateTimeInterval
        DateTimeIntervalSelected = UserDefaultsValue.dateTimeInterval
    }
}
