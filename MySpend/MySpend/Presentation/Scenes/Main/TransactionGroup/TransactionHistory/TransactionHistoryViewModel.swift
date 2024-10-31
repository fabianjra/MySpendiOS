//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Foundation

class TransactionHistoryViewModel: BaseViewModel {
    
    @Published var transactionToModify = TransactionModel()
    
    @Published var dateTimeInvertal: DateTimeInterval = .month
    @Published var selectedMonth: Int = .zero // Indice de 0 a 11, siendo enero = 0

    let dateFormatter = DateFormatter()
    var monthSymbols: [String] = []
    
    @Published var showAlertDelete = false
    @Published var showModifyTransactionModal = false

    override init() {
        monthSymbols = dateFormatter.monthSymbols // ["January", "February", ..., "December"]
        selectedMonth = Calendar.current.component(.month, from: Date()) - 1
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
