//
//  MockTransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockTransactionModel {
    
    static func fetchAll(type: MockDataType) async -> [TransactionModel] {
        do {
            var mockTransactions: [TransactionModel] = []
            
            switch type {
            case .empty:
                mockTransactions = []
                
            case .normal:
                mockTransactions = try await TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
                
            case .saturated:
                mockTransactions = try await TransactionManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAll()
            }
            
            return mockTransactions
        } catch {
            return []
        }
    }
}
