//
//  NewCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Foundation

class NewCategoryViewModel: ObservableObject {
    @Published var category: CategoryModel
    
    init(category: CategoryModel) {
        self.category = category
    }
    
    //TODO: Agregar funcion de agregar nueva transaccion.
}
