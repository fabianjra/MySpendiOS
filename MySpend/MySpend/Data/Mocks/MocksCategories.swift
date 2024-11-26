//
//  MocksCategories.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/11/24.
//

import Foundation

struct MocksCategories {
    
    static let expense1 = CategoryModel(id: UUID().uuidString,
                                        icon: CategoryIcons.household.list[0],
                                        name: "Gasolina",
                                        categoryType: .expense)
    
    static let expense2 = CategoryModel(id: UUID().uuidString,
                                        icon: CategoryIcons.foodAndDrink.list[0],
                                        name: "Comida",
                                        categoryType: .expense)
    
    static let expense3 = CategoryModel(id: UUID().uuidString,
                                        icon: CategoryIcons.foodAndDrink.list[1],
                                        name: "Salidas",
                                        categoryType: .expense)
    
    static let income1 = CategoryModel(id: UUID().uuidString,
                                       icon: CategoryIcons.bills.list[0],
                                       name: "Cobros",
                                       categoryType: .income)
    
    static let income2 = CategoryModel(id: UUID().uuidString,
                                       icon: CategoryIcons.bills.list[1],
                                       name: "Recarga",
                                       categoryType: .income)
    
    static let expenseSaturated1 = CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.foodAndDrink.list[0],
                                                 name: "akjhfdashfdkjashasdfhh43df kjahsj dhasjkf jasdlkfa df",
                                                 categoryType: .expense)
    
    static let expenseSaturated2 = CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.foodAndDrink.list[1],
                                                 name: "a4234sdfasdf akjhfdashfdkjashdf kjahsj dhasjkf jasdlkfa df",
                                                 categoryType: .expense)
    
    static let normal: [CategoryModel] = [expense1, expense2, expense3, income1, income2]
    
    static let random_generated = (1...40).map { item in
        
        CategoryModel(id: UUID().uuidString,
                      icon: CategoryIcons.bills.list.randomElement()!,
                      name: "\(item) Randomed",
                      categoryType: .expense)
    }
}
