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
    
    @State private var isEditing = false
    @State private var selectedItems = Set<TransactionModel>()
    
    var body: some View {
        ContentContainer {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if transactionsLoaded.isEmpty {
                emptyView
            } else {
                transactionsList
            }
            
            TextError(viewModel.errorMessage)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
        .sheet(isPresented: $viewModel.showModifyTransactionModal) {
            AddModifyTransactionView(model: $selectedModel, selectedDate: $selectedDate)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
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
                                      isEditing: $isEditing,
                                      showEditor: true)
            
            let transactionsFiltered = UtilsTransactions.filteredTransactions(selectedDate, transactions: transactionsLoaded, for: dateTimeInterval)
            
            List {
                ForEach(transactionsFiltered) { item in
                    VStack {
                        HStack {
                            Image(systemName: item.category.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: FrameSize.width.iconInsideTextField,
                                       height: FrameSize.width.iconInsideTextField)
                                .foregroundStyle(Color.textPrimaryForeground)
                            
                            
                            Button("") {
                                selectedModel = item
                                viewModel.showModifyTransactionModal = true
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
                    }
                    .alert("Delete transaction", isPresented: $viewModel.showAlertDelete) {
                        Button("Delete", role: .destructive) { delete() }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this transaction? \n This action cannot be undone.")
                    }
                    .padding(.vertical, ConstantViews.mediumSpacing)
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .animation(.default, value: transactionsFiltered.count)
            
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
