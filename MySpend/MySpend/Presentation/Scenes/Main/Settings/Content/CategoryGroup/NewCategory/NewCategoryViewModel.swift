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
    
    func addNewCategory() async -> ResponseModel {
        if model.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, Messages.emptySpaces.localizedDescription)
        }
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
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
