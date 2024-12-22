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
                                        categoryType: .expense,
                                        dateCreated: Calendar.current.date(byAdding: .day, value: 15, to: .now)!)
    
    static let expense2 = CategoryModel(id: UUID().uuidString,
                                        icon: CategoryIcons.foodAndDrink.list[0],
                                        name: "Comida",
                                        categoryType: .expense,
                                        dateCreated: Calendar.current.date(byAdding: .month, value: 20, to: .now)!)
    
    static let expense3 = CategoryModel(id: UUID().uuidString,
                                        icon: CategoryIcons.foodAndDrink.list[1],
                                        name: "Salidas",
                                        categoryType: .expense,
                                        dateCreated: Calendar.current.date(byAdding: .year, value: 1, to: .now)!)
    
    static let income1 = CategoryModel(id: UUID().uuidString,
                                       icon: CategoryIcons.bills.list[0],
                                       name: "Cobros",
                                       categoryType: .income,
                                       dateCreated: Calendar.current.date(byAdding: .day, value: 3, to: .now)!)
    
    static let income2 = CategoryModel(id: UUID().uuidString,
                                       icon: CategoryIcons.bills.list[1],
                                       name: "Recarga",
                                       categoryType: .income,
                                       dateCreated: Calendar.current.date(byAdding: .day, value: -5, to: .now)!)
    
    static let expenseSaturated1 = CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.foodAndDrink.list[0],
                                                 name: "akjhfdashfdkjashasdfhh43df kjahsj dhasjkf jasdlkfa df",
                                                 categoryType: .expense,
                                                 dateCreated: .now)
    
    static let expenseSaturated2 = CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.foodAndDrink.list[1],
                                                 name: "a4234sdfasdf akjhfdashfdkjashdf kjahsj dhasjkf jasdlkfa df",
                                                 categoryType: .expense,
                                                 dateCreated: Calendar.current.date(byAdding: .day, value: 33, to: .now)!)
    
    static let normal: [CategoryModel] = [expense1, expense2, expense3, income1, income2]
    
    static let onlyExpenses: [CategoryModel] = [expense1, expense2, expense3]
    
    static let onlyIncomes: [CategoryModel] = [income1, income2]
    
    static let random_generated = (1...40).map { item in
        
        CategoryModel(id: UUID().uuidString,
                      icon: CategoryIcons.bills.list.randomElement()!,
                      name: "\(item) Randomed",
                      categoryType: .expense,
                      dateCreated: Calendar.current.date(byAdding: .day, value: item, to: .now)!)
    }
}
