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
    
    @State private var selectedModel = TransactionModel()
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            showTrailingAction: true,
                            trailingImage: Image.plus,
                            trailingAction: {
                viewModel.showNewTransactionModal = true
            })
            .padding(.bottom)
            
            ZStack {
                if viewModel.isLoadingSecondary {
                    //TODO: TEMPORAL. ANALIZAR SI SE PUEDE UTILIZAR LOADER DE OTRA FORMA.
                    LoaderView()
                        .background(.ultraThinMaterial)
                        .cornerRadius(ConstantRadius.corners)
                        .padding(48)
                        .frame(maxHeight: 330, alignment: .center)
                }
                
                if transactionsLoaded.isEmpty {
                    emptyView
                } else {
                    transactionsList
                        .blur(radius: viewModel.isLoadingSecondary ? 1 : .zero)
                }
            }
            
            
            TextError(viewModel.errorMessage)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
        .sheet(isPresented: $viewModel.showModifyTransactionModal) {
            AddModifyTransactionView(model: $selectedModel, selectedDate: $selectedModel.dateTransaction)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .disabled(viewModel.isLoadingSecondary)
    }
    
    var menuSort: some View {
        Section("Sort by") {
            Button {
                if viewModel.sortTransactionsBy == .byDateNewest {
                    viewModel.sortTransactionsBy = .byDateOldest
                } else {
                    viewModel.sortTransactionsBy = .byDateNewest
                }
            } label: {
                viewModel.sortTransactionsBy == .byDateNewest ? Label.dateOldestFirst : Label.dateNewestFirst
            }
            
            Button {
                if viewModel.sortTransactionsBy == .byAmountHigher {
                    viewModel.sortTransactionsBy = .byAmountLower
                } else {
                    viewModel.sortTransactionsBy = .byAmountHigher
                }
            } label: {
                viewModel.sortTransactionsBy == .byAmountHigher ? Label.amountLowestFirst : Label.amountHighesttFirst
            }
            
            Button {
                if viewModel.sortTransactionsBy == .byCategoryNameAz {
                    viewModel.sortTransactionsBy = .byCategoryNameZa
                } else {
                    viewModel.sortTransactionsBy = .byCategoryNameAz
                }
            } label: {
                viewModel.sortTransactionsBy == .byCategoryNameAz ? Label.categoryNameZa : Label.categoryNameAz
            }
        }
    }
    
    var emptyView: some View {
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
    
    var transactionsList: some View {
        VStack {
            
            DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval,
                                      selectedDate: $selectedDate,
                                      isEditing: $viewModel.isEditing,
                                      showEditor: true,
                                      trailingButtonDisabled: viewModel.selectedListItems.isEmpty,
                                      counterSelected: viewModel.selectedListItems.count) {
                viewModel.selectedListItems.removeAll()
            } actionTrailingEdit: {
                viewModel.showAlertDeleteMultiple = true
            } contentLeadingSort: {
                menuSort
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
                                Image(systemName: viewModel.selectedListItems.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .foregroundStyle(Color.alert)
                                    .transition(.scale.combined(with: .move(edge: .leading)))
                            }
                            
                            Image(systemName: item.category.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: FrameSize.width.iconInsideTextField,
                                       height: FrameSize.width.iconInsideTextField)
                                .foregroundStyle(Color.textPrimaryForeground)
                            
                            
                            Button("") {
                                if viewModel.isEditing {
                                    if viewModel.selectedListItems.contains(item) {
                                        viewModel.selectedListItems.remove(item)
                                    } else {
                                        viewModel.selectedListItems.insert(item)
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
                                      color: item.transactionType == .income ? Color.primaryLeading : Color.alert)
                            
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
                    .alert("Delete transaction", isPresented: $viewModel.showAlertDelete) {
                        Button("Delete", role: .destructive) { delete() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this transaction? \n This action cannot be undone.")
                    }
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
    
    private func delete() {
        Task {
            let result = await viewModel.deleteTransaction(selectedModel)
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func deleteMltipleTransactions() {
        Task {
            let result = await viewModel.deleteMltipleTransactions()
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("Normal es_CR") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant(MockTransactions.normal), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Random saturated en_US") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant(MockTransactions.random_generated), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "en_US"))
    }
}

#Preview("No content en_US_POSIX") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant([]), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "en_US_POSIX"))
    }
}
