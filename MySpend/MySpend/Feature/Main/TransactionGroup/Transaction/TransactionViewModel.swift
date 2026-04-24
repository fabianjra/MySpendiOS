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
    @Published var groupedTransactions: UtilsCurrency.groupedTransactions = []
    
    
    //MARK: VIEW PROPERTIES
    @Published var dateTimeInterval = UserDefaultsManager.dateTimeInterval
    @Published var selectedDate: Date = .now
    @Published var searchText: String = ""

    
    // MARK: NAMESPACES
    var transitionNewTransaction = "id-new-transaction"
    var transitionSettings = "id-settings"
    var transitionFilters = "id-filters"

    
    // MARK: FILTER
    @Published var showFilter = false
    @Published var selectedAccountsFilter = Set<AccountModel>()
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
            
            groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
            allAccounts = try await AccountManager(viewContext).fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            Logger.exception(error, type: .CoreData)
        }
    }
    
    func filterTransactions() {
        if selectedAccountsFilter.isEmpty {
            transactions = allTransactions
        } else {
            let selectedIDs = Set(selectedAccountsFilter.compactMap(\.id))
            transactions = allTransactions.filter { selectedIDs.contains($0.account.id) }
        }
        
        groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactions)
    }
}

