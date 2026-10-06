//
//  TransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 1/8/23.
//

import SwiftUI

struct TransactionView: View {
    
    @StateObject private var viewModel = TransactionViewModel()
    
    // MARK: NAVIGATION
    @State private var showNewTransactionView = false
    @State private var showSettings = false
    @State private var showFilters = false
    @State private var showSearchView = false
    @State private var navigateToHistory: Bool = false
    
    @Environment(AccountManager.self) private var accountManager
    
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
                AddModifyTransactionView(selectedDate: viewModel.selectedDate)
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
    }
    
    var headerTitle: some View {
        VStack(alignment: .leading) {

            HStack {
                VStack(alignment: .leading) {
                    Text(UtilsDate.greeting)
                        .font(.footnote.weight(.light))
                        .lineLimit(ConstantViews.singleTextMaxLines)
                    
                    Text(.greet(viewModel.userName, Emojis.greeting.rawValue))
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
            
            VStack(alignment: .leading, spacing: .zero) {
                
                Text(.transactionsTotalBalance)
                    .fontWeight(.light)
                    .fontDesign(.rounded)
                
                HStack {
                    Text(viewModel.totalBalanceFormatted)
                        .font(viewModel.totalBalanceFormatted.description.filter(\.isNumber).count > 7 ? .title : .largeTitle)
                        //.monospacedDigit()
                        .lineLimit(ConstantViews.singleTextMaxLines)
                    
                    Spacer()
                    
                    NavigationLink {
                        TransactionHistoryView(transactionsLoaded: $viewModel.transactionsFiltered,
                                               dateTimeInterval: $viewModel.dateTimeInterval,
                                               selectedDate: $viewModel.selectedDate)
                    } label: {
                        HStack {
                            Text(.transactionButtonDetails)
                                .fontDesign(.rounded)
                            
                            Image.chevronRight
                        }
                        .foregroundColor(Color.textPrimaryForeground)
                        .padding(.horizontal)
                        .padding(.vertical, ConstantViews.bigSpacing)
                        .glassEffect(.regular.interactive())
                    }
                }
            }
        }
    }
    
    var bodyContent: some View {
        VStack {
            
            DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                      selectedDate: $viewModel.selectedDate,
                                      isEditing: .constant(false)){}
            
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
                    .textStyle(size: .medium, truncateMode: .tail)
            }
            
            if viewModel.transactionsFiltered.isEmpty && !accountManager.isFilterActive {
                TransactionsEmptyView()
                
            } else {
                ScrollView(showsIndicators: false) {
                    
                    if !viewModel.groupedTransactionsIncomes.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.transactionTypeIncomes)
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
                                    
                                    Text(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
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
                            
                            Text(.transactionTypeExpenses)
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
                                    
                                    Text(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                        .lineLimit(ConstantViews.singleTextMaxLines)
                                        .monospacedDigit()
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                    }
                }
                .animation(.default, value: viewModel.transactionsFiltered.count)
                
            }
            
            Text(viewModel.errorMessage)
            
            TotalBalanceView(transactions: viewModel.transactionsFiltered,
                             showTotalBalance: false)
                .padding(.bottom)
            
            //Tiene un efecto no deseado al transicionar entre tab y tab.
            //TODO: Revisar si con listener se comporta diferente.
            //.redacted(reason: viewModel.isLoading ? .placeholder : [])
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
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        UserDefaultsManager.userName = "Previews"
        AccountManager.shared.isFilterActive = isFilterActive
    }
    
    @State var router = Router.shared
    @State var themeManager = ThemeManager.shared
    @State var previewAccountManager = AccountManager.shared
    
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
        .environment(previewAccountManager)
        .environment(themeManager)
        .preferredColorScheme(themeManager.theme.colorScheme)
    }
}

#Preview("Normal \(Previews.localeES_CR)") {
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
