//
//  MockTransactions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/11/24.
//

import Foundation

struct MockUsers {
    static let user1 = UserModel(id: UUID().uuidString,
                                  fullname: "Fabian Test",
                                  email: "test@test.com",
                                  accounts: [])
}

struct MockAccounts {
    static let account1 = AccountModel(user: MockUsers.user1,
                                       transactions: [])
}

struct MockTransactions {
    
    static let normal = [
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: 15, to: .now)!,
                         amount: 100,
                         category: MocksCategories.expense1,
                         account: MockAccounts.account1,
                         notes: "",
                         repeating: false),
        
        TransactionModel(dateTransaction: .now,
                         amount: 200,
                         category: MocksCategories.expense1,
                         account: MockAccounts.account1,
                         notes: "",
                         repeating: false),
        
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: 25, to: .now)!,
                         amount: 50,
                         category: MocksCategories.expense1,
                         account: MockAccounts.account1,
                         notes: "",
                         repeating: false),
        
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: -30, to: .now)!,
                         amount: 1200,
                         category: MocksCategories.income1,
                         account: MockAccounts.account1,
                         notes: "",
                         repeating: false)
        
    ]
    
    static let saturated = [
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: 1, to: .now)!,
                         amount: 142342342354234,
                         category: MocksCategories.expense1,
                         account: MockAccounts.account1,
                         notes: "Comidaasf safasdf saf sa asdffasdfasryewrrts fsadf s",
                         repeating: false),
        
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: 5, to: .now)!,
                         amount: 142342342354234,
                         category: MocksCategories.expense2,
                         account: MockAccounts.account1,
                         notes: "Comidaasf safasdf saf sa asdffasdfasryewrrts fsadf s",
                         repeating: false),
    ]
    
    static let random_generated = (1...Int.random(in:10...40)).map { item in
        
        TransactionModel(dateTransaction: Calendar.current.date(byAdding: .month, value: Int.random(in: 0...30), to: .now)!,
                         amount: Decimal(Double.random(in: 10.99...7456825682.99)),
                         category: MocksCategories.expense1,
                         account: MockAccounts.account1,
                         notes: "",
                         repeating: false)
    }
}
