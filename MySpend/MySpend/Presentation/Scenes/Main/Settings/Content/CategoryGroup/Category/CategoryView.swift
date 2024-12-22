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
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Categories",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select or add categories",
                            subTitleWeight: .regular)
            .padding(.horizontal)
            .padding(.bottom)
            
            VStack {
                PickerSegmented(selection: $viewModel.categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
            ZStack(alignment: .bottomTrailing) {
                
                let categoriesFiltered = viewModel.categories
                    .filter { $0.categoryType == viewModel.categoryType }
                    .sorted(by: { $0.name < $1.name })
                
                if categoriesFiltered.isEmpty {
                    NoContentView(title: "No categories",
                                  rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
                } else {
                    ListContainer {
                        ForEach(categoriesFiltered) { category in
                            HStack {
                                let icon = category.icon.getIconFromSFSymbol
                                
                                if let image = icon {
                                    image
                                        .frame(width: FrameSize.width.iconCategoryList,
                                               height: FrameSize.height.iconCategoryList)
                                }
                                
                                Button(category.name) {
                                    selectedModel = category
                                    viewModel.showModifyItemModal = true
                                }
                                
                                Spacer()
                                
                                Image.chevronRight
                            }
                            .listRowBackground(Color.listRowBackground) //Background for each row.
                            .swipeActions(edge: .trailing) {
                                Button {
                                    selectedModel = category
                                    viewModel.showAlertDelete = true
                                } label: {
                                    Label.delete
                                }
                                .tint(Color.alert)
                                
                                Button {
                                    selectedModel = category
                                    viewModel.showModifyItemModal = true
                                } label: {
                                    Label.edit
                                }
                                .tint(Color.warning)
                            }
                            .alert("Delete category", isPresented: $viewModel.showAlertDelete) {
                                Button("Delete", role: .destructive) { delete() }
                                Button("Cancel", role: .cancel) { }
                            } message: {
                                Text("Want to delete this category? \n This action cannot be undone.")
                            }
                        }
                    }
                    .animation(.default, value: categoriesFiltered.count)
                }
                
                ButtonRounded {
                    viewModel.showNewItemModal = true
                }
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $viewModel.showNewItemModal) {
            AddModifyCategoryView(categoryType: $viewModel.categoryType)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .sheet(isPresented: $viewModel.showModifyItemModal) {
            AddModifyCategoryView(model: $selectedModel,
                               categoryType: $viewModel.categoryType)
            .presentationDetents([.large])
            .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
    
    private func delete() {
        Task {
            let result = await viewModel.deleteCategory(selectedModel)
            
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

#Preview("Saturated en_US") {
    CategoryView(viewModel: CategoryViewModel(categories: MocksCategories.random_generated))
        .environment(\.locale, .init(identifier: "en_US"))
}

#Preview("No content es_ES") {
    CategoryView()
        .environment(\.locale, .init(identifier: "en_ES"))
}
