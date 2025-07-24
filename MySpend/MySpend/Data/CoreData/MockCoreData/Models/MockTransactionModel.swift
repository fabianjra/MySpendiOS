//
//  MockTransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockTransactionModel {
    
    static func fetchAll() async -> [TransactionModel] {
        do {
            return try await TransactionManager(viewContext: CoreDataUtilities.getViewContext).fetchAll()
        } catch {
            return []
        }
    }
}
