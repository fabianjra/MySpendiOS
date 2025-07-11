//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Combine

class TransactionViewModel: BaseViewModel {

    @Published var userName = UserDefaultsManager.userName
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    
    @Published var transactions: [TransactionModel] = []
    @Published var groupedTransactions: UtilsCurrency.groupedTransactions = []
    
    func refreshUserName() {
        userName = UserDefaultsManager.userName
    }
    
    /// Llamar en `onAppear`
    func activateObservers() {
        startObservingContextChanges { [weak self] in
            self?.fetchAll()
        }
        
        fetchAll()
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        //stopObservingContextChanges() //No permite actualizar cambios vista child (Subview)
    }
    
    private func fetchAll() {
        do {
            transactions = try TransactionManager(viewContext: viewContext).fetchAll()
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
        } catch {
            Logger.exception(error, type: .CoreData)
        }
    }
    
    deinit {
        //stopObservingContextChanges() //TODO: Debe llamarse para remover el osberver
    }
}
