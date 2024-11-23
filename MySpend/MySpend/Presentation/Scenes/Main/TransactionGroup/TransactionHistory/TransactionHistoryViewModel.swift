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
        var header = ""
        
        let calendar = Calendar.current
        let formatStyle = UtilsDate.getDateFormatStyleLocale()
        
        switch timeInterval {
            
        case .day:
            
            let isCurrentMonth = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .month)
            let isCurrentYear = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .year)
                
            var format = formatStyle.day().weekday()
            
            // Agrega el mes si no está en el mes actual
            if !isCurrentMonth {
                format = format.month()
            }
            
            // Agrega el año si no está en el año actual
            if !isCurrentYear {
                format = format.year()
            }
            
            header = selectedDate.formatted(format)
            
        case .week:
            
            guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
                // It is supposed to no get here, this is only beacasue dateInterval is optional.
                return selectedDate.formatted(.dateTime.week().locale(Locale.current))
            }
            
            let startOfWeek = weekInterval.start
            // Gets the weekOfYear minus the monday.
            let endOfWeekSunday = Calendar.current.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
            
            let isWeekInSameMonth = Calendar.current.isDate(startOfWeek, equalTo: endOfWeekSunday, toGranularity: .month)

            // Valida que el dia en el que comienza la semana esté dentro del mismo mes cuando termina, sino, indica el mes al dia
            // que comienza. Sino, se mostrarian fechas en meses diferentes sin indicarlo.
            let headerLeadingFormat = isWeekInSameMonth ?
            Date.FormatStyle.dateTime.day().locale(Locale.current) :
            Date.FormatStyle.dateTime.day().month().locale(Locale.current)
            
            let headerTrailingFormat = Date.FormatStyle.dateTime.day().month().locale(Locale.current)
            
            header = startOfWeek.formatted(headerLeadingFormat) + " - " + endOfWeekSunday.formatted(headerTrailingFormat)
            
        case .month:
            var format = formatStyle.month().year()
            header = selectedDate.formatted(format)
            
        case .year:
            var format = formatStyle.year()
            header = selectedDate.formatted(format)
        }
        
        return header
    }
}
