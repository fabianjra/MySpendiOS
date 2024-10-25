//
//  ModifyCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import Foundation

class ModifyCategoryViewModel: BaseViewModel {
    
    @Published var model: CategoryModel
    @Published var showIconsModal = false
    @Published var showAlert = false
    
    init(model: CategoryModel) {
        self.model = model
    }
    
    func modifyCategory() async -> ResponseModel {
        if model.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, Messages.emptySpaces.localizedDescription)
        }
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().modifyDocument(self.model, documentId: self.model.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteCategory() async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().deleteDocument(self.model.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
