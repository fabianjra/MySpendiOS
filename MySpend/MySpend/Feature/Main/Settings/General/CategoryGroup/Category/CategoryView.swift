//
//  CategoryView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoryView: View {
    
    @Environment(CategoryManager.self) private var manager
    @Environment(\.editMode) private var editMode
    
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing == true
    }
    
    @State private var viewModel = CategoryViewModel()
    @State private var toastResponse: ToastResponse?
    
    
    
    
    
    @State private var showNewItemModal = false
    
    @State private var modelType: CategoryType = .expense
    @State private var modelToModify: CategoryModel?
    @State private var modelToDelete: CategoryModel?
    
    
    var body: some View {
        VStack {
            categoryList
        }
        .navigationTitle(
            viewModel.selectedCategories.isEmpty ?
                .categoriesTitle : .selectorSelectedCountFemale(viewModel.selectedCategories.count)
        )
        .navigationSubtitle(.categoriesSubtitle(manager.sortedCategories.count))
        .navigationBarBackButtonHidden(isEditing)
        
        .toolbar {
            toolbarContent
        }
        
        .onChange(of: editMode?.wrappedValue) { _, newValue in
            if newValue?.isEditing != true {
                viewModel.selectedCategories.removeAll()
            }
        }
        
        
        // MARK: SHEETS
        
        .sheet(isPresented: $showNewItemModal) {
            AddModifyCategoryView(categoryType: $modelType)
                .presentationDetents([.large])
        }
        .sheet(item: $modelToModify) { model in
            AddModifyCategoryView(model, categoryType: $modelType)
                .presentationDetents([.large])
                .onDisappear {
                    modelToModify = nil
                }
        }
        
        .toast($toastResponse)
    }
    
    
    
    private var categoryList: some View {
        VStack {
            Picker("", selection: $modelType) {
                ForEach(CategoryType.allCases) { type in
                    Text(type.localized)
                }
            }
            .pickerStyle(.segmented)
            .glassEffect(.regular)
            .padding(.horizontal)
            
            
            List(selection: $viewModel.selectedCategories) {
                if manager.sortedCategories.isEmpty {
                    Section {
                        Text(.categoriesEmpty)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Section {
                        ForEach(manager.sortedCategories) { item in
                            Button {
                                if isEditing {
                                    viewModel.toggleCategorySelection(item)
                                } else {
                                    modelToModify = item
                                    //viewModel.showUpdateAccount = true
                                }
                            } label: {
                                HStack {
                                    Label(item.name, systemImage: item.icon)
                                        .foregroundStyle(Color.primary)
                                    
                                    Spacer()
                                    
                                    if !isEditing {
                                        Image.chevronRight
                                            .tint(.secondary)
                                    }
                                }
                            }
                            .tag(item)
                            
                            .swipeActions(edge: .trailing) {
                                if !isEditing {
                                    
                                    Button(.selectorDelete, systemImage: ConstantSystemImage.trash) {
                                        modelToDelete = item
                                        viewModel.showAlertDelete = true
                                    }
                                    .labelStyle(.iconOnly)
                                    .tint(.alert)
                                    
                                    
                                    Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                        modelToModify = item
                                        //viewModel.showUpdateAccount = true
                                    }
                                    .labelStyle(.iconOnly)
                                }
                            }
                            
                            .contextMenu {
                                if !isEditing {
                                    
                                    Button(.selectorEdit, systemImage: ConstantSystemImage.squareAndPencil) {
                                        modelToModify = item
                                        //viewModel.showUpdateAccount = true
                                    }
                                    
                                    
                                    Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                                        modelToDelete = item
                                        viewModel.showAlertDelete = true
                                    }
                                }
                            }
                            
                            .alert(.categoryDelete(viewModel.selectedCategories.count), isPresented: $viewModel.showAlertDelete) {
                                Button(.alertOptionDelete, role: .destructive) {
                                    Task {
                                        if viewModel.selectedCategories.isEmpty {
                                            
                                            defer {
                                                modelToDelete = nil
                                            }
                                            
                                            if let category = modelToDelete {
                                                toastResponse = await manager.delete(category)
                                            }
                                            
                                        } else {
                                            
                                            defer {
                                                viewModel.selectedCategories.removeAll()
                                            }
                                            
                                            toastResponse = await manager.delete(viewModel.selectedCategories)
                                        }
                                        
                                        editMode?.wrappedValue = .inactive
                                    }
                                }
                                
                                Button(.alertOptionCancel, role: .cancel) { }
                            } message: {
                                Text(.categoryDeleteMessage(viewModel.selectedCategories.count))
                            }
                        }
                    } header: {
                        //Text(.accountListHeader)
                        
                    } footer: {
                        //Text(.accountListFooter)
                    }
                }
            }
            .animation(.default, value: manager.sortedCategories)
            .scrollContentBackground(.hidden)
        }
        .background(Color.backgroundGradient)
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        
        // MARK: TOP
        
        ToolbarItem(placement: .navigation) {
            if isEditing {
                if viewModel.selectedCategories.count == manager.sortedCategories.count {
                    Button(.selectorDeselectAll) {
                        viewModel.selectedCategories = Set()
                    }
                } else {
                    Button(.selectorSelectAll) {
                        viewModel.selectedCategories = Set(manager.sortedCategories)
                    }
                }
            }
        }
        
        ToolbarItemGroup(placement: .primaryAction) {
            
            if isEditing {
                Button(role: .cancel) {
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                }
            } else {
                
                Menu(.menuOptionsTitle, systemImage: ConstantSystemImage.options) {
                    
                    Button {
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label(.selectorSelect, systemImage: ConstantSystemImage.checkmarkCircle)
                    }
                    
                    MenuOrderCategory()
                }
                .menuOrder(.fixed)
                .disabled(manager.sortedCategories.isEmpty)
            }
        }
        
        
        // MARK: BOTTOM
        
        ToolbarSpacer(.flexible, placement: .bottomBar)
        
        ToolbarItem(placement: .bottomBar) {
            if isEditing {
                Button(.selectorDelete, systemImage: ConstantSystemImage.trash, role: .destructive) {
                    viewModel.showAlertDelete = true
                }
                .disabled(viewModel.selectedCategories.isEmpty)
                
            } else {
                Button(.transactionAdd, systemImage: ConstantSystemImage.addNewItem) {
                    showNewItemModal = true
                }
            }
        }
    }
}

private struct previewWrapper: View {
    init(_ mockDataType: MockDataType = .normal) {
        _manager = State(initialValue: CategoryManager(viewContext: mockDataType.viewContext))
    }
    
    @State var manager: CategoryManager
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        CategoryView()
            .environment(manager)
            .environment(\.editMode, $editMode)
    }
}

#Preview(Previews.localeES_CR) {
    NavigationStack {
        previewWrapper()
    }
    .environment(\.locale, .init(identifier: Previews.localeES_CR))
}

#Preview("Saturated \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(.saturated)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}

#Preview("Empty \(Previews.localeEN)") {
    NavigationStack {
        previewWrapper(.empty)
    }
    .environment(\.locale, .init(identifier: Previews.localeEN))
}

//#Preview("Only expenses es_CR") {
//    CategoryView(viewModel: CategoryViewModel(categories: MocksCategoriesFB.onlyExpenses))
//        .environment(\.locale, .init(identifier: "es_CR"))
//}
//
//#Preview("Only incomes en_US") {
//    CategoryView(viewModel: CategoryViewModel(categories: MocksCategoriesFB.onlyIncomes))
//        .environment(\.locale, .init(identifier: "en_US"))
//}
