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
    
    // MARK: VIEW
    @Published var showAlertDelete = false
    @Published var showModifyTransactionModal = false

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
    
    func getHeader(by timeInterval: DateTimeInterval) -> String {
        var header = ""
        
        let formatStyle = UtilsDate.getDateFormatStyleLocale()
        let calendar = Calendar.current
        
        let isCurrentMonth = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .month)
        let isCurrentYear = calendar.isDate(selectedDate, equalTo: .now, toGranularity: .year)
        
        switch timeInterval {
            
        case .day:
            header = getFormatDay(formatStyle, isCurrentMonth: isCurrentMonth, isCurrentYear: isCurrentYear)
            
        case .week:
            header = getFormatWeekday(formatStyle, calendar: calendar, isCurrentMonth: isCurrentMonth, isCurrentYear: isCurrentYear)
            
        case .month:
            header = getFormatMonth(formatStyle, isCurrentYear: isCurrentYear)
            
        case .year:
            header = getFormatYear(formatStyle)
        }
        
        return header
    }
    
    private func getFormatDay(_ formatStyle: Date.FormatStyle, isCurrentMonth: Bool, isCurrentYear: Bool) -> String {
        var format = isCurrentMonth ? formatStyle.day().weekday(.wide) : formatStyle.day().weekday().month()
        
        if !isCurrentYear {
            format = format.year()
        }
        
        return selectedDate.formatted(format)
    }
    
    private func getFormatWeekday(_ formatStyle: Date.FormatStyle, calendar: Calendar, isCurrentMonth: Bool, isCurrentYear: Bool) -> String {
        guard let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate) else {
            // It is supposed to no get here, this is only beacasue dateInterval is optional.
            return selectedDate.formatted(.dateTime.week().locale(Locale.current))
        }
        
        let startOfWeek = weekInterval.start
        // Gets the weekOfYear minus the monday.
        let endOfWeekSunday = calendar.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
        
        let isWeekInSameMonth = calendar.isDate(startOfWeek, equalTo: endOfWeekSunday, toGranularity: .month)

        let formatStyleLeading = isWeekInSameMonth ? formatStyle.day() : formatStyle.day().month()
        
        var formatStyleTrailing = UtilsDate.getDateFormatStyleLocale().day().month()
        
        if !isCurrentYear {
            formatStyleTrailing = formatStyleTrailing.year()
        }
        
        return startOfWeek.formatted(formatStyleLeading) + " - " + endOfWeekSunday.formatted(formatStyleTrailing)
    }
    
    private func getFormatMonth(_ formatStyle: Date.FormatStyle, isCurrentYear: Bool) -> String {
        let format = isCurrentYear ? formatStyle.month(.wide) : formatStyle.month().year()
        return selectedDate.formatted(format)
    }
    
    private func getFormatYear(_ formatStyle: Date.FormatStyle) -> String {
        let format = formatStyle.year()
        return selectedDate.formatted(format)
    }
}
