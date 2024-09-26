//
//  NewCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Foundation

class NewCategoryViewModel: BaseViewModel {
    
    @Published var model = CategoryModel()
    
    func addNewCategory() async -> ResponseModel {
        if model.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, ConstantMessages.emptySpaces.localizedDescription)
        }
        
        var response = ResponseModel()
        
        await performWithLoader {
            do {
                try await CategoriesDatabase().addNewCategory(categoryModel: self.model)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
