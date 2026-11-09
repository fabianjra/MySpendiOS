//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TransactionView: View {
    
    @Environment(TransactionManager.self) private var manager
    @Environment(AccountManager.self) private var accountManager
    
    @State private var viewModel = TransactionViewModel()
    
    private var filteredTransactions: [TransactionModel] {
        manager.filteredAndSortedTransactions(by: viewModel.dateTimeInterval,
                                              selectedDate: viewModel.selectedDate,
                                              accountIDs: accountManager.selectedAccountsToFilterByID)
    }
    
    private var totalBalance: Decimal {
        filteredTransactions.calculateTotals().balance
    }
    
    var body: some View {
        VStack {
            if viewModel.showSearchView {
                List {
                    //TODO: MOCK
                    ForEach(0...10, id: \.self) { item in
                        Text(verbatim: "\(item)")
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                
            } else {
                Group {
                    headerTitle
                    
                    transactionsList
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(.titleHomeView)
        .toolbar(.hidden, for: .navigationBar)
        
        .toolbar {
            toolbarContent
        }
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $viewModel.showCreateTransaction) {
            NavigationStack {
                CreateTransactionView(selectedDate: viewModel.selectedDate)
            }
        }
        .sheet(isPresented: $viewModel.showFilters) {
            NavigationStack {
                FilterTransactionsView()
            }
        }
        
        .searchable(text: $viewModel.searchText, isPresented: $viewModel.showSearchView)
        .searchToolbarBehavior(.minimize)
        
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(Color.backgroundGradient)
    }
    
    var headerTitle: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(UtilsDate.greeting)
                        .font(.footnote.weight(.light))
                        .lineLimit(1)
                    
                    Text(.greet(viewModel.userName, "👋"))
                        .font(.title2.bold())
                        .fontDesign(.rounded)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Button {
                    Router.shared.navigate(to: .settings)
                } label: {
                    Image.settingsFill
                        .font(.title2)
                }
                .buttonStyle(.glass)
            }
            .padding(.bottom)
            
            
            
            NavigationLink {
                TransactionHistoryView(dateTimeInterval: $viewModel.dateTimeInterval,
                                       selectedDate: $viewModel.selectedDate)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(.transactionsTotalBalance)
                            .fontWeight(.light)
                            .fontDesign(.rounded)
                        
                        let balanceFormatted = totalBalance.amountToString.addCurrencySymbol
                        
                        Text(balanceFormatted)
                            .font(balanceFormatted.filter(\.isNumber).count > 7 ? .title : .largeTitle)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    //Text(.transactionButtonDetails)
                    
                    Image.chevronRight
                        .font(.title)
                    
                }
                .foregroundColor(Color.primary)
            }
            .padding(.trailing)
            //.glassEffect(.regular.interactive())
        }
    }
    
    var transactionsList: some View {
        
        // Se utiliza una variable para guardar filteredTransactions porque cada llamado de filteredTransactions dentro del body, recorre nuevamente esa lista.
        let transactions = filteredTransactions
        let groupedTransactions = UtilsTransactions.groupTransactionsByType(transactions)
        
        let filteredAccountsDescription = UtilsTransactions.filteredAccountsDescription(accounts: accountManager.sortedAccounts,
                                                                                        selectedAccountsToFilter: accountManager.selectedAccountsToFilterByID,
                                                                                        isFilterActive: manager.isFilterActive)
        return VStack {
            DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                      selectedDate: $viewModel.selectedDate)
            
            if let text = filteredAccountsDescription {
                Text(text)
                    .font(.caption)
                    .lineLimit(2)
            }
            
            ScrollView(showsIndicators: false) {
                
                if transactions.isEmpty  {
                    Text(.transactionsEmpty)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                } else {
                    
                    if !groupedTransactions.incomes.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.categoryTypeIncomes)
                                .foregroundStyle(Color.accentColor)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(groupedTransactions.incomes, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .fontDesign(.rounded)
                                        .lineLimit(1)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.amountToString.addCurrencySymbol)
                                        .lineLimit(1)
                                        .monospacedDigit()
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    if !groupedTransactions.expenses.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.categoryTypeExpenses)
                                .foregroundStyle(.alert)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(groupedTransactions.expenses, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .fontDesign(.rounded)
                                        .lineLimit(1)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.amountToString.addCurrencySymbol)
                                        .lineLimit(1)
                                        .monospacedDigit()
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                    }
                    
                }
            }
            .animation(.default, value: transactions)
            
            TotalBalanceView(transactions: transactions)
                .padding(.bottom)
        }
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        
        FilterTransactionsToolbarBottom(showFilters: $viewModel.showFilters)
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        
        //ToolbarSpacer(.fixed, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem, role: .confirm) {
                viewModel.showCreateTransaction = true
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        _manager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _categoryManager = State(initialValue: CategoryManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        
        manager.isFilterActive = isFilterActive
        UserDefaultsManager.userName = "Previews"
    }
    
    @State var themeManager = ThemeManager.shared
    @State var router = Router.shared
    
    
    @State var manager: TransactionManager
    @State var categoryManager: CategoryManager
    @State var accountManager: AccountManager
    
    var body: some View {
        NavigationStack(path: $router.path) {
            TransactionView()
                .navigationDestination(for: Router.Destination.self) { destination in
                    switch destination {
                    case .settings:
                        SettingsView()
                        
                    default:
                        EmptyView()
                    }
                }
        }
        .environment(themeManager)
        .preferredColorScheme(themeManager.theme.colorScheme)
        
        .environment(manager)
        .environment(categoryManager)
        .environment(accountManager)
    }
}

#Preview(Previews.localeES_CR) {
    previewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Normal filtered \(Previews.localeEN)") {
    previewWrapper(isFilterActive: true)
        .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Saturated \(Previews.localeEN_US)") {
    previewWrapper(.saturated)
        .environment(\.locale, .init(identifier: Previews.localeEN_US))
}

#Preview("Empty \(Previews.localeES_ES)") {
    previewWrapper(.empty)
        .environment(\.locale, .init(identifier: Previews.localeES_ES))
}
