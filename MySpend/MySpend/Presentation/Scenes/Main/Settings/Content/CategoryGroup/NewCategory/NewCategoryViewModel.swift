//
//  NewCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Foundation

class NewCategoryViewModel: BaseViewModel {
    
    @Published var model = CategoryModel()
    @Published var showIconsModal = false
    
    func addNewCategory(_ categoryType: TransactionType) async -> ResponseModel {
        if model.name.isEmptyOrWhitespace {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        model.categoryType = categoryType
        model.dateCreated = .now
        model.datemodified = .now
        
        var response = ResponseModel()
        
        await performWithLoader { currentUser in
            do {
                self.model.userId = currentUser.uid
                
                try await Repository().addNewDocument(self.model, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
