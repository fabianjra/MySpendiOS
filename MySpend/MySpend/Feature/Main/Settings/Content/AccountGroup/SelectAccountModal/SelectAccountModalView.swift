//
//  SelectAccountModalView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 10/7/25.
//

import SwiftUI

struct SelectAccountModalView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var modelType: AccountType = .general
    @Binding var selectedModel: AccountModel
    
    @StateObject var viewModel = AccountViewModel()
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Accounts",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select the account",
                            subTitleWeight: .regular,
                            showLeadingAction: false,
                            showTrailingAction: true)
            .padding(.top)
            .padding(.vertical)
            .padding(.horizontal)
            
            
            VStack {
                PickerView(selection: $modelType)
                    .frame(maxWidth: ConstantFrames.iPadMaxWidth)
                    .padding(.bottom, ConstantViews.mediumSpacing)
                
                
                RowLCTCointainer(leadingContent: {
                    MenuContainer {
                        Section("Sorted by: \(viewModel.sortModelsBy.rawValue)") {
                            sortButton(for: .byNameAz)
                            sortButton(for: .byCreationNewest)
                        }
                        
                        Section {
                            sortButtonResetToDefault
                        }
                    }
                })
            }
            .padding(.horizontal)
            
            
            ZStack(alignment: .bottomTrailing) {
                let modelsFiltered = UtilsAccounts.filteredAccounts(viewModel.models,
                                                                    by: modelType,
                                                                    sortType: viewModel.sortModelsBy)
                
                if modelsFiltered.isEmpty {
                    NoContentView(title: "Empty", entity: "Account")
                } else {
                    ListContainer {
                        ForEach(modelsFiltered) { item in
                            HStack {
                                let icon = item.icon.getIconFromSFSymbol
                                
                                if let image = icon {
                                    image
                                        .frame(width: FrameSize.width.iconCategoryList,
                                               height: FrameSize.height.iconCategoryList)
                                }
                                
                                Button(item.name) {
                                    selectedModel = item
                                    dismiss()
                                }
                                
                                Spacer()
                                
                                Image.chevronRight
                            }
                        }
                        .listRowBackground(Color.listRowBackground) //Background for each row.
                    }
                    .animation(.default, value: viewModel.sortModelsBy)
                }
            }
        }
        .onAppear {
            viewModel.activateObservers()
            modelType = selectedModel.type
        }
        .onDisappear {
            viewModel.deactivateObservers()
        }
        .presentationDetents([.large])
        .presentationCornerRadius(ConstantRadius.cornersModal)
    }
    
    private func sortButton(for sortingOption: SortAccounts) -> some View {
        Button {
            if viewModel.sortModelsBy == sortingOption {
                viewModel.sortModelsBy = sortingOption.toggle
            } else {
                viewModel.sortModelsBy = sortingOption
            }
            
            viewModel.updateSelectedSort()
        } label: {
            viewModel.sortModelsBy == sortingOption ? sortingOption.label() : sortingOption.label(inverted: false)
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
    @Previewable @State var model = AccountModel()
    
    ZStack(alignment: .top) {
        Color.backgroundBottom
        VStack {
            Spacer()
            TextPlain("Model selected: \(model.name)")
            Button("Show modal") {
                showModal = true
            }
            Spacer()
        }
    }.sheet(isPresented: $showModal) {
        SelectAccountModalView(selectedModel: $model)
            .environment(\.locale, .init(identifier: "en_US"))
    }
    .onAppear {
        showModal = true
    }
}
