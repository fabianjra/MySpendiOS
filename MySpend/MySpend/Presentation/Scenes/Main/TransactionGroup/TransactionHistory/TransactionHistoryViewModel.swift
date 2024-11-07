//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var dateTimeInvertal: DateTimeInterval = .month
    @Published var selectedMonth: Int = .zero // Indice de 0 a 11, siendo enero = 0
    @Published var selectedYear: Int


    let dateFormatter = DateFormatter()
    var monthSymbols: [String] = []
    
    @Published var showAlertDelete = false
    @Published var showModifyTransactionModal = false

    override init() {
        monthSymbols = dateFormatter.monthSymbols // ["January", "February", ..., "December"]
        selectedMonth = Calendar.current.component(.month, from: Date()) - 1
        
        selectedYear = Calendar.current.component(.year, from: Date())
    }
    
    func filteredTransactions(_ transactions: [TransactionModel]) -> [TransactionModel] {
        
        let sortedTransactions = transactions.sorted(by: { $0.dateTransaction > $1.dateTransaction })
        
        if dateTimeInvertal == .day {
            //TODO: Filtrar por dia seleccionado. Se debe crear el array de dias en base al mes seleccionado.
            
        } else if dateTimeInvertal == .month {
            return sortedTransactions.filter {
                Calendar.current.component(.month, from: $0.dateTransaction) == selectedMonth + 1
            }
            
        } else if dateTimeInvertal == .year {
            return sortedTransactions.filter {
                Calendar.current.component(.year, from: $0.dateTransaction) == selectedYear
            }
        }
        
        return sortedTransactions
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
