//
//  NSManagedObject+Extensions.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 23/7/25.
//

import CoreData

extension NSManagedObject {
    
    /// Nombre de la entidad tal como está en el modelo `.xcdatamodeld`
    /// (por defecto coincide con el nombre de la clase Swift).
    @nonobjc
    static var entityName: String {
        // Si cambias el nombre en el inspector de Core Data
        // sigue funcionando: usa `entity().name`
        entity().name ?? String(describing: Self.self)
    }
}

