//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    // MARK: DATE
    @Published var dateTimeIntertal: DateTimeInterval = .month
    @Published var selectedDate: Date = Date()
    let dateFormatter = DateFormatter()
    
    // MARK: VIEW
    @Published var showAlertDelete = false
    @Published var showModifyTransactionModal = false

    override init() {
        super.init()
        dateFormatter.locale = Locale()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    /// Filtra las transacciones por intervalos de tiempo seleccionados y las ordena en forma descendente en base a la fecha de la transaccion
    func filteredTransactions(_ transactions: [TransactionModel], for interval: DateTimeInterval) -> [TransactionModel] {
        let calendar = Calendar.current
        let sortedTransactions = transactions.sorted(by: { $0.dateTransaction > $1.dateTransaction })
        
        switch interval {
            
        case .day:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, inSameDayAs: selectedDate)
            }
            
        case .week:
            if let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) {
                let endOfSunday = calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
                
                return sortedTransactions.filter {
                    $0.dateTransaction >= weekInterval.start && $0.dateTransaction <= endOfSunday
                }
            }
            return []
            
        case .month:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, equalTo: selectedDate, toGranularity: .month)
            }
            
        case .year:
            return sortedTransactions.filter {
                calendar.isDate($0.dateTransaction, equalTo: selectedDate, toGranularity: .year)
            }
        }
    }
    
    func deleteTransaction(_ model: TransactionModel) async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .transactions)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}

/// Navigation between DateTime intervals
extension TransactionHistoryViewModel {
    
    /// Permite manipular el valor de la fecha seleccionada para navegar segun el intervalo seleccionado.
    func navigateDateTime(to timeNavigate: TimeNavigate) {
        
        if timeNavigate == .today {
            selectedDate = .now
        } else {
            navigateToDateByInterval(dateTimeIntertal, to: timeNavigate)
        }
    }
    
    private func navigateToDateByInterval(_ dateTimeInterval: DateTimeInterval, to timeNavigate: TimeNavigate) {
        
        let timeToMove = timeNavigate == .next ? 1 : timeNavigate == .previous ? -1 : .zero
        
        if let newDate = Calendar.current.date(byAdding: dateTimeInterval.componentType, value: timeToMove, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    /// Validation to show correct header based of DateTimeInterval
    func getHeader(by timeInterval: DateTimeInterval) -> String {
        let currentLocale = Locale.current
        
        var header = ""
        
        switch timeInterval {
            
        case .day:
            header = selectedDate.formatted(.dateTime.day().weekday().locale(currentLocale))
            
        case .week:
            
            guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
                // It is supposed to no get here, this is only beacasue dateInterval is optional.
                return selectedDate.formatted(.dateTime.week().locale(currentLocale))
            }
            
            let startOfWeek = weekInterval.start
            let endOfWeekSunday = Calendar.current.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end // Gets the weekOfYear minus the monday.
            
            let isWeekInSameMonth = Calendar.current.isDate(startOfWeek, equalTo: endOfWeekSunday, toGranularity: .month)
            
            header = startOfWeek.formatted(isWeekInSameMonth ? .dateTime.day().locale(currentLocale) : .dateTime.day().month().locale(currentLocale)) + " - " + endOfWeekSunday.formatted(.dateTime.day().month().locale(currentLocale))
            
        case .month:
            header = selectedDate.formatted(.dateTime.month().year().locale(currentLocale))
            
        case .year:
            header = selectedDate.formatted(.dateTime.year().locale(currentLocale))
        }
        
        return header
    }
}
