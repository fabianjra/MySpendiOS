//
//  TransactionModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

// Equatable: Permite comparar el tipo de transaccion para agruparlas en la sumatoria total de expeses/incomes
// Hashable: Permite seleccionar varios items a la hora de eliminarlos.

struct TransactionModel: Identifiable, Equatable, Hashable {
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    var dateModified: Date
    let id: UUID
    let isActive: Bool
    
    // Entity-specific Attributes
    var amount: Decimal
    var dateTransaction: Date
    var notes: String
    
    // Relationships
    var category: CategoryModel
    var account: AccountModel
    
    init() {
        dateCreated = .init()
        dateModified = .init()
        id = UUID()
        isActive = true
        
        amount = .zero
        dateTransaction = .init()
        notes = ""
        category = CategoryModel()
        account = AccountModel()
    }
    
    // When a new Transaction is created
    init(amount: Decimal = .zero, dateTransaction: Date = .now, notes: String = "", category: CategoryModel = CategoryModel(), account: AccountModel = AccountModel()) {
        self.init()
        self.amount = amount
        self.dateTransaction = dateTransaction
        self.notes = notes
        self.category = category
        self.account = account
    }
    
    // Init the model from Entity
    init(_ entity: Transaction) {
        dateCreated = entity.dateCreated ?? .init()
        dateModified = entity.dateModified ?? .init()
        id = entity.id ?? UUID()
        isActive = entity.isActive
        
        amount = entity.amount?.decimalValue ?? .zero
        dateTransaction = entity.dateTransaction ?? .init()
        notes = entity.notes ?? ""
        category = TransactionModel.convertToCategoryModel(entity.category)
        account = TransactionModel.convertToAccountModel(entity.account)
    }
    
    private static func convertToCategoryModel(_ categoryCoreData: Category?) -> CategoryModel {
        if let category = categoryCoreData {
            return CategoryModel(category)
        } else {
            return CategoryModel()
        }
    }
    
    private static func convertToAccountModel(_ accountCoreData: Account?) -> AccountModel {
        if let account = accountCoreData {
            return AccountModel(account)
        } else {
            return AccountModel()
        }
    }
    
    enum Field: Hashable, CaseIterable {
        case amount
        case notes
    }
}
