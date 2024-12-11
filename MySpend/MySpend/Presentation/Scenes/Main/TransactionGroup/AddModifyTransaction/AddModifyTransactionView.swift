//
//  AddModifyTransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

/**
 This view can be instantiated with a model or without a model.
 Pass a model of type `TransactionModel` if you want to modify something on it, eg: when you want to modify a transaction.
 If you don't pass a model by parameter, the `bool` let `isNewTransaction` will be set to true, because will use an internal @State model inside to
 manage the model data in the view and no the Binding model used for paraemter.
 
 - Parameters:
    - model: This model shoulb be passed only when you want to modify something in the model already loaded.

 - Date: December 2024
 */
struct AddModifyTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var model: TransactionModel
    @State private var defaultModel = TransactionModel()
    
    @StateObject var viewModel = AddModifyTransactionViewModel()
    @FocusState private var focusedField: TransactionModel.Field?
    
    private let isNewTransaction: Bool
    
    var modelBinding: Binding<TransactionModel> {
        Binding(
            get: { isNewTransaction ? defaultModel : model }, /// Use defaultModel when is a New Transaction
            set: { newValue in
                if isNewTransaction {
                    defaultModel = newValue /// Get the default model when is a new transaction.
                } else {
                    model = newValue /// Use the model passed by parameter when is a Modify Transaction.
                }
            }
        )
    }
    
    /// Way to initialize a Binding if you want to pass a value (model) or just initialize the model with default valures.
    init(model: Binding<TransactionModel>? = nil) {
        if let model = model {
            self.isNewTransaction = false
            self._model = model
        } else {
            /// In case a model is no passed by parameter, wont be use model. Will use defaultModel instead.
            self.isNewTransaction = true
            self._model = .constant(TransactionModel())
        }
        //self.isNewTransaction = isNewTransaction
    }
    
    var body: some View {
        NavigationStack { // This is needed for showing toolBar Keyboard.
            ScrollViewReader { scrollViewProxy in
                FormContainer {
                    
                    HeaderNavigator(title: isNewTransaction ? "New transaction" : "Modify transaction",
                                    titleWeight: .regular,
                                    titleSize: isNewTransaction ? .bigXL : .bigL,
                                    subTitle: isNewTransaction ? "Enter transation details" : "Modify transaction details",
                                    showLeadingAction: false,
                                    showTrailingAction: true)
                    .padding(.vertical)
                    
                    
                    // MARK: SEGMENT
                    VStack {
                        PickerSegmented(selection: modelBinding.transactionType,
                                        segments: TransactionType.allCases)
                        .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    VStack {
                        TextFieldReadOnly(text: $viewModel.dateString,
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
                            focusedField = .none
                            viewModel.showDatePicker = true
                        }
                    }
                    
                    
                    // MARK: TEXTFIELDS
                    VStack {
                        TextFieldAmount(text: $viewModel.amountString)
                            .focused($focusedField, equals: .amount)
                        
                        
                        TextFieldReadOnlySelectable(placeHolder: "Category",
                                                    text: modelBinding.category.name,
                                                    iconLeading: Image.stackFill,
                                                    colorDisabled: false,
                                                    errorMessage: $viewModel.errorMessage)
                        .onTapGesture {
                            focusedField = .none
                            viewModel.showCategoryList = true
                        }
                        
                        TextFieldNotes(text: modelBinding.notes)
                            .id(viewModel.notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom)
                    }
                    
                    
                    // MARK: BUTTONS
                    VStack {
                        Button(isNewTransaction ? "Add" : "Modify") {
                            process(isNewTransaction ? .add : .modify)
                        }
                        .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                        .padding(.vertical)
                        
                        if isNewTransaction == false {
                            Button("Delete") {
                                viewModel.showAlert = true
                            }
                            .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold, isLoading: $viewModel.isLoadingSecondary))
                            .alert("Delete transaction", isPresented: $viewModel.showAlert) {
                                Button("Delete", role: .destructive) { process(.delete) }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete this transaction? \n This action cannot be undone.")
                            }
                        }
                        
                        TextError(viewModel.errorMessage)
                    }
                    
                    Spacer()
                }
                .onAppear {
                    if isNewTransaction == false {
                        viewModel.onAppear(modelBinding.wrappedValue)
                    }
                }
                .onChange(of: focusedField) { _, newFocusedField in
                    if focusedField == .notes {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.notesId, anchor: .bottom)
                            }
                            
                        }
                    }
                }
                .onChange(of: modelBinding.wrappedValue.transactionType) {
                    viewModel.errorMessage = ""
                    modelBinding.wrappedValue.category = CategoryModel() //Clean category beacause won't be the same TransactionType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(model: modelBinding,
                                        dateString: $viewModel.dateString,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: modelBinding.category,
                                            categoryType: modelBinding.wrappedValue.transactionType)
                }
            }
        }
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process(_ processType: ProcessType) {
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNewTransaction(modelBinding.wrappedValue)
            case .modify:
                result = await viewModel.modifyTransaction(modelBinding.wrappedValue)
            case .delete:
                result = await viewModel.deleteTransaction(modelBinding.wrappedValue)
            }
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("New") {
    AddModifyTransactionView()
}

#Preview("Modify") {
    @Previewable @State var model = MockTransactions.normal.first!
    
    AddModifyTransactionView(model: $model)
}
