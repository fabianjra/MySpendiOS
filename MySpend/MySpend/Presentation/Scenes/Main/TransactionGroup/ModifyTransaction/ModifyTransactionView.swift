//
//  ModifyTransactionView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 27/10/24.
//

import SwiftUI

struct ModifyTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var modelLoaded: TransactionModel
    @StateObject var viewModel = ModifyTransactionViewModel()
    @FocusState private var focusedField: TransactionModel.Field?
    
    private let notesId = "notes"
    
    var body: some View {
        NavigationStack { // This is needed for showing toolBar Keyboard.
            ScrollViewReader { scrollViewProxy in
                FormContainer {
                    //TODO: El texto se corta en dispositivos mas pequenos, hacer salto de linea
                    HeaderNavigator(title: "Modify transaction",
                                    titleWeight: .regular,
                                    titleSize: .bigL,
                                    subTitle: "Modify transaction details",
                                    showLeadingAction: false,
                                    showTrailingAction: true)
                    .padding(.vertical)
                    
                    
                    // MARK: SEGMENT
                    VStack {
                        PickerSegmented(selection: $modelLoaded.transactionType,
                                        segments: TransactionType.allCases)
                        .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    VStack {
                        TextFieldReadOnly(text: $viewModel.dateString,
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
                            viewModel.showDatePicker = true
                        }
                    }
                    
                    
                    // MARK: TEXTFIELDS
                    VStack {
                        TextFieldAmount(text: $viewModel.amountString,
                                        errorMessage: $viewModel.errorMessage)
                        .focused($focusedField, equals: .amount)
                        
                        
                        TextFieldReadOnlySelectable(placeHolder: "Category",
                                                    text: $modelLoaded.category.name,
                                                    iconLeading: Image.stackFill,
                                                    colorDisabled: false,
                                                    errorMessage: $viewModel.errorMessage)
                        .onTapGesture {
                            viewModel.showCategoryList = true
                        }
                        
                        TextFieldNotes(text: $modelLoaded.notes)
                            .id(notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom)
                    }
                    
                    
                    // MARK: BUTTONS
                    VStack {
                        Button("Modify") {
                            process()
                        }
                        .buttonStyle(ButtonPrimaryStyle(isLoading: $viewModel.isLoading))
                        .padding(.vertical)
                        
                        //TODO: Cambiar estilo de boton por uno solamente bordes pintados.
                        Button("Delete") {
                            viewModel.showAlert = true
                        }
                        .buttonStyle(ButtonPrimaryStyle(color: [Color.alert], isLoading: $viewModel.isLoadingSecondary))
                        .padding(.vertical)
                        .alert("Delete transaction", isPresented: $viewModel.showAlert) {
                            Button("Delete", role: .destructive) { delete() }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Want to delete this transaction? \n This action cannot be undone.")
                        }
                        
                        
                        TextError(message: viewModel.errorMessage)
                    }
                    
                    Spacer()
                }
                .onAppear {
                    viewModel.onAppear(modelLoaded)
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
                .onChange(of: modelLoaded.transactionType) {
                    viewModel.errorMessage = ""
                    modelLoaded.category = CategoryModel() //Clean the category beacause won't be the same TransactionType (Exponse, income).
                }
                .sheet(isPresented: $viewModel.showDatePicker) {
                    DatePickerModalView(model: $modelLoaded,
                                        dateString: $viewModel.dateString,
                                        showModal: $viewModel.showDatePicker)
                }
                .sheet(isPresented: $viewModel.showCategoryList) {
                    SelectCategoryModalView(selectedCategory: $modelLoaded.category,
                                            transactionType: modelLoaded.transactionType)
                }
            }
        }
        .disabled(viewModel.isLoading || viewModel.isLoadingSecondary)
    }
    
    private func process() {
        focusedField = .none
        Task {
            let result = await viewModel.modifyTransaction(modelLoaded)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func delete() {
        focusedField = .none
        Task {
            let result = await viewModel.deleteTransaction(modelLoaded)
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview {
    @Previewable @State var model = TransactionModel(id: "01",
                                                     amount: 2500.00,
                                                     dateTransaction: .now,
                                                     category: CategoryModel(id: "01",
                                                                             icon: CategoryIcons.foodAndDrink.list[.zero],
                                                                             name: "Comidas",
                                                                             categoryType: .expense),
                                                     notes: "notas cargadas",
                                                     transactionType: .expense)
    VStack {
        ModifyTransactionView(modelLoaded: $model)
    }
}
