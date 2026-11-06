//
//  AddModifyTransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct UpdateTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(TransactionManager.self) private var manager
    
    @Binding var transaction: TransactionModel
    
    @State private var type: CategoryType
    @State private var amountString: String
    
    @State private var showAlert = false
    @State private var toastResponse: ToastResponse?
    
    
    init(transaction: Binding<TransactionModel>) {
        self._transaction = transaction
        self._type = State(initialValue: transaction.wrappedValue.category.type)
        self._amountString = State(initialValue: transaction.wrappedValue.amount.convertAmountDecimalToString)
    }
    
    var body: some View {
        
        //TODO: El type se esta seteando a Income cuando es una transaccion income, entonces el textField de categoria queda en blanco.
        //TODO: La cuenta no esta siendo seleccionada correctamente.
        TransactionForm(transaction: $transaction, type: $type, amountString: $amountString)
        
            .navigationTitle(.transactionUpdateTitle)
            .navigationBarTitleDisplayMode(.inline)
        
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        Task {
                            guard let amount = amountString.convertAmountToDecimal, amount >= .zero else {
                                toastResponse = ToastResponse(.responseErrorInvalidAmount, .error)
                                return
                            }
                            
                            transaction.amount = amount
                            toastResponse = await manager.update(transaction)
                            
                            if toastResponse?.type == .ok {
                                dismiss()
                            }
                        }
                    } label: {
                        Text(.buttonSave)
                            .padding(.vertical, ConstantViews.paddingButtonVertical)
                            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    }
                    .padding(.horizontal)
                    .buttonStyle(.glass)
                    .padding(.bottom)
                    .disabled(toastResponse != nil)
                    
                    Button(.alertOptionDelete, role: .destructive) {
                        showAlert = true
                    }
                    .padding(.bottom)
                }
                
                .alert(.transactionDelete(.zero), isPresented: $showAlert) {
                    Button(.alertOptionDelete, role: .destructive) {
                        Task {
                            toastResponse = await manager.delete(transaction)
                            
                            if toastResponse?.type == .ok {
                                dismiss()
                            }
                        }
                    }
                    
                    Button(.alertOptionCancel, role: .cancel) { }
                } message: {
                    Text(.transactionDeleteMessage(.zero))
                }
            }
        
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
    
    @Previewable @State var manager = TransactionManager.shared
    @Previewable @State var accountManager = AccountManager.shared
    @Previewable @State var categoryManager = CategoryManager.shared
    
    @Previewable @State var transaction = TransactionModel()
//    @Previewable @State var type: CategoryType
    
    NavigationStack {
        UpdateTransactionView(transaction: $transaction)
    }
    .environment(manager)
    .environment(accountManager)
    .environment(categoryManager)
    .environment(\.locale, .init(identifier: Previews.localeES))
}
