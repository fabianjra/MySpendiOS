//
//  CategoriesView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoriesView: View {
    
    @StateObject var categoriesVM = CategoriesViewModel(categories: [])
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
                    ForEach(categoriesVM.categories) { category in
                        HStack {
                            let navIcon = Utils.getIconFromString(category.icon)
                            
                            navIcon
                                .frame(width: FrameSize.width.navIconCategoryList,
                                       height: FrameSize.height.navIconCategoryList)
                            
                            Text(category.description)
                            
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
            Task {
                await categoriesVM.getCategories()
            }
        }
        .sheet(isPresented: $showNewItemModal) {
            NewCategoryView()
                .presentationDetents([.large])
        }
    }
}

#Preview("Content") {
    VStack {
        let category1 = CategoryModel(icon: "envelope.fill",
                                      description: "Gasolina",
                                      categoryType: .expense)
        let category2 = CategoryModel(icon: "lock.fill", 
                                      description: "Comida",
                                      categoryType: .income)
        let category3 = CategoryModel(icon: nil,
                                      description: "Sin icono",
                                      categoryType: .expense)
        let category4 = CategoryModel(icon: "", 
                                      description: "String vacio",
                                      categoryType: .expense)
        let category5 = CategoryModel(icon: "person.fill", 
                                      description: "Turismo",
                                      categoryType: .income)
        
        let categories = [category1, category2, category3, category4, category5]
        
        let categoriesVM = CategoriesViewModel(categories: categories)
        
        CategoriesView(categoriesVM: categoriesVM)
    }
}

#Preview("Screen filled") {
    VStack {
        @State var arrayCategories: [CategoryModel] = (1...40).map { item in
            CategoryModel(icon: "person.fill", 
                          description: "\(item) Categoria prueba",
                          categoryType: .expense)
        }
        
        let categoriesVM = CategoriesViewModel(categories: arrayCategories)
        CategoriesView(categoriesVM: categoriesVM)
    }
}

#Preview("Withou content") {
        CategoriesView()
}
