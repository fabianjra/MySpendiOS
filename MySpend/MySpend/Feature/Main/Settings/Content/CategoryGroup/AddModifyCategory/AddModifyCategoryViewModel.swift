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
    
    func addNewCategory(_ model: CategoryModel, categoryType: CategoryType) -> ResponseModelFB {
        if model.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.type = categoryType
        
        do {
            try CategoryManager(viewContext: viewContext).create(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func modifyCategory(_ model: CategoryModel, categoryType: CategoryType) -> ResponseModelFB {
        if model.name.isEmptyOrWhitespace {
            return ResponseModelFB(.error, Errors.emptySpaces.localizedDescription)
        }
        
        //TODO: Cambiar para que mas bien se use el selectedDate con la de Model:
        var modelMutated = model
        modelMutated.type = categoryType
        modelMutated.dateModified = .now
        
        do {
            try CategoryManager(viewContext: viewContext).update(modelMutated)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
    
    func deleteCategory(_ model: CategoryModel) -> ResponseModelFB {
        do {
            try CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModelFB(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModelFB(.error, error.localizedDescription)
        }
    }
}
