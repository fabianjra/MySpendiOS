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
                
                if viewModel.transactionsFiltered.isEmpty {
                    NoContentToAddView()
                } else {
                    bodyContent
                }
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
        .onAppear {
            /// Disable Swipe to go back when ResumeView is showing.
            AppState.shared.swipeEnabled = false
        }
        .onDisappear {
            AppState.shared.swipeEnabled = true
        }
        
        
        // MARK: LOAD FILTER BY OPTIONS
        .onChange(of: viewModel.transactionsFiltered) {
            applyFilters()
        }
        .onChange(of: filters.selectedAccountsFilter) {
            applyFilters()
        }
        .onChange(of: [filters.isFilterActive, filters.showOnlyFavorites]) {
            applyFilters()
        }
        
        // MARK: FILTER TRANSACTIONS BY DATE
        .onChange(of: viewModel.selectedDate) {
            applyFilters()
        }
        .onChange(of: viewModel.dateTimeInterval) {
            applyFilters()
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
            //.matchedTransitionSource(id: viewModel.transitionSettings, in: namesapce)
        }
    }
    
    var headerActions: some View {
        VStack {
            NavigationLink {
                TransactionHistoryView(transactionsLoaded: $viewModel.transactionsFiltered,
                                       dateTimeInterval: $viewModel.dateTimeInterval,
                                       selectedDate: $viewModel.selectedDate,
                                       isMutipleAccounts: viewModel.allAccounts.count > 1 ? true : false)
            } label: {
                TextButtonHorizontalStyled(Localizable.Button.history.key,
                                           iconLeading: Image.stackFill,
                                           iconTrailing: Image.arrowRight)
            }
            .disabled(viewModel.transactionsFiltered.isEmpty)
            
            DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                      selectedDate: $viewModel.selectedDate,
                                      isEditing: .constant(false)){}
        }
    }
    
    var bodyContent: some View {
        VStack {
            if viewModel.allAccounts.count > 1 {
                
                let text: LocalizedStringResource = {
                    
                    // Si todas las cuentas están seleccionadas, muestra “All accounts”
                    if filters.selectedAccountsFilter.count == viewModel.allAccounts.count {
                        return .filterAccountAll
                    }
                    
                    // Si hay un subconjunto de cuentas, se enlistan los nombres
                    let accountsSelected = viewModel.allAccounts.filter { filters.selectedAccountsFilter.contains($0.id) }
                        .map(\.name)
                        .joined(separator: ", ")
                    
                    return LocalizedStringResource(stringLiteral: accountsSelected)
                }()
                
                Text(text)
                    .textStyle(size: .medium, truncateMode: .tail)
            }
            
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
                        }
                    }
                }
            }
            .animation(.default, value: filters.selectedAccountsFilter.count)
            
            TextError(viewModel.errorMessage)
            
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
        
        FilterTransactionsButtonView(allAccounts: $viewModel.allAccounts)
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        
        //ToolbarSpacer(.fixed, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            Button("Add transaction", systemImage: "plus") {
                showNewTransactionView = true
            }
            .tint(Color.primaryTop)
        }
        //.matchedTransitionSource(id: viewModel.transitionNewTransaction, in: namesapce)
    }
    
    private func applyFilters() {
        viewModel.filterTransactions(byAccounts: filters.selectedAccountsFilter,
                                     showOnlyFavorites: filters.showOnlyFavorites)
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        //UserDefaultsManager.userDefaults = .preview
        UserDefaultsManager.userName = "Preview pruebas"
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
