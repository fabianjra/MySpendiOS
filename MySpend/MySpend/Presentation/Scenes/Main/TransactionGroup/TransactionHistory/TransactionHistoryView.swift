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
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if transactionsLoaded.isEmpty {
                emptyView
            } else {
                transactionsList
            }
            
            TextError(viewModel.errorMessage)
                .padding(.bottom)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
        .sheet(isPresented: $viewModel.showModifyTransactionModal) {
            ModifyTransactionView(modelLoaded: $selectedModel)
                .presentationDragIndicator(.visible)
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
            DateIntervalNavigatorView(dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            
            let viewModelFiltered = UtilsTransactions.filteredTransactions(selectedDate, transactions: transactionsLoaded, for: dateTimeInterval)
            
            if viewModelFiltered.isEmpty {
                emptyView
            } else {
                List {
                    ForEach(viewModelFiltered) { item in
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
                                    if item.notes.isEmptyOrWhitespace(){
                                        TextPlain(item.category.name)
                                    } else {
                                        TextPlain(item.notes)
                                    }
                                    
                                    TextPlain(item.dateTransaction.toStringShortLocale(), size: .small)
                                }
                                
                                Spacer()
                                
                                TextPlain(item.amount.convertAmountDecimalToString().addCurrencySymbol(),
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
                        .padding(.vertical, ConstantViews.mediumSpacing)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .animation(.default, value: viewModelFiltered.count)
            }
            
            TotalBalanceView(transactions: .constant(viewModelFiltered), showTotalBalance: false, addBottomSpacing: false)
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

#Preview("With Content es_CR") {
    @Previewable @State var array = [TransactionModel(id: UUID().uuidString,
                                                      amount: 100,
                                                      dateTransaction: Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.bills.list[0],
                                                                              name: "Gasolina",
                                                                              categoryType: .expense),
                                                      notes: "",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 200,
                                                      dateTransaction: .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.bills.list[1],
                                                                              name: "Comida",
                                                                              categoryType: .expense),
                                                      notes: "Fue un almuerzo de trabajo",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 50,
                                                      dateTransaction: Calendar.current.date(byAdding: .day, value: 13, to: Date()) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.foodAndDrink.list[0],
                                                                              name: "Comida",
                                                                              categoryType: .expense),
                                                      notes: "",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 50,
                                                      dateTransaction: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.household.list[0],
                                                                              name: "Gasolina",
                                                                              categoryType: .expense),
                                                      notes: "",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 50,
                                                      dateTransaction: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 11)) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.household.list[0],
                                                                              name: "Gasolina",
                                                                              categoryType: .expense),
                                                      notes: "",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 50,
                                                      dateTransaction: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 18)) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.household.list[0],
                                                                              name: "Gasolina",
                                                                              categoryType: .expense),
                                                      notes: "",
                                                      transactionType: .expense),
                                     TransactionModel(id: UUID().uuidString,
                                                      amount: 500,
                                                      dateTransaction: Calendar.current.date(from: DateComponents(year: 2024, month: 11, day: 1)) ?? .now,
                                                      category: CategoryModel(id: UUID().uuidString,
                                                                              icon: CategoryIcons.foodAndDrink.list[0],
                                                                              name: "Recarga",
                                                                              categoryType: .income),
                                                      notes: "",
                                                      transactionType: .income)]
    
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: $array, dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Saturated Content EN") {
    
    @Previewable @State var array: [TransactionModel] = (1...Int.random(in:10...40)).map { item in
        
        TransactionModel(id: UUID().uuidString,
                         amount: Decimal(Double.random(in: 10.99...7456825682.99)),
                         dateTransaction: .now,
                         category: CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.bills.list.randomElement()!,
                                                 name: "nombre categoria - CategoryModel",
                                                 categoryType: .expense),
                         notes: "",
                         transactionType: .expense)
    }
    
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: $array, dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "en_US"))
    }
}

#Preview("No content EN") {
    @Previewable @State var dateTimeInterval = DateTimeInterval.month
    @Previewable @State var selectedDate = Date()
    
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant([]), dateTimeInterval: $dateTimeInterval, selectedDate: $selectedDate)
            .environment(\.locale, .init(identifier: "en_US_POSIX"))
    }
}
