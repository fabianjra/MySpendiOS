//
//  MockTransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

import Foundation

@MainActor
struct MockTransactionModel {
    
     static func fetchAll() -> [TransactionModel] {
        do {
            let mockTransactions = try TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
            return mockTransactions
        } catch {
            return []
        }
    }
}
