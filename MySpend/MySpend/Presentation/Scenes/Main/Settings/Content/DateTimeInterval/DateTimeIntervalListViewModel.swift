//
//  DateTimeIntervalListViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/1/25.
//

import Foundation

class DateTimeIntervalListViewModel: BaseViewModel {
    
    @Published var DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval //TODO: hacer un Publisher para detectar el cambio automaticamente.
    
    func updateDateTimeInterval(_ dateTimeInterval: DateTimeInterval) {
        UserDefaultsManager.dateTimeInterval = dateTimeInterval
        DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval
    }
    
    func resetDateTimeInterval() {
        UserDefaultsManager.removeValue(for: .dateTimeInterval)
        DateTimeIntervalSelected = UserDefaultsManager.dateTimeInterval
    }
}
