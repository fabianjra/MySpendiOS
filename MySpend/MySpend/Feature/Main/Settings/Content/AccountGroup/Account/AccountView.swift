//
//  AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct AccountView: View {
    
    @State private var viewModel = AccountViewModel()
    
    
    // MARK: USED ONLY IN VIEW
    
    @State private var showNewItemModal = false
    @State private var showAlertDelete = false
    @State private var showAlertDeleteMultiple = false
    
    var body: some View {
        VStack {
            if !viewModel.allAccounts.isEmpty {
                topMenu
                    .padding(.top)
            }
            
            itemList
        }
        .background(Color.backgroundContentGradient)
        .navigationTitle("Accounts")
        
        .toolbar {
            toolbarContent
        }
        
        
        // MARK: EVENTS
        
        .onDisappear {
            viewModel.deactivateObservers()
        }
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $showNewItemModal) {
            AddModifyAccountView()
        }
        .sheet(item: $viewModel.accountToUpdate) { account in
            AddModifyAccountView(account)
                .onDisappear {
                    viewModel.accountToUpdate = nil
                    //TODO: Agregar mensaje a Toast del update.
                }
        }
        
        .toast(viewModel.responseToast, isPresented: $viewModel.showToast)
    }
    
    // MARK: - VIEWS
    
    private var topMenu: some View {
        VStack {
            ListEditorView(isEditing: $viewModel.isEditing,
                           counterSelected: viewModel.selectedAccounts.count) {
                
                viewModel.selectedAccounts.removeAll()
                
            } actionTrailingEdit: {
                showAlertDeleteMultiple = true
            }
            
            
            VStack {
                RowLCTCointainer(disabled: viewModel.isEditing, leadingContent:  {
                    MenuContainer(addHorizontalPadding: true, disabled: viewModel.isEditing) {
                        Section("Sorted by: \(viewModel.sortSelection.rawValue)") {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
                        }
                        
                        // Reset the sort selection to default
                        Section {
                            sortButtonResetToDefault
                        }
                    }
                })
            }
            .disabled(viewModel.isEditing)
        }
        .padding(.horizontal)
    }

    private func sortButton(for sortingOption: SortAccounts) -> some View {
        Button {
            if viewModel.sortSelection == sortingOption {
                viewModel.sortSelection = sortingOption.toggle
            } else {
                viewModel.sortSelection = sortingOption
            }

        } label: {
            viewModel.sortSelection == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
        }
    }
    
    private var sortButtonResetToDefault: some View {
        Button {
            viewModel.resetSelectedSort()
        } label: {
            Label.restoreSelection
                .foregroundStyle(Color.alert, Color.alert)
        }
    }
    
    private var itemList: some View {
        VStack {
            if viewModel.allAccounts.isEmpty {
                TransactionsEmptyView()
            } else {
                ListContainer {
                    SectionContainer("Available accounts", isInsideList: true) {
                        ForEach(viewModel.allAccounts) { item in
                            HStack {
                                if viewModel.isEditing {
                                    Image(systemName: viewModel.selectedAccounts.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: FrameSize.width.iconRowList,
                                               height: FrameSize.height.iconRowList)
                                        .foregroundStyle(Color.alert)
                                        .transition(.scale.combined(with: .move(edge: .leading)))
                                }
                                
                                let icon = item.icon.getIconFromSFSymbol
                                
                                if let image = icon {
                                    image
                                        .frame(width: FrameSize.width.iconCategoryList,
                                               height: FrameSize.height.iconCategoryList)
                                }
                                
                                Button(item.name) {
                                    if viewModel.isEditing {
                                        if viewModel.selectedAccounts.contains(item) {
                                            viewModel.selectedAccounts.remove(item)
                                        } else {
                                            viewModel.selectedAccounts.insert(item)
                                        }
                                    } else {
                                        viewModel.accountToUpdate = item
                                    }
                                }
                                
                                Spacer()
                                
                                if item.id == viewModel.defaultModelSelected?.id {
                                    TextPlain("Default",
                                              color: Color.textFieldForeground,
                                              family: .light,
                                              size: .medium)
                                }
                                
                                Image.chevronRight
                            }
                            .listRowBackground(Color.listRowBackground) //Background for each row.
                            .swipeActions(edge: .trailing) {
                                Button {
                                    viewModel.accountToUpdate = item
                                    showAlertDelete = true
                                } label: {
                                    Label.delete
                                }
                                .tint(Color.alert)
                                
                                Button {
                                    viewModel.accountToUpdate = item
                                } label: {
                                    Label.edit
                                }
                                .tint(Color.warning)
                            }
                            
                            // MARK: DELETE ITEMS SINGLE
                            
                            .alert("Delete account", isPresented: $showAlertDelete) {
                                Button("Delete", role: .destructive) {
                                    Task {
                                        await viewModel.delete()
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete this account? \n This action cannot be undone.")
                            }
                            
                            // MARK: DELETE ITEMS MULTIPLE
                            
                            .alert("Delete accounts", isPresented: $showAlertDeleteMultiple) {
                                Button("Delete", role: .destructive) {
                                    Task {
                                        await viewModel.deleteMltipleItems()
                                    }
                                }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete these accounts? \n This action cannot be undone.")
                            }
                        }
                    }
                }
                .animation(.default, value: viewModel.allAccounts.count)
                .animation(.default, value: viewModel.isEditing)
                .animation(.default, value: viewModel.sortSelection)
            }
        }
    }
    
    func rowView(_ model: AccountModel?) -> some View {
        HStack {
            if let image = model?.icon.getIconFromSFSymbol {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FrameSize.height.iconRowList,
                           height: FrameSize.width.iconRowList)
            }
            
            TextPlain(model?.name ?? "No default account selected", color: Color.disabledForeground)
            
            Spacer()
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            
            if viewModel.isEditing {
                
                if viewModel.selectedAccounts.count == viewModel.selectedAccounts.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedAccounts = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedAccounts = Set(viewModel.allAccounts)
                    }
                }
            }
        }
        
        ToolbarItemGroup(placement: .bottomBar) {
            Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem) {
                showNewItemModal = true
            }
            .disabled(viewModel.isEditing)
        }
    }
}


private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
        
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
    }
    var body: some View { AccountView() }
}

#Preview("Normal es_CR") {
    NavigationStack {
        previewWrapper()
            .environment(\.locale, .init(identifier: "es_CR"))
    }
}

#Preview("Saturated es_ES") {
    previewWrapper(.saturated)
        .environment(\.locale, .init(identifier: "es_ES"))
}

#Preview("Empty en_US") {
    previewWrapper(.empty)
        .environment(\.locale, .init(identifier: "en_US"))
}
