//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @Environment(TransactionManager.self) private var manager
    @Environment(AccountManager.self) private var accountManager
    
    @Environment(\.editMode) private var editMode
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @State private var viewModel = TransactionHistoryViewModel()
    @State private var toastResponse: ToastResponse?
    
    private var filteredTransactions: [TransactionModel] {
        manager.filteredAndSortedTransactions(by: dateTimeInterval, selectedDate: selectedDate)
    }
    
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    var body: some View {
        
        VStack {
            DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
                .padding(.horizontal)
                .disabled(isEditing)
            
            transactionsList
            
            TotalBalanceView(transactions: filteredTransactions)
                .padding(.horizontal)
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
        
        .background(Color.backgroundGradient)
        
        .toast($toastResponse)
    }
    
    private var transactionsList: some View {
        List(selection: $viewModel.selectedTransactions) {
            if filteredTransactions.isEmpty {
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
                Section {
                    ForEach(filteredTransactions) { item in
                        
                        Button {
                            if isEditing {
                                viewModel.toggleTransactionSelection(item)
                            } else {
                                viewModel.transactionToUpdate = item
                                viewModel.showUpdateTransaction = true
                            }
                            
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Label(item.notes.isEmptyOrWhitespace ? item.category.name : item.notes, systemImage: item.category.icon)
                                        .foregroundStyle(Color.primary)
                                        .lineLimit(1)
                                        .padding(.bottom, ConstantViews.minimumSpacing)
                                    
                                    HStack {
                                        if accountManager.sortedAccounts.count > 1 {
                                            Text("\(item.account.name):")
                                                .font(.footnote)
                                                .fontDesign(.rounded)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Text(item.dateTransaction.toStringShortLocale)
                                            .font(.footnote)
                                            .fontDesign(.rounded)
                                            .foregroundStyle(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                
                                Spacer()
                                
                                Text(item.amount.amountToString.addCurrencySymbol)
                                    .foregroundStyle(item.category.type == .income ? Color.accentColor : .alert)
                                    .monospacedDigit()
                                    .lineLimit(1)
                                
                                if !isEditing {
                                    if item.favorite {
                                        Button(.selectorFavorite, systemImage: ConstantSystemImage.favoriteFill) {
                                            Task {
                                                toastResponse = await manager.favorite(item)
                                            }
                                        }
                                        .labelStyle(.iconOnly)
                                    }
                                }
                                
                                if !isEditing {
                                    Image.chevronRight
                                        .tint(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
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
                                            toastResponse = await manager.favorite(item)
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
                                        toastResponse = await manager.favorite(item)
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
                                            toastResponse = await manager.delete(transaction)
                                        }
                                        
                                    } else {
                                        defer {
                                            viewModel.selectedTransactions.removeAll()
                                        }
                                        
                                        toastResponse = await manager.delete(viewModel.selectedTransactions)
                                    }
                                    
                                    editMode?.wrappedValue = .inactive
                                }
                            }
                            
                            Button(.alertOptionCancel, role: .cancel) { }
                        } message: {
                            Text(.transactionDeleteMessage(viewModel.selectedTransactions.count))
                        }
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                .alignmentGuide(.listRowSeparatorLeading) { dimensions in
                    dimensions[.leading]
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .animation(.default, value: filteredTransactions)
    }
    
    // MARK: VIEWS
    
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
                        
                        toastResponse = await manager.favorite(viewModel.selectedTransactions, newState: shouldMarkAsFavorite)
                        
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
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        _manager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
    }
    
    @State var manager: TransactionManager
    @State var accountManager: AccountManager
    
    @State var editMode: EditMode = .inactive
    
    @State var dateTimeInterval: DateTimeInterval = .month
    @State var selectedDate: Date = .now
    
    var body: some View {
        TransactionHistoryView(dateTimeInterval: $dateTimeInterval,
                               selectedDate: $selectedDate)
        .environment(manager)
        .environment(accountManager)
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
