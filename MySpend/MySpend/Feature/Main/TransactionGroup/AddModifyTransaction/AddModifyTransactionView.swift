//
//  AddModifyTransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 15/8/23.
//

import SwiftUI
import CoreData

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
    
    @Binding var model: TransactionModel
    @Binding private var selectedDate: Date
    
    @StateObject var viewModel: AddModifyTransactionViewModel
    @State private var defaultModel = TransactionModel()

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
    init(model: Binding<TransactionModel>? = nil,
         selectedDate: Binding<Date>,
         viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        
        if let model = model {
            self.isNewTransaction = false
            self._model = model
        } else {
            /// In case a model is no passed by parameter, wont be use model. Will use defaultModel instead.
            self.isNewTransaction = true
            self._model = .constant(TransactionModel())
        }
        self._selectedDate = selectedDate
        
        _viewModel = StateObject(wrappedValue: AddModifyTransactionViewModel(viewContext: viewContext))
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
                        PickerSegmented(selection: modelBinding.category.type,
                                        segments: CategoryType.allCases)
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
                    viewModel.onAppear(modelBinding.wrappedValue,
                                       selectedDate: selectedDate,
                                       isNewTransaction: isNewTransaction)
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
                .onChange(of: modelBinding.wrappedValue.category.type) {
                    viewModel.errorMessage = ""
                    modelBinding.wrappedValue.category = CategoryModel() /// Clean category beacause won't be the same CategoryType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(selectedDate: $selectedDate,
                                        dateString: $viewModel.dateString,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: modelBinding.category,
                                            categoryType: modelBinding.category.type)
                }
            }
        }
        // This modal sometimes dont apply the corner radius. It looks like is a SwiftUI Bug..
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process(_ processType: ProcessType) {
        let result: ResponseModelFB
        
        switch processType {
        case .add:
            result = viewModel.addNewTransaction(modelBinding.wrappedValue, selectedDate: selectedDate)
        case .modify:
            result = viewModel.modifyTransaction(modelBinding.wrappedValue, selectedDate: selectedDate)
        case .delete:
            result = viewModel.deleteTransaction(modelBinding.wrappedValue)
        }
        
        if result.status.isSuccess {
            dismiss()
        } else {
            viewModel.errorMessage = result.message
        }
    }
}

#Preview("New") {
    @Previewable @State var selectedDate = Date()
    AddModifyTransactionView(selectedDate: $selectedDate, viewContext: MockTransaction.preview.container.viewContext)
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
