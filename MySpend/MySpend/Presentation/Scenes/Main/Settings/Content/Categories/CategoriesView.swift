//
//  CategoriesView.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import SwiftUI

struct CategoriesView: View {
    
    @State var arrayCategories: [CategoryModel]
    
    init(arrayCategories: [CategoryModel] = []) {
        self.arrayCategories = arrayCategories
    }
    
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
                    ForEach(arrayCategories) { category in
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
                    print("New category add")
                }
                .padding(.trailing, ConstantViews.paddingButtonAddCategory)
                .padding(.bottom, ConstantViews.paddingButtonAddCategory)
            }
        }
    }
}

#Preview("Content") {
    VStack {
        let category1 = CategoryModel(icon: "envelope.fill",
                                      description: "Gasolina",
                                      type: .expense)
        let category2 = CategoryModel(icon: "lock.fill", 
                                      description: "Comida",
                                      type: .income)
        let category3 = CategoryModel(icon: nil,
                                      description: "Sin icono",
                                      type: .expense)
        let category4 = CategoryModel(icon: "", 
                                      description: "String vacio",
                                      type: .expense)
        let category5 = CategoryModel(icon: "person.fill", 
                                      description: "Turismo",
                                      type: .income)
        
        let categories = [category1, category2, category3, category4, category5]
        
        CategoriesView(arrayCategories: categories)
    }
}

#Preview("Screen filled") {
    VStack {
        @State var arrayCategories: [CategoryModel] = (1...40).map { item in
            CategoryModel(icon: "person.fill", 
                          description: "\(item) Categoria prueba",
                          type: .expense)
        }
        
        CategoriesView(arrayCategories: arrayCategories)
    }
}

#Preview("Withou content") {
        CategoriesView()
}
