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
    let dateModified: Date
    var id = UUID()
    
    // Entity-specific Attributes
    var amount: Decimal
    var dateTransaction: Date
    var notes: String
    var favorite: Bool
    
    // Relationships
    var category: CategoryModel
    var account: AccountModel
    
    init(amount: Decimal = .zero,
         dateTransaction: Date = .now,
         notes: String = "",
         favorite: Bool = false,
         category: CategoryModel = CategoryModel(),
         account: AccountModel = AccountModel()) {
        
        self.dateCreated = .init()
        self.dateModified = .init()

        self.amount = amount
        self.dateTransaction = dateTransaction
        self.notes = notes
        self.favorite = favorite
        
        self.category = category
        self.account = account
    }
    
    // Init the model from Entity
    init(_ entity: Transaction) {
        self.dateCreated = entity.dateCreated ?? .init()
        self.dateModified = entity.dateModified ?? .init()
        self.id = entity.id ?? UUID()
        
        self.amount = entity.amount?.decimalValue ?? .zero
        self.dateTransaction = entity.dateTransaction ?? .init()
        self.notes = entity.notes ?? ""
        self.favorite = entity.favorite
        
        self.category = TransactionModel.convertToCategoryModel(entity.category)
        self.account = TransactionModel.convertToAccountModel(entity.account)
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
