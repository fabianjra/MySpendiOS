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
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel: AddModifyTransactionViewModel
    @FocusState private var focusedField: TransactionModel.Field?
    
    @State private var showDatePicker = false
    @State private var showCategoryList = false
    @State private var showAccountList = false
    
    init(_ model: TransactionModel? = nil, selectedDate: Date? = nil) {
        _viewModel = StateObject(wrappedValue: AddModifyTransactionViewModel(model, selectedDate: selectedDate))
    }
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    // MARK: SEGMENT
                    
                    VStack {
                        PickerView(selection: $viewModel.model.category.type)
                            .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    
                    VStack {
                        TextFieldReadOnly(placeHolder: "Date", text: .constant(viewModel.model.dateTransaction.toStringShortLocale),
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
                            //focusedField = .none
                            showDatePicker = true
                        }
                    }
                    
                    
                    // MARK: TEXTFIELDS
                    
                    VStack {
                        TextFieldAmount(text: $viewModel.amountString)
                            .focused($focusedField, equals: .amount)
                        
                        
                        TextFieldReadOnlySelectable(placeHolder: "Category",
                                                    text: $viewModel.model.category.name,
                                                    iconLeading: Image.stackFill,
                                                    colorDisabled: false,
                                                    errorMessage: $viewModel.errorMessage)
                        .onTapGesture {
                            showCategoryList = true
                        }
                        
                        
                        if viewModel.showAccountTextField {
                            TextFieldReadOnlySelectable(placeHolder: "Account",
                                                        text: $viewModel.model.account.name,
                                                        iconLeading: Image.walletFill,
                                                        colorDisabled: false,
                                                        errorMessage: $viewModel.errorMessage)
                            .onTapGesture {
                                showAccountList = true
                            }
                        }
                        
                        
                        TextFieldNotes(text: $viewModel.model.notes)
                            .id(viewModel.notesId)
                            .focused($focusedField, equals: .notes)
                            .padding(.bottom, ConstantViews.mediumSpacing)
                        
                        
                        Toggle(isOn: $viewModel.favorite) {
                            Text(.favoriteMarkFavorite)
                                .textStyle
                        }
                        .tint(Color.primaryBottom)
                        .padding(.horizontal)
                    }
                    
                    
                    Text(viewModel.errorMessage)
                        .textErrorStyle
                }
                .disabled(viewModel.disabled)
                
                Spacer()
            }
            
            // MARK: SCROLL OPTIONS
            
            .padding(.horizontal)
            .scrollDisabled(true)
            .background(Color.backgroundContentGradient)
            .ignoresSafeArea(.all, edges: .bottom)
            
            
            // MARK: EVENTS
            
            .onAppear {
                Task {
                    await viewModel.fetchAccounts()
                }
                
                if viewModel.isNewModel {
                    focusedField = .amount
                }
            }
            .onChange(of: focusedField) {
                if focusedField == .notes {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation {
                            scrollViewProxy.scrollTo(viewModel.notesId, anchor: .bottom)
                        }
                    }
                }
            }
            .onChange(of: viewModel.model.category.type) {_, newValue in
                viewModel.errorMessage = ""
                viewModel.model.category = CategoryModel(type: newValue) // Clean category beacause won't be the same CategoryType (Exponse, income).
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerModalView(selectedDate: $viewModel.model.dateTransaction,
                                    showModal: $showDatePicker)
            }
            .sheet(isPresented: $showCategoryList) {
                SelectCategoryModalView(selectedCategory: $viewModel.model.category,
                                        categoryType: $viewModel.model.category.type) //TOD: Refatorizar porque se envia el mismo objeto
            }
            .sheet(isPresented: $showAccountList) {
                SelectAccountModalView(selectedModel: $viewModel.model.account)
            }
        }
        
        // Para agregar objetos flotantes al pie de la pantalla.
        .safeAreaInset(edge: .bottom) {
            safeAreaBottomView
        }
        
        // MARK: NAVIGATION
        .navigationTitle(viewModel.isNewModel ? .transactionNew : .transactionModify) // Necesario para ver la descripcion al presionar el boton atras al navegar.
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
            
            ToolbarItem(placement: .title) {
                Text(viewModel.isNewModel ? .transactionNew : .transactionModify)
                    .textStyle
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .close) {
                    dismiss()
                }
            }
        }
    }
    
    private var safeAreaBottomView: some View {
        VStack {
            Button {
                process(viewModel.isNewModel ? .add : .modify)
            } label: {
                Text(viewModel.isNewModel ? .transactionAdd : .transactionModify)
                    .textStyle
                    .padding(.vertical, ConstantViews.paddingButtonTransaction)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .buttonStyle(.glass)
            .padding(.bottom, viewModel.isNewModel ? nil : .zero)
            
            
            if viewModel.isNewModel == false {
                Button(.transactionDelete(.zero)) {
                    viewModel.showAlert = true
                }
                .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold))
                
                .alert(.transactionDelete(.zero), isPresented: $viewModel.showAlert) {
                    
                    Button(.alertOptionDelete, role: .destructive) { process(.delete) }
                    Button(.alertOptionCancel, role: .cancel) { }
                    
                } message: {
                    Text(.transactionDeleteMessage(.zero))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func process(_ processType: ProcessType) {
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNew()
            case .modify:
                result = await viewModel.modify()
            case .delete:
                result = await viewModel.delete()
            }
            
            if result.status.isSuccess {
                dismiss()
            } else {
                viewModel.errorMessage = result.message
            }
        }
    }
}

private struct PreviewWrapper: View {
    init(_ mockDataType: MockDataType = .empty) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    
    @State private var selectedModel: TransactionModel?
    @State private var models: [TransactionModel] = []
    
    var body: some View {
        VStack {
            Text("Transacciones:")
            
            List(models) { model in
                Button(model.id.uuidString) {
                    selectedModel = model
                }
            }
            .sheet(item: $selectedModel) { model in
                NavigationStack {
                    AddModifyTransactionView(model)
                }
            }
        }
        .task {
            models = await MockTransactionModel.fetchAll()
            
            if !models.isEmpty && models.first != nil {
                selectedModel = models.first
            }
        }
    }
}


#Preview("New \(Previews.localeEN)") {
    NavigationStack {
        AddModifyTransactionView()
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Modify \(Previews.localeES_CR)") {
    NavigationStack {
        PreviewWrapper(.normal)
        
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}
