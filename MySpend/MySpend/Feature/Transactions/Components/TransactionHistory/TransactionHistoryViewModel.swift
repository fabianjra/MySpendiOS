//
//  TransactionHistoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import Observation

@Observable
final class TransactionHistoryViewModel {
    
    var searchText = ""
    
    /*
     Caracteristicas de usar un set para la seleccion de items:
     
     Búsqueda (contains):       O(1) – tabla hash.
     Inserción / eliminación:   O(1) si el elemento existe.
     Duplicados:                Imposibles: cada elemento es único.
     Orden:                     No garantiza orden estable.
     */
    var selectedTransactions = Set<TransactionModel>()
    
    var showCreateTransaction = false
    
    var showUpdateTransaction = false
    var transactionToUpdate = TransactionModel()
    
    var showAlertDelete = false
    var transactionToDelete: TransactionModel?
    
    var showSearchView = false
    var showFilters = false

    func toggleTransactionSelection(_ transaction: TransactionModel) {
        if selectedTransactions.contains(transaction) {
            selectedTransactions.remove(transaction)
        } else {
            selectedTransactions.insert(transaction)
        }
    }
}

