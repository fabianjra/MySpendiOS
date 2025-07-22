//
//  MockAccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

@MainActor
struct MockAccountModel {
    
    static func fetchAllCount(type: MockDataType) async -> Int {
        do {
            var accountCount = Int.zero
            
            switch type {
            case .empty:
                accountCount = Int.zero
                
            case .normal:
                accountCount = try await AccountManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAllCount()
                
            case .saturated:
                accountCount = try await AccountManager(viewContext: MockCoreDataNormal.preview.container.viewContext).fetchAllCount()
            }
            
            return accountCount
        } catch {
            return .zero
        }
    }
}
