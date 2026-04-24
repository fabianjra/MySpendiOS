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
    @State private var showNewTransactionModal = false
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
                    
                    //TODO: Agregar boton para filtrar Accounts. A la derecha del nombre del usuario
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
                        
                        
                        let transactionsFiltered = UtilsTransactions.filteredTransactions(viewModel.selectedDate,
                                                                                          transactions: viewModel.transactions,
                                                                                          for: viewModel.dateTimeInterval)
                        
                        let groupedTransactions = UtilsCurrency.calculateGroupedTransactions(transactionsFiltered)
                            .sorted(by: { $0.totalAmount > $1.totalAmount })
                        
                        ScrollView(showsIndicators: false) {
                            ForEach(groupedTransactions, id:\.category.id) { item in
                                HStack {
                                    TextPlain(item.category.name)
                                    
                                    Spacer()
                                    
                                    TextPlain(item.totalAmount.convertAmountDecimalToString.addCurrencySymbol)
                                }
                                .padding(.vertical, ConstantViews.minimumSpacing)
                            }
                        }
                        .animation(.default, value: transactionsFiltered.count)
                        
                        TextError(viewModel.errorMessage)
                        
                        TotalBalanceView(transactions: transactionsFiltered)
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
        .sheet(isPresented: $showNewTransactionModal) {
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
                    showNewTransactionModal = true
                }
                .tint(Color.primaryTop)
            }
            //.matchedTransitionSource(id: viewModel.transitionNewTransaction, in: namesapce)
        }
        .searchable(text: $viewModel.searchText, isPresented: $showSearchView, placement: .toolbar)
        .searchToolbarBehavior(.minimize)
        .toolbar(.hidden, for: .navigationBar)
        
        
        // MARK: EVENTS
        
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
        .onChange(of: viewModel.selectedAccountsFilter, {
            viewModel.filterTransactions()
        })
    }
    
    
    // MARK: FILTER
    
    //@ToolbarContentBuilder
    private var filterDescriptionView: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                withAnimation {
                    viewModel.showFilter.toggle()
                    
                    if viewModel.showFilter == false {
                        viewModel.selectedAccountsFilter.removeAll()
                    }
                }
            } label: {
                Image.filter
                    .foregroundStyle(.textPrimaryForeground)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.horizontal, ConstantViews.paddingMedium)
                    .padding(.vertical, ConstantViews.paddingMedium)
                    .background(viewModel.selectedAccountsFilter.isEmpty ? nil : Capsule().fill(.primaryTop))
            }
            
            
            if viewModel.showFilter {
                Button {
                    showFiltersView = true
                } label: {
                    VStack(alignment: .leading) {
                        TextPlain("Filtered by", size: .medium)
                        
                        TextPlain(getTextDescription(by: viewModel.selectedAccountsFilter),
                                  color: viewModel.selectedAccountsFilter.isEmpty ? .textPrimaryForeground : .primaryTop,
                                  size: .mediumSmall,
                                  truncateMode: .tail)
                    }
                }
                .frame(width: ConstantFrames.filterMaxWidth)
                .contentShape(Rectangle())
                .matchedTransitionSource(id: viewModel.transitionFilters, in: namesapce)
            }
        }
    }
    
    private func getTextDescription(by account: Set<AccountModel>) -> String {
        
        if account.count == 1 {
            return account.first?.name ?? ""
            
        } else if account.count > 1 {
            return "some accounts"
            
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
