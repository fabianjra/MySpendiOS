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
    @Published var transactions: [TransactionModel] = []
    
    @Published var transactionsFiltered: [TransactionModel] = []
    @Published var groupedTransactionsIncomes: UtilsCurrency.groupedTransactions = []
    @Published var groupedTransactionsExpenses: UtilsCurrency.groupedTransactions = []
    
    
    //MARK: VIEW PROPERTIES
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    @Published var selectedDate: Date = .now
    @Published var searchText: String = ""
    
    
    // MARK: NAMESPACES
    var transitionNewTransaction = "id-new-transaction"
    var transitionSettings = "id-settings"
    var transitionFilters = "id-filters"
    
    
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
            transactions = fetched
            
            allAccounts = try await AccountManager(viewContext).fetchAll()
            
            //selectedAccountsFilter = Set(allAccounts) //TODO: Ahora se van a agregar al userDefaults al momento de agregarla manualmente desde el Account manager.
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }

    func filterTransactionsByOptions(byAccounts selectedAccountsFilter: Set<AccountModel>, showOnlyFavorites: Bool, isFilterActive: Bool) {
        
        guard isFilterActive else {
            transactions = allTransactions
            return
        }
        
        let accountIDs = Set(selectedAccountsFilter.compactMap { $0.id })
        transactions = allTransactions.filter { accountIDs.contains($0.account.id) && (showOnlyFavorites ? $0.favorite : true) }
    }
    
//    func restoreFilterSelectionByOptions() {
//        selectedAccountsFilter = Set(allAccounts)
//        showOnlyFavorites = false
//    }
    
    func filterTransactionsByDate() {
        transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                      transactions: transactions,
                                                                      for: dateTimeInterval)
        
        groupedTransactionsIncomes = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered).filter {$0.category.type == .income}.sorted(by: { $0.totalAmount > $1.totalAmount })
        groupedTransactionsExpenses = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered).filter {$0.category.type == .expense}.sorted(by: { $0.totalAmount > $1.totalAmount })
    }
    
//    func addRemoveAccountsInUserDefaults(account: AccountModel) {
//        if selectedAccountsFilter.contains(account) {
//            selectedAccountsFilter.remove(account)
//        } else {
//            selectedAccountsFilter.insert(account)
//        }
//        
//        UserDefaultsManager.selectedAccountsFilter = Set(selectedAccountsFilter)
//    }
}

