//
//  MockAccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockAccountModel {
    
    static func fetchAll() async -> [AccountModel] {
        do {
            return try await AccountManager(CoreDataUtilities.getViewContext).fetchAll()
        } catch {
            return []
        }
    }
    
    static func fetchAllCount() async -> Int {
        do {
            return try await AccountManager(CoreDataUtilities.getViewContext).fetchAllCount()
        } catch {
            return Int.zero
        }
    }
}
