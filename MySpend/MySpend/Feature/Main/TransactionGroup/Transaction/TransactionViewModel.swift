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
    
    /**
     Call this function in `onFirstAppear`.
     Shoud be called once when open application because this view will be active all alonge the app life.
     
     Dont call stopObservingChanges becaise this viewModel will be alive all alonge the app, listening for changes and show them in this home view.
     */
    func activateObservers() {
        startObserveViewContextChanges { [weak self] in
            self?.fetchAll()
        }
        
        startObserveUserDefaultsChanges { [weak self] in
            self?.dateTimeInterval = UserDefaultsManager.dateTimeInterval
            self?.userName = UserDefaultsManager.userName
        }
        
        fetchAll()
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
    
    private func fetchAccountCount() throws {
        let count = try AccountManager(viewContext: viewContext).fetchAllCount()
        isMutipleAccounts = count > 1 ? true : false
    }
}
