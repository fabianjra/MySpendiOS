//
//  MockCoreDataEmpty.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 22/7/25.
//

import CoreData

struct MockCoreDataEmpty {
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        return result
    }()
}
