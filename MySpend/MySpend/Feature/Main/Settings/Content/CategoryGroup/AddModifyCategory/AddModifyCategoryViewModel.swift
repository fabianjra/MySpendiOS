//
//  AddModifyCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import Foundation

final class AddModifyCategoryViewModel: BaseViewModel {
    
    @Published var showIconsModal = false
    @Published var showAlert = false
    
    func addNew(_ model: CategoryModel, type: CategoryType) -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.type = type
        
        do {
            try CategoryManager(viewContext: viewContext).create(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify(_ model: CategoryModel, type: CategoryType) -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.type = type
        
        do {
            try CategoryManager(viewContext: viewContext).update(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete(_ model: CategoryModel) -> ResponseModel {
        do {
            try CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
