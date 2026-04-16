//
//  AddModifyAccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI
 
struct AddModifyAccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var accountType: AccountType
    
    @StateObject private var viewModel: AddModifyAccountViewModel
    @FocusState private var focusedField: AccountModel.Field?
    
    @State private var selectedIcon = ""
    @State private var showIconsModal = false
    
    init(_ model: AccountModel? = nil, accountType: Binding<AccountType>) {
        _viewModel = StateObject(wrappedValue: AddModifyAccountViewModel(model))
        
        self._accountType = accountType
    }
    
    var body: some View {
        FormContainer {
            
            HeaderNavigator(title: viewModel.isAddModel ? "New account" : "Modify account",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: viewModel.isAddModel ? "Enter the account details" : "Modify the account details",
                            showLeadingAction: false,
                            showTrailingAction: true)
            .padding(.vertical)
            
            
            // MARK: SEGMENT
            
            VStack {
                PickerView(selection: $accountType)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    .padding(.bottom)
            }
            
            
            // MARK: TEXTFIELDS
            
            VStack {
                TextFieldModelName(text: $viewModel.model.name,
                                   errorMessage: $viewModel.errorMessage)
                .focused($focusedField, equals: .name)
                .onSubmit { process(viewModel.isAddModel ? .add : .modify) }
                
                Button("") {
                    showIconsModal = true
                }
                .buttonStyle(ButtonTextFieldStyle(icon: viewModel.model.icon, actionClear: {
                    viewModel.model.icon = ""
                }))
            }
            .padding(.bottom)
            
            //MARK: TOOGLE
            
            VStack {
                Toggle(isOn: $viewModel.isDefaultSelected) {
                    TextPlain("Default account:")
                }
                .tint(Color.primaryBottom)
                .padding(.horizontal)
                
                TextError(viewModel.errorMessage)
                    .padding(.vertical)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                Button(action: {
                    process(viewModel.isAddModel ? .add : .modify)
                }, label: {
                    TextPlain(viewModel.isAddModel ? "Add" : "Modify")
                        .padding(.vertical, ConstantViews.paddingButtonTransaction)
                        .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                })
                .buttonStyle(.glass)
                .padding(.bottom, viewModel.isAddModel ? nil : .zero)
                
                
                if viewModel.isAddModel == false {
                    Button("Delete") {
                        viewModel.showAlert = true
                    }
                    .buttonStyle(ButtonLinkStyle(color: Color.alert, fontfamily: .semibold))
                    .alert("Delete account", isPresented: $viewModel.showAlert) {
                        Button("Delete", role: .destructive) { process(.delete) }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Want to delete this account? \n This action cannot be undone.")
                    }
                }
            }
            .padding(.horizontal)
        }
        
        .sheet(isPresented: $showIconsModal) {
            IconListModalView(selectedIcon: $selectedIcon, showModal: $showIconsModal)
        }
        .onChange(of: selectedIcon) { _, newValue in
            viewModel.model.icon = newValue
        }
        .onAppear {
            focusedField = .name
            
            if viewModel.isAddModel == false {
                accountType = viewModel.model.type
            }
        }
    }
    
    private func process(_ processType: ProcessType) {
        Task {
            let result: ResponseModel
            
            switch processType {
            case .add:
                result = await viewModel.addNew(type: accountType)
            case .modify:
                result = await viewModel.modify(type: accountType)
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


#Preview("New") {
    @Previewable @State var type: AccountType = .general
    
    VStack {
        AddModifyAccountView(accountType: $type)
    }
}
