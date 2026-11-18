//
//  CreateTransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 4/11/26.
//

import SwiftUI

struct CreateTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TransactionManager.self) private var manager
    
    var selectedDate: Date
    
    @State private var transaction: TransactionModel
    @State private var amountString = ""
    @State private var type = CategoryType.expense
    
    @State private var toastResponse: ToastResponse?
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        _transaction = State(initialValue: TransactionModel(dateTransaction: selectedDate))
    }
    
    var body: some View {
        TransactionForm(transaction: $transaction, type: $type, amountString: $amountString) {
            
            Task {
                guard let amount = amountString.amountToDecimal, amount >= .zero else {
                    toastResponse = ToastResponse(.responseErrorInvalidAmount, .error)
                    return
                }
                
                transaction.amount = amount
                toastResponse = await manager.create(transaction)
                
                if toastResponse?.type != .error {
                    dismiss()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
            .navigationTitle(.transactionCreateTitle)
            .navigationBarTitleDisplayMode(.inline)
        
//            .safeAreaInset(edge: .bottom) {
//                Button {
//                    Task {
//                        guard let amount = amountString.amountToDecimal, amount >= .zero else {
//                            toastResponse = ToastResponse(.responseErrorInvalidAmount, .error)
//                            return
//                        }
//                        
//                        transaction.amount = amount
//                        toastResponse = await manager.create(transaction)
//                        
//                        if toastResponse?.type != .error {
//                            dismiss()
//                        }
//                    }
//                } label: {
//                    Text(.buttonSave)
//                        .padding(.vertical, ConstantViews.paddingButtonVertical)
//                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
//                }
//                .padding(.horizontal)
//                .buttonStyle(.glass)
//                .padding(.bottom)
//                .disabled(toastResponse != nil)
//            }
        
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button(role: .cancel) {
                        dismiss()
                    }
                }
            }
        
            .background {
                Color.backgroundGradient
                    .ignoresSafeArea(.container, edges: .all)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        
            .toast($toastResponse)
    }
}

#Preview(Previews.localeES) {
    
    @Previewable @State var transactionManager = TransactionManager(viewContext: MockDataType.normal.viewContext)
    @Previewable @State var accountManager = AccountManager(viewContext: MockDataType.normal.viewContext)
    @Previewable @State var categoryManager = CategoryManager(viewContext: MockDataType.normal.viewContext)
    
    @Previewable @State var currencyManager = CurrencyManager.shared
    
    @Previewable @State var selectedDate = Date.now
    
    NavigationStack {
        CreateTransactionView(selectedDate: selectedDate)
    }
    .environment(transactionManager)
    .environment(accountManager)
    .environment(categoryManager)
    .environment(currencyManager)
    .environment(\.locale, .init(identifier: Previews.localeES))
}
