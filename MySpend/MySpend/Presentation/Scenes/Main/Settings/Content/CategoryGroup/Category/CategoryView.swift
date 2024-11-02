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
                    .sorted(by: { $0.dateCreated > $1.dateCreated })
                
                if categoriesFiltered.isEmpty {
                    NoContentView(title: "No categories",
                                  rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
                } else {
                    ListContainer {
                        ForEach(categoriesFiltered) { category in
                            HStack {
                                let icon = Utils.getIconFromString(category.icon)
                                
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
            NewCategoryView(model: CategoryModel(categoryType: viewModel.categoryType))
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .sheet(isPresented: $viewModel.showModifyItemModal) {
            ModifyCategoryView(modelLoaded: $selectedModel)
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

#Preview("Content") {
    VStack {
        let array = [
            CategoryModel(id: UUID().uuidString,
                          icon: "envelope.fill",
                          name: "Expense 1",
                          categoryType: .expense),
            CategoryModel(id: UUID().uuidString,
                          icon: "arrowshape.turn.up.left.fill",
                          name: "Income 1",
                          categoryType: .income),
            CategoryModel(id: UUID().uuidString,
                          icon: "xmark",
                          name: "Expense 2",
                          categoryType: .expense),
            CategoryModel(id: UUID().uuidString,
                          icon: "",
                          name: "Expense 3",
                          categoryType: .expense),
            
            CategoryModel(id: UUID().uuidString,
                          icon: "person.fill",
                          name: "Income 2",
                          categoryType: .income)
        ]
        
        let viewModel = CategoryViewModel(categories: array)
        
        CategoryView(viewModel: viewModel)
    }
}

#Preview("Screen filled") {
    
    @Previewable @State var arrayCategories: [CategoryModel] = (1...40).map { item in
        
        CategoryModel(id: UUID().uuidString,
                      icon: "person.fill",
                      name: "\(item) Categoria prueba",
                      categoryType: .expense)
    }
    
    VStack {
        let viewModel = CategoryViewModel(categories: arrayCategories)
        CategoryView(viewModel: viewModel)
    }
}

#Preview("No content") {
    CategoryView()
}
