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
    @Binding var isMutipleAccounts: Bool
    
    @State private var showNewItemModal = false
    @State private var modelToModify: TransactionModel?
    @State private var modelToDelete: TransactionModel?
    
    var body: some View {
        ContentContainer {
            
            ZStack {
                if transactionsLoaded.isEmpty {
                    emptyView
                } else {
                    transactionsList
                }
            }
            
            
            TextError(viewModel.errorMessage)
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline) //TODO: CAMBIAR: El navegador de fechas va a ir abajo, entonces va a ponerse el titulo en grande al bajar.
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showNewItemModal = true
                } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewItemModal) {
            AddModifyTransactionView(selectedDate: selectedDate)
        }
        .sheet(item: $modelToModify) { model in
            AddModifyTransactionView(model)
                .onDisappear {
                    modelToModify = nil
                }
        }
    }
    
    // MARK: VIEWS
    
    private var emptyView: some View {
        VStack {
            Spacer()
            TextPlain("No transactions",
                      family: .semibold,
                      size: .bigXL,
                      aligment: .center)
            .padding(.vertical)
            Spacer()
        }
    }
    
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

    private var transactionsList: some View {
        VStack {
            DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                      selectedDate: $selectedDate,
                                      isEditing: $viewModel.isEditing,
                                      showEditor: true,
                                      counterSelected: viewModel.selectedTransactions.count) {
                
                viewModel.selectedTransactions.removeAll()
                
            } actionTrailingEdit: {
                viewModel.showAlertDeleteMultiple = true
                
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
            
            let transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate,
                                                                              transactions: transactionsLoaded,
                                                                              for: dateTimeInterval,
                                                                              sortTransactions: viewModel.sortTransactionsBy)
 
            List {
                ForEach(transactionsFiltered, id: \.self) { item in
                    VStack {
                        HStack {
                            if viewModel.isEditing {
                                Image(systemName: viewModel.selectedTransactions.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.height.selectIconInsideTextField,
                                           height: FrameSize.width.selectIconInsideTextField)
                                    .foregroundStyle(Color.alert)
                                    .transition(.scale.combined(with: .move(edge: .leading)))
                            }
                            
                            if let image = item.category.icon.getIconFromSFSymbol {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.width.iconInsideTextField,
                                           height: FrameSize.height.iconInsideTextField)
                                    .foregroundStyle(Color.textPrimaryForeground)
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
                            
                            Image.chevronRight
                                .foregroundStyle(Color.textPrimaryForeground)
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
                    .listRowSeparatorTint(Color.textPrimaryForeground.opacity(ConstantColors.opacityHalf))
                    
                    // MARK: SWIPE ACTIONS:
                    
                    .swipeActions(edge: .trailing) {
                        Button {
                            modelToDelete = item
                            viewModel.showAlertDelete = true
                        } label: {
                            Label.delete
                        }
                        .tint(Color.alert)
                        
                        Button {
                            modelToModify = item
                        } label: {
                            Label.edit
                        }
                        .tint(Color.warning)
                    }
                    
                    // MARK: DELETE TRANSACTION SINGLE
                    
                    .alert("Delete transaction", isPresented: $viewModel.showAlertDelete) {
                        Button("Delete", role: .destructive) { delete() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this transaction? \n This action cannot be undone.")
                    }
                    
                    // MARK: DELETE TRANSACTION MULTIPLE
                    
                    .alert("Delete transactions", isPresented: $viewModel.showAlertDeleteMultiple) {
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
            .animation(.default, value: transactionsFiltered.count)
            .animation(.default, value: viewModel.isEditing)
            .animation(.default, value: viewModel.sortTransactionsBy)
            
            TotalBalanceView(transactions: transactionsFiltered, showTotalBalance: false, addBottomSpacing: false)
        }
    }
    
    // MARK: FUNCTIONS
    
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
                               isMutipleAccounts: $isMultipleAccounts)
        .task {
            transactionsLoaded = await MockTransactionModel.fetchAll()
            
            let count = await MockAccountModel.fetchAllCount()
            isMultipleAccounts = count > 1
        }
    }
}

#Preview("Normal es_CR") {
    TransactionPreviewWrapper(.normal)
        .environment(\.locale, .init(identifier: "es_CR"))
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
