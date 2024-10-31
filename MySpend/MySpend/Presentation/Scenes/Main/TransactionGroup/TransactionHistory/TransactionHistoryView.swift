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
    @State private var selectedModel: TransactionModel?
    
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
            ModifyTransactionView(modelLoaded: $viewModel.transactionToModify)
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
            .padding(.bottom)
            //.colorMultiply(.primaryLeading)
            
            //TODO: Refactorizar para poder navegar entre años tambien, al pasar de diciembre.
            ButtonSelectValueInterval(viewModel.monthSymbols[viewModel.selectedMonth]) {
                if viewModel.selectedMonth > 0 {
                    viewModel.selectedMonth -= 1
                }
                
            } actionCenter: {
                
            } actionLeading: {
                if viewModel.selectedMonth < 11 {
                    viewModel.selectedMonth += 1
                }
            }
            .padding(.bottom)
            
            
            VStack {
                let viewModelSorted = transactionsLoaded
                    .filter { Calendar.current.component(.month, from: $0.dateTransaction) == viewModel.selectedMonth + 1 }
                    .sorted(by: { $0.dateTransaction > $1.dateTransaction })
                
                List {
                    ForEach(viewModelSorted) { item in
                        VStack {
                            HStack {
                                Image(systemName: item.category.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.width.iconInsideTextField,
                                           height: FrameSize.width.iconInsideTextField)
                                    .foregroundStyle(Color.textPrimaryForeground)
                                
                                
                                Button("") {
                                    viewModel.transactionToModify = item
                                    viewModel.showModifyTransactionModal = true
                                }
                                
                                VStack(alignment: .leading) {
                                    TextPlain(message: item.category.name)
                                    TextPlain(message: item.dateTransaction.toStringShortLocale(), size: .small)
                                }
                                
                                Spacer()
                                
                                TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol())
                                    .padding(.trailing, ConstantViews.mediumSpacing)
                                
                                Image.chevronRight
                                    .foregroundStyle(Color.textPrimaryForeground)
                            }
                            
                            DividerView()
                                .opacity(ConstantColors.opacityHalf)
                        }
                        .frame(height: FrameSize.height.rowForListTransactionHistory)
                        .swipeActions(edge: .trailing) {
                            Button {
                                selectedModel = item
                                viewModel.showAlertDelete = true
                            } label: {
                                Label.delete
                            }
                            .tint(Color.warning)
                        }
                        .alert("Delete category", isPresented: $viewModel.showAlertDelete) {
                            Button("Delete", role: .destructive) { delete() }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Want to delete this category? \n This action cannot be undone.")
                        }
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
            }
        }
    }
    
    private func delete() {
        Task {
            if let selectedModel {
                let result = await viewModel.deleteTransaction(selectedModel)
                
                if result.status.isError {
                    viewModel.errorMessage = result.message
                }
            }
        }
    }
}

#Preview("With Content ES") {
    
    @Previewable @State var array = [TransactionModel(id: "01",
                                  amount: 100,
                                  dateTransaction: .now,
                                  category: CategoryModel(id: "01", icon: CategoryIcons.bills.list[0], name: "Gasolina", categoryType: .expense),
                                  notes: "Nota",
                                  transactionType: .expense),
                 TransactionModel(id: "02",
                                  amount: 200,
                                  dateTransaction: .now + 1,
                                  category: CategoryModel(id: "02", icon: CategoryIcons.bills.list[1],name: "Comida", categoryType: .expense),
                                  notes: "Nota",
                                  transactionType: .expense),
                 TransactionModel(id: "03",
                                  amount: 50,
                                  dateTransaction: .now + 2,
                                  category: CategoryModel(id: "02", icon: CategoryIcons.foodAndDrink.list[0],name: "Comida", categoryType: .expense),
                                  notes: "Nota",
                                  transactionType: .expense),
                 TransactionModel(id: "04",
                                  amount: 50,
                                  dateTransaction: .now + 3,
                                  category: CategoryModel(id: "01", icon: CategoryIcons.household.list[0],name: "Gasolina", categoryType: .expense),
                                  notes: "Nota",
                                  transactionType: .expense),
                 TransactionModel(id: "05",
                                  amount: 5000,
                                  dateTransaction: .now + 4,
                                  category: CategoryModel(id: "03", icon: CategoryIcons.household.list[1],name: "Recarga saldo", categoryType: .income),
                                  notes: "Nota",
                                  transactionType: .income)]
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
