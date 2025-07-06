//
//  MockTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/11/24.
//

import Foundation

struct MockTransactionsFB {
    
    static let normal = [TransactionModelFB(id: UUID().uuidString,
                                          amount: 100,
                                          dateTransaction: Calendar.current.date(byAdding: .month, value: 15, to: .now)!,
                                          category: MocksCategoriesFB.expense1,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.income1.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 200,
                                          dateTransaction: .now,
                                          category: MocksCategoriesFB.expense2,
                                          notes: "Fue un almuerzo de trabajo",
                                          categoryType: MocksCategoriesFB.expense2.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 50,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 56, to: .now)!,
                                          category: MocksCategoriesFB.expense2,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.expense2.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 500,
                                          dateTransaction: Calendar.current.date(byAdding: .month, value: -2, to: .now)!,
                                          category: MocksCategoriesFB.expense3,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.expense3.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 7000,
                                          dateTransaction: Calendar.current.date(byAdding: .year, value: 1, to: .now)!,
                                          category: MocksCategoriesFB.expense3,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.expense3.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 3455,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 4, to: .now)!,
                                          category: MocksCategoriesFB.expense1,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.expense1.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 560,
                                          dateTransaction: .now,
                                          category: MocksCategoriesFB.expense1,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.expense1.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 300,
                                          dateTransaction: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                                          category: MocksCategoriesFB.income2,
                                          notes: "devolucion de un prestamo",
                                          categoryType: MocksCategoriesFB.income2.categoryType),
                         
                         TransactionModelFB(id: UUID().uuidString,
                                          amount: 250000,
                                          dateTransaction: .now,
                                          category: MocksCategoriesFB.income1,
                                          notes: "",
                                          categoryType: MocksCategoriesFB.income1.categoryType)]
    
    static let saturated = [TransactionModelFB(id: UUID().uuidString,
                                             amount: 142342342354234,
                                             dateTransaction: Calendar.current.date(byAdding: .month, value: 1, to: .now)!,
                                             category: MocksCategoriesFB.expense1,
                                             notes: "Comidaasf safasdf saf sa asdffasdfasryewrrts fsadf s",
                                             categoryType: MocksCategoriesFB.income1.categoryType),
                            
                            TransactionModelFB(id: UUID().uuidString,
                                             amount: 52354234532523,
                                             dateTransaction: .now,
                                             category: MocksCategoriesFB.expenseSaturated1,
                                             notes: "Gasolina asdfsaf asdfasd fsadf as fas",
                                             categoryType: MocksCategoriesFB.expenseSaturated1.categoryType),
                            
                            TransactionModelFB(id: UUID().uuidString,
                                             amount: 500523532535325320,
                                             dateTransaction: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
                                             category: MocksCategoriesFB.expenseSaturated2,
                                             notes: "",
                                             categoryType: MocksCategoriesFB.expenseSaturated2.categoryType),
                            
                            TransactionModelFB(id: UUID().uuidString,
                                             amount: 50,
                                             dateTransaction: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
                                             category: MocksCategoriesFB.income1,
                                             notes: "devolucion de un prestamo",
                                             categoryType: MocksCategoriesFB.income1.categoryType),
                            
                            TransactionModelFB(id: UUID().uuidString,
                                             amount: 500,
                                             dateTransaction: .now,
                                             category: MocksCategoriesFB.income1,
                                             notes: "",
                                             categoryType: MocksCategoriesFB.income1.categoryType)]
    
    static let random_generated = (1...Int.random(in:10...40)).map { item in
        
        TransactionModelFB(id: UUID().uuidString,
                         amount: Decimal(Double.random(in: 10.99...7456825682.99)),
                         dateTransaction: .now,
                         category: CategoryModelFB(id: UUID().uuidString,
                                                 icon: CategoryIcons.bills.list.randomElement()!,
                                                 name: "nombre categoria",
                                                 categoryType: .expense),
                         notes: "",
                         categoryType: .expense)
    }
}
