//
//  SelectCategoryModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/10/24.
//

import SwiftUI

struct SelectCategoryModalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // Parameters managed by New Transaction (add or modify):
    @Binding var selectedCategory: CategoryModel
    @Binding var categoryType: CategoryType
    
    @StateObject private var viewModel = CategoryViewModel()
    
    // Validate if should dismiss this modal because a new category was added.
    @State private var isNewModelAdded: Bool = false
    @State private var newCategoryID: UUID = UUID()
    
    @State private var showNewItemModal = false
    
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
                PickerView(selection: $categoryType)
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
                    NoContentToAddView(rotationDegress: ConstantAnimations.rotationArrowBottomTrailing)
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
                    showNewItemModal = true
                }
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
        }
        .onAppear {
            Task {
                await viewModel.activateObservers()
            }
        }
        .onDisappear {
            viewModel.deactivateObservers()
        }
        .onChange(of: viewModel.categories) {
            if isNewModelAdded {
                if let newCategoryAdded = viewModel.categories.first(where: { $0.id == newCategoryID }) {
                    selectedCategory = newCategoryAdded
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showNewItemModal) {
            AddModifyCategoryView(categoryType: $categoryType,
                                  newCategoryID: $newCategoryID,
                                  isSelectionMode: true,
                                  isNewModelAdded: $isNewModelAdded)
            .presentationDetents([.large])
        }
        .presentationDetents([.large])
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

//TOD: REPARAR
//#Preview("Expenses es_CR") {
//    @Previewable @State var showModal = true
//    @Previewable @State var selectedCategory = CategoryModel()
//    //@Previewable @State var viewModelMock = CategoryManager(viewContext: MockTransaction.preview.container.viewContext)
//    @Previewable @State var viewModelMock = CoreDataUtilities.
//    
//    ZStack(alignment: .top) {
//        Color.backgroundBottom
//        VStack {
//            Spacer()
//            TextPlain("Selected category: \(selectedCategory.name)")
//            
//            Button("Show modal") {
//                showModal = true
//            }
//            Spacer()
//        }
//    }.sheet(isPresented: $showModal) {
//        SelectCategoryModalView(selectedCategory: $selectedCategory,
//                                categoryType: $selectedCategory.categoryType,
//                                viewModel: viewModelMock)
//            .environment(\.locale, .init(identifier: "es_CR"))
//    }
//    .onAppear {
//        showModal = true
//    }
//}

#Preview("No content en_US") {
    @Previewable @State var showModal = true
    @Previewable @State var categoryType: CategoryType = .expense
    
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
        SelectCategoryModalView(selectedCategory: .constant(CategoryModel()), categoryType: $categoryType)
            .environment(\.locale, .init(identifier: "en_US"))
    }
    .onAppear {
        showModal = true
    }
}
