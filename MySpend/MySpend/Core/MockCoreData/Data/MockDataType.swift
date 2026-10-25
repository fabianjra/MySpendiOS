//
//  MockDataType.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 18/7/25.
//

//import Foundation
import CoreData

enum MockDataType {
    case empty
    case normal
    case saturated
}

@MainActor
extension MockDataType {
    var viewContext: NSManagedObjectContext {
        switch self {
        case .empty:
            return MockCoreDataEmpty.preview.container.viewContext

        case .normal:
            return MockCoreDataNormal.preview.container.viewContext

        case .saturated:
            return MockCoreDataSaturated.preview.container.viewContext
        }
    }
}
