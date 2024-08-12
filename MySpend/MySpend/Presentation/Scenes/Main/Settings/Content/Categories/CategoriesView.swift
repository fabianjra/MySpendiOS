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
                            if let icon = category.icon {
                                
                                Utils.getIconFromString(icon)
                                    .frame(width: FrameSize.width.navIconCategoryList,
                                           height: FrameSize.height.navIconCategoryList)
                            }
                            
                            Text(category.description)
                            
                            Spacer()
                            
                            Image.chevronRight
                        }
                    }
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
        let category1 = CategoryModel(icon: "envelope.fill", description: "Gasolina")
        let category2 = CategoryModel(icon: "lock.fill", description: "Comida")
        let category3 = CategoryModel(icon: "person.fill", description: "Turismo")
        
        let categories = [category1, category2, category3]
        
        CategoriesView(arrayCategories: categories)
    }
}

#Preview("Screen filled") {
    VStack {
        @State var arrayCategories: [CategoryModel] = (1...40).map { item in
            CategoryModel(icon: "person.fill", description: "\(item) Categoria prueba")
        }
        
        CategoriesView(arrayCategories: arrayCategories)
    }
}

#Preview("Withou content") {
        CategoriesView()
}
