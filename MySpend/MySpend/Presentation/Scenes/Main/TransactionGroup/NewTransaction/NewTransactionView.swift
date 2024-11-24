//
//  ModalNewTransaction.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI

struct NewTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = NewTransactionViewModel()
    @FocusState private var focusedField: TransactionModel.Field?
    
    private let notesId = "notes"
    
    var body: some View {
        NavigationStack { // This is needed for showing toolBar Keyboard.
            ScrollViewReader { scrollViewProxy in
                FormContainer {
                    
                    HeaderNavigator(title: "New transaction",
                                    titleWeight: .regular,
                                    titleSize: .bigXL,
                                    subTitle: "Enter transation details",
                                    showLeadingAction: false,
                                    showTrailingAction: true)
                    .padding(.vertical)
                    
                    
                    // MARK: SEGMENT
                    VStack {
                        PickerSegmented(selection: $viewModel.model.transactionType,
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
                                                    text: $viewModel.model.category.name,
                                                    iconLeading: Image.stackFill,
                                                    colorDisabled: false,
                                                    errorMessage: $viewModel.errorMessage)
                        .onTapGesture {
                            focusedField = .none
                            viewModel.showCategoryList = true
                        }
                        
                        TextFieldNotes(text: $viewModel.model.notes)
                            .id(notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom)
                    }
                    
                    
                    // MARK: BUTTONS
                    VStack {
                        Button("Add") {
                            process()
                        }
                        .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                        .padding(.vertical)
                        .padding(.bottom)
                        
                        
                        TextError(viewModel.errorMessage)
                    }
                    
                    Spacer()
                }
                .onChange(of: focusedField) { _, newFocusedField in
                    if focusedField == .notes {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation {
                                scrollViewProxy.scrollTo(notesId, anchor: .bottom)
                            }
                            
                        }
                    }
                }
                .onChange(of: viewModel.model.transactionType) {
                    viewModel.errorMessage = ""
                    viewModel.model.category = CategoryModel() //Clean category beacause won't be the same TransactionType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(model: $viewModel.model,
                                        dateString: $viewModel.dateString,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: $viewModel.model.category,
                                            categoryType: viewModel.model.transactionType)
                }
            }
        }
        .disabled(viewModel.isLoading)
    }

    private func process() {
        Task {
            let result = await viewModel.addNewTransaction()
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview {
    NewTransactionView()
}
