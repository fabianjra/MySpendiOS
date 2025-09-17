//
//  CategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoryView: View {
    
    @StateObject private var viewModel = CategoryViewModel()
    
    @State private var showNewItemModal = false
    
    @State private var modelType: CategoryType = .expense
    @State private var modelToModify: CategoryModel?
    @State private var modelToDelete: CategoryModel?
    
    //TOD: MOVER A VISTAS POR SEPARADO PARA PODER AGREGAR EL LOADER
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Categories",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select or add categories",
                            subTitleWeight: .regular)
            .padding(.bottom)
            
            
            if !viewModel.categories.isEmpty {
                topMenu
            }
            
            
            ZStack(alignment: .bottomTrailing) {
                
                categoryList
                
                ButtonRounded {
                    showNewItemModal = true
                }
                .disabled(viewModel.isEditing)
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
            
            TextError(viewModel.errorMessage)
        }
        .task {
            await viewModel.activateObservers()
        }
        .onDisappear {
            viewModel.deactivateObservers()
        }
        .sheet(isPresented: $showNewItemModal) {
            AddModifyCategoryView(categoryType: $modelType)
                .presentationDetents([.large])
        }
        .sheet(item: $modelToModify) { model in
            AddModifyCategoryView(model, categoryType: $modelType)
                .presentationDetents([.large])
                .onDisappear {
                    modelToModify = nil
                }
        }
    }
    
    // MARK: - VIEWS
    
    private var topMenu: some View {
        VStack {
            ListEditorView(isEditing: $viewModel.isEditing,
                           counterSelected: viewModel.selectedCategories.count) {
                
                viewModel.selectedCategories.removeAll()
                
            } actionTrailingEdit: {
                viewModel.showAlertDeleteMultiple = true
            }
            
            
            VStack {
                PickerView(selection: $modelType)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    .padding(.bottom, ConstantViews.mediumSpacing)
                
                RowLCTCointainer(disabled: viewModel.isEditing, leadingContent:  {
                    MenuContainer(addHorizontalPadding: true, disabled: viewModel.isEditing) {
                        Section("Sorted by: \(viewModel.sortCategoriesBy.rawValue)") {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
                            sortButton(for: .byMostOftenUsed)
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
        .disabled(viewModel.categories.isEmpty)
    }

    private func sortButton(for sortingOption: SortCategories) -> some View {
        Button {
            if viewModel.sortCategoriesBy == sortingOption {
                viewModel.sortCategoriesBy = sortingOption.toggle
            } else {
                viewModel.sortCategoriesBy = sortingOption
            }
            
            viewModel.updateSelectedSort()
        } label: {
            viewModel.sortCategoriesBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
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
    
    private var categoryList: some View {
        VStack {
            let categoriesFiltered = UtilsCategories.filteredCategories(viewModel.categories,
                                                                        by: modelType,
                                                                        sortType: viewModel.sortCategoriesBy)
            
            if categoriesFiltered.isEmpty {
                NoContentToAddView(rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
            } else {
                ListContainer {
                    ForEach(categoriesFiltered) { item in
                        HStack {
                            if viewModel.isEditing {
                                Image(systemName: viewModel.selectedCategories.contains(item) ? ConstantSystemImage.checkmarkCircleFill : ConstantSystemImage.circle)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: FrameSize.width.selectIconInsideTextField,
                                           height: FrameSize.height.selectIconInsideTextField)
                                    .foregroundStyle(Color.alert)
                                    .transition(.scale.combined(with: .move(edge: .leading)))
                            }
                            
                            if let image = item.icon.getIconFromSFSymbol {
                                image
                                    .frame(width: FrameSize.width.iconCategoryList,
                                           height: FrameSize.height.iconCategoryList)
                            }
                            
                            Button(item.name) {
                                if viewModel.isEditing {
                                    if viewModel.selectedCategories.contains(item) {
                                        viewModel.selectedCategories.remove(item)
                                    } else {
                                        viewModel.selectedCategories.insert(item)
                                    }
                                } else {
                                    modelToModify = item
                                }
                            }
                            
                            Spacer()
                            
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
                        
                        .alert("Delete category", isPresented: $viewModel.showAlertDelete) {
                            Button("Delete", role: .destructive) { delete() }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Want to delete this category? \n This action cannot be undone.")
                        }
                        
                        // MARK: DELETE ITEMS MULTIPLE
                        
                        .alert("Delete categoreis", isPresented: $viewModel.showAlertDeleteMultiple) {
                            Button("Delete", role: .destructive) { deleteMltipleCategories() }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Want to delete these categories? \n This action cannot be undone.")
                        }
                    }
                }
                .animation(.default, value: categoriesFiltered.count)
                .animation(.default, value: viewModel.isEditing)
                .animation(.default, value: viewModel.sortCategoriesBy)
            }
        }
    }
    
    
    // MARK: - FUNCTIONS
    
    private func delete() {
        Task {
            defer {
                modelToDelete = nil
            }
            
            let result = await viewModel.delete(modelToDelete)
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func deleteMltipleCategories() {
        Task {
            let result = await viewModel.deleteMltiple()
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        CoreDataUtilities.shared.mockDataType = mockDataType
    }
    var body: some View { CategoryView() }
}

#Preview("Normal es_CR") {
    previewWrapper()
        .environment(\.locale, .init(identifier: "es_CR"))
}

#Preview("Saturated en_US") {
    previewWrapper(.saturated)
        .environment(\.locale, .init(identifier: "en_US"))
}

#Preview("Empty es_ES") {
    previewWrapper(.empty)
        .environment(\.locale, .init(identifier: "en_ES"))
}

//#Preview("Only expenses es_CR") {
//    CategoryView(viewModel: CategoryViewModel(categories: MocksCategoriesFB.onlyExpenses))
//        .environment(\.locale, .init(identifier: "es_CR"))
//}
//
//#Preview("Only incomes en_US") {
//    CategoryView(viewModel: CategoryViewModel(categories: MocksCategoriesFB.onlyIncomes))
//        .environment(\.locale, .init(identifier: "en_US"))
//}
