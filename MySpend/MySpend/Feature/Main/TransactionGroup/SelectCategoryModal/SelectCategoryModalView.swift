//
//  SelectCategoryModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct SelectCategoryModalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // Parameters managed by New Transaction (add or modify):
    @Binding var selectedCategory: CategoryModelFB
    @Binding var categoryType: TransactionType
    
    @StateObject var viewModel = CategoryViewModel()
    
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
            
            
            VStack {
                PickerSegmented(selection: $categoryType,
                                segments: TransactionType.allCases)
                .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                .padding(.bottom, ConstantViews.mediumSpacing)
                
                RowLCTCointainer(leadingContent: {
                    MenuContainer {
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
            .padding(.horizontal)
            
            
            ZStack(alignment: .bottomTrailing) {
                
                let categoriesFiltered = UtilsCategories.filteredCategories(viewModel.categories,
                                                                            by: categoryType,
                                                                            sortType: viewModel.sortCategoriesBy)
                
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
                                    selectedCategory = category
                                    dismiss()
                                }
                                
                                Spacer()
                                
                                Image.chevronRight
                            }
                        }
                        .listRowBackground(Color.listRowBackground) //Background for each row.
                    }
                    .animation(.default, value: viewModel.sortCategoriesBy)
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
}

#Preview("Expenses es_CR") {
    @Previewable @State var showModal = true
    @Previewable @State var selectedCategory = CategoryModelFB()
    @Previewable @State var viewModelMock = CategoryViewModel(categories: MocksCategoriesFB.normal)
    
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
                                categoryType: $selectedCategory.categoryType,
                                viewModel: viewModelMock)
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
        SelectCategoryModalView(selectedCategory: .constant(CategoryModelFB()),
                                categoryType: .constant(.expense),
                                viewModel: CategoryViewModel())
            .environment(\.locale, .init(identifier: "en_US"))
    }
    .onAppear {
        showModal = true
    }
}
