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
    
    @Published var isMutipleAccounts: Bool = false
    
    func refreshUserName() {
        userName = UserDefaultsManager.userName
    }
    
    /// Llamar en `onAppear`
    func activateObservers() {
        startObserveViewContextChanges { [weak self] in
            self?.fetchAll()
        }
        
        fetchAll()
    }
    
    private func fetchAccountCount() throws {
        let count = try AccountManager(viewContext: viewContext).fetchAllCount()
        
        if count > 1 {
            isMutipleAccounts = true
        }
    }
    
    /// Llamar en `onDisappear`
    func deactivateObservers() {
        //stopObservingContextChanges() //No permite actualizar cambios vista child (Subview)
    }
    
    private func fetchAll() {
        do {
            transactions = try TransactionManager(viewContext: viewContext).fetchAll()
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
            
            try fetchAccountCount()
        } catch {
            Logger.exception(error, type: .CoreData)
            errorMessage = error.localizedDescription
        }
    }
    
    deinit {
        //stopObservingContextChanges() //TODO: Debe llamarse para remover el osberver
    }
}
