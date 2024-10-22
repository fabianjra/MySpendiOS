//
//  CategoriesView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoriesView: View {
    
    @StateObject var viewModel = CategoriesViewModel()
    @State private var showNewItemModal = false
    
    var body: some View {
        ContentContainer(addPading: false) {
            
            HeaderNavigator(title: "Categories",
                            titleWeight: .regular,
                            titleSize: .bigXL,
                            subTitle: "Select or add categories",
                            subTitleWeight: .regular)
            .padding(.horizontal)
            
            ZStack(alignment: .bottomTrailing) {
                ListContainer {
                    ForEach(viewModel.categories) { category in
                        HStack {
                            let icon = Utils.getIconFromString(category.icon)
                            
                            if let image = icon {
                                image
                                    .frame(width: FrameSize.width.iconCategoryList,
                                           height: FrameSize.height.iconCategoryList)
                            }
                            
                            Text(category.name)
                            
                            Spacer()
                            
                            Image.chevronRight
                        }
                    }
                    .listRowBackground(Color.listRowBackground) //Background for each row.
                }
                
                ButtonRounded {
                    showNewItemModal = true
                }
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        .sheet(isPresented: $showNewItemModal) {
            NewCategoryView()
                .presentationDetents([.large])
                .presentationCornerRadius(ConstantRadius.cornersModal)
        }
    }
}

#Preview("Content") {
    VStack {
        let category1 = CategoryModel(icon: "envelope.fill",
                                      name: "Gasolina",
                                      categoryType: .expense)
        let category2 = CategoryModel(icon: "arrowshape.turn.up.left.fill",
                                      name: "Comida",
                                      categoryType: .income)
        let category3 = CategoryModel(icon: "",
                                      name: "Sin icono",
                                      categoryType: .expense)
        let category4 = CategoryModel(icon: "", 
                                      name: "String vacio",
                                      categoryType: .expense)
        let category5 = CategoryModel(icon: "person.fill", 
                                      name: "Turismo",
                                      categoryType: .income)
        
        let categories = [category1, category2, category3, category4, category5]
        
        let categoriesVM = CategoriesViewModel(categories: categories)
        
        CategoriesView(viewModel: categoriesVM)
    }
}

#Preview("Screen filled") {
    
    @Previewable @State var arrayCategories: [CategoryModel] = (1...40).map { item in
        
        CategoryModel(icon: "person.fill",
                      name: "\(item) Categoria prueba",
                      categoryType: .expense)
    }
    
    VStack {
        let categoriesVM = CategoriesViewModel(categories: arrayCategories)
        CategoriesView(viewModel: categoriesVM)
    }
}

#Preview("Withou content") {
        CategoriesView()
}
