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
    var id = UUID()
    
    // Entity-specific Attributes
    let currencyCode: String
    var icon: String // Emoji
    var name: String
    
    // Values by default when a new Transaction is created
    init(currencyCode: String = "", icon: String = "", name : String = "") {
        self.dateCreated = .init()
        self.dateModified = .init()
        
        self.currencyCode = currencyCode
        self.icon = currencyCode
        self.name = name
    }
    
    // Init the model from Entity
    init(_ entity: Account) {
        self.dateCreated = entity.dateCreated ?? .init()
        self.dateModified = entity.dateModified ?? .init()
        self.id = entity.id ?? UUID()
        
        self.currencyCode = entity.currencyCode ?? ""
        self.icon = entity.icon ?? ""
        self.name = entity.name ?? ""
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
}
