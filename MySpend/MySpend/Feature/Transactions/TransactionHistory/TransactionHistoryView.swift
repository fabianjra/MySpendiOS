//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @Environment(TransactionManager.self) private var transactionManager
    @Environment(AccountManager.self) private var accountManager
    @Environment(CurrencyManager.self) private var currencyManager
    
    @Environment(\.editMode) private var editMode
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    @State private var viewModel = TransactionHistoryViewModel()
    @State private var toastResponse: ToastResponse?
    
    private var filteredTransactions: [TransactionModel] {
        transactionManager.filteredAndSortedTransactions(by: dateTimeInterval,
                                                         selectedDate: selectedDate,
                                                         accountIDs: accountManager.selectedAccountsToFilterByID)
    }
    
    @AppStorage(UserDefaultsKeys.showCents.rawValue,
                store: UserDefaultsManager.userDefaults)
    private var showCents = true
    
    var body: some View {
        VStack {
            DateTimeNavigatorView(dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
                .padding(.horizontal)
                .padding(.bottom)
                .disabled(isEditing)
            
            totalBalance
                .padding(.horizontal)
            
            transactionsList
            
            
        }
        .navigationTitle(
            viewModel.selectedTransactions.isEmpty ?
                .titleHistoryView : .selectorSelectedCountFemale(viewModel.selectedTransactions.count)
        )
        .navigationSubtitle(.transactionsSubtitle(filteredTransactions.count))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)
        
        .toolbar {
            toolbarContent
        }
        
        .onChange(of: editMode?.wrappedValue) { _, newValue in
            if newValue?.isEditing != true {
                viewModel.selectedTransactions.removeAll()
            }
        }
        
        
        // MARK: SHEETS
        .sheet(isPresented: $viewModel.showCreateTransaction) {
            NavigationStack {
                CreateTransactionView(selectedDate: selectedDate)
            }
        }
        
        .sheet(isPresented: $viewModel.showUpdateTransaction) {
            NavigationStack {
                UpdateTransactionView(transaction: viewModel.transactionToUpdate)
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
        
        .toast($toastResponse)
    }
    
    private var transactionsList: some View {
        
        let transactions = filteredTransactions
        let groupedTransactions = UtilsTransactions.groupTransactionsByDate(transactions)
        
        return List(selection: $viewModel.selectedTransactions) {
            
            if transactions.isEmpty {
                Section {
                    HStack {
                        Spacer()
                        Text(.transactionsEmpty)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
            } else {
                if transactionManager.sortSelection.sortBy == .dateTransaction {
                    ForEach(groupedTransactions, id: \.date) { group in
                        transactionRow(group.transactions, groupDate: group.date)
                    }
                } else {
                    transactionRow(transactions)
                }
                
            }
        }
        .scrollEdgeEffectStyle(.soft, for: .bottom)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .animation(.default, value: transactions)
        //.listRowBackground(Color.clear)
        //.listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
    }
    
    private func transactionRow(_ transactions: [TransactionModel], groupDate: Date? = nil) -> some View {
        Section {
            ForEach(transactions) { item in
                
                Button {
                    if isEditing {
                        viewModel.toggleTransactionSelection(item)
                    } else {
                        viewModel.transactionToUpdate = item
                        viewModel.showUpdateTransaction = true
                    }
                    
                } label: {
                    HStack {
                        
                        Label {
                            Text(item.notes.isEmptyOrWhitespace ? item.category.name : item.notes)
                            
                            HStack {
                                if shouldShowAccountName {
                                    Text(verbatim: item.account.name + (groupDate == nil ? ":" : ""))
                                }
                                
                                if groupDate == nil {
                                    Text(item.dateTransaction.toStringShortLocale)
                                }
                            }
                            .font(.footnote)
                            .foregroundStyle(Color.secondary)
                            
                        } icon: {
                            Image(systemName: item.category.icon)
                        }
                        .fontWeight(.light)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.primary)
                        
                        
                        Spacer()
                        
                        if !isEditing {
                            if item.favorite {
                                Button(.selectorFavorite, systemImage: ConstantSystemImage.favoriteFill) {
                                    Task {
                                        toastResponse = await transactionManager.favorite(item)
                                    }
                                }
                                .foregroundStyle(Color.accentColor)
                                .labelStyle(.iconOnly)
                            }
                        }
                        
                        Text(item.amount.amountToString(showCents: showCents).addCurrencySymbol(currencyManager.selectedSymbolOrCode))
                            .foregroundStyle(item.category.type == .income ? Color.accentColor : .alert)
                            .monospacedDigit()
                    }
                    .lineLimit(1)
                    .fontDesign(.rounded)
                }
                .tag(item)
                
                
                .swipeActions(edge: .trailing) {
                    if !isEditing {
                        
                        Button(.selectorDelete, systemImage: ConstantSystemImage.trash) {
                            viewModel.transactionToDelete = item
                            viewModel.showAlertDelete = true
                        }
                        .labelStyle(.iconOnly)
                        .tint(.alert)
                        
                        
                        Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                            viewModel.transactionToUpdate = item
                            viewModel.showUpdateTransaction = true
                        }
                        .labelStyle(.iconOnly)
                        
                        
                        if item.favorite == false {
                            Button(.selectorFavorite, systemImage: ConstantSystemImage.favoriteFill) {
                                Task {
                                    toastResponse = await transactionManager.favorite(item)
                                }
                            }
                            .labelStyle(.iconOnly)
                            .tint(.accentColor)
                        }
                    }
                }
                
                
                .contextMenu {
                    if !isEditing {
                        
                        Button(item.favorite ? .selectorUnfavorite : .selectorFavorite,
                               systemImage: item.favorite ? ConstantSystemImage.unfavoriteFill : ConstantSystemImage.favoriteFill) {
                            Task {
                                toastResponse = await transactionManager.favorite(item)
                            }
                        }
                               .tint(.accentColor)
                        
                        Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                            viewModel.transactionToUpdate = item
                            viewModel.showUpdateTransaction = true
                        }
                        
                        
                        Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                            viewModel.transactionToDelete = item
                            viewModel.showAlertDelete = true
                        }
                    }
                }
                
                
                .alert(.transactionDelete(viewModel.selectedTransactions.count), isPresented: $viewModel.showAlertDelete) {
                    Button(.alertOptionDelete, role: .destructive) {
                        Task {
                            if viewModel.selectedTransactions.isEmpty {
                                defer {
                                    viewModel.transactionToDelete = nil
                                }
                                
                                if let transaction = viewModel.transactionToDelete {
                                    toastResponse = await transactionManager.delete(transaction)
                                }
                                
                            } else {
                                defer {
                                    viewModel.selectedTransactions.removeAll()
                                }
                                
                                toastResponse = await transactionManager.delete(viewModel.selectedTransactions)
                            }
                            
                            editMode?.wrappedValue = .inactive
                        }
                    }
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                } message: {
                    Text(.transactionDeleteMessage(viewModel.selectedTransactions.count))
                }
                
            }
        } header: {
            if let groupDate = groupDate {
                if dateTimeInterval != .day {
                    let calendar = Calendar.current
                    let isCurrentYear = calendar.isDate(groupDate, equalTo: .now, toGranularity: .year)
                    
                    if calendar.isDateInToday(groupDate) {
                        Text(.dateToday)
                        
                        //HStack {
                        //    Text(.dateToday)
                        //
                        //    Spacer()
                        //
                        //    Text(group.balance.amountToString(showCents: showCents).addCurrencySymbol(currencyManager.selectedSymbolOrCode))
                        //}
                        //.font(.callout)
                    } else {
                        Text(groupDate, format: isCurrentYear
                             ? .dateTime.weekday(.wide).day().month(.abbreviated)
                             : .dateTime.weekday(.wide).day().month(.abbreviated).year())
                        
                        //HStack {
                        //    Text(group.date, format: isCurrentYear
                        //         ? .dateTime.weekday(.wide).day().month(.abbreviated)
                        //         : .dateTime.weekday(.wide).day().month(.abbreviated).year())
                        //
                        //    Spacer()
                        //
                        //    Text(group.balance.amountToString(showCents: showCents).addCurrencySymbol(currencyManager.selectedSymbolOrCode))
                        //}
                        //.font(.callout)
                    }
                }
            }
        }
        .alignmentGuide(.listRowSeparatorLeading) { dimensions in
            dimensions[.leading]
        }
    }
    
    private var totalBalance: some View {
        HStack(spacing: .zero) {
            let totals = filteredTransactions.calculateTotals()
            
            VStack(alignment: .leading) {
                Text(.categoryTypeIncomes)
                    .fontWeight(.light)
                    .foregroundStyle(Color.secondary)
                
                Text(totals.incomes.amountToString(showCents: showCents).addCurrencySymbol(currencyManager.selectedSymbolOrCode))
                    .monospacedDigit()
                    .foregroundStyle(Color.accentColor)
            }
            .lineLimit(1)
            .font(.callout)
            .fontDesign(.rounded)
            
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .overlay(Color.secondary)
                .padding(.horizontal)
            
            VStack(alignment: .leading) {
                
                Text(.categoryTypeExpenses)
                    .fontWeight(.light)
                    .foregroundStyle(Color.secondary)
                
                Text(totals.expenses.amountToString(showCents: showCents).addCurrencySymbol(currencyManager.selectedSymbolOrCode))
                    .monospacedDigit()
                    .foregroundStyle(.alert)
            }
            .lineLimit(1)
            .font(.callout)
            .fontDesign(.rounded)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding()
        .background(Color.backgroundBottom)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if isEditing {
                if viewModel.selectedTransactions.count == filteredTransactions.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedTransactions = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedTransactions = Set(filteredTransactions)
                    }
                }
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            if isEditing {
                Button(role: .cancel) {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
            } else {
                
                Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                    
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label(.selectorSelect, systemImage: ConstantSystemImage.checkmarkCircle)
                    }
                    
                    TransactionSortMenu()
                }
                .menuOrder(.fixed)
                .disabled(filteredTransactions.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        if isEditing {
            
            ToolbarItem(placement: .bottomBar) {
                
                let shouldMarkAsFavorite = shouldMarkAsFavorite
                
                Button(shouldMarkAsFavorite ? .selectorFavorite : .selectorUnfavorite,
                       systemImage: shouldMarkAsFavorite ? ConstantSystemImage.favoriteFill : ConstantSystemImage.unfavoriteFill) {
                    
                    Task {
                        defer {
                            viewModel.selectedTransactions.removeAll()
                        }
                        
                        toastResponse = await transactionManager.favorite(viewModel.selectedTransactions, newState: shouldMarkAsFavorite)
                        
                        editMode?.wrappedValue = .inactive
                    }
                    
                }
                       .disabled(viewModel.selectedTransactions.isEmpty)
            }
            
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            
        } else {
            FilterTransactionsToolbarBottom(showFilters: $viewModel.showFilters)
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            DefaultToolbarItem(kind: .search, placement: .bottomBar) //TODO: Reparar: se pasa hacia arriba al editar.
        }
        
        ToolbarItem(placement: .bottomBar) {
            if isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                    viewModel.showAlertDelete = true
                }
                .disabled(viewModel.selectedTransactions.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem, role: .confirm) {
                    viewModel.showCreateTransaction = true
                }
            }
        }
    }
    
    
    // MARK: FUNCTIONS
    
    /**
     Si todas las transacciones seleccionadas son favoritas, el botón debe quitarlas de favoritos.
     Si al menos una no es favorita, debe marcar todas como favoritas.
     */
    private var shouldMarkAsFavorite: Bool {
        if viewModel.selectedTransactions.isEmpty {
            return true
        }
        
        return !viewModel.selectedTransactions.allSatisfy(\.favorite)
    }
    
    private var shouldShowAccountName: Bool {
        guard accountManager.sortedAccounts.count > 1 else {
            return false
        }
        
        return !transactionManager.isFilterActive || accountManager.selectedAccountsToFilterByID.count > 1
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        _transactionManager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
    }
    
    @State var transactionManager: TransactionManager
    @State var accountManager: AccountManager
    
    @State var editMode: EditMode = .inactive
    
    @State var currencyManager = CurrencyManager.shared
    @State var dateTimeInterval: DateTimeInterval = .month
    @State var selectedDate: Date = .now
    
    var body: some View {
        TransactionHistoryView(dateTimeInterval: $dateTimeInterval,
                               selectedDate: $selectedDate)
        .environment(transactionManager)
        .environment(accountManager)
        .environment(currencyManager)
        .environment(\.editMode, $editMode)
    }
}

#Preview(Previews.localeES_CR) {
    NavigationStack {
        PreviewWrapper(.normal)
        
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Random Saturated \(Previews.localeEN_US)") {
    NavigationStack {
        PreviewWrapper(.saturated)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN_US))
}

#Preview("Empty \(Previews.localeEN_US_POSIX)") {
    NavigationStack {
        PreviewWrapper(.empty)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN_US_POSIX))
}
