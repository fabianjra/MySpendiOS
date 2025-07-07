//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Combine

class TransactionViewModel: BaseViewModel {

    @Published var userName: String = "Generic user"
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    
    @Published var transactions: [TransactionModel] = []
    @Published var groupedTransactions: UtilsCurrency.groupedTransactions = []
    
    /// Llamar en `onAppear`
    func activateObservers() {
        startObservingContextChanges { [weak self] in
            self?.fetchAll()
        }
        
        fetchAll()
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        stopObservingContextChanges()
    }
    
    private func fetchAll() {
        do {
            transactions = try TransactionManager(viewContext: viewContext).fetchAll()
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
        } catch {
            Logs.CatchException(error, type: .CoreData)
        }
    }
}
