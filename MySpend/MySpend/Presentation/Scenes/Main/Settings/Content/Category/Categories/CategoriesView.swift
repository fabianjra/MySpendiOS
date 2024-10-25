//
//  CategoriesView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoriesView: View {
    
    @StateObject var viewModel = CategoriesViewModel()
    
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
                ListContainer {
                    
                    let categoriesFiltered = viewModel.categories.filter { $0.categoryType == viewModel.categoryType }
                    
                    ForEach(categoriesFiltered) { category in
                        HStack {
                            let icon = Utils.getIconFromString(category.icon)
                            
                            if let image = icon {
                                image
                                    .frame(width: FrameSize.width.iconCategoryList,
                                           height: FrameSize.height.iconCategoryList)
                            }
                            
                            Button(category.name) {
                                viewModel.categoryToModify = category
                                viewModel.showModifyItemModal = true
                            }
                            
                            Spacer()
                            
                            Image.chevronRight
                        }
                    }
                    .listRowBackground(Color.listRowBackground) //Background for each row.
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
            NewCategoryView()
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .sheet(isPresented: $viewModel.showModifyItemModal) {
            ModifyCategoryView(model: $viewModel.categoryToModify)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
}

#Preview("Content") {
    VStack {
        let array = [
            CategoryModel(icon: "envelope.fill",
                          name: "Expense 1",
                          categoryType: .expense),
            CategoryModel(icon: "arrowshape.turn.up.left.fill",
                          name: "Income 1",
                          categoryType: .income),
            CategoryModel(icon: "xmark",
                          name: "Expense 2",
                          categoryType: .expense),
            CategoryModel(icon: "",
                          name: "Expense 3",
                          categoryType: .expense),
            
            CategoryModel(icon: "person.fill",
                          name: "Income 2",
                          categoryType: .income)
        ]
        
        let viewModel = CategoriesViewModel(categories: array)
        
        CategoriesView(viewModel: viewModel)
    }
}

#Preview("Screen filled") {
    
    @Previewable @State var arrayCategories: [CategoryModel] = (1...40).map { item in
        
        CategoryModel(icon: "person.fill",
                      name: "\(item) Categoria prueba",
                      categoryType: .expense)
    }
    
    VStack {
        let viewModel = CategoriesViewModel(categories: arrayCategories)
        CategoriesView(viewModel: viewModel)
    }
}

#Preview("Without content") {
    CategoriesView()
}
