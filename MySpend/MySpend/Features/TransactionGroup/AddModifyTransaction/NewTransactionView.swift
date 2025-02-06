//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct AddModifyTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var model: TransactionModel
    @StateObject var viewModel = NewTransactionViewModel()
    @FocusState private var focusedField: TransactionModel.Field?
    
    let isNewTransaction: Bool
    
    init(model: Binding<TransactionModel>? = nil, isNewTransaction: Bool = true) {
        if let model = model {
            self._model = model
        } else {
            var defaultModel = TransactionModel()
            self._model = Binding(
                get: { defaultModel },
                set: { defaultModel = $0 }
            )
        }
        self.isNewTransaction = isNewTransaction
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
                        PickerSegmented(selection: $model.transactionType,
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
                        TextFieldAmount(text: $viewModel.amountString,
                                        errorMessage: $viewModel.errorMessage)
                        .focused($focusedField, equals: .amount)
                        
                        
                        TextFieldReadOnlySelectable(placeHolder: "Category",
                                                    text: $model.category.name,
                                                    iconLeading: Image.stackFill,
                                                    colorDisabled: false,
                                                    errorMessage: $viewModel.errorMessage)
                        .onTapGesture {
                            focusedField = .none
                            viewModel.showCategoryList = true
                        }
                        
                        TextFieldNotes(text: $model.notes)
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
                        viewModel.onAppear(model)
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
                .onChange(of: model.transactionType) {
                    viewModel.errorMessage = ""
                    model.category = CategoryModel() //Clean category beacause won't be the same TransactionType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(model: $model,
                                        dateString: $viewModel.dateString,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: $model.category,
                                            categoryType: model.transactionType)
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
                result = await viewModel.addNewTransaction(model)
            case .modify:
                result = await viewModel.modifyTransaction(model)
            case .delete:
                result = await viewModel.deleteTransaction(model)
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
    
    AddModifyTransactionView(model: $model, isNewTransaction: false)
}
