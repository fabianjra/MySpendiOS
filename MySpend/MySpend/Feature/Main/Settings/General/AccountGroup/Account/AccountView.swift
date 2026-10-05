//
//  AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.editMode) private var editMode
    @Environment(AccountManager.self) private var accountManager
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @State private var viewModel = AccountViewModel()
    @State private var toast = ToastViewModel()
    
    @State private var showNewItemModal = false
    @State private var showAlertDelete = false
    
    var body: some View {
        VStack {
            itemList
        }
        .navigationTitle(
            viewModel.selectedAccounts.count == .zero ?
                .accountsTitle : .selectorSelectedCountFemale(viewModel.selectedAccounts.count)
        )
        .navigationSubtitle(.accountsSubtitle(accountManager.sortedAccounts.count))
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
        
        .sheet(isPresented: $showNewItemModal) {
            AddModifyAccountView()
        }
        
        .sheet(item: $viewModel.accountToUpdate) { account in
            AddModifyAccountView(account)
                .onDisappear {
                    viewModel.accountToUpdate = nil
                    //TODO: Agregar mensaje a Toast del update. Debe ir al finalizar el ModifyAccountView.
                }
        }
        
        .toast(toast.response, isPresented: $toast.show)
    }
    
    // MARK: - VIEWS
    
    private var itemList: some View {
        VStack {
            List(selection: $viewModel.selectedAccounts) {
                if accountManager.sortedAccounts.isEmpty {
                    Section {
                        Text(.accountsEmpty)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Section {
                        ForEach(accountManager.sortedAccounts) { item in
                            Button {
                                if isEditing {
                                    viewModel.toggleAccountSelection(item)
                                } else {
                                    viewModel.accountToUpdate = item
                                }
                                
                            } label: {
                                HStack {
                                    Label(item.name, systemImage: item.icon)
                                        .foregroundStyle(Color.primary)
                                    
                                    Spacer()
                                    
                                    if item.id == accountManager.defaultSelected?.id {
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
                                    
                                    Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                        viewModel.accountToDelete = item
                                        showAlertDelete = true
                                    }
                                    .labelStyle(.iconOnly)
                                    
                                    
                                    Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                        viewModel.accountToUpdate = item
                                    }
                                    .labelStyle(.iconOnly)
                                }
                            }
                            
                            .contextMenu {
                                if !isEditing {
                                    
                                    Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                        viewModel.accountToUpdate = item
                                    }
                                    
                                    
                                    Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                        viewModel.accountToDelete = item
                                        showAlertDelete = true
                                    }
                                }
                            }
                            
                            .alert(.accountDelete(viewModel.selectedAccounts.count), isPresented: $showAlertDelete) {
                                Button(.alertOptionDelete, role: .destructive) {
                                    Task {
                                        if viewModel.selectedAccounts.isEmpty {
                                            
                                            defer {
                                                viewModel.accountToDelete = nil
                                            }
                                            
                                            toast.response = await accountManager.delete(viewModel.accountToDelete)
                                        } else {
                                            
                                            defer {
                                                viewModel.selectedAccounts.removeAll()
                                            }
                                            
                                            toast.response = await accountManager.deleteMltipleItems(viewModel.selectedAccounts)
                                        }
                                        
                                        editMode?.wrappedValue = .inactive
                                    }
                                }
                                
                                Button(.alertOptionCancel, role: .cancel) { }
                            } message: {
                                Text(.accountDeleteMessage(viewModel.selectedAccounts.count))
                            }
                        }
                    }
                }
            }
            //.navigationLinkIndicatorVisibility(.visible)
            .animation(.default, value: accountManager.sortedAccounts)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundGradient)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        @Bindable var accountManagerBind = accountManager
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if isEditing {
                if viewModel.selectedAccounts.count == accountManager.sortedAccounts.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedAccounts = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedAccounts = Set(accountManager.sortedAccounts)
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
                    
                    Menu {
                        Section {
                            Picker(.sortTitle, selection: $accountManagerBind.sortingSelected.sortBy) {
                                ForEach(AccountSortOption.allCases, id: \.self) { sortBy in
                                    Text(sortBy.localized)
                                        .tag(sortBy)
                                }
                            }
                            
                        }
                        
                        Section {
                            Picker(.sortTitle, selection: $accountManagerBind.sortingSelected.order) {
                                ForEach(SortOrder.allCases, id: \.self) { order in
                                    Text(order.localized)
                                        .tag(order)
                                }
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading) {
                                Button(role: .destructive) {
                                    accountManager.resetSort()
                                } label: {
                                    Text(.sortByDefault)
                                }
                            }
                            
                        }
                        
                    } label: {
                        Label(.sortTitle, systemImage: ConstantSystemImage.arrowUpDown)
                        
                        Text(accountManager.sortingSelected.sortBy.localized)
                    }
                    
                }
                .menuOrder(.fixed)
                .disabled(accountManager.sortedAccounts.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            if isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                    showAlertDelete = true
                }
                .disabled(viewModel.selectedAccounts.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem, role: .confirm) {
                    showNewItemModal = true
                }
            }
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
    }
    
    @State var previewAccountManager = AccountManager.shared
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        AccountView()
            .environment(previewAccountManager)
            .environment(\.editMode, $editMode)
    }
}

#Preview("Normal \(Previews.localeES_CR)") {
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
