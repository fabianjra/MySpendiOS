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
    
    var body: some View {
        VStack {
            itemList
        }
        .background(Color.backgroundContentGradient)
        .navigationTitle(.accountsTitle)
        .navigationBarTitleDisplayMode(.inline)
//        .toolbarTitleDisplayMode(.inlineLarge)
        .navigationBarBackButtonHidden(viewModel.isEditing)
        
        .toolbar {
            toolbarContent
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
        
        .toast(viewModel.responseToast, isPresented: $viewModel.showToast)
    }
    
    // MARK: - VIEWS
    
    private var itemList: some View {
        VStack {
            if viewModel.allAccounts.isEmpty {
                TransactionsEmptyView()
            } else {
                ListContainer {
                    SectionContainer(isInsideList: true) {
                        ForEach(viewModel.allAccounts) { item in
                            HStack {
                                if viewModel.isEditing {
                                    Image(systemName: viewModel.selectedAccounts.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: FrameSize.width.iconRowList,
                                               height: FrameSize.height.iconRowList)
                                        .foregroundStyle(.alert)
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
                                    
                                    Text(.accountsDefault)
                                        .textStyle(color: .textFieldForeground,
                                                   family: .light,
                                                   size: .medium)
                                }
                                
                                Image.chevronRight
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
                                            await viewModel.delete()
                                        } else {
                                            await viewModel.deleteMltipleItems()
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
                if viewModel.selectedAccounts.count == viewModel.allAccounts.count {
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
        
        ToolbarItem(placement: .title) {
            if viewModel.selectedAccounts.count == .zero {
                Text(.accountsTitle)
                    .textStyle(size: .big)
            } else {
                Text(.selectorSelectedCountFemale(viewModel.selectedAccounts.count))
                    .textStyle(size: .medium)
            }
        }
        
        
        // MARK: BOTTOM
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            
            
            if viewModel.isEditing {
                Button(role: .cancel) {
                    viewModel.selectedAccounts.removeAll()
                    
                    withAnimation {
                        viewModel.isEditing = false
                    }
                }
            } else {
                
                Menu("Options", systemImage: ConstantSystemImage.options) {
                    
                    Button {
                        viewModel.isEditing = true
                    } label: {
                        Label(.selectorSelect, systemImage: ConstantSystemImage.checkmarkCircle)
                    }
            
                    
                    Menu {
                        Section {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
                        }
                        
                        // Reset the sort selection to default
                        Section {
                            Button {
                                withAnimation {
                                    viewModel.resetSelectedSort()
                                }
                            } label: {
                                Label.restoreSelection
                                    .tint(.alert)
                            }
                        }
                    } label: {
                        Label("Sort by", systemImage: ConstantSystemImage.arrowUpDown) //TODO: Agregar estilo para label
                            .font(.montserrat())
                        
                        Text(viewModel.sortSelection.rawValue)
                            .textStyle
                    }
                    
                }
                .menuOrder(.fixed)
                .disabled(viewModel.allAccounts.isEmpty)
            }
            
        }
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            if viewModel.isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash) {
                    showAlertDelete = true
                }
                .disabled(viewModel.selectedAccounts.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem) {
                    showNewItemModal = true
                }
            }
        }
    }
    
    
    private func sortButton(for sortingOption: SortAccounts) -> some View {
        Button {
            withAnimation {
                if viewModel.sortSelection == sortingOption {
                    viewModel.sortSelection = sortingOption.toggle
                } else {
                    viewModel.sortSelection = sortingOption
                }
            }
        } label: {
            viewModel.sortSelection == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
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
            .environment(\.locale, .init(identifier: Previews.localeES_CR))
    }
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
