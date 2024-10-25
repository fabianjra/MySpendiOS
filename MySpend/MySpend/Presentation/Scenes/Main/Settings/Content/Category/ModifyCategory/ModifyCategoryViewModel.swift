//
//  ModifyCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 24/10/24.
//

import Foundation

class ModifyCategoryViewModel: BaseViewModel {
    
    @Published var showIconsModal = false
    @Published var showAlert = false
    
    func modifyCategory(_ model: CategoryModel) async -> ResponseModel {
        if model.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, Messages.emptySpaces.localizedDescription)
        }
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await Repository().modifyDocument(model, documentId: model.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
    
    func deleteCategory(_ model: CategoryModel) async -> ResponseModel {
        var response = ResponseModel()
        
        await performWithLoaderSecondary {
            do {
                try await Repository().deleteDocument(model.id, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
