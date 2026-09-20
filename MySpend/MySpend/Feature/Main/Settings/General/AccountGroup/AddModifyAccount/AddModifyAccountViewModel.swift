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
        
        super.init()
    }
    
    func addNew() async -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        do {
            try await AccountManager(viewContext).create(model)
            FilterCenter.shared.selectedAccountsFilter.insert(model.id)
            
            if isDefaultSelected {
                UserDefaultsManager.defaultAccountID = model.id.uuidString
            }
            
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
    
    func modify() async -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        do {
            try await AccountManager(viewContext).update(model)
            
            if isDefaultSelected {
                UserDefaultsManager.defaultAccountID = model.id.uuidString
            } else {
                if UserDefaultsManager.defaultAccountID == model.id.uuidString {
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
            try await AccountManager(viewContext).delete(model)
            return ResponseModel(.successful)
        } catch {
            Logger.exception(error, type: .CoreData)
            return ResponseModel(.error, error.localizedDescription)
        }
    }
}
