//
//  NewCategoryViewModel.swift
//  MySpend
//
//  Created by Fabian Rodriguez on 11/8/24.
//

import Foundation

class NewCategoryViewModel: BaseViewModel {
    
    @Published var showIconsModal = false
    
    func addNewCategory(_ model: CategoryModel) async -> ResponseModel {
        if model.name.isEmptyOrWhitespace() {
            return ResponseModel(.error, Errors.emptySpaces.localizedDescription)
        }
        
        var mutableModel = model
        mutableModel.dateCreated = .now
        mutableModel.datemodified = .now
        
        var response = ResponseModel()
        
        await performWithLoader { currentUser in
            do {
                mutableModel.userId = currentUser.uid
                
                try await Repository().addNewDocument(mutableModel, forSubCollection: .categories)
                
                response = ResponseModel(.successful)
            } catch {
                Logs.WriteCatchExeption(error: error)
                response = ResponseModel(.error, error.localizedDescription)
            }
        }
        
        return response
    }
}
