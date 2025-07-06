//
//  CategoryModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 25/7/24.
//

import Foundation

struct CategoryModelFB: Identifiable, Codable, Equatable, Hashable  {
    var id: String = ""
    var icon: String = CategoryIcons.household.list.first ?? "tag.fill"
    var name: String = ""
    var categoryType: CategoryType = .expense
    var dateCreated: Date = .init()
    var datemodified: Date = .init()
    var userId: String = ""
    var usedCounter: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
        case name
        case categoryType
        case dateCreated
        case datemodified
        case userId
        case usedCounter
    }
    
    enum Field: Hashable, CaseIterable {
        case name
    }
    
    mutating func incrementUsedCounter() {
        self.usedCounter += 1
    }
    
    //TODO: BORRAR CUANDO SE LIMPIE LA BASE DE DATOS.
    //NECESARIO solo por usedCounter ya que en documentos actuales no existe el valor.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decodificación normal para las demás propiedades
        self.id = try container.decode(String.self, forKey: .id)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.name = try container.decode(String.self, forKey: .name)
        self.categoryType = try container.decode(CategoryType.self, forKey: .categoryType)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.datemodified = try container.decode(Date.self, forKey: .datemodified)
        self.userId = try container.decode(String.self, forKey: .userId)
        
        // Solo asigna un valor por defecto a `usedCounter` si no está presente en el JSON
        self.usedCounter = try container.decodeIfPresent(Int.self, forKey: .usedCounter) ?? 0
    }
        
    //TODO: BORRAR CUANDO SE LIMPIE LA BASE DE DATOS.
    //NECESARIO solo por usedCounter ya que en documentos actuales no existe el valor.
    init(id: String = "",
         icon: String = CategoryIcons.household.list.first ?? "tag.fill",
         name: String = "",
         categoryType: CategoryType = .expense,
         dateCreated: Date = .init(),
         datemodified: Date = .init(),
         userId: String = "",
         usedCounter: Int = 0) {
        
        self.id = id
        self.icon = icon
        self.name = name
        self.categoryType = categoryType
        self.dateCreated = dateCreated
        self.datemodified = datemodified
        self.userId = userId
        self.usedCounter = usedCounter
    }
}
