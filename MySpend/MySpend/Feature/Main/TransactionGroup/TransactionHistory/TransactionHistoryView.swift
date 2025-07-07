//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI
import CoreData

struct TransactionHistoryView: View {
    
    @StateObject var viewModel: TransactionHistoryViewModel
    
    @Binding var transactionsLoaded: [TransactionModel]
    @Binding var dateTimeInterval: DateTimeInterval
    @Binding var selectedDate: Date
    
    @State private var selectedModel = TransactionModel()
    
    init(transactionsLoaded: Binding<[TransactionModel]>,
         dateTimeInterval: Binding<DateTimeInterval>,
         selectedDate: Binding<Date>,
         viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {

        _transactionsLoaded = transactionsLoaded
        _dateTimeInterval = dateTimeInterval
        _selectedDate = selectedDate
        
        _viewModel = StateObject(wrappedValue: TransactionHistoryViewModel(viewContext: viewContext))
    }
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            showTrailingAction: true,
                            disabledTrailingAction: viewModel.isEditing,
                            trailingImage: Image.plus,
                            trailingAction: {
                viewModel.showNewTransactionModal = true
            })
            .padding(.bottom)
            
            ZStack {
                if transactionsLoaded.isEmpty {
                    emptyView
                } else {
                    transactionsList
                        .disabled(viewModel.isLoadingSecondary)
                }
            }
            
            
            TextError(viewModel.errorMessage)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
        .sheet(isPresented: $viewModel.showNewTransactionModal) {
            AddModifyTransactionView(selectedDate: $selectedDate)
        }
        .sheet(isPresented: $viewModel.showModifyTransactionModal) {
            AddModifyTransactionView(model: $selectedModel, selectedDate: $selectedModel.dateTransaction)
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
                            
                            Image(systemName: item.category.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: FrameSize.width.iconInsideTextField,
                                       height: FrameSize.height.iconInsideTextField)
                                .foregroundStyle(Color.textPrimaryForeground)
                            
                            
                            Button("") {
                                if viewModel.isEditing {
                                    if viewModel.selectedTransactions.contains(item) {
                                        viewModel.selectedTransactions.remove(item)
                                    } else {
                                        viewModel.selectedTransactions.insert(item)
                                    }
                                } else {
                                    selectedModel = item
                                    viewModel.showModifyTransactionModal = true
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                if item.notes.isEmptyOrWhitespace {
                                    TextPlain(item.category.name)
                                } else {
                                    TextPlain(item.notes)
                                }
                                
                                TextPlain(item.dateTransaction.toStringShortLocale, size: .small)
                            }
                            
                            Spacer()
                            
                            TextPlain(item.amount.convertAmountDecimalToString.addCurrencySymbol,
                                      color: item.category.type == .income ? Color.primaryLeading : Color.alert)
                            
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
                        .opacity(viewModel.isLoadingSecondary && selectedModel.id == item.id ? .zero : 1)
                        .overlay {
                            if viewModel.isLoadingSecondary && selectedModel.id == item.id { //TODO: Agregar loader para cuando son varias transacciones. Aqui solo aplica para una.
                                Loader()
                                    .foregroundColor(Color.primaryLeading)
                            }
                        }
                    }
                    .frame(height: FrameSize.height.rowForListTransactionHistory)
                    .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                    .listRowSeparatorTint(Color.textPrimaryForeground.opacity(ConstantColors.opacityHalf))
                    
                    // MARK: SWIPE ACTIONS:
                    
                    .swipeActions(edge: .trailing) {
                        Button {
                            selectedModel = item
                            viewModel.showAlertDelete = true
                        } label: {
                            Label.delete
                        }
                        .tint(Color.alert)
                        
                        Button {
                            selectedModel = item
                            viewModel.showModifyTransactionModal = true
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
        let result = viewModel.deleteTransaction(selectedModel)
        
        if result.status.isSuccess {
            selectedModel = TransactionModel() //Clean the selected transaction after deleting it.
        } else {
            viewModel.errorMessage = result.message
        }
    }
    
    private func deleteMltipleTransactions() {
        let result = viewModel.deleteMltipleTransactions()
        
        if result.status.isError {
            viewModel.errorMessage = result.message
        }
    }
}

//TOD: REPARAR
//#Preview("Normal es_CR") {
//    @Previewable @State var dateTimeInterval = DateTimeInterval.month
//    @Previewable @State var selectedDate = Date()
//    
//    VStack {
//        TransactionHistoryView(transactionsLoaded: .constant(MockTransactionsFB.normal), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
//            .environment(\.locale, .init(identifier: "es_CR"))
//    }
//}
//
//#Preview("Random saturated en_US") {
//    @Previewable @State var dateTimeInterval = DateTimeInterval.month
//    @Previewable @State var selectedDate = Date()
//    
//    VStack {
//        TransactionHistoryView(transactionsLoaded: .constant(MockTransactionsFB.random_generated), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
//            .environment(\.locale, .init(identifier: "en_US"))
//    }
//}

#Preview("No content en_US_POSIX") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant([]),
                               dateTimeInterval: $dateTimeInterval,
                               selectedDate: $selectedDate,
                               viewContext: MockTransaction.preview.container.viewContext)
            .environment(\.locale, .init(identifier: "en_US_POSIX"))
    }
}
