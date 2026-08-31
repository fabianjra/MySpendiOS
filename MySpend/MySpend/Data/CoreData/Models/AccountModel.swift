//
//  AccountModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/6/25.
//

import Foundation

// Se agrega el sufijo "Model" para diferenciarlo de la entidad de CoreDate (sin el sufijo model).
struct AccountModel: Codable, Identifiable, Equatable, Hashable {
    
    // Shared attributes (Abstract class):
    let dateCreated: Date
    let dateModified: Date
    let id: UUID
    let isActive: Bool
    
    // Entity-specific Attributes
    var currencyCode: String
    var icon: String // Emoji
    var name: String
    var notes: String
    var userId: String // For Firebase
    
    init() {
        dateCreated = .init()
        dateModified = .init()
        id = UUID()
        isActive = true
        
        currencyCode = ""
        icon = ""
        name = ""
        notes = ""
        userId = ""
    }
    
    // When a new Transaction is created
    init(currencyCode: String = "", icon: String = "", name: String, notes: String = "") {
        self.init()
        self.currencyCode = currencyCode
        self.icon = icon
        self.name = name
        self.notes = notes
    }
    
    // Init the model from Entity
    init(_ entity: Account) {
        dateCreated = entity.dateCreated ?? .init()
        dateModified = entity.dateModified ?? .init()
        id = entity.id ?? UUID()
        isActive = entity.isActive
        
        currencyCode = entity.currencyCode ?? ""
        icon = entity.icon ?? ""
        name = entity.name ?? ""
        notes = entity.notes ?? ""
        userId = entity.userId ?? ""
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
