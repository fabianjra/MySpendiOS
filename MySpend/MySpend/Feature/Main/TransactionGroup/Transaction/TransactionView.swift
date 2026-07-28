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
    
    // MARK: NAMESPACES
    @Namespace private var namesapce
    
    var body: some View {
        VStack {
            
            if showSearchView {
                
                Color.red //TODO: Agregar vista de busqueda
                
            } else {
                
                // MARK: - HEADER
                
                HStack {
                    VStack(alignment: .leading) {
                        TextPlainLocalized(textLocalized: "greet \(viewModel.userName) \(Emojis.greeting.rawValue)",
                                           table: LocalizableTable.user,
                                           family: .semibold,
                                           size: .big,
                                           lineLimit: ConstantViews.singleTextMaxLines,
                                           truncateMode: .tail)
                        
                        TextPlainLocalized(Localizable.User.welcome,
                                           family: .light,
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
                    .matchedTransitionSource(id: viewModel.transitionSettings, in: namesapce)
                }
                
                
                // MARK: - TRANSACTIONS
                
                if viewModel.transactions.isEmpty {
                    NoContentToAddView()
                } else {
                    VStack {
                        NavigationLink {
                            TransactionHistoryView(transactionsLoaded: $viewModel.transactions,
                                                   dateTimeInterval: $viewModel.dateTimeInterval,
                                                   selectedDate: $viewModel.selectedDate,
                                                   isMutipleAccounts: viewModel.allAccounts.count > 1 ? true : false)
                        } label: {
                            TextButtonHorizontalStyled(Localizable.Button.history.key,
                                                       iconLeading: Image.stackFill,
                                                       iconTrailing: Image.arrowRight)
                        }
                        
                        DateIntervalNavigatorView(dateTimeInterval: $viewModel.dateTimeInterval,
                                                  selectedDate: $viewModel.selectedDate,
                                                  isEditing: .constant(false)){}
                        
                        
                        ScrollView(showsIndicators: false) {
                            
                            if !viewModel.groupedTransactionsIncomes.isEmpty {
                                VStack(alignment: .leading) {
                                    TextPlain("Incomes", color: Color.primaryTop, family: .semibold, size: .big)
                                        .padding(.vertical, ConstantViews.minimumSpacing)
                                    
                                    ForEach(viewModel.groupedTransactionsIncomes, id:\.category.id) { item in
                                        HStack {
                                            TextPlain(item.category.name)
                                                .padding(.leading)
                                            
                                            Spacer()
                                            
                                            TextPlain(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                            
                            if !viewModel.groupedTransactionsExpenses.isEmpty {
                                VStack(alignment: .leading) {
                                    TextPlain("Expenses", color: Color.alert, family: .semibold, size: .big)
                                        .padding(.vertical, ConstantViews.minimumSpacing)
                                    
                                    ForEach(viewModel.groupedTransactionsExpenses, id:\.category.id) { item in
                                        HStack {
                                            TextPlain(item.category.name)
                                                .padding(.leading)
                                            
                                            Spacer()
                                            
                                            TextPlain(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                        }
                                    }
                                }
                            }
                        }
                        .animation(.default, value: viewModel.transactionsFiltered.count)
                        
                        TextError(viewModel.errorMessage)
                        
                        TotalBalanceView(transactions: viewModel.transactionsFiltered)
                            .padding(.bottom)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    //Tiene un efecto no deseado al transicionar entre tab y tab.
                    //TODO: Revisar si con listener se comporta diferente.
                    //.redacted(reason: viewModel.isLoading ? .placeholder : [])
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
            //            .navigationTransition(
            //                .zoom(sourceID: transitionNewTransaction, in: namesapce)
            //            )
        }
        .popover(isPresented: $showFiltersView) {
            NavigationStack {
                FilterTransactionsView(viewModel: viewModel)
                    .presentationDetents([.medium, .large])
            }
            .navigationTransition(
                .zoom(sourceID: viewModel.transitionFilters, in: namesapce)
            )
        }
        
        .toolbar {
            filterDescriptionView
            
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
        .onChange(of: viewModel.transactions, {
            viewModel.filterTransactionsByOptions()
        })
        .onChange(of: viewModel.selectedAccountsFilter, {
            viewModel.filterTransactionsByOptions()
        })
        .onChange(of: viewModel.showFilter, {
            viewModel.filterTransactionsByOptions()
        })
        .onChange(of: viewModel.favoriteSelected, {
            viewModel.filterTransactionsByOptions()
        })
        
        
        // MARK: FILTER TRANSACTIONS BY DATE
        
        .onChange(of: viewModel.selectedDate) {
            viewModel.filterTransactionsByDate()
        }
        .onChange(of: viewModel.transactions) {
            viewModel.filterTransactionsByDate()
        }
        .onChange(of: viewModel.dateTimeInterval) {
            viewModel.filterTransactionsByDate()
        }
    }

    
    // MARK: FILTER
    
    //@ToolbarContentBuilder
    private var filterDescriptionView: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
//                    withAnimation {
                        viewModel.showFilter.toggle()
//                    }
                } label: {
                    Image.filter
                        .foregroundStyle(.textPrimaryForeground)
                        .padding(ConstantViews.paddingSmall)
                        .background(viewModel.showFilter ? Capsule().fill(.primaryTop) : nil)
                    //.animation(nil, value: UUID()) //otra manera de desabilitar la animacion.
                        .transaction { transaction in
                            transaction.animation = nil
                        }
                }
                
                
                if viewModel.showFilter {
                    Button {
                        showFiltersView = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                TextPlain("Filtered by", size: .medium)
                                
                                TextPlain(getTextDescription,
                                          color: viewModel.selectedAccountsFilter.isEmpty ? .textPrimaryForeground : .primaryTop,
                                          size: .mediumSmall,
                                          truncateMode: .tail)
                            }
                            
                            Spacer()
                        }
                        .frame(width: ConstantFrames.filterMaxWidth)
                    }
                    .frame(width: ConstantFrames.filterMaxWidth)
                    .contentShape(Rectangle()) //Para detectar el touch en todo el espacio disponible.
                    .matchedTransitionSource(id: viewModel.transitionFilters, in: namesapce)
                }
            }
        }
    }
    
    private var getTextDescription: String {
        let selectedAccountsFilter = viewModel.selectedAccountsFilter
        
        if selectedAccountsFilter.count == 1 {
            return selectedAccountsFilter.first?.name ?? ""
            
        } else if selectedAccountsFilter.count > 1 {
            return "accounts"
            
        } else {
            return "none"
        }
    }
    
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        UserDefaultsManager.userDefaults = .preview
        UserDefaultsManager.userName = "Preview pruebas"
    }
    
    var body: some View { TransactionView() }
}

#Preview("Normal \(Previews.localeES_CR)") {
    NavigationStack {
        previewWrapper()
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
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
