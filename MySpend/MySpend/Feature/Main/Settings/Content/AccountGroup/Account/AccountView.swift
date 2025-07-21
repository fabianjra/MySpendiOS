//
//  AccountView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import SwiftUI

struct AccountView: View {
    
    @State private var showNewItemModal = false
    
    @StateObject var viewModel = AccountViewModel()
    
    @State private var modelType: AccountType = .general
    @State private var modelToModify: AccountModel?
    @State private var modelToDelete: AccountModel?
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Accounts",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select or add accounts",
                            subTitleWeight: .regular)
            .padding(.bottom)
            
            
            if !viewModel.models.isEmpty {
                topMenu
            }
            
            
            ZStack(alignment: .bottomTrailing) {
                
                itemList
                
                ButtonRounded {
                    showNewItemModal = true
                }
                .disabled(viewModel.isEditing)
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
            
            TextError(viewModel.errorMessage)
        }
        .onAppear {
            viewModel.activateObservers()
        }
        .onDisappear {
            viewModel.deactivateObservers()
        }
        // Siempre con bordes pero hace mas lento la activacion del sheet:
        //.sheet(isPresented: $showNewItemModal, onDismiss:{ UtilsUI.actionDelayed{ isSheetOpen = false }}) {
        .sheet(isPresented: $showNewItemModal) {
            AddModifyAccountView(accountType: $modelType)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .sheet(item: $modelToModify) { model in
            AddModifyAccountView(model, accountType: $modelType)
            .onDisappear {
                modelToModify = nil
            }
            .presentationDetents([.large])
            .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
    
    // MARK: - VIEWS
    
    private var topMenu: some View {
        VStack {
            ListEditorView(isEditing: $viewModel.isEditing,
                           counterSelected: viewModel.selectedModels.count) {
                
                viewModel.selectedModels.removeAll()
                
            } actionTrailingEdit: {
                viewModel.showAlertDeleteMultiple = true
            }
            
            
            VStack {
                PickerView(selection: $modelType)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    .padding(.bottom, ConstantViews.mediumSpacing)
                
                RowLCTCointainer(disabled: viewModel.isEditing, leadingContent:  {
                    MenuContainer(addHorizontalPadding: true, disabled: viewModel.isEditing) {
                        Section("Sorted by: \(viewModel.sortModelsBy.rawValue)") {
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
        .disabled(viewModel.models.isEmpty)
    }

    private func sortButton(for sortingOption: SortAccounts) -> some View {
        Button {
            if viewModel.sortModelsBy == sortingOption {
                viewModel.sortModelsBy = sortingOption.toggle
            } else {
                viewModel.sortModelsBy = sortingOption
            }
            
            viewModel.updateSelectedSort()
        } label: {
            viewModel.sortModelsBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
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
            let modelsFiltered = UtilsAccounts.filteredAccounts(viewModel.models,
                                                                by: modelType,
                                                                sortType: viewModel.sortModelsBy)
            
            if modelsFiltered.isEmpty {
                NoContentToAddView(rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
            } else {
                ListContainer {
                    SectionContainer("Available accounts", isInsideList: true) {
                        ForEach(modelsFiltered) { item in
                            HStack {
                                if viewModel.isEditing {
                                    Image(systemName: viewModel.selectedModels.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: FrameSize.width.selectIconInsideTextField,
                                               height: FrameSize.height.selectIconInsideTextField)
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
                                        if viewModel.selectedModels.contains(item) {
                                            viewModel.selectedModels.remove(item)
                                        } else {
                                            viewModel.selectedModels.insert(item)
                                        }
                                    } else {
                                        modelToModify = item
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
                                    modelToDelete = item
                                    viewModel.showAlertDelete = true
                                } label: {
                                    Label.delete
                                }
                                .tint(Color.alert)
                                
                                Button {
                                    modelToModify = item
                                } label: {
                                    Label.edit
                                }
                                .tint(Color.warning)
                            }
                            
                            // MARK: DELETE ITEMS SINGLE
                            
                            .alert("Delete account", isPresented: $viewModel.showAlertDelete) {
                                Button("Delete", role: .destructive) { delete() }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete this account? \n This action cannot be undone.")
                            }
                            
                            // MARK: DELETE ITEMS MULTIPLE
                            
                            .alert("Delete accounts", isPresented: $viewModel.showAlertDeleteMultiple) {
                                Button("Delete", role: .destructive) { deleteMltipleItems() }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete these accounts? \n This action cannot be undone.")
                            }
                        }
                    }
                }
                .animation(.default, value: modelsFiltered.count)
                .animation(.default, value: viewModel.isEditing)
                .animation(.default, value: viewModel.sortModelsBy)
            }
        }
    }
    
    func rowView(_ model: AccountModel?) -> some View {
        HStack {
            if let image = model?.icon.getIconFromSFSymbol {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: FrameSize.height.selectIconInsideTextField,
                           height: FrameSize.width.selectIconInsideTextField)
            }
            
            TextPlain(model?.name ?? "No default account selected", color: Color.disabledForeground)
            
            Spacer()
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    private func delete() {
        defer {
            modelToDelete = nil
        }
        
        let result = viewModel.delete(modelToDelete)
        
        if result.status.isError {
            viewModel.errorMessage = result.message
        }
    }
    
    private func deleteMltipleItems() {
        let result = viewModel.deleteMltipleItems()
        
        if result.status.isError {
            viewModel.errorMessage = result.message
        }
    }
}


private struct previewWrapper: View {
    init() {
        UserDefaultsManager.userDefaults = .preview
        UserDefaultsManager.defaultAccountID = MockCDConstants.mainAccountID
    }
    var body: some View { AccountView() }
}

#Preview("es_CR") {
    previewWrapper()
        .environment(\.locale, .init(identifier: "es_CR"))
}
