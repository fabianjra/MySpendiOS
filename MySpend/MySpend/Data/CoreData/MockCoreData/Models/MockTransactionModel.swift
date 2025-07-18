//
//  MockTransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockTransactionModel {
    
    static func fetchAll(type: MockDataType) -> [TransactionModel] {
        do {
            var mockTransactions: [TransactionModel] = []
            
            switch type {
            case .empty:
                mockTransactions = try TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
                
            case .normal:
                mockTransactions = try TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
                
            case .saturated:
                mockTransactions = try TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
            }
            
            return mockTransactions
        } catch {
            return []
        }
    }
}
