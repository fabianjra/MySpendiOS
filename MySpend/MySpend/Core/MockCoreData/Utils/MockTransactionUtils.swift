//
//  MockTransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

import CoreData

@MainActor
struct MockTransactionUtils {
    
    static func fetchAll(_ viewContext: NSManagedObjectContext) async -> [TransactionModel] {
        do {
            //return try await TransactionCoreDataManager(CoreDataUtilities.getViewContext).fetchAll()
            return try await TransactionCoreDataManager(viewContext).fetchAll()
        } catch {
            return []
        }
    }
    
//    static func fetchSingle() async -> TransactionModel {
//        do {
//            return try await TransactionManager(CoreDataUtilities.getViewContext).fetchAll().first ?? TransactionModel()
//        } catch {
//            return TransactionModel()
//        }
//    }
}
