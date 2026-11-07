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
    
    @State private var transaction: TransactionModel
    @State private var type: CategoryType
    @State private var amountString: String
    
    @State private var showAlert = false
    @State private var toastResponse: ToastResponse?
    
    
    /**
     Inicializa la vista con una copia independiente de la transacción utilizando @State.
     
     Se evita utilizar @Binding porque los cambios realizados en el formulario
     se propagarían inmediatamente a la vista padre, incluso si el usuario cancela
     la edición sin guardar, conservando modificaciones no deseadas en memoria.
     
     Como TransactionModel es un struct, @State permite modificar una copia local
     sin afectar el modelo original.
     
     Si el usuario cancela, los cambios se descartan. Si confirma, las modificaciones
     se guardan en Core Data.
     */
    init(transaction: TransactionModel) {
        _transaction = State(initialValue: transaction)
        self._type = State(initialValue: transaction.category.type)
        self._amountString = State(initialValue: transaction.amount.amountToString)
    }
    
    var body: some View {
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


private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .normal, isFilterActive: Bool = false) {
        _manager = State(initialValue: TransactionManager(viewContext: mockDataType.viewContext))
        _accountManager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
        _categoryManager = State(initialValue: CategoryManager(viewContext: mockDataType.viewContext))
    }
    
    @State var manager: TransactionManager
    @State var accountManager: AccountManager
    @State var categoryManager: CategoryManager
    
    @State var transaction = TransactionModel()
    @State var isPresented = false
    
    var body: some View {
        VStack {
            List(manager.filteredAndSortedTransactions(by: .month, selectedDate: .now)) { item in
                Button(item.category.name) {
                    self.transaction = item
                    isPresented = true
                }
            }
        }
        .onChange(of: manager.filteredAndSortedTransactions(by: .month, selectedDate: .now), initial: true) { _, items in
            guard let firstItem = items.first else {
                return
            }
            
            transaction = firstItem
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                UpdateTransactionView(transaction: transaction)
            }
        }
        .environment(manager)
        .environment(accountManager)
        .environment(categoryManager)
    }
}

#Preview(Previews.localeES_CR) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview(Previews.localeEN) {
    PreviewWrapper()
        .environment(\.locale, .init(identifier: Previews.localeEN))
}
