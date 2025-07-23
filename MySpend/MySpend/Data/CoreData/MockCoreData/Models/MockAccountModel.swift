//
//  MockAccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockAccountModel {
    
    static func fetchAllCount() async -> Int {
        do {
            return try await AccountManager(viewContext: CoreDataUtilities.getViewContext()).fetchAllCount()
        } catch {
            return Int.zero
        }
    }
}
