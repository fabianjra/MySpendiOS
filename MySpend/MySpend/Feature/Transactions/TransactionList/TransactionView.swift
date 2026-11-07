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
    
    @StateObject private var viewModel = TransactionViewModel()
    @State private var toastResponse: ToastResponse?

    
    
    
    
    
    
    
    
    // MARK: NAVIGATION
    @State private var showNewTransactionView = false
    @State private var showSettings = false
    @State private var showFilters = false
    @State private var showSearchView = false
    @State private var navigateToHistory: Bool = false
    
    
    
    var body: some View {
        VStack {
            if showSearchView {
                List {
                    //TODO: MOCK
                    ForEach(0...10, id: \.self) { item in
                        Text("\(item)")
                    }
                }
                .scrollDismissesKeyboard(.immediately)
                
            } else {
                headerTitle
                
                bodyContent
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundGradient)
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $showNewTransactionView) {
            NavigationStack {
                CreateTransactionView(selectedDate: viewModel.selectedDate)
            }
        }
        .sheet(isPresented: $showFilters) {
            NavigationStack {
                FilterTransactionsView()
            }
        }
        
        .navigationTitle(.titleHomeView)
        .searchable(text: $viewModel.searchText, isPresented: $showSearchView)
        .searchToolbarBehavior(.minimize)
        .toolbar {
            toolbarContent
        }
        .toolbar(.hidden, for: .navigationBar)
        
        
        // MARK: ON APPEAR / DISSAPEAR
        
        .onFirstAppear {
            Task {
                await viewModel.activateObservers()
            }
        }
        
        // MARK: LOAD FILTER BY OPTIONS
        .onChange(of: viewModel.transactionsFiltered) {
            viewModel.filterTransactions(accountManager: accountManager)
        }
        .onChange(of: accountManager.selectedAccountsToFilterByID) {
            viewModel.filterTransactions(accountManager: accountManager)
        }
        .onChange(of: [accountManager.isFilterActive, accountManager.showOnlyFavorites]) {
            viewModel.filterTransactions(accountManager: accountManager)
        }
        
        // MARK: FILTER TRANSACTIONS BY DATE
        .onChange(of: viewModel.selectedDate) {
            viewModel.filterTransactions(accountManager: accountManager)
        }
        .onChange(of: viewModel.dateTimeInterval) {
            viewModel.filterTransactions(accountManager: accountManager)
        }
        
        .toast($toastResponse)
    }
    
    var headerTitle: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(UtilsDate.greeting)
                        .font(.footnote.weight(.light))
                        .lineLimit(ConstantViews.singleTextMaxLines)
                    
                    Text(.greet(viewModel.userName, "👋"))
                        .font(.title2.bold())
                        .fontDesign(.rounded)
                        .lineLimit(ConstantViews.singleTextMaxLines)
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
                TransactionHistoryView(transactionsLoaded: $viewModel.transactionsFiltered,
                                       dateTimeInterval: $viewModel.dateTimeInterval,
                                       selectedDate: $viewModel.selectedDate)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(.transactionsTotalBalance)
                            .fontWeight(.light)
                            .fontDesign(.rounded)
                        
                        Text(viewModel.totalBalanceFormatted)
                            .font(viewModel.totalBalanceFormatted.description.filter(\.isNumber).count > 7 ? .title : .largeTitle)
                            .lineLimit(ConstantViews.singleTextMaxLines)
                    }
                    
                    Spacer()
                    
//                    Text(.transactionButtonDetails)
//                        .fontDesign(.rounded)
                    
                    Image.chevronRight
                        .font(.title)
                    
                }
                .foregroundColor(Color.primary)
            }
//            .navigationLinkIndicatorVisibility(.visible)
            .padding(.trailing)
            //.glassEffect(.regular.interactive())
        }
    }
    
    var bodyContent: some View {
        VStack {
            
            DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                      selectedDate: $viewModel.selectedDate)
            
            if accountManager.sortedAccounts.count > 1 {
                
                /// ¿Filtro activo?
                ///     ↓
                /// ¿Ninguna cuenta? → "None"
                ///     ↓
                /// ¿Todas? → "All"
                ///     ↓
                /// Entonces → nombres de las seleccionadas
                let text: LocalizedStringResource = {
                    guard accountManager.isFilterActive else {
                        return ""
                    }
                    
                    let selectedAccounts = accountManager.selectedAccountsToFilterByID
                    
                    if selectedAccounts.isEmpty {
                        return .filterAccountNoneTitle
                    }
                    
                    if selectedAccounts.count == accountManager.sortedAccounts.count {
                        return .filterAccountAll
                    }
                    
                    let accountNames = accountManager.sortedAccounts
                        .filter { selectedAccounts.contains($0.id) }
                        .map(\.name)
                        .joined(separator: ", ")
                    
                    return LocalizedStringResource(stringLiteral: accountNames)
                }()
                
                Text(text)
                    .font(.callout)
                    .lineLimit(2)
            }
            
            if viewModel.transactionsFiltered.isEmpty && !accountManager.isFilterActive {
                TransactionsEmptyView()
                
            } else {
                ScrollView(showsIndicators: false) {
                    
                    if !viewModel.groupedTransactionsIncomes.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.categoryTypeIncomes)
                                .foregroundStyle(Color.accentColor)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(viewModel.groupedTransactionsIncomes, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .fontDesign(.rounded)
                                        .lineLimit(ConstantViews.singleTextMaxLines)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.amountToString.addCurrencySymbol)
                                        .lineLimit(ConstantViews.singleTextMaxLines)
                                        .monospacedDigit()
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    if !viewModel.groupedTransactionsExpenses.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.categoryTypeExpenses)
                                .foregroundStyle(.alert)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(viewModel.groupedTransactionsExpenses, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .fontDesign(.rounded)
                                        .lineLimit(ConstantViews.singleTextMaxLines)
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.amountToString.addCurrencySymbol)
                                        .lineLimit(ConstantViews.singleTextMaxLines)
                                        .monospacedDigit()
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                    }
                }
                .animation(.default, value: viewModel.transactionsFiltered)
                
            }
            
            Text(viewModel.errorMessage)
            
            TotalBalanceView(transactions: viewModel.transactionsFiltered)
                .padding(.bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        
        FilterTransactionsToolbarBottom(showFilters: $showFilters)
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        
        //ToolbarSpacer(.fixed, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem, role: .confirm) {
                showNewTransactionView = true
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        _manager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        _accountManager.wrappedValue.isFilterActive = isFilterActive
        
        UserDefaultsManager.userName = "Previews"
    }
    
    @State var themeManager = ThemeManager.shared
    @State var router = Router.shared
    
    @State var manager: TransactionManager
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
