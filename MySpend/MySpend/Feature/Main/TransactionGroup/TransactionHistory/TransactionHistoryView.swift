//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @StateObject var viewModel = TransactionHistoryViewModel()
    
    @Binding var transactionsLoaded: [TransactionModel]
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    var isMutipleAccounts: Bool
    
    
    // MARK: ALERTS (Solo manejadas dentro de la vista, no hacen nada en ViewModel)
    @State private var showAlertDelete = false
    @State private var showAlertDeleteMultiple = false
    
    
    // MARK: NAVIGATION
    @State private var showNewItemModal = false
    @State private var showSearchView = false
    @State private var modelToModify: TransactionModel?
    @State private var modelToDelete: TransactionModel?
    
    var body: some View {
        VStack {
            if transactionsLoaded.isEmpty {
                
                TextPlain("No transactions",
                          family: .semibold,
                          size: .bigXL,
                          aligment: .center)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                VStack {
                    header
                    transactionsList
                }
                .padding(.horizontal)
            }
            
            TextError(viewModel.errorMessage)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline) //TODO: CAMBIAR: El navegador de fechas va a ir abajo, entonces va a ponerse el titulo en grande al bajar.
        .toolbar {
            
            //Toolbar Top:
            
            ToolbarItem(placement: .navigation) {
                if viewModel.isEditing {
                    Button("Select all") {
                        //TODO: ...
                    }
                }
            }
            
            ToolbarItem(placement: .title) {
                
                if viewModel.selectedTransactions.count == .zero {
                    TextPlain("History")
                } else {
                    TextPlain("\(viewModel.selectedTransactions.count.description) selected")
                }
                
            }
            
            ToolbarItem(placement: .primaryAction) {
                
                if viewModel.isEditing {
                    Button(role: .cancel) {
                        viewModel.selectedTransactions.removeAll()
                        viewModel.isEditing = false
                    }
                    
                } else {
                    Button("Select") {
                        viewModel.isEditing = true
                    }
                }
            }
            
            
            //Toolbar Bottom:
            
            if viewModel.isEditing {
                ToolbarItem(placement: .bottomBar) {
                    Button("Favorite", systemImage: ConstantSystemImage.favorite) {
                        favoriteMultipleTransactions()
                    }
                }
                
                ToolbarSpacer(.flexible, placement: .bottomBar)
                
            } else {
                //filterButton
                ToolbarSpacer(.flexible, placement: .bottomBar)
                DefaultToolbarItem(kind: .search, placement: .bottomBar)
            }
            
            ToolbarItem(placement: .bottomBar) {
                
                if viewModel.isEditing {
                    Button("Delete", systemImage: ConstantSystemImage.trash) {
                        showAlertDeleteMultiple = true
                    }
                    
                } else {
                    Button("Add transaction", systemImage: "plus") {
                        showNewItemModal = true
                    }
                    .tint(Color.primaryTop)
                }
            }
        }
        .searchable(text: $viewModel.searchText, isPresented: $showSearchView, placement: .toolbar)
        .searchToolbarBehavior(.minimize)
        .navigationBarBackButtonHidden(viewModel.isEditing)
        
        .sheet(isPresented: $showNewItemModal) {
            NavigationStack {
                AddModifyTransactionView(selectedDate: selectedDate)
            }
        }
        .sheet(item: $modelToModify) { model in
            NavigationStack {
                AddModifyTransactionView(model)
                    .onDisappear {
                        modelToModify = nil
                    }
            }
        }
        .background(Color.backgroundContentGradient)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .onAppear {
            filterTransactionsByDate()
        }
        .onChange(of: selectedDate) {
            filterTransactionsByDate()
        }
        .onChange(of: transactionsLoaded) {
            filterTransactionsByDate()
        }
        .onChange(of: dateTimeInterval) {
            filterTransactionsByDate()
        }
        .onChange(of: viewModel.sortTransactionsBy) {
            filterTransactionsByDate()
        }
    }
    
    private func filterTransactionsByDate() {
        viewModel.transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                                transactions: transactionsLoaded,
                                                                                for: dateTimeInterval,
                                                                                sortTransactions: viewModel.sortTransactionsBy)
    }
    
    
    // MARK: VIEWS
    
    private func sortButton(_ sortingOption: SortTransactions) -> some View {
        Button {
            if viewModel.sortTransactionsBy == sortingOption {
                viewModel.sortTransactionsBy = sortingOption.toggle
            } else {
                viewModel.sortTransactionsBy = sortingOption
            }
            
            viewModel.updateSelectedSort() // Updates the sort selection to store in UserDefaults.
        } label: {
            viewModel.sortTransactionsBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
        }
    }
    
    private var sortButtonResetToDefault: some View {
        Button {
            viewModel.resetSelectedSort()
        } label: {
            Label.restoreSelection
                .foregroundStyle(Color.alert, Color.alert)
        }
    }
    
    private var header: some View {
        //        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
        //                                  selectedDate: $selectedDate,
        //                                  isEditing: $viewModel.isEditing,
        //                                  showEditor: true,
        //                                  counterSelected: viewModel.selectedTransactions.count) {
        //
        //            viewModel.selectedTransactions.removeAll()
        
        
        DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                  selectedDate: $selectedDate,
                                  isEditing: $viewModel.isEditing,
                                  showEditor: false, //TODO: Convertir a True para mostrar el Sort by
                                  counterSelected: viewModel.selectedTransactions.count) {
        } actionTrailingEdit: {
            //showAlertDeleteMultiple = true
            
        } contentLeadingSort: {
            Section("Sorted by: \(viewModel.sortTransactionsBy.rawValue)") {
                sortButton(.byDateNewest)
                sortButton(.byAmountHigher)
                sortButton(.byCategoryNameAz)
            }
            
            // Reset the sort selection to default
            Section {
                sortButtonResetToDefault
            }
        }
    }
    
    private var transactionsList: some View {
        VStack {
            List {
                ForEach(viewModel.transactionsFiltered, id: \.self) { item in
                    VStack {
                        HStack {
                            if viewModel.isEditing {
                                Image(systemName: viewModel.selectedTransactions.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.alert)
                                    .transition(.scale.combined(with: .move(edge: .leading)))
                            }
                            
                            if let image = item.category.icon.getIconFromSFSymbol {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.width.iconInsideTextField,
                                           height: FrameSize.height.iconInsideTextField)
                                    .foregroundStyle(.textPrimaryForeground)
                            }
                            
                            Button("") {
                                if viewModel.isEditing {
                                    if viewModel.selectedTransactions.contains(item) {
                                        viewModel.selectedTransactions.remove(item)
                                    } else {
                                        viewModel.selectedTransactions.insert(item)
                                    }
                                } else {
                                    modelToModify = item
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                if item.notes.isEmptyOrWhitespace {
                                    TextPlain(item.category.name)
                                } else {
                                    TextPlain(item.notes)
                                }
                                
                                HStack {
                                    if isMutipleAccounts {
                                        TextPlain("\(item.account.name):", size: .small)
                                    }
                                    
                                    TextPlain(item.dateTransaction.toStringShortLocale, size: .small)
                                }
                            }
                            
                            Spacer()
                            
                            TextPlain(item.amount.convertAmountDecimalToString.addCurrencySymbol,
                                      color: item.category.type == .income ? Color.primaryTop : Color.alert)
                            
                            if item.favorite {
                                Image(systemName: ConstantSystemImage.favoriteFill)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.iconRowList,
                                           height: FrameSize.width.iconRowList)
                                    .foregroundStyle(.yellow)
                                    .onTapGesture {
                                        favorite(item)
                                    }
                            }
                            
                            //Image.chevronRight
                            //.foregroundStyle(.textPrimaryForeground)
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            //Removes the padding Leading in the RowSeparator.
                            return .zero
                        }
                        .alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
                            //Removes the padding Trailing in the RowSeparator.
                            return viewDimensions[.listRowSeparatorTrailing]
                        }
                    }
                    .frame(height: FrameSize.height.rowForListTransactionHistory)
                    .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                    .listRowSeparatorTint(.textPrimaryForeground.opacity(ConstantColors.opacityHalf))
                    
                    // MARK: SWIPE ACTIONS:
                    
                    .swipeActions(edge: .trailing) {
                        if !viewModel.isEditing {
                            contextMenuActions(item)
                        }
                    }
                    .contextMenu {
                        if !viewModel.isEditing {
                            contextMenuActions(item)
                        }
                    }
                    
                    // MARK: DELETE TRANSACTION SINGLE
                    
                    .alert("Delete transaction", isPresented: $showAlertDelete) {
                        Button("Delete", role: .destructive) { delete() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this transaction? \n This action cannot be undone.")
                    }
                    
                    // MARK: DELETE TRANSACTION MULTIPLE
                    
                    .alert("Delete transactions", isPresented: $showAlertDeleteMultiple) {
                        Button("Delete", role: .destructive) { deleteMltipleTransactions() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete these transactions? \n This action cannot be undone.")
                    }
                    .padding(.vertical, ConstantViews.mediumSpacing)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .animation(.default, value: viewModel.transactionsFiltered.count)
            .animation(.default, value: viewModel.isEditing)
            .animation(.default, value: viewModel.sortTransactionsBy)
            
            TotalBalanceView(transactions: viewModel.transactionsFiltered, showTotalBalance: false)
        }
    }
    
    private func contextMenuActions(_ item: TransactionModel) -> some View {
        VStack {
            Button("Edit", systemImage: ConstantSystemImage.squareAndPencil) {
                modelToModify = item
            }
            //.tint(.warning)
            
            
            Button("Favorite", systemImage: ConstantSystemImage.favoriteFill) {
                favorite(item)
            }
            .foregroundStyle(.textFieldForeground)
            .tint(Color.warning)
            
            
            Button("Delete", systemImage: ConstantSystemImage.trash) {
                modelToDelete = item
                showAlertDelete = true
            }
            .tint(.alert)
        }
    }
    
    
    // MARK: FUNCTIONS
    
    private func favorite(_ model: TransactionModel) {
        Task {
            let result = await viewModel.favorite(model)
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func favoriteMultipleTransactions() {
        Task {
            let result = await viewModel.favoriteMltiple()
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func delete() {
        Task {
            defer {
                modelToDelete = nil
            }
            
            let result = await viewModel.delete(modelToDelete)
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func deleteMltipleTransactions() {
        Task {
            let result = await viewModel.deleteMltiple()
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
}

private struct TransactionPreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State private var transactionsLoaded: [TransactionModel] = []
    @State private var dateTimeInterval: DateTimeInterval = .month
    @State private var selectedDate: Date = .now
    @State private var isMultipleAccounts: Bool = false
    
    var body: some View {
        TransactionHistoryView(transactionsLoaded: $transactionsLoaded,
                               dateTimeInterval: $dateTimeInterval,
                               selectedDate: $selectedDate,
                               isMutipleAccounts: isMultipleAccounts)
        .task {
            transactionsLoaded = await MockTransactionModel.fetchAll()
            
            let count = await MockAccountModel.fetchAllCount()
            isMultipleAccounts = count > 1
        }
    }
}

#Preview("Normal es_CR") {
    NavigationStack {
        TransactionPreviewWrapper(.normal)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Random Saturated en_US") {
    TransactionPreviewWrapper(.saturated)
        .environment(\.locale, .init(identifier: "en_US"))
}

#Preview("Empty en_US_POSIX") {
    TransactionPreviewWrapper()
        .environment(\.locale, .init(identifier: "en_US_POSIX"))
}

#Preview("Navigation es_CR") {
    NavigationStack {
        TransactionPreviewWrapper(.normal)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}
