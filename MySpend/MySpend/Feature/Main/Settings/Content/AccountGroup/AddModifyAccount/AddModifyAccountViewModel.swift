//
//  AddModifyAccountViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 9/7/25.
//

import Foundation

final class AddModifyAccountViewModel: BaseViewModel {
    
    @Published var model: AccountModel
    @Published var isDefaultSelected = false
    
    @Published var showIconsModal = false
    @Published var showAlert = false
    var isAddModel: Bool = true
    
    init(_ model: AccountModel? = nil) {
        
        // If model exists, then it's a Modify action.
        if let modelLoaded = model {
            self.model = modelLoaded
            self.isAddModel = false
            
            if UserDefaultsManager.defaultAccountID == modelLoaded.id.uuidString {
                self.isDefaultSelected = true
            }
        } else {
            self.model = AccountModel()
        }
        
        super.init(viewContext: CoreDataUtilities.getViewContext()) //TOD: Utilizarlo para la inyeccion del preview
    }
    
    func addNew(type: AccountType) async -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        modelMutated.type = type
        
        do {
            try await AccountManager(viewContext: viewContext).create(modelMutated)
            
            if isDefaultSelected {
                UserDefaultsManager.defaultAccountID = modelMutated.id.uuidString
            }
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify(type: AccountType) async -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var modelMutated = model
        
        do {
            // Si el nuevo tipo de account es difente al actual, debe validar que no tega transacciones asociadas
            // a una categoria de un tipo incompatible del nuevo tipo de categoria seleccioanda.
            // Ver mas en la documentacion del metodo "fetchIncompatibleTypeCount"
            if modelMutated.type != type {
                let incompatibleTransactionsCount = try await TransactionManager(viewContext: viewContext).fetchIncompatibleTypeCount(currentAccountID: modelMutated.id.uuidString,
                                                                                                                                      newAccountType: type)
                
                if incompatibleTransactionsCount > .zero {
                    return ResponseModel(.error, Errors.cannotUpdateAccountWithTransactions(incompatibleTransactionsCount.description).localizedDescription)
                }
            }
            
            modelMutated.type = type
            try await AccountManager(viewContext: viewContext).update(modelMutated)
            
            if isDefaultSelected {
                UserDefaultsManager.defaultAccountID = modelMutated.id.uuidString
            } else {
                if UserDefaultsManager.defaultAccountID == modelMutated.id.uuidString {
                    UserDefaultsManager.defaultAccountID = ""
                }
            }
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func delete() async -> ResponseModel {
        do {
            try await AccountManager(viewContext: viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
