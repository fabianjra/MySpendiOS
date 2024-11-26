//
//  MockTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/11/24.
//

import Foundation

struct MockTransactions {
    
    static let normal = [TransactionModel(id: UUID().uuidString,
                                          amount: 100,
                                          dateTransaction: Calendar.current.date(byAdding: .month, value: 15, to: .now)!,
                                          category: MocksCategories.expense1,
                                          notes: "",
                                          transactionType: MocksCategories.income1.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 200,
                                          dateTransaction: .now,
                                          category: MocksCategories.expense2,
                                          notes: "Fue un almuerzo de trabajo",
                                          transactionType: MocksCategories.expense2.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 50,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 56, to: .now)!,
                                          category: MocksCategories.expense2,
                                          notes: "",
                                          transactionType: MocksCategories.expense2.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 500,
                                          dateTransaction: Calendar.current.date(byAdding: .month, value: -2, to: .now)!,
                                          category: MocksCategories.expense3,
                                          notes: "",
                                          transactionType: MocksCategories.expense3.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 7000,
                                          dateTransaction: Calendar.current.date(byAdding: .year, value: 1, to: .now)!,
                                          category: MocksCategories.expense3,
                                          notes: "",
                                          transactionType: MocksCategories.expense3.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 3455,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 4, to: .now)!,
                                          category: MocksCategories.expense1,
                                          notes: "",
                                          transactionType: MocksCategories.expense1.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 560,
                                          dateTransaction: .now,
                                          category: MocksCategories.expense1,
                                          notes: "",
                                          transactionType: MocksCategories.expense1.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 300,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                                          category: MocksCategories.income2,
                                          notes: "devolucion de un prestamo",
                                          transactionType: MocksCategories.income2.categoryType),
                         
                         TransactionModel(id: UUID().uuidString,
                                          amount: 250000,
                                          dateTransaction: .now,
                                          category: MocksCategories.income1,
                                          notes: "",
                                          transactionType: MocksCategories.income1.categoryType)]
    
    static let saturated = [TransactionModel(id: UUID().uuidString,
                                             amount: 142342342354234,
                                             dateTransaction: Calendar.current.date(byAdding: .month, value: 1, to: .now)!,
                                             category: MocksCategories.expense1,
                                             notes: "Comidaasf safasdf saf sa asdffasdfasryewrrts fsadf s",
                                             transactionType: MocksCategories.income1.categoryType),
                            
                            TransactionModel(id: UUID().uuidString,
                                             amount: 52354234532523,
                                             dateTransaction: .now,
                                             category: MocksCategories.expenseSaturated1,
                                             notes: "Gasolina asdfsaf asdfasd fsadf as fas",
                                             transactionType: MocksCategories.expenseSaturated1.categoryType),
                            
                            TransactionModel(id: UUID().uuidString,
                                             amount: 500523532535325320,
                                             dateTransaction: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
                                             category: MocksCategories.expenseSaturated2,
                                             notes: "",
                                             transactionType: MocksCategories.expenseSaturated2.categoryType),
                            
                            TransactionModel(id: UUID().uuidString,
                                             amount: 50,
                                             dateTransaction: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                                             category: MocksCategories.income1,
                                             notes: "devolucion de un prestamo",
                                             transactionType: MocksCategories.income1.categoryType),
                            
                            TransactionModel(id: UUID().uuidString,
                                             amount: 500,
                                             dateTransaction: .now,
                                             category: MocksCategories.income1,
                                             notes: "",
                                             transactionType: MocksCategories.income1.categoryType)]
    
    static let random_generated = (1...Int.random(in:10...40)).map { item in
        
        TransactionModel(id: UUID().uuidString,
                         amount: Decimal(Double.random(in: 10.99...7456825682.99)),
                         dateTransaction: .now,
                         category: CategoryModel(id: UUID().uuidString,
                                                 icon: CategoryIcons.bills.list.randomElement()!,
                                                 name: "nombre categoria",
                                                 categoryType: .expense),
                         notes: "",
                         transactionType: .expense)
    }
}
