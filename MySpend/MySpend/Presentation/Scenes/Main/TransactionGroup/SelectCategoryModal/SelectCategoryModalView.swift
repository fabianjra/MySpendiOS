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
    
    // Validate if should dismiss this modal because a new category was added.
    @State var isNewCategoryAdded: Bool = false
    @State var newCategoryID: String = ""
    
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
            
            
            PickerSegmented(selection: $categoryType,
                            segments: TransactionType.allCases)
            .frame(maxWidth: ConstantFrames.iPadMaxWidth)
            .padding(.bottom, ConstantViews.mediumSpacing)
            .padding(.horizontal)
            
            
            ZStack(alignment: .bottomTrailing) {
                
                let categoriesFiltered = viewModel.categories.filter { $0.categoryType == categoryType }
                
                if categoriesFiltered.isEmpty {
                    NoContentView(title: "No categories",
                                  rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
                } else {
                    ListContainer {
                        ForEach(categoriesFiltered.sorted(by: { $0.name < $1.name })) { category in
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
        .onChange(of: isNewCategoryAdded) { _, newValue in
            if newValue {
                if let newCategoryAdded = viewModel.categories.first(where: { $0.id == newCategoryID }) {
                    selectedCategory = newCategoryAdded
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $viewModel.showNewCategoryModal) {
            AddModifyCategoryView(categoryType: $categoryType,
                                  isNewCategoryAdded: $isNewCategoryAdded,
                                  newCategoryID: $newCategoryID)
            .presentationDetents([.large])
            .presentationCornerRadius(ConstantRadius.cornersModal)
        }
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
    }
}

#Preview("Expenses es_CR") {
    @Previewable @State var showModal = true
    @Previewable @State var selectedCategory = CategoryModel()
    
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
        SelectCategoryModalView(selectedCategory: $selectedCategory,
                                viewModel: CategoryViewModel(categories: MocksCategories.normal),
                                categoryType: $selectedCategory.categoryType)
            .environment(\.locale, .init(identifier: "es_CR"))
    }
    .onAppear {
        showModal = true
    }
}

#Preview("No content en_US") {
    @Previewable @State var showModal = true
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        SelectCategoryModalView(selectedCategory: .constant(CategoryModel()),
                                viewModel: CategoryViewModel(),
                                categoryType: .constant(.expense))
            .environment(\.locale, .init(identifier: "en_US"))
    }
    .onAppear {
        showModal = true
    }
}
