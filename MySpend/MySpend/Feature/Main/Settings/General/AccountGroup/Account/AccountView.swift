//
//  AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct AccountView: View {
    
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
        .navigationSubtitle(.accountsSubtitle(viewModel.sortedAccounts.count))
        .navigationBarBackButtonHidden(viewModel.isEditing)
        
        .toolbar {
            toolbarContent
        }
        
        .task {
            let response = await viewModel.fetchAccounts()
            
            guard let response = response else { return }
            if response.type == .error {
                toast.response = response
            }
        }
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
                    //TODO: Agregar mensaje a Toast del update. Debe ir al finalizar el ModifyAccountView.
                }
        }
        
        .toast(toast.response, isPresented: $toast.show)
    }
    
    // MARK: - VIEWS
    
    private var itemList: some View {
        VStack {
            List {
                if viewModel.sortedAccounts.isEmpty {
                    Text(.accountsEmpty)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.sortedAccounts) { item in
                        Button {
                            if viewModel.isEditing {
                                viewModel.toggleAccountSelection(item)
                            } else {
                                viewModel.accountToUpdate = item
                            }
                            
                        } label: {
                            HStack {
                                if viewModel.isEditing {
                                    Image(systemName: viewModel.selectedAccounts.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: FrameSize.width.iconRowList,
                                               height: FrameSize.height.iconRowList)
                                        .foregroundStyle(Color.accentColor)
                                        .transition(.scale.combined(with: .move(edge: .leading)))
                                    
                                }
                                
                                item.icon.getIconFromSFSymbol?
                                    .foregroundStyle(.textPrimaryForeground)
                                
                                Text(item.name)
                                    .textStyle
                                
                                Spacer()
                                
                                if item.id == viewModel.defaultModelSelected?.id {
                                    Text(.accountsDefault)
                                        .textStyle(color: .textPrimaryForeground,
                                                   family: .light,
                                                   size: .mediumSmall)
                                }
                                
                                if !viewModel.isEditing {
                                    Image.chevronRight
                                        .tint(.secondary)
                                }
                            }
                        }
                        
                        .swipeActions(edge: .trailing) {
                            if !viewModel.isEditing {
                                
                                Button("", systemImage: ConstantSystemImage.trash) {
                                    viewModel.accountToDelete = item
                                    showAlertDelete = true
                                }
                                .tint(.alert)
                                
                                
                                Button("", systemImage: ConstantSystemImage.squareAndPencil) {
                                    viewModel.accountToUpdate = item
                                }
                            }
                        }
                        
                        .contextMenu {
                            if !viewModel.isEditing {
                                
                                Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                    viewModel.accountToUpdate = item
                                }
                                
                                
                                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                    viewModel.accountToDelete = item
                                    showAlertDelete = true
                                }
                                .tint(.alert)
                            }
                        }
                        
                        .alert(.accountDelete(viewModel.selectedAccounts.count), isPresented: $showAlertDelete) {
                            Button(.alertOptionDelete, role: .destructive) {
                                Task {
                                    if viewModel.selectedAccounts.isEmpty {
                                        toast.response = await viewModel.delete()
                                    } else {
                                        toast.response = await viewModel.deleteMltipleItems()
                                    }
                                }
                            }
                            
                            Button(.alertOptionCancel, role: .cancel) { }
                        } message: {
                            Text(.accountDeleteMessage(viewModel.selectedAccounts.count))
                        }
                    }
                }
            }
            //.foregroundColor(Color.listRowForeground) //Para los botones. El texto queda originalmente en azul.
            //.navigationLinkIndicatorVisibility(.visible)
            .animation(.default, value: viewModel.sortedAccounts)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundGradient)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if viewModel.isEditing {
                if viewModel.selectedAccounts.count == viewModel.sortedAccounts.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedAccounts = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedAccounts = Set(viewModel.sortedAccounts)
                    }
                }
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            if viewModel.isEditing {
                Button(role: .cancel) {
                    viewModel.selectedAccounts.removeAll()
                    
                    withAnimation {
                        viewModel.isEditing = false
                    }
                }
            } else {
                
                Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                    
                    Button {
                        withAnimation {
                            viewModel.isEditing = true
                        }
                    } label: {
                        Label(.selectorSelect, systemImage: ConstantSystemImage.checkmarkCircle)
                    }
                    
                    
                    Menu {
                        Section {
                            Picker(.sortTitle, selection: $viewModel.sortSelection.sortBy) {
                                ForEach(AccountSortOption.allCases, id: \.self) { sortBy in
                                    Text(sortBy.localized)
                                        .tag(sortBy)
                                }
                            }
                            
                        }
                        
                        Section {
                            Picker(.sortTitle, selection: $viewModel.sortSelection.order) {
                                ForEach(SortOrder.allCases, id: \.self) { order in
                                    Text(order.localized)
                                        .tag(order)
                                }
                            }
                        }
                        
                        Section {
                            VStack(alignment: .leading) {
                                Button(role: .destructive) {
                                    viewModel.resetSelectedSort()
                                } label: {
                                    Text(.sortByDefault)
                                }
                            }
                            
                        }
                        
                    } label: {
                        Label(.sortTitle, systemImage: ConstantSystemImage.arrowUpDown)
                        
                        Text(viewModel.sortSelection.sortBy.localized)
                    }
                    
                }
                .menuOrder(.fixed)
                .disabled(viewModel.sortedAccounts.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            if viewModel.isEditing {
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
    var body: some View { AccountView() }
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
