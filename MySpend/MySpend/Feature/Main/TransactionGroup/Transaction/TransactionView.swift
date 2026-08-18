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
    @State private var showFiltersView = false
    @State private var showSearchView = false
    @State private var navigateToHistory: Bool = false
    
    private let filters = FilterCenter.shared
    
    var body: some View {
        VStack {
            if showSearchView {
                Color.red //TODO: Agregar vista de busqueda
                
            } else {
                headerTitle

                headerActions
                
                bodyContent
            }
        }
        .padding(.horizontal)
        .background(Color.backgroundContentGradient)
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingsView()
            }
        }
        .sheet(isPresented: $showNewTransactionView) {
            NavigationStack {
                AddModifyTransactionView(selectedDate: viewModel.selectedDate)
            }
        }
        
        .navigationTitle(.titleHomeView)
        .toolbar {
            toolbarContent
        }
        .searchable(text: $viewModel.searchText, isPresented: $showSearchView, placement: .toolbar)
        .searchToolbarBehavior(.minimize)
        .toolbar(.hidden, for: .navigationBar)
        
        
        // MARK: ON APPEAR / DISSAPEAR
        
        .onFirstAppear {
            Task {
                await viewModel.activateObservers()
            }
        }
        
        // MARK: LOAD FILTER BY OPTIONS
        .onChange(of: viewModel.transactionsFiltered) {
            viewModel.filterTransactions()
        }
        .onChange(of: filters.selectedAccountsFilter) {
            viewModel.filterTransactions()
        }
        .onChange(of: [filters.isFilterActive, filters.showOnlyFavorites]) {
            viewModel.filterTransactions()
        }
        
        // MARK: FILTER TRANSACTIONS BY DATE
        .onChange(of: viewModel.selectedDate) {
            viewModel.filterTransactions()
        }
        .onChange(of: viewModel.dateTimeInterval) {
            viewModel.filterTransactions()
        }
    }
    
    var headerTitle: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(.mainHeaderGreet(viewModel.userName, Emojis.greeting.rawValue))
                    .textStyle(family: .semibold,
                               size: .big,
                               lineLimit: ConstantViews.singleTextMaxLines,
                               truncateMode: .tail)
                
                Text(.mainHeaderSubtitle)
                    .textStyle(family: .light,
                               size: .small,
                               lineLimit: ConstantViews.singleTextMaxLines)
            }
            
            Spacer()
            
            Button {
                showSettings = true
            } label: {
                Image.settingsFill
                    .resizable()
                    .frame(width: ConstantFrames.navigationBarIcon,
                           height: ConstantFrames.navigationBarIcon)
                    .padding(ConstantViews.paddingNavigationBarIcon)
                    .foregroundStyle(Color.buttonForeground)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
        }
    }
    
    var headerActions: some View {
        VStack {
            NavigationLink {
                TransactionHistoryView(transactionsLoaded: $viewModel.transactionsFiltered,
                                       dateTimeInterval: $viewModel.dateTimeInterval,
                                       selectedDate: $viewModel.selectedDate)
            } label: {
                HStack {
                    Image.stackFill
                        .foregroundColor(Color.textPrimaryForeground)
                    
                    VStack(alignment: .leading) {
                        Text(.buttonHistory)
                            .textStyle
                        
                        Text(.buttonHistorySubtitle)
                            .textStyle(size: .small)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Image.arrowRight
                        .foregroundColor(Color.textPrimaryForeground)
                }
                .padding(.horizontal)
                .padding(.vertical)
                //.glassEffect(.regular.tint(Color.secondaryTop).interactive())
                .glassEffect(.regular.interactive())
            }
            
            DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                      selectedDate: $viewModel.selectedDate,
                                      isEditing: .constant(false)){}
        }
    }
    
    var bodyContent: some View {
        VStack {
            if filters.allAccounts.count > 1 {
                
                /// ¿Filtro activo?
                ///     ↓
                /// ¿Ninguna cuenta? → "None"
                ///     ↓
                /// ¿Todas? → "All"
                ///     ↓
                /// Entonces → nombres de las seleccionadas
                let text: LocalizedStringResource = {
                    guard filters.isFilterActive else {
                        return ""
                    }
                    
                    let selectedAccounts = filters.selectedAccountsFilter
                    
                    if selectedAccounts.isEmpty {
                        return .filterAccountNoneTitle
                    }
                    
                    if selectedAccounts.count == filters.allAccounts.count {
                        return .filterAccountAll
                    }
                    
                    let accountNames = filters.allAccounts
                        .filter { selectedAccounts.contains($0.id) }
                        .map(\.name)
                        .joined(separator: ", ")
                    
                    return LocalizedStringResource(stringLiteral: accountNames)
                }()
                
                Text(text)
                    .textStyle(size: .medium, truncateMode: .tail)
            }
            
            if viewModel.transactionsFiltered.isEmpty && !filters.isFilterActive {
                TransactionsEmptyView()
                
            } else {
                ScrollView(showsIndicators: false) {
                    
                    if !viewModel.groupedTransactionsIncomes.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.transactionTypeIncomes)
                                .textStyle(color: .primaryTop, family: .semibold, size: .big)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(viewModel.groupedTransactionsIncomes, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .textStyle
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                        .textStyle
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    if !viewModel.groupedTransactionsExpenses.isEmpty {
                        VStack(alignment: .leading) {
                            
                            Text(.transactionTypeExpenses)
                                .textStyle(color: .alert, family: .semibold, size: .big)
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            
                            ForEach(viewModel.groupedTransactionsExpenses, id:\.category.id) { item in
                                HStack {
                                    Text(item.category.name)
                                        .textStyle
                                        .padding(.leading)
                                    
                                    Spacer()
                                    
                                    Text(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                        .textStyle
                                }
                                .padding(.bottom, ConstantViews.minimumSpacing)
                            }
                        }
                    }
                }
                .animation(.default, value: filters.selectedAccountsFilter.count)
                
            }
            
            Text(viewModel.errorMessage)
                .textErrorStyle
            
            TotalBalanceView(transactions: viewModel.transactionsFiltered)
                .padding(.bottom)
            
            //Tiene un efecto no deseado al transicionar entre tab y tab.
            //TODO: Revisar si con listener se comporta diferente.
            //.redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        
        FilterTransactionsToolbarBottom(placement: .bottomBar)
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        
        //ToolbarSpacer(.fixed, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button(.transactionAdd, systemImage: ConstantSystemImage.addTransaction) {
                showNewTransactionView = true
            }
            .tint(Color.primaryTop)
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        UserDefaultsManager.userName = "Previews"
        FilterCenter.shared.isFilterActive = isFilterActive
    }
    
    var body: some View { TransactionView() }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper()
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
}

#Preview("Normal filtered \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(isFilterActive: true)
            .environment(\.locale, .init(identifier: Previews.localeEN))
    }
}

#Preview("Saturated \(Previews.localeEN_US)") {
    NavigationStack {
        previewWrapper(.saturated)
            .environment(\.locale, .init(identifier: Previews.localeEN_US))
    }
}

#Preview("Empty \(Previews.localeES_ES)") {
    NavigationStack {
        previewWrapper(.empty)
            .environment(\.locale, .init(identifier: Previews.localeES_ES))
    }
}
