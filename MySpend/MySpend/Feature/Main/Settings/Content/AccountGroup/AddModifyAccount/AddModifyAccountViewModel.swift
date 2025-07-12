//
//  AddModifyAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

final class AddModifyAccountViewModel: BaseViewModel {
    
    @Published var model: AccountModel
    
    @Published var showIconsModal = false
    @Published var showAlert = false
    var isAddModel: Bool = true
    
    init(_ model: AccountModel? = nil) {
        
        // If model exists, then it's a Modify action.
        if let modelLoaded = model {
            self.model = modelLoaded
            self.isAddModel = false
        } else {
            self.model = AccountModel()
        }
        
        super.init(viewContext: CoreDataUtilities.getViewContext()) //TOD: Utilizarlo para la inyeccion del preview
    }
    
    func addNew(type: AccountType) -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.type = type
        
        do {
            try AccountManager(viewContext: viewContext).create(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify(type: AccountType) -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        
        do {
            // Si el nuevo tipo de transaccion es difente al actual, debe validar que no tega transacciones asociada,
            // a menos de que la nueva sea general, ya que esa permite expenses/incomes.
            if modelMutated.type != type && type != .general {

                //TOD: Podria validarse si las transacciones son todas del mismo tipo al que se quiere modificar la cuenta para que se permita.
                let transactionsForAccountCount = try TransactionManager(viewContext: viewContext).fetchAllCount(byAccountID: modelMutated.id.uuidString)
                
                if transactionsForAccountCount > 0 {
                    return ResponseModel(.error, Errors.cannotUpdateAccountWithTransactions(transactionsForAccountCount.description).localizedDescription)
                }
            }
            
            modelMutated.type = type
            try AccountManager(viewContext: viewContext).update(modelMutated)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() -> ResponseModel {
        do {
            try AccountManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
