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
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
    }
}

#Preview("Expenses ES") {
    @Previewable @State var showModal = true
    @Previewable @State var selectedCategory = CategoryModel(id: "01",
                                                             icon: CategoryIcons.bills.list[0],
                                                             name: "Expense 1",
                                                             categoryType: .expense)
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain(message: "Selected category: \(selectedCategory.name)")
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        let array = [
            CategoryModel(id: "01",
                          icon: CategoryIcons.bills.list[0],
                          name: "Expense 1",
                          categoryType: .expense),
            CategoryModel(id: "02",
                          icon: CategoryIcons.bills.list[1],
                          name: "Income 1",
                          categoryType: .income),
            CategoryModel(id: "03",
                          icon: CategoryIcons.bills.list[2],
                          name: "Expense 2",
                          categoryType: .expense),
            CategoryModel(id: "04",
                          icon: "",
                          name: "Expense 3",
                          categoryType: .expense),
            CategoryModel(id: "05",
                          icon: CategoryIcons.bills.list[3],
                          name: "Income 2",
                          categoryType: .income)
        ]
        
        let viewModel = CategoryViewModel(categories: array)
        
        SelectCategoryModalView(viewModel: viewModel, selectedCategory: $selectedCategory, transactionType: .expense)
            .environment(\.locale, .init(identifier: "es"))
    }
    .onAppear {
        showModal = true
    }
}
