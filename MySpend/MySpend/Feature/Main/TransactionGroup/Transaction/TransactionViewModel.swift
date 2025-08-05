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
    @Published var showAccountFilter: Bool = false
    
    /**
     Call this function in `onFirstAppear`.
     Shoud be called once when open application because this view will be active all alonge the app life.
     
     Dont call stopObservingChanges becaise this viewModel will be alive all alonge the app, listening for changes and show them in this home view.
     */
    func activateObservers() async {
        startObserveViewContextChanges { [weak self] in
            await self?.fetchAll()
        }
        
        startObserveUserDefaultsChanges { [weak self] in
            self?.dateTimeInterval = UserDefaultsManager.dateTimeInterval
            self?.userName = UserDefaultsManager.userName
        }
        
        await fetchAll()
    }
    
    private func fetchAll() async {
        do {
            transactions = try await TransactionManager(viewContext).fetchAll()
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
            
            try await fetchAccountCount()
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }
    
    private func fetchAccountCount() async throws {
        let count = try await AccountManager(viewContext).fetchAllCount()
        isMutipleAccounts = count > 1 ? true : false
    }
}
