//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    // MARK: DATE
    @Published var dateTimeInvertal: DateTimeInterval = .month
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
    
    /**
     Permite manipular la fecha segun el intervalo seleccionado
     */
    func adjustselectDate(by component: Calendar.Component, value: Int) {
        if let newDate = Calendar.current.date(byAdding: component, value: value, to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    /**
     Filtra las transacciones por intervalos de tiempo seleccionados
     */
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
