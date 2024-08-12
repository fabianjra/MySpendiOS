//
//  NewCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Foundation

class NewCategoryViewModel: BaseViewModel {
    @Published var model = CategoryModel()
    @Published var errorMessage = ""
    
    func addNewCategory() async -> ResponseModel {
        errorMessage = ""
        
        if model.name.isEmptyOrWhitespace() {
            //errorMessage = ConstantMessages.emptySpaces.localizedDescription
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        var response = ResponseModel()
        await performWithLoader {
            do {
                try await DatabaseStore.addNewCategory(categoryModel: self.model)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                //newTransaction.errorMessage = error.localizedDescription
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
