//
//  AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(AccountManager.self) private var manager
    @Environment(\.editMode) private var editMode
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @State private var viewModel = AccountViewModel()
    @State private var toastResponse: ToastResponse?
    
    var body: some View {
        VStack {
            accountList
        }
        .navigationTitle(
            viewModel.selectedAccounts.isEmpty ?
                .accountsTitle : .selectorSelectedCountFemale(viewModel.selectedAccounts.count)
        )
        .navigationSubtitle(.accountsSubtitle(manager.sortedAccounts.count))
        .navigationBarBackButtonHidden(isEditing)
        
        .toolbar {
            toolbarContent
        }
        
        .onChange(of: editMode?.wrappedValue) { _, newValue in
            if newValue?.isEditing != true {
                viewModel.selectedAccounts.removeAll()
            }
        }
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $viewModel.showCreateAccount) {
            NavigationStack {
                CreateAccountView()
            }
        }
        
        .sheet(isPresented: $viewModel.showUpdateAccount) {
            NavigationStack {
                UpdateAccountView(account: $viewModel.accountToUpdate)
            }
        }
        
        .toast($toastResponse)
    }
    
    // MARK: - VIEWS
    
    private var accountList: some View {
        List(selection: $viewModel.selectedAccounts) {
            if manager.sortedAccounts.isEmpty {
                Section {
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                }
            } else {
                Section {
                    ForEach(manager.sortedAccounts) { item in
                        Button {
                            if isEditing {
                                viewModel.toggleAccountSelection(item)
                            } else {
                                viewModel.accountToUpdate = item
                                viewModel.showUpdateAccount = true
                            }
                            
                        } label: {
                            HStack {
                                Label(item.name, systemImage: item.icon)
                                    .foregroundStyle(Color.primary)
                                
                                Spacer()
                                
                                if item.id == manager.defaultAccount?.id {
                                    Text(.accountsDefault)
                                        .foregroundStyle(Color.secondary)
                                        .fontWeight(.light)
                                        .font(.footnote)
                                }
                                
                                if !isEditing {
                                    Image.chevronRight
                                        .tint(.secondary)
                                }
                            }
                        }
                        .tag(item)
                        
                        .swipeActions(edge: .trailing) {
                            if !isEditing {
                                
                                Button(.selectorDelete, systemImage: ConstantSystemImage.trash) {
                                    viewModel.accountToDelete = item
                                    viewModel.showAlertDelete = true
                                }
                                .labelStyle(.iconOnly)
                                .tint(.alert)
                                
                                
                                Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                    viewModel.accountToUpdate = item
                                    viewModel.showUpdateAccount = true
                                }
                                .labelStyle(.iconOnly)
                            }
                        }
                        
                        .contextMenu {
                            if !isEditing {
                                
                                Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                    viewModel.accountToUpdate = item
                                    viewModel.showUpdateAccount = true
                                }
                                
                                
                                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                    viewModel.accountToDelete = item
                                    viewModel.showAlertDelete = true
                                }
                            }
                        }
                        
                        .alert(.accountDelete(viewModel.selectedAccounts.count), isPresented: $viewModel.showAlertDelete) {
                            Button(.alertOptionDelete, role: .destructive) {
                                Task {
                                    if viewModel.selectedAccounts.isEmpty {
                                        
                                        defer {
                                            viewModel.accountToDelete = nil
                                        }
                                        
                                        if let account = viewModel.accountToDelete {
                                            toastResponse = await manager.delete(account)
                                        }
                                        
                                    } else {
                                        
                                        defer {
                                            viewModel.selectedAccounts.removeAll()
                                        }
                                        
                                        toastResponse = await manager.delete(viewModel.selectedAccounts)
                                    }
                                    
                                    editMode?.wrappedValue = .inactive
                                }
                            }
                            
                            Button(.alertOptionCancel, role: .cancel) { }
                        } message: {
                            Text(.accountDeleteMessage(viewModel.selectedAccounts.count))
                        }
                    }
                } header: {
                    Text(.accountListHeader)
                    
                } footer: {
                    if manager.accountsCount > 1 {
                        Text(.accountListFooter)
                    }
                }
            }
        }
        //.navigationLinkIndicatorVisibility(.visible)
        .animation(.default, value: manager.sortedAccounts)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundGradient)
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if isEditing {
                if viewModel.selectedAccounts.count == manager.sortedAccounts.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedAccounts = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedAccounts = Set(manager.sortedAccounts)
                    }
                }
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            if isEditing {
                //EditButton()
                Button(role: .cancel) {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
            } else {
                
                Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                    
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label(.selectorSelect, systemImage: ConstantSystemImage.checkmarkCircle)
                    }
                    
                    AccountSortMenu()
                }
                .menuOrder(.fixed)
                .disabled(manager.sortedAccounts.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            if isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                    viewModel.showAlertDelete = true
                }
                .disabled(viewModel.selectedAccounts.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem) {
                    viewModel.showCreateAccount = true
                }
            }
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
        
        _manager = State(initialValue: AccountManager(viewContext: mockDataType.viewContext))
    }
    
    @State var manager: AccountManager
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        AccountView()
            .environment(manager)
            .environment(\.editMode, $editMode)
    }
}

#Preview(Previews.localeES_CR) {
    NavigationStack {
        previewWrapper()
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Saturated \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(.saturated)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}


#Preview("Empty \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(.empty)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}
