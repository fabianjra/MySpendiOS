//
//  SelectCategoryModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct SelectCategoryModalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedCategory: CategoryModel
    @StateObject var viewModel = CategoryViewModel()
    
    @Binding var categoryType: TransactionType
    
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
                
                let categoriesFiltered = viewModel.categories.filter { $0.categoryType == categoryType }
                
                if categoriesFiltered.isEmpty {
                    NoContentView(title: "No categories",
                                  rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
                } else {
                    ListContainer {
                        ForEach(categoriesFiltered.sorted(by: { $0.datemodified > $1.datemodified })) { category in
                            HStack {
                                let icon = category.icon.getIconFromSFSymbol
                                
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
                    viewModel.showNewCategoryModal = true
                }
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $viewModel.showNewCategoryModal) {
            AddModifyCategoryView(categoryType: $categoryType)
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
    }
}

#Preview("Expenses es_CR") {
    @Previewable @State var showModal = true
    @Previewable @State var selectedCategory = MocksCategories.normal.first!
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain("Selected category: \(selectedCategory.name)")
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        SelectCategoryModalView(selectedCategory: $selectedCategory, viewModel: CategoryViewModel(categories: MocksCategories.normal), categoryType: $selectedCategory.categoryType)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
    .onAppear {
        showModal = true
    }
}
