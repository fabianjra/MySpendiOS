//
//  AddModifyCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import Foundation

final class AddModifyCategoryViewModel: BaseViewModel {
    
    @Published var model: CategoryModel
    
    @Published var showIconsModal = false
    @Published var showAlert = false
    var isAddModel: Bool = true
    
    init(_ model: CategoryModel? = nil) {
        
        // If model exists, then is a Modify action.
        if let modelLoaded = model {
            self.model = modelLoaded
            self.isAddModel = false
        } else {
            self.model = CategoryModel()
        }
        
        super.init(viewContext: CoreDataUtilities.getViewContext())
    }
    
    func addNew(type: CategoryType) -> ResponseModel {
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
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify(type: CategoryType) -> ResponseModel {
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
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() -> ResponseModel {
        do {
            try CategoryManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logs.CatchException(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
