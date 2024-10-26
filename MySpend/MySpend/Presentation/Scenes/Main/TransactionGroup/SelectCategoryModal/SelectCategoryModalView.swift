//
//  SelectCategoryModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct SelectCategoryModalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = CategoryViewModel()
    @Binding var selectedCategory: CategoryModel
    var transactionType: TransactionType
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Categories",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select the category",
                            subTitleWeight: .regular,
                            showLeadingAction: false,
                            showTrailingAction: true)
            .padding(.top)
            .padding(.vertical)
            .padding(.horizontal)
            
            
            ZStack(alignment: .bottomTrailing) {
                
                let categoriesFiltered = viewModel.categories.filter { $0.categoryType == transactionType }
                
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
                                    selectedCategory = category
                                    dismiss()
                                }
                                
                                Spacer()
                                
                                Image.chevronRight
                            }
                        }
                        .listRowBackground(Color.listRowBackground) //Background for each row.
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
            NewCategoryView(model: CategoryModel(categoryType: transactionType))
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
}

#Preview("Content EN") {
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
        
        let viewModel = CategoryViewModel(categories: array)
        
        SelectCategoryModalView(viewModel: viewModel, selectedCategory: .constant(CategoryModel()), transactionType: .expense)
            .environment(\.locale, .init(identifier: "en"))
    }
}

#Preview("No content ES") {
    VStack {
        SelectCategoryModalView(viewModel: CategoryViewModel(), selectedCategory: .constant(CategoryModel()), transactionType: .expense)
            .environment(\.locale, .init(identifier: "es"))
    }
}
