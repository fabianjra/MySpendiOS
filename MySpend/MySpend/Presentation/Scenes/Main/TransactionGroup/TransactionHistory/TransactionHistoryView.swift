//
//  TransactionHistoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/8/24.
//

import SwiftUI

struct TransactionHistoryView: View {
    
    @ObservedObject var viewModel: TransactionHistoryViewModel
    
    var body: some View {
        ContentContainer {

            HeaderNavigator(title: "History",
                            titleWeight: .regular,
                            titleSize: .bigXL)
            .padding(.bottom)
            
            if viewModel.transactions.isEmpty {
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
            .padding(.bottom)
            //.colorMultiply(.primaryLeading)
            
            TextPlain(message: "Fecha filtrada")
            
            ButtonSelectValueInterval(viewModel.dateTimeInvertal.today) {
                
            } actionCenter: {
                
            } actionLeading: {
                
            }
            .padding(.bottom)

            
            ScrollView(showsIndicators: false) {
                ForEach(viewModel.transactions.sorted(by: { $0.dateTransaction > $1.dateTransaction })) { item in
                    VStack {
                        HStack {
                            Image(systemName: item.category.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: FrameSize.width.iconInsideTextField,
                                       height: FrameSize.width.iconInsideTextField)
                                .foregroundStyle(Color.textPrimaryForeground)
                            
                            VStack(alignment: .leading) {
                                TextPlain(message: item.category.name)
                                TextPlain(message: item.dateTransaction.toStringShortLocale(), size: .small)
                            }
                            
                            Spacer()
                            
                            TextPlain(message: item.amount.convertAmountDecimalToString().addCurrencySymbol())
                        }
                        .padding(.vertical, ConstantViews.minimumSpacing)
                        
                        DividerView()
                            .opacity(ConstantColors.opacityHalf)
                    }
                    .contentShape(Rectangle()) // For the Spacers() to be also Touchables.
                    
                    //TODO: Implementar el swipeAction con LIST.
//                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
//                        Button {
//                            
//                        } label: {
//                            Label("Delete", systemImage: "trash")
//                        }
//                        .tint(Color.warning)
//                    }
                    .onTapGesture {
                        viewModel.transactionToModify = item
                        viewModel.showModifyTransactionModal = true
                    }
                }
            }
        }
    }
}

#Preview("With Content ES") {
    VStack {
        let array = [TransactionModel(id: "01",
                                      amount: 100,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01", icon: CategoryIcons.bills.list[0], name: "Gasolina", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "02",
                                      amount: 200,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02", icon: CategoryIcons.bills.list[1],name: "Comida", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "03",
                                      amount: 50,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "02", icon: CategoryIcons.foodAndDrink.list[0],name: "Comida", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "04",
                                      amount: 50,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "01", icon: CategoryIcons.household.list[0],name: "Gasolina", categoryType: .expense),
                                      notes: "Nota",
                                      transactionType: .expense),
                     TransactionModel(id: "05",
                                      amount: 5000,
                                      dateTransaction: .now,
                                      category: CategoryModel(id: "03", icon: CategoryIcons.household.list[1],name: "Recarga saldo", categoryType: .income),
                                      notes: "Nota",
                                      transactionType: .income)]
        
        TransactionHistoryView(viewModel: TransactionHistoryViewModel(transactions: array))
            .environment(\.locale, .init(identifier: "es"))
    }
}

#Preview("No content EN") {
    VStack {
        TransactionHistoryView(viewModel: TransactionHistoryViewModel())
            .environment(\.locale, .init(identifier: "en"))
    }
}
