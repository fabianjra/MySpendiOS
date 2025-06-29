//
//  CDSort.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 28/6/25.
//

import Foundation

struct CDSort {
    
    struct CategoryEntity {
        static let byName_dateCreated: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \Category.name, ascending: true),
                                          NSSortDescriptor(keyPath: \Category.dateCreated, ascending: true)]
    }
}
