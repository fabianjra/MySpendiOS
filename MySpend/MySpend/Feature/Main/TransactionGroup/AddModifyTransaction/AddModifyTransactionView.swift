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
    - model: This model should be passed only when you want to modify something in the model already loaded.

 - Date: December 2024
 */
struct AddModifyTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: AddModifyTransactionViewModel
    @FocusState private var focusedField: TransactionModel.Field?
    
    @State private var categoryType: CategoryType = .expense
    
    init(_ model: TransactionModel? = nil, selectedDate: Date? = nil) {
        _viewModel = StateObject(wrappedValue: AddModifyTransactionViewModel(model, selectedDate: selectedDate))
    }

    var body: some View {
        NavigationStack { // This is needed for showing toolBar Keyboard.
            ScrollViewReader { scrollViewProxy in
                FormContainer {
                    
                    HeaderNavigator(title: viewModel.isNewTransaction ? "New transaction" : "Modify transaction",
                                    titleWeight: .regular,
                                    titleSize: viewModel.isNewTransaction ? .bigXL : .bigL,
                                    subTitle: viewModel.isNewTransaction ? "Enter transation details" : "Modify transaction details",
                                    showLeadingAction: false,
                                    showTrailingAction: true)
                    .padding(.vertical)
                    
                    
                    // MARK: SEGMENT
                    VStack {
                        PickerCategoryType(selection: $categoryType,
                                        segments: CategoryType.allCases)
                        .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    VStack {
                        TextFieldReadOnly(text: .constant(viewModel.model.dateTransaction.toStringShortLocale),
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
                            .toolbar {
                                if focusedField == .amount {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        
                                        Button("Done") {
                                            focusedField = .none
                                        }
                                    }
                                }
                            }
                        
                        
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
                            .id(viewModel.notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom)
                    }
                    
                    
                    // MARK: BUTTONS
                    VStack {
                        Button(viewModel.isNewTransaction ? "Add" : "Modify") {
                            process(viewModel.isNewTransaction ? .add : .modify)
                        }
                        .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                        .padding(.vertical)
                        
                        if viewModel.isNewTransaction == false {
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
                .onChange(of: focusedField) { _, newFocusedField in
                    if focusedField == .notes {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.notesId, anchor: .bottom)
                            }
                            
                        }
                    }
                }
                .onChange(of: categoryType) {
                    viewModel.errorMessage = ""
                    viewModel.model.category = CategoryModel(type: categoryType) /// Clean category beacause won't be the same CategoryType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(selectedDate: $viewModel.model.dateTransaction,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: $viewModel.model.category,
                                            categoryType: $categoryType)
                }
            }
        }
        // This modal sometimes dont apply the corner radius. It looks like is a SwiftUI Bug..
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process(_ processType: ProcessType) {
        let result: ResponseModel
        
        switch processType {
        case .add:
            result = viewModel.addNewTransaction(categoryType)
        case .modify:
            result = viewModel.modifyTransaction(categoryType)
        case .delete:
            result = viewModel.deleteTransaction()
        }
        
        if result.status.isSuccess {
            dismiss()
        } else {
            viewModel.errorMessage = result.message
        }
    }
}

#Preview("New") {
    //@Previewable @State var selectedDate = Date()
    //@Previewable @State var model = TransactionModel()
    
    //@Previewable @State var selectedDate = Date()
    AddModifyTransactionView()
}

//TOD: REPARAR
//#Preview("Modify") {
//    @Previewable @State var model = MockTransaction.preview.container.viewContext.fe
//    @Previewable @State var selectedDate = MockTransactionsFB.normal.first!.dateTransaction
//    
//    AddModifyTransactionView(model: $model,
//                             selectedDate: $selectedDate,
//                             viewContext: MockTransaction.preview.container.viewContext)
//}
