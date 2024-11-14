//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @Binding var transactionsLoaded: [TransactionModel]
    @StateObject var viewModel = TransactionHistoryViewModel()
    @State private var selectedModel = TransactionModel()
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding()
            
            if transactionsLoaded.isEmpty {
                emptyView
            } else {
                transactionsList
            }
            
            TextError(message: viewModel.errorMessage)
                .padding(.bottom)
        }
        .onAppear {
            print("Router count HISTORY: \(Router.shared.path.count)")
        }
        .sheet(isPresented: $viewModel.showModifyTransactionModal) {
            ModifyTransactionView(modelLoaded: $selectedModel)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
    
    var emptyView: some View {
        VStack {
            Spacer()
            TextPlain(message: "No transactions",
                      family: .semibold,
                      size: .bigXL,
                      aligment: .center)
            .padding(.vertical)
            Spacer()
        }
    }
    
    var transactionsList: some View {
        VStack {
            
            Picker("Time interval", selection: $viewModel.dateTimeInvertal) {
                ForEach(DateTimeInterval.allCases) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            //.colorMultiply(.primaryLeading)
            
            /// Navigate between days, weeks, months and years
            if viewModel.dateTimeInvertal == .day {
                let header = viewModel.selectedDate.formatted(.dateTime.day().month().year())
                
                ButtonSelectValueInterval(header) {
                    viewModel.adjustselectDate(by: .day, value: -1)
                } actionCenter: {
                    viewModel.selectedDate = .now
                } actionLeading: {
                    viewModel.adjustselectDate(by: .day, value: 1)
                }
                
            } else if viewModel.dateTimeInvertal == .week {
                if let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: viewModel.selectedDate) {
                    let startOfWeek = weekInterval.start
                    let endOfWeekSunday = Calendar.current.date(byAdding: .second, value: -1, to: weekInterval.end) ?? weekInterval.end
                        
                    let isSameMonth = Calendar.current.isDate(startOfWeek, equalTo: endOfWeekSunday, toGranularity: .month)
                    
                    
                    let header = startOfWeek.formatted(isSameMonth ? .dateTime.day() : .dateTime.day().month()) + " - " + endOfWeekSunday.formatted(.dateTime.day().month())
                    
                    ButtonSelectValueInterval(header) {
                        viewModel.adjustselectDate(by: .weekOfYear, value: -1)
                    } actionCenter: {
                        viewModel.selectedDate = .now
                    } actionLeading: {
                        viewModel.adjustselectDate(by: .weekOfYear, value: 1)
                    }
                    
                } else {
                    let header = viewModel.selectedDate.formatted(.dateTime.week())
                    
                    ButtonSelectValueInterval(header) {
                        viewModel.adjustselectDate(by: .weekOfYear, value: -1)
                    } actionCenter: {
                        viewModel.selectedDate = .now
                    } actionLeading: {
                        viewModel.adjustselectDate(by: .weekOfYear, value: 1)
                    }
                }
                
            } else if viewModel.dateTimeInvertal == .month {
                let header = viewModel.selectedDate.formatted(.dateTime.month().year())
                
                ButtonSelectValueInterval(header) {
                    viewModel.adjustselectDate(by: .month, value: -1)
                } actionCenter: {
                    viewModel.selectedDate = .now
                } actionLeading: {
                    viewModel.adjustselectDate(by: .month, value: 1)
                }
                
            } else if viewModel.dateTimeInvertal == .year {
                let header = viewModel.selectedDate.formatted(.dateTime.year())
                
                ButtonSelectValueInterval(header) {
                    viewModel.adjustselectDate(by: .year, value: -1)
                } actionCenter: {
                    viewModel.selectedDate = .now
                } actionLeading: {
                    viewModel.adjustselectDate(by: .year, value: 1)
                }
            }
            
            VStack {
                let viewModelFiltered = viewModel.filteredTransactions(transactionsLoaded, for: viewModel.dateTimeInvertal)
                
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
                                        TextPlain(message: item.category.name)
                                    } else {
                                        TextPlain(message: item.notes)
                                    }
                                    
                                    TextPlain(message: item.dateTransaction.toStringShortLocale(), size: .small)
                                }
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol())
                                    .padding(.trailing, ConstantViews.mediumSpacing)
                                
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
                            .padding(.horizontal)
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
                .animation(.default, value: viewModelFiltered.count)
            }
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

#Preview("With Content ES") {
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
                                                      transactionType: .expense)]
    VStack {
        TransactionHistoryView(transactionsLoaded: $array)
            .environment(\.locale, .init(identifier: "es"))
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
    
    VStack {
        TransactionHistoryView(transactionsLoaded: $array)
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content EN") {
    VStack {
        TransactionHistoryView(transactionsLoaded: .constant([]))
            .environment(\.locale, .init(identifier: "en"))
    }
}
