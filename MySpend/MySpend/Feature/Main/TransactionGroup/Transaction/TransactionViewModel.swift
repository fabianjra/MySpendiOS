//
//  TransactionViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 8/8/24.
//

import Foundation

class TransactionViewModel: BaseViewModel {
    
    @Published var userName = UserDefaultsManager.userName
    
    private var allTransactions: [TransactionModel] = []
    @Published var transactionsFiltered: [TransactionModel] = []
    
    @Published var groupedTransactionsIncomes: UtilsCurrency.groupedTransactions = []
    @Published var groupedTransactionsExpenses: UtilsCurrency.groupedTransactions = []
    
    
    //MARK: VIEW PROPERTIES
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    @Published var selectedDate: Date = .now
    //@Published var searchText: String = ""
    
    // MARK: FILTER
    @Published var allAccounts: [AccountModel] = []
    
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
            //self?.dateTimeInterval = UserDefaultsManager.dateTimeInterval //TODO: Pasar al view para actualizar el segment en caso de que cambie desde el UserDefaults de settings. Ahorita solamente carga el segment al inicio.
            self?.userName = UserDefaultsManager.userName
        }
        
        await fetchAll()
    }
    
    private func fetchAll() async {
        do {
            let fetched = try await TransactionManager(viewContext).fetchAll()
            allTransactions = fetched
            transactionsFiltered = fetched
            
            allAccounts = try await AccountManager(viewContext).fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func filterTransactions(byAccounts selectedAccountsFilter: Set<AccountModel>, showOnlyFavorites: Bool, isFilterActive: Bool) {
        
        if isFilterActive {
            let accountIDs = Set(selectedAccountsFilter.compactMap { $0.id })
            transactionsFiltered = allTransactions.filter { accountIDs.contains($0.account.id) && (showOnlyFavorites ? $0.favorite : true) }
            
        } else {
            transactionsFiltered = allTransactions
        }
        
        transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                      transactions: transactionsFiltered,
                                                                      for: dateTimeInterval)
        
        groupedTransactionsIncomes = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered).filter {$0.category.type == .income}.sorted(by: { $0.totalAmount > $1.totalAmount })
        groupedTransactionsExpenses = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered).filter {$0.category.type == .expense}.sorted(by: { $0.totalAmount > $1.totalAmount })
    }
}

