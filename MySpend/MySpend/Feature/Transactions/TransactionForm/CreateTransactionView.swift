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
    @Environment(AccountManager.self) private var accountManager
    
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
                        CategoryPickerView(selection: $viewModel.model.category.type)
                            .padding(.bottom)
                    }
                    
                    // MARK: DATE
                    
                    VStack {
                        TextFieldReadOnly(placeHolder: "Date", text: .constant(viewModel.model.dateTransaction.toStringShortLocale),
                                          iconLeading: Image.calendar,
                                          colorDisabled: false)
                        .onTapGesture {
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
                        }
                        .tint(.accentColor)
                        .padding(.horizontal)
                    }
                }
                .disabled(viewModel.disabled)
                
                Spacer()
            }
            
            // MARK: SCROLL OPTIONS
            
            .padding(.horizontal)
            .scrollDisabled(true)
            .background(Color.backgroundGradient)
            .ignoresSafeArea(.all, edges: .bottom)
            
            
            // MARK: EVENTS
            
            .onAppear {
                viewModel.configureSelectedAccount(accountManager.sortedAccounts)

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
                DatePickerModalView(selectedDate: $viewModel.model.dateTransaction)
            }
            .sheet(isPresented: $showCategoryList) {
                NavigationStack {
                    //TODO: Refactorizar: No se debe manejar el type enlazado al modelo, porque la categoria ya pertenece a un tipo.
                    SelectCategoryView(selectedCategory: $viewModel.model.category, type: $viewModel.model.category.type)
                }
            }
            .sheet(isPresented: $showAccountList) {
                NavigationStack {
                    SelectAccountView(selectedAccount: $viewModel.model.account)
                }
            }
        }
        
        // Para agregar objetos flotantes al pie de la pantalla.
        .safeAreaInset(edge: .bottom) {
            safeAreaBottomView
        }
        
        // MARK: NAVIGATION
        .navigationTitle(viewModel.isNewModel ? .transactionNew : .transactionModify)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar {
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
                    .padding(.vertical, ConstantViews.paddingButtonVertical)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .buttonStyle(.glass)
            .padding(.bottom, viewModel.isNewModel ? nil : .zero)
            
            
            if viewModel.isNewModel == false {
                Button(.transactionDelete(.zero)) {
                    viewModel.showAlert = true
                }
                .padding(.vertical)
                .foregroundStyle(.alert)
                .fontWeight(.semibold)
                
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

#Preview(Previews.localeES) {
    
    @Previewable @State var manager = TransactionManager.shared
    @Previewable @State var accountManager = AccountManager.shared
    @Previewable @State var categoryManager = CategoryManager.shared
    
    NavigationStack {
        CreateTransactionView()
    }
    .environment(manager)
    .environment(accountManager)
    .environment(categoryManager)
    .environment(\.locale, .init(identifier: Previews.localeES))
}
