//
//  CategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoryView: View {
    
    @StateObject var viewModel = CategoryViewModel()
    @State private var selectedModel = CategoryModel()
    
    //TODO: MOVER A VISTAS POR SEPARADO PARA PODER AGREGAR EL LOADER
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
                    viewModel.showNewCategoryModal = true
                }
                .disabled(viewModel.isEditing)
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
            
            TextError(viewModel.errorMessage)
        }
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $viewModel.showNewCategoryModal) {
            AddModifyCategoryView(categoryType: $viewModel.categoryType)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .sheet(isPresented: $viewModel.showModifyCategoryModal) {
            AddModifyCategoryView(model: $selectedModel,
                                  categoryType: $viewModel.categoryType)
            .presentationDetents([.large])
            .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .disabled(viewModel.isLoadingSecondary)
    }
    
    // MARK: VIEWS
    
    private var topMenu: some View {
        VStack {
            ListEditorView(isEditing: $viewModel.isEditing,
                           counterSelected: viewModel.selectedCategories.count) {
                
                viewModel.selectedCategories.removeAll()
                
            } actionTrailingEdit: {
                viewModel.showAlertDeleteMultiple = true
            }
            
            
            VStack {
                PickerSegmented(selection: $viewModel.categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom, ConstantViews.mediumSpacing)
                
                RowLCTCointainer(disabled: viewModel.isEditing, leadingContent:  {
                    MenuContainer(addHorizontalPadding: true, disabled: viewModel.isEditing) {
                        Section("Sort by") {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
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
        } label: {
            viewModel.sortCategoriesBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
        }
    }
    
    private var categoryList: some View {
        VStack {
            let categoriesFiltered = UtilsCategories.filteredCategories(viewModel.categories,
                                                                        by: viewModel.categoryType,
                                                                        sortType: viewModel.sortCategoriesBy)
            
            if categoriesFiltered.isEmpty {
                NoContentView(title: "No categories",
                              rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
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
                            
                            let icon = item.icon.getIconFromSFSymbol
                            
                            if let image = icon {
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
                                    selectedModel = item
                                    viewModel.showModifyCategoryModal = true
                                }
                            }
                            
                            Spacer()
                            
                            Image.chevronRight
                        }
                        .listRowBackground(Color.listRowBackground) //Background for each row.
                        .swipeActions(edge: .trailing) {
                            Button {
                                selectedModel = item
                                viewModel.showAlertDelete = true
                            } label: {
                                Label.delete
                            }
                            .tint(Color.alert)
                            
                            Button {
                                selectedModel = item
                                viewModel.showModifyCategoryModal = true
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
    
    
    // MARK: FUNCTIONS
    
    private func delete() {
        Task {
            let result = await viewModel.deleteCategory(selectedModel)
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
    
    private func deleteMltipleCategories() {
        Task {
            let result = await viewModel.deleteMltipleCategories()
            
            if result.status.isError {
                viewModel.errorMessage = result.message
            }
        }
    }
}

#Preview("es_CR") {
    CategoryView(viewModel: CategoryViewModel(categories: MocksCategories.normal))
        .environment(\.locale, .init(identifier: "es_CR"))
}

#Preview("Only expenses es_CR") {
    CategoryView(viewModel: CategoryViewModel(categories: MocksCategories.onlyExpenses))
        .environment(\.locale, .init(identifier: "es_CR"))
}

#Preview("Only incomes en_US") {
    CategoryView(viewModel: CategoryViewModel(categories: MocksCategories.onlyIncomes))
        .environment(\.locale, .init(identifier: "en_US"))
}

#Preview("Saturated en_US") {
    CategoryView(viewModel: CategoryViewModel(categories: MocksCategories.random_generated))
        .environment(\.locale, .init(identifier: "en_US"))
}

#Preview("No content es_ES") {
    CategoryView()
        .environment(\.locale, .init(identifier: "en_ES"))
}
